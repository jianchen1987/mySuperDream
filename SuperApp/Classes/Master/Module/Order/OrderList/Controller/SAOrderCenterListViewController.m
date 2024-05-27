//
//  SAOrderCenterListViewController.m
//  SuperApp
//
//  Created by Tia on 2023/2/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderCenterListViewController.h"
#import "GNOrderDTO.h"
#import "HDCheckStandPresenter.h"
#import "HDCheckStandRepaymentAlertView.h"
#import "HDCheckStandViewController.h"
#import "HDMediator+GroupOn.h"
#import "LKDataRecord.h"
#import "SAAlertView.h"
#import "SAAppEnvConfig.h"
#import "SAAppEnvManager.h"
#import "SACMSCardTableViewCell.h"
#import "SACMSCardView.h"
#import "SACMSManager.h"
#import "SAMenuView.h"
#import "SAOrderBillListModel.h"
#import "SAOrderCenterListTableViewCell.h"
#import "SAOrderListBillListAlertView.h"
#import "SAOrderListDTO.h"
#import "SAOrderListRspModel.h"
#import "SAPaymentDTO.h"
#import "SAQueryPaymentStateRspModel.h"
#import "SATableView.h"
#import "SAWriteDateReadableModel.h"
#import "TNOrderDTO.h"
#import "SAAddressCacheAdaptor.h"

#define truePageSize 10


@interface SAOrderCenterListViewController () <UITableViewDelegate, UITableViewDataSource, HDCheckStandViewControllerDelegate, SAMenuViewDelegate>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 请求的一页数量
@property (nonatomic, assign) NSUInteger pageSize;
/// 所有订单模型
@property (nonatomic, strong) NSMutableArray<SAOrderModel *> *dataSource;

@property (nonatomic, strong) NSMutableArray *cmsDataSource;
/// DTO
@property (nonatomic, strong) SAOrderListDTO *orderListDTO;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 电商订单DTO
@property (nonatomic, strong) TNOrderDTO *tinhNowDTO;
/// 支付状态查询DTO
@property (nonatomic, strong) SAPaymentDTO *paymentStateDTO;
/// 团购订单DTO
@property (nonatomic, strong) GNOrderDTO *groupBuyDTO;
/// 团购获取buinessOrderNo
@property (nonatomic, strong, nullable) SAOrderModel *selectOrderModel;

/// 空数据容器
@property (nonatomic, strong) UIViewPlaceholderViewModel *noDatePlaceHolder;

@property (nonatomic, strong) SAMenuView *saMenuView;

@property (nonatomic, weak) SAOrderModel *targetViewModel;
///< cms配置
@property (nonatomic, strong) SACMSPageViewConfig *config;
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;

@end


@implementation SAOrderCenterListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.tableView.hd_hasData) {
        if (SAUser.hasSignedIn) {
            self.tableView.dataSource = self.provider;
            self.tableView.delegate = self.provider;
        }
        [self.tableView successGetNewDataWithNoMoreData:true];
    }

    if (SAUser.hasSignedIn) {
        if (self.dataSource.count > 0) {
            self.pageSize = truePageSize * self.currentPageNo;
            //            [self getNewData];
            // 避免刷新数据后页面乱跳
            @HDWeakify(self);
            [self getDataForPageNo:1 completion:^(BOOL success, BOOL hasNextPage, NSInteger pageNo) {
                @HDStrongify(self);
                [self.tableView successGetNewDataWithNoMoreData:!hasNextPage scrollToTop:NO];
            }];
        } else {
            [self.tableView getNewData];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SAMenuView dismissAllSAMenu];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.G5;

    self.miniumGetNewDataDuration = 0;
    self.pageSize = truePageSize;
    [self.view addSubview:self.tableView];
    if (SAUser.hasSignedIn) {
        self.tableView.dataSource = self.provider;
        self.tableView.delegate = self.provider;
    }

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            self.tabBarController.selectedIndex = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
    };
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - Data
- (void)getNewData {
    self.currentPageNo = 1;

    @HDWeakify(self);
    [self getDataForPageNo:self.currentPageNo completion:^(BOOL success, BOOL hasNextPage, NSInteger pageNo) {
        @HDStrongify(self);
        @HDWeakify(self);
        [self getCMSDataCompletion:^(BOOL success) {
            @HDStrongify(self);
            if (success) {
                [self.tableView successGetNewDataWithNoMoreData:!hasNextPage];
            } else {
                [self.tableView failGetNewData];
            }
        }];
    }];
}

