//
//  SAOrderListViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderListViewController.h"
#import "GNOrderDTO.h"
#import "HDCheckStandPresenter.h"
#import "HDCheckStandRepaymentAlertView.h"
#import "HDCheckStandViewController.h"
#import "HDMediator+GroupOn.h"
#import "LKDataRecord.h"
#import "SAAppEnvConfig.h"
#import "SAAppEnvManager.h"
#import "SAOrderListDTO.h"
#import "SAOrderListRspModel.h"
#import "SAOrderListTableViewCell+Skeleton.h"
#import "SAOrderListTableViewCell.h"
#import "SAPaymentDTO.h"
#import "SAQueryPaymentStateRspModel.h"
#import "SATableView.h"
#import "TNOrderDTO.h"

#define truePageSize 10


@interface SAOrderListViewController () <UITableViewDelegate, UITableViewDataSource, HDCheckStandViewControllerDelegate>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 请求的一页数量
@property (nonatomic, assign) NSUInteger pageSize;
/// 所有订单模型
@property (nonatomic, strong) NSMutableArray<SAOrderModel *> *dataSource;
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

///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;

@end


@implementation SAOrderListViewController
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
            [self getNewData];
        } else {
            [self.tableView getNewData];
        }
    }
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
            self.tableView.dataSource = self.provider;
            self.tableView.delegate = self.provider;
            [self.tableView successGetNewDataWithNoMoreData:true];
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
    [self getDataForPageNo:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)getDataForPageNo:(NSInteger)pageNo {
    @HDWeakify(self);
    [self.orderListDTO getOrderListWithBusinessType:self.businessLine orderState:self.orderState pageNum:pageNo pageSize:self.pageSize orderTimeStart:nil orderTimeEnd:nil
        success:^(SAOrderListRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.tableView.dataSource = self;
            self.tableView.delegate = self;

            NSArray<SAOrderModel *> *list = rspModel.list;
            if (pageNo == 1) {
                [self.dataSource removeAllObjects];
                if (list.count) {
                    [self.dataSource addObjectsFromArray:list];
                }
                [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            } else {
                if (list.count) {
                    [self.dataSource addObjectsFromArray:list];
                }
                [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            pageNo == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
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
                @"source" : [[self nameOfSource] stringByAppendingString:@".门店icon"],
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
            @"source" : [[self nameOfSource] stringByAppendingString:@".再来一单"],
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

#pragma mark - private methods
- (void)navigateToOrderDetailsWithOrderNo:(NSString *_Nonnull)orderNo outPayNo:(NSString *_Nullable)outPayNo businessOrderNo:(NSString *_Nullable)bizOrderNo businessLine:(SAClientType)businessLine {
    if ([businessLine isEqualToString:SAClientTypeYumNow]) {
        [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": orderNo}];
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

- (NSString *)nameOfSource {
    if(self.orderState == SAOrderStateWatingEvaluation) {
        return HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单列表.待评价"] : @"订单列表.待评价";
    } else if(self.orderState == SAOrderStateWatingRefund) {
        return HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单列表.退款售后"] : @"订单列表.退款售后";
    } else {
        return HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单列表.全部"] : @"订单列表.全部";
    }
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;

    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:SAOrderModel.class]) {
        SAOrderListTableViewCell *cell = [SAOrderListTableViewCell cellWithTableView:tableView];
        SAOrderModel *trueModel = (SAOrderModel *)model;
        trueModel.isFirstCell = indexPath.row == 0;
        trueModel.isLastCell = indexPath.row == self.dataSource.count - 1;
        trueModel.hideBusinessLogo = ![self.businessLine isEqualToString:SAClientTypeMaster];
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

        cell.clickedPickUpBlock = ^(SAOrderModel *_Nonnull orderModel) {
            @HDStrongify(self);
            [self handlePickUpWithModel:orderModel];
        };
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.row >= self.dataSource.count)
        return;

    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:SAOrderModel.class]) {
        SAOrderModel *trueModel = (SAOrderModel *)model;
        if (HDIsStringNotEmpty(trueModel.orderDetailUrl)) {
            [SAWindowManager openUrl:trueModel.orderDetailUrl withParameters:nil];
        } else {
            [self navigateToOrderDetailsWithOrderNo:trueModel.orderNo outPayNo:trueModel.outPayOrderNo businessOrderNo:trueModel.businessOrderNo businessLine:trueModel.businessLine];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
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
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

- (NSMutableArray<SAOrderModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
            return [SAOrderListTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [SAOrderListTableViewCell skeletonViewHeight];
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

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