- (void)getCMSDataCompletion:(void (^)(BOOL success))completion {
    if (HDIsStringEmpty(self.pageIdentify)) {
        !completion ?: completion(YES);
        return;
    }

#warning 这里拿到地址的不一定准确，存在风险
    // 拿当前用户选择的经纬度
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    // 异步开始请求最新数据
    @HDWeakify(self);
    [SACMSManager getPageWithAddress:addressModel identify:self.pageIdentify pageWidth:kScreenWidth operatorNo:[SAUser hasSignedIn] ? SAUser.shared.operatorNo : @""
        success:^(SACMSPageView *_Nonnull page, SACMSPageViewConfig *_Nonnull config) {
            @HDStrongify(self);
            if (!HDIsObjectNil(self.config) && [config isEqual:self.config]) {
                HDLog(@"当前有配置，且配置一样，不刷新");
            } else {
                HDLog(@"当前无配置，或者配置不一样，刷新");
                [self parsingCMSPageConfig:config];
            }
            !completion ?: completion(YES);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            // 失败不需要更新
            !completion ?: completion(NO);
        }];
}

- (void)parsingCMSPageConfig:(SACMSPageViewConfig *)config {
    self.config = config;

    SACMSPageView *page = [[SACMSPageView alloc] initWithWidth:kScreenWidth config:config];
    NSMutableArray *cellModels = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < page.cardViews.count; i++) {
        SACMSCardTableViewCellModel *model = SACMSCardTableViewCellModel.new;
        model.cardView = page.cardViews[i];
        model.cardConfig = config.cards[i];
        model.cardView.clickNode = ^(SACMSCardView *_Nonnull card, SACMSNode *_Nullable node, NSString *_Nullable link, NSString *_Nullable spm) {
            if (HDIsStringNotEmpty(link)) {
                if ([link.lowercaseString hasPrefix:@"superapp://"] && ![SAWindowManager canOpenURL:link]) {
                    [NAT showAlertWithMessage:SALocalizedString(@"feature_no_support", @"您的App不支持这个功能哦~请升级最新版APP体验完整功能~")
                                  buttonTitle:SALocalizedString(@"update_righnow", @"去升级") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                      [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1507128993"];
                                  }];
                    return;
                } else {
                    [SAWindowManager openUrl:link withParameters:@{
                        @"source" : [NSString stringWithFormat:@"%@.%@@%d.%@", HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : @"订单列表", card.config.cardName, i, spm],
                        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : node.nodePublishNo
                    }];
                }

                // 埋点
                [LKDataRecord.shared traceClickEvent:node.name
                                          parameters:@{@"route": HDIsStringNotEmpty(link) ? link : @"", @"nodePublishNo": HDIsStringNotEmpty(node.nodePublishNo) ? node.nodePublishNo : @""}
                                                 SPM:[LKSPM SPMWithPage:config.pageName area:[NSString stringWithFormat:@"%@@%d", card.config.cardName, i] node:spm]];
            }
        };
        [cellModels addObject:model];
    }

    self.cmsDataSource = cellModels.mutableCopy;
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    @HDWeakify(self);
    [self getDataForPageNo:self.currentPageNo completion:^(BOOL success, BOOL hasNextPage, NSInteger pageNo) {
        @HDStrongify(self);
        if (success) {
            [self.tableView successLoadMoreDataWithNoMoreData:!hasNextPage];
        } else {
            [self.tableView failLoadMoreData];
        }
    }];
}

- (void)getDataForPageNo:(NSInteger)pageNo completion:(void (^)(BOOL success, BOOL hasNextPage, NSInteger pageNo))completion {
    @HDWeakify(self);
    [self.orderListDTO getOrderListWithBusinessType:self.businessLine orderState:self.orderState pageNum:pageNo pageSize:self.pageSize orderTimeStart:self.orderTimeStart orderTimeEnd:self.orderTimeEnd
        keyName:self.keyName success:^(SAOrderListRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.tableView.dataSource = self;
            self.tableView.delegate = self;

            NSArray<SAOrderModel *> *list = rspModel.list;
            if (pageNo == 1) {
                [self.dataSource removeAllObjects];
                if (list.count) {
                    [self.dataSource addObjectsFromArray:list];
                }
            } else {
                if (list.count) {
                    [self.dataSource addObjectsFromArray:list];
                }
            }
            !completion ?: completion(YES, rspModel.hasNextPage, rspModel.pageNum);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            !completion ?: completion(NO, NO, pageNo);
        }];
    // 更新currentPageNo为实际页码，pageSize为 truePageSize
    if (self.pageSize > truePageSize) {
        self.currentPageNo = self.pageSize / truePageSize;
        self.pageSize = truePageSize;
    }
}

- (void)showConfirmOrderAlert:(SAOrderModel *)orderModel {
    @HDWeakify(self);
    if ([orderModel.businessLine isEqualToString:SAClientTypeTinhNow]) {
        [NAT showAlertWithMessage:TNLocalizedString(@"tn_order_confirm_title", @"请确认，你已经收到货") confirmButtonTitle:TNLocalizedString(@"tn_button_received", @"确定")
            confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
                @HDStrongify(self);
                [self handleConfirmOrderWithModel:orderModel];
            }
            cancelButtonTitle:TNLocalizedString(@"tn_button_NoYet_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
    } else {
        [NAT showAlertWithMessage:WMLocalizedString(@"receive_goods_confirm_ask", @"是否确认收到商品？") confirmButtonTitle:WMLocalizedString(@"not_now", @"暂时不")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }
            cancelButtonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                @HDStrongify(self);
                [self handleConfirmOrderWithModel:orderModel];
            }];
    }
}

/// 根据业务类型确认订单
- (void)handleConfirmOrderWithModel:(SAOrderModel *)orderModel {
    SAClientType businessLine = orderModel.businessLine;
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        [self showloading];
        @HDWeakify(self);
        [self.orderListDTO confirmOrderWithOrderNo:orderModel.orderNo success:^{
            @HDStrongify(self);
            [self dismissLoading];

            [self.tableView getNewData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        [self showloading];
        @HDWeakify(self);
        [self.tinhNowDTO confirmOrderWithOrderNo:orderModel.orderNo success:^{
            @HDStrongify(self);
            [self dismissLoading];
            [self.tableView getNewData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }
}

/// 根据业务类型跳转门店详情页
- (void)handleJumpToStoreWithModel:(SAOrderModel *)orderModel {
    if (HDIsStringNotEmpty(orderModel.merchantUrl)) {
        [SAWindowManager openUrl:orderModel.merchantUrl withParameters:@{}];
        return;
    }

    SAClientType businessLine = orderModel.businessLine;
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        if ([orderModel.businessContent.businessType isEqualToString:WMBusinessTypeDigitelMenu]) {
            return;
        } else {
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
                @"storeNo": orderModel.storeNo,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@".门店icon"] : @"订单列表门店icon",
                @"associatedId" : self.viewModel.associatedId
            }];
        }
    } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": orderModel.storeNo}];
    } else if ([businessLine isEqualToString:SAClientTypePhoneTopUp]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobile-h5/phone-recharge/index", SAAppEnvManager.sharedInstance.appEnvConfig.h5URL];
        [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"url": urlStr}];
    } else if ([businessLine isEqualToString:SAClientTypeGroupBuy]) {
        [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": orderModel.storeNo}];
    } else if ([businessLine isEqualToString:SAClientTypeBillPayment]) {
        [HDMediator.sharedInstance navigaveToPayNowUtilitiesVC:@{}];
    }
}

/// 根据业务类型做评价页面跳转
- (void)handleEvaluateOrderWithModel:(SAOrderModel *)orderModel {
    SAClientType businessLine = orderModel.businessLine;
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
        params[@"orderNo"] = orderModel.orderNo;
        params[@"storeNo"] = orderModel.storeNo;
        params[@"logoURL"] = orderModel.storeLogo;
        params[@"storeName"] = orderModel.storeName.desc;
        params[@"deliveryType"] = @(SADeliveryTypeMerchant);
        params[@"serviceType"] = @(orderModel.serviceType);
        [HDMediator.sharedInstance navigaveToOrderEvaluationViewController:params];
    } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
        params[@"orderNo"] = orderModel.orderNo;
        //        [HDMediator.sharedInstance navigaveToTinhNowEvaluationViewController:params];
        [HDMediator.sharedInstance navigaveToTinhNowPostReviewlViewController:params];
    }
}

/// 根据业务类型做退款详情页面跳转
- (void)handleJumpToRefundDetailWithModel:(SAOrderModel *)orderModel {
    SAClientType businessLine = orderModel.businessLine;

    if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
        params[@"orderNo"] = orderModel.orderNo;
        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:params];
        return;
    }
    //除了电商，其余跳公共退款页面
    [HDMediator.sharedInstance navigaveToCommonRefundDetailViewController:@{@"aggregateOrderNo": orderModel.orderNo}];
}

/// 根据业务类型做支付操作
- (void)handleOrderPayWithModel:(SAOrderModel *)orderModel {
    SAClientType businessLine = orderModel.businessLine;
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        [self openCashRegisterWithModel:orderModel];
    } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        //电商可能有改价0元订单  不用唤起收银台
        [self.view showloading];
        @HDWeakify(self);
        [self.paymentStateDTO queryOrderPaymentStateWithOrderNo:orderModel.orderNo success:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            if (rspModel.actualPayAmount.cent.integerValue > 0) { // 实付金额>0元时才需要调起收银台
                //订单号不为空  就去支付
                [self openCashRegisterWithModel:orderModel];
            } else {
                [HDTips showWithText:TNLocalizedString(@"tn_pay_state_tips", @"订单状态已变化，请刷新当前页面") inView:self.view hideAfterDelay:3];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            [self openCashRegisterWithModel:orderModel];
        }];
    } else if ([businessLine isEqualToString:SAClientTypeGroupBuy]) {
        HDCheckStandRepaymentAlertViewConfig *config = HDCheckStandRepaymentAlertViewConfig.new;
        @HDWeakify(self);
        config.clickOnContinuePaymentHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
            @HDStrongify(self);
            self.selectOrderModel = orderModel;
            [self openCashRegisterWithModel:orderModel];
        };
        config.clickOnWailtPaymentResultHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {

        };
        config.clickOnServiceHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
            [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/help-center"}];
        };
        HDCheckStandRepaymentAlertView *alertView = [HDCheckStandRepaymentAlertView alertViewWithConfig:config];
        [alertView show];
    } else {
        // 允许支付
        [self openCashRegisterWithModel:orderModel];
    }
}
///打开收银台
- (void)openCashRegisterWithModel:(SAOrderModel *)orderModel {
    SAClientType businessLine = orderModel.businessLine;
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];

    buildModel.orderNo = orderModel.orderNo;
    //    buildModel.outPayOrderNo = orderModel.outPayOrderNo;
    buildModel.payableAmount = orderModel.actualPayAmount;
    buildModel.businessLine = businessLine;
    buildModel.storeNo = orderModel.storeNo;
    buildModel.merchantNo = orderModel.merchantNo;
    buildModel.goods = nil; // 拿不到商品信息

    buildModel.needCheckPaying = YES; //需要校验重新支付的时候改成YES

    buildModel.payType = orderModel.payType;

    buildModel.serviceType = orderModel.serviceType;

    [HDCheckStandPresenter payWithTradeBuildModel:buildModel preferedHeight:0 fromViewController:self delegate:self];
}

/// 根据业务类型做再次购买操作  进入购物车
- (void)handleRebuyWithModel:(SAOrderModel *)orderModel {
    SAClientType businessLine = orderModel.businessLine;
    if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        [self showloading];
        @HDWeakify(self);
        [self.tinhNowDTO rebuyOrderWithOrderNo:orderModel.orderNo success:^(NSArray *_Nonnull skuIds) {
            @HDStrongify(self);
            [self dismissLoading];
            [SAWindowManager openUrl:@"SuperApp://TinhNow/ShoppingCar" withParameters:@{@"skuIds": skuIds}];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    } else if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        // 为了跟安卓效果一致（测试要求），在门店详情发送再来一单请求
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
            @"storeNo": orderModel.storeNo,
            @"onceAgainOrderNo": orderModel.orderNo,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@".再来一单"] : @"订单列表再来一单",
            @"associatedId" : self.viewModel.associatedId
        }];
    } else if ([businessLine isEqualToString:SAClientTypeGroupBuy]) {
        [self showloading];
        @HDWeakify(self);
        [self.groupBuyDTO orderGetOrderProductCodeWithOrderNo:orderModel.businessOrderNo success:^(GNProductModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];
            [HDMediator.sharedInstance navigaveToGNStoreProductViewController:@{@"storeNo": orderModel.storeNo, @"productCode": rspModel.productCode, @"fromOrder": @"bugAgain"}];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }

    [LKDataRecord.shared traceEvent:@"click_rebuy_button" name:@"订单列表再来一单按钮点击" parameters:@{@"businessLine": businessLine, @"orderNo": orderModel.orderNo}
                                SPM:[LKSPM SPMWithPage:@"SAOrderListViewController" area:@"" node:@""]];
}

/// 根据业务类型做订单取消操作
- (void)handleOrderCancelWithModel:(SAOrderModel *)orderModel {
    SAClientType businessLine = orderModel.businessLine;
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        [self showloading];
        @HDWeakify(self);
        [self.paymentStateDTO queryOrderPaymentStateWithOrderNo:orderModel.orderNo success:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];

            [self.tableView getNewData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        [self showloading];
        @HDWeakify(self);
        [self.tinhNowDTO cancelOrderWithOrderNo:orderModel.orderNo success:^{
            @HDStrongify(self);
            [self dismissLoading];

            [self.tableView getNewData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    } else if ([businessLine isEqualToString:SAClientTypeGroupBuy]) {
    }
}

- (void)queryNearbyRoteWithModel:(SAOrderModel *)model {
    [self showloading];
    @HDWeakify(self);
    [self.tinhNowDTO queryNearByRouteWithOrderNo:model.orderNo storeNo:model.storeNo success:^(NSString *_Nullable route) {
        @HDStrongify(self);
        [self dismissLoading];
        if (HDIsStringNotEmpty(route)) {
            [SAWindowManager openUrl:route withParameters:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)handleMoreFunctionWithModel:(SAOrderModel *)model {
    HDLog(@"%s-%f", __func__, model.orderTime);
    if (!_saMenuView) {
        _saMenuView = [[SAMenuView alloc] init];
    }

    if (model == self.targetViewModel) {
        [SAMenuView dismissAllSAMenu];
        self.targetViewModel = nil;
    } else {
        if (self.targetViewModel) {
            [SAMenuView dismissAllSAMenu];
        }

        self.targetViewModel = model;

        [_saMenuView setTargetView:model.associatedTargetView InView:self.view];
        _saMenuView.delegate = self;
        [_saMenuView setTitleArray:model.associatedTargetOptionArray];
        [self.view addSubview:_saMenuView];
        [_saMenuView show];
    }
}

- (void)handlePickUpWithModel:(SAOrderModel *)model {
    @HDWeakify(self);
    HDAlertView *alert = [HDAlertView alertViewWithTitle:WMLocalizedString(@"wm_pickup_Kind reminder", @"温馨提示") message:WMLocalizedString(@"wm_pickup_tips03", @"您确定已收到商品吗？")
                                                  config:nil];

    [alert addButton:[HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") type:HDAlertViewButtonTypeCancel
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                }]];

    [alert addButton:[HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") type:HDAlertViewButtonTypeCustom
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                    @HDStrongify(self);

                                                    [self showloading];
                                                    @HDWeakify(self);
                                                    [self.orderListDTO submitPickUpOrderWithOrderNo:model.orderNo success:^{
                                                        @HDStrongify(self);
                                                        [self dismissLoading];
                                                        // 重新获取订单详情
                                                        [self.tableView getNewData];
                                                    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                                                        @HDStrongify(self);
                                                        [self dismissLoading];
                                                    }];
                                                }]];

    [alert show];
}

#pragma mark - private methods
- (void)navigateToOrderDetailsWithOrderNo:(NSString *_Nonnull)orderNo outPayNo:(NSString *_Nullable)outPayNo businessOrderNo:(NSString *_Nullable)bizOrderNo businessLine:(SAClientType)businessLine {
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{
            @"orderNo": orderNo,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : @"订单列表",
            @"associatedId" : self.viewModel.associatedId
        }];
        
    } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": orderNo}];
    } else if ([businessLine isEqualToString:SAClientTypePhoneTopUp]) {
        [HDMediator.sharedInstance navigaveToTopUpDetailViewController:@{@"orderNo": orderNo, @"outPayOrderNo": outPayNo}];
    } else if ([businessLine isEqualToString:SAClientTypeGroupBuy]) {
        [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": bizOrderNo}];
    } else if ([businessLine isEqualToString:SAClientTypeBillPayment]) {
        [HDMediator.sharedInstance navigaveToPayNowPaymentBillOrderDetailsVC:@{@"orderNo": orderNo}];
    } else {
        [HDMediator.sharedInstance navigaveToCommonOrderDetails:@{@"orderNo": orderNo}];
    }
}

- (void)deleteOrder {
    if(HDIsObjectNil(self.targetViewModel)) {
        return;
    }
    
    NSString *orderNo = [self.targetViewModel.orderNo copy];
    
    if(HDIsStringEmpty(orderNo)) {
        return;
    }
    
    @HDWeakify(self);
    [self.orderListDTO deleteOrderWithOrderNo:orderNo success:^{
        @HDStrongify(self);
        [self getNewData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];

    self.targetViewModel = nil;
}

- (void)getOrderBillList {
    @HDWeakify(self);
    [self.view showloading];
    [self.orderListDTO getOrderBillListWithOrderNo:self.targetViewModel.orderNo success:^(SAOrderBillListModel *_Nonnull model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (model && (model.payList.count + model.refundList.count > 0)) {
            SAOrderListBillListAlertView *alertView = SAOrderListBillListAlertView.new;
            alertView.model = model;
            alertView.didSelectedBlock = ^(BOOL isRefund, SAOrderBillListItemModel *_Nonnull model) {
                if (!isRefund) {
                    [HDMediator.sharedInstance navigaveToBillPaymentDetails:@{@"payTransactionNo": model.payTransactionNo}];
                } else {
                    [HDMediator.sharedInstance navigaveToBillRefundDetails:@{@"refundTransactionNo": model.refundTransactionNo}];
                }
            };
            [alertView show];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];

    self.targetViewModel = nil;
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    @HDWeakify(self);
    @HDWeakify(controller);
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
        // 跳转订单详情
        @HDStrongify(self);
        @HDStrongify(controller);
        [vc.navigationController popViewControllerAnimated:NO];
        [self navigateToOrderDetailsWithOrderNo:controller.currentOrderNo outPayNo:@"" businessOrderNo:nil businessLine:controller.businessLine];
    };

    params[@"orderClickBlock"] = orderDetailBlock;
    params[@"orderNo"] = controller.currentOrderNo;
    params[@"businessLine"] = controller.businessLine;
    params[@"merchantNo"] = controller.merchantNo;
    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        @HDStrongify(self);
        if ([controller.businessLine isEqualToString:SAClientTypeGroupBuy]) {
            // 团购支付成功
            [HDMediator.sharedInstance navigaveToGNOrderResultViewController:@{@"orderNo": self.selectOrderModel.businessOrderNo}];
        } else {
            // orderNo:聚合订单号,businessLine:业务线枚举
            @HDWeakify(self);
            @HDWeakify(controller);
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
                // 跳转订单详情
                @HDStrongify(self);
                @HDStrongify(controller);
                [vc.navigationController popViewControllerAnimated:NO];
                [self navigateToOrderDetailsWithOrderNo:controller.currentOrderNo outPayNo:@"" businessOrderNo:nil businessLine:controller.businessLine];
            };

            params[@"orderClickBlock"] = orderDetailBlock;
            params[@"orderNo"] = controller.currentOrderNo;
            params[@"businessLine"] = controller.businessLine;
            params[@"merchantNo"] = controller.merchantNo;
            [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
        }
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        @HDStrongify(controller);

        @HDWeakify(self);
        @HDWeakify(controller);
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
            // 跳转订单详情
            @HDStrongify(self);
            @HDStrongify(controller);
            [vc.navigationController popViewControllerAnimated:NO];
            [self navigateToOrderDetailsWithOrderNo:controller.currentOrderNo outPayNo:@"" businessOrderNo:nil businessLine:controller.businessLine];
        };

        params[@"orderClickBlock"] = orderDetailBlock;
        params[@"orderNo"] = controller.currentOrderNo;
        params[@"businessLine"] = controller.businessLine;
        params[@"merchantNo"] = controller.merchantNo;
        [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

//货到付款操作完成
- (void)checkStandViewControllerCashOnDeliveryCompleted:(HDCheckStandViewController *)controller bussineLine:(SAClientType)bussineLine orderNo:(NSString *)orderNo {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        if ([bussineLine isEqualToString:SAClientTypeYumNow] && HDIsStringNotEmpty(orderNo)) {
            [HDMediator.sharedInstance navigaveToOrderResultViewController:@{@"orderNo": orderNo}];
        } else {
            [self.tableView getNewData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.dataSource.count;
    } else {
        return self.cmsDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        if (indexPath.row >= self.dataSource.count)
            return UITableViewCell.new;
        id model = self.dataSource[indexPath.row];
        if ([model isKindOfClass:SAOrderModel.class]) {
            SAOrderCenterListTableViewCell *cell = [SAOrderCenterListTableViewCell cellWithTableView:tableView];
            SAOrderModel *trueModel = (SAOrderModel *)model;
            trueModel.isFirstCell = indexPath.row == 0;
            trueModel.isLastCell = indexPath.row == self.dataSource.count - 1;
            //取消隐藏logo
            //        trueModel.hideBusinessLogo = ![self.businessLine isEqualToString:SAClientTypeMaster];
            cell.model = trueModel;

            @HDWeakify(self);
            ///< 确认收货按钮点击
            cell.clickedConfirmReceivingBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self showConfirmOrderAlert:orderModel];
            };
            ///< 门店标题点击
            cell.clickedStoreTitleBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handleJumpToStoreWithModel:orderModel];
            };
            ///< 评价按钮点击
            cell.clickedEvaluationOrderBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handleEvaluateOrderWithModel:orderModel];
            };
            ///< 退款详情按钮点击
            cell.clickedRefundDetailBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handleJumpToRefundDetailWithModel:orderModel];
            };
            ///< 立即支付按钮
            cell.clickedPayNowBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handleOrderPayWithModel:orderModel];
            };
            ///< 支付倒计时结束
            cell.payTimerCountDownEndedBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handleOrderCancelWithModel:orderModel];
            };
            ///< 再次购买 点击
            cell.clickedRebuyBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handleRebuyWithModel:orderModel];
            };
            ///< 转账按钮
            cell.clickedTransferBlock = ^(SAOrderModel *_Nonnull orderModel) {
                [[HDMediator sharedInstance] navigaveToTinhNowTransferViewController:@{@"orderNo": orderModel.orderNo}];
            };
            ///< 再来一单
            cell.clickedOneMoreBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self queryNearbyRoteWithModel:orderModel];
            };

            cell.clickedMoreFunctionBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handleMoreFunctionWithModel:orderModel];
            };
            cell.didSelectRowBlock = ^{
                @HDStrongify(self);
                [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            };
            cell.clickedPickUpBlock = ^(SAOrderModel *_Nonnull orderModel) {
                @HDStrongify(self);
                [self handlePickUpWithModel:orderModel];
            };
            return cell;
        }
    } else {
        id model = self.cmsDataSource[indexPath.row];
        if ([model isKindOfClass:SACMSCardTableViewCellModel.class]) {
            SACMSCardTableViewCellModel *trueModel = (SACMSCardTableViewCellModel *)model;
            SACMSCardTableViewCell *cell = [SACMSCardTableViewCell cellWithTableView:tableView];
            cell.model = trueModel;
            @HDWeakify(self);
            trueModel.cardView.refreshCard = ^(SACMSCardView *_Nonnull card) {
                @HDStrongify(self);
                [self.tableView successGetNewDataWithNoMoreData:YES];
            };
            return cell;
        }
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SAMenuView dismissAllSAMenu];

    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.row >= self.dataSource.count)
        return;

    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:SAOrderModel.class]) {
        SAOrderModel *trueModel = (SAOrderModel *)model;
        if (HDIsStringNotEmpty(trueModel.orderDetailUrl)) {
            [SAWindowManager openUrl:trueModel.orderDetailUrl withParameters:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : @"订单列表",
                @"associatedId" : self.viewModel.associatedId
            }];
        } else {
            [self navigateToOrderDetailsWithOrderNo:trueModel.orderNo outPayNo:trueModel.outPayOrderNo businessOrderNo:trueModel.businessOrderNo businessLine:trueModel.businessLine];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [SAMenuView dismissAllSAMenu];
}

#pragma mark - SAMenuViewDelegate
- (void)hasSelectedSAMenuViewIndex:(NSInteger)index {
    if (!self.targetViewModel)
        return;

    NSArray *options = self.targetViewModel.associatedTargetOptionArray;

    if (index > options.count)
        return;

    NSString *optionStr = options[index];

    if ([optionStr isEqualToString:SALocalizedString(@"oc_delete_order", @"删除订单")]) {
        SAAlertView *alertView = [SAAlertView alertViewWithTitle:SALocalizedString(@"oc_tips1", @"确认删除该订单") message:nil config:nil];
        SAAlertViewButton *btn1 = [SAAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") type:SAAlertViewButtonTypeCancel
                                                             handler:^(SAAlertView *alertView, SAAlertViewButton *button) {
                                                                 [alertView dismiss];
                                                                 self.targetViewModel = nil;
                                                             }];
        @HDWeakify(self);
        SAAlertViewButton *btn2 = [SAAlertViewButton buttonWithTitle:SALocalizedString(@"oc_btn_confirm", @"确认") type:SAAlertViewButtonTypeDefault
                                                             handler:^(SAAlertView *alertView, SAAlertViewButton *button) {
                                                                 @HDStrongify(self);
                                                                 [self deleteOrder];
                                                                 [alertView dismiss];
                                                                 self.targetViewModel = nil;
                                                             }];
        [alertView addButtons:@[btn1, btn2]];
        [alertView show];
    } else if ([optionStr isEqualToString:SALocalizedString(@"oc_bill", @"支付账单")]) {
        [self getOrderBillList];
    }
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = HDAppTheme.color.sa_backgroundColor;
        _tableView.placeholderViewModel = self.noDatePlaceHolder;
    }
    return _tableView;
}

- (NSMutableArray<SAOrderModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)cmsDataSource {
    if (!_cmsDataSource) {
        _cmsDataSource = NSMutableArray.new;
    }
    return _cmsDataSource;
}

- (SAOrderListDTO *)orderListDTO {
    if (!_orderListDTO) {
        _orderListDTO = SAOrderListDTO.new;
    }
    return _orderListDTO;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [SAOrderCenterListTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [SAOrderCenterListTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}


/** @lazy tinhnow */
- (TNOrderDTO *)tinhNowDTO {
    if (!_tinhNowDTO) {
        _tinhNowDTO = [[TNOrderDTO alloc] init];
    }
    return _tinhNowDTO;
}
- (SAPaymentDTO *)paymentStateDTO {
    if (!_paymentStateDTO) {
        _paymentStateDTO = [[SAPaymentDTO alloc] init];
    }
    return _paymentStateDTO;
}

- (GNOrderDTO *)groupBuyDTO {
    if (!_groupBuyDTO) {
        _groupBuyDTO = GNOrderDTO.new;
    }
    return _groupBuyDTO;
}

- (UIViewPlaceholderViewModel *)noDatePlaceHolder {
    if (!_noDatePlaceHolder) {
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.image = @"ac_placehold";
        placeHolder.imageSize = CGSizeMake(kRealWidth(200), kRealWidth(200));
        placeHolder.titleFont = HDAppTheme.font.sa_standard12;
        placeHolder.titleColor = [UIColor hd_colorWithHexString:@"#999999"];
        placeHolder.needRefreshBtn = YES;
        placeHolder.refreshBtnTitle = SALocalizedString(@"oc_tips3", @"看看有什么想买的");
        placeHolder.refreshBtnTitleColor = HDAppTheme.color.sa_C1;
        placeHolder.refreshBtnTitleFont = HDAppTheme.font.sa_standard12;
        placeHolder.refreshBtnBackgroundColor = HDAppTheme.color.sa_backgroundColor;
        placeHolder.refreshBtnGhostColor = HDAppTheme.color.sa_C1;
        placeHolder.refreshBtnBorderWidth = 1;
        placeHolder.title = SALocalizedString(@"oc_tips2", @"你还没有相关的订单");
        _noDatePlaceHolder = placeHolder;
    }
    return _noDatePlaceHolder;
}

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
