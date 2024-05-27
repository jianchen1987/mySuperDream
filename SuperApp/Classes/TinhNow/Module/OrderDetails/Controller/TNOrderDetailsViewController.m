//
//  TNOrderDetailsViewController.m
//  SuperApp
//
//  Created by seeu on 2020/7/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsViewController.h"
#import "HDCheckStandPresenter.h"
#import "HDCheckStandViewController.h"
#import "HDTradeBuildOrderModel.h"
#import "SAAddressModel.h"
#import "SAChoosePaymentMethodPresenter.h"
#import "SAGoodsModel.h"
#import "SAInfoTableViewCell.h"
#import "SAPaymentDTO.h"
#import "SAQueryPaymentStateRspModel.h"
#import "SAShoppingAddressModel.h"
#import "SATableView.h"
#import "TNCustomerServiceAlertView.h"
#import "TNCustomerServiceView.h"
#import "TNExchangeAlertView.h"
//#import "TNExpressTrackingStatusCell.h"
#import "NSDate+SAExtension.h"
#import "TNIMManagerHander.h"
#import "TNIMManger.h"
#import "TNOrderActionBarView.h"
#import "TNOrderDTO.h"
#import "TNOrderDetailAdressCell.h"
#import "TNOrderDetailContactCell.h"
#import "TNOrderDetailExpressCell.h"
#import "TNOrderDetailsGoodsSummarizeTableViewCell.h"
#import "TNOrderDetailsSkeletonCell.h"
#import "TNOrderDetailsStatusTableViewCell.h"
#import "TNOrderDetailsViewModel.h"
#import "TNOrderDiffrenceRecordView.h"
#import "TNOrderSkuSpecifacationCell.h"
#import "TNOrderStoreHeaderView.h"
#import "TNOrderSubmitGoodsTableViewCell.h"
#import "TNOrderSubmitSkeletonTableViewCell.h"
#import "TNOrderTipCell.h"
#import "TNPaymentResultViewController.h"
#import "TNPhoneActionAlertView.h"
#import "TNQueryOrderDetailsRspModel.h"
#import "TNTabBarViewController.h"
#import "UIView+NAT.h"


@interface TNOrderDetailsViewController () <UITableViewDelegate, UITableViewDataSource, HDCheckStandViewControllerDelegate>
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 底部操作栏
@property (nonatomic, strong) TNOrderActionBarView *actionBarView;
/// viewMoedl
@property (nonatomic, strong) TNOrderDetailsViewModel *viewModel;
/// 定时器
@property (nonatomic, strong) NSTimer *timer;
/// 订单详情 用于 更换地址之后 决定是否触发 hd_getNewData
@property (nonatomic, assign) BOOL isNeedGetData;
/// 支付状态查询DTO
@property (nonatomic, strong) SAPaymentDTO *paymentStateDTO;

//@property (nonatomic, strong) NSTimer *paymentStateTimer;  ///< 支付状态定时器
@property (nonatomic, strong) TNOrderDTO *orderDto; ///<
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNOrderDetailsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.orderNo = [parameters valueForKey:@"orderNo"];
    }
    return self;
}

- (void)dealloc {
    //    if (_timer) {
    //        [_timer invalidate];
    //        _timer = nil;
    //    }
    [self.timer invalidate];
    self.timer = nil;
    //    [self.paymentStateTimer invalidate];
    //    self.paymentStateTimer = nil;
}

- (void)hd_setupViews {
    self.viewModel = TNOrderDetailsViewModel.new;
    self.miniumGetNewDataDuration = 1;
    self.isNeedGetData = YES;
    self.view.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.actionBarView];

    //    self.paymentStateTimer = [HDWeakTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(queryPaymentState) userInfo:nil repeats:YES];
}
// 页面埋点
- (void)trackingPage {
    [TNEventTrackingInstance trackPage:@"order_result" properties:@{@"orderId": self.orderNo}];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarH);
        make.bottom.equalTo(self.actionBarView.mas_top);
    }];

    [self.actionBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kRealHeight(50.0f) + kiPhoneXSeriesSafeBottomHeight);
    }];
    [super updateViewConstraints];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_order_details", @"订单详情");
}
#pragma mark - Data
- (void)hd_getNewData {
    if (HDIsStringNotEmpty(self.orderNo)) {
        if (self.isNeedGetData) {
            [self removePlaceHolder];
            [self.viewModel getNewDataWithOrderNo:self.orderNo];
        }
        self.isNeedGetData = YES;
    }
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    self.viewModel.view = self.view;
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:YES];

    self.viewModel.networkFailBlock = ^{
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self refreshNewData];
        }];
    };

    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self hd_getNewData];
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view dismissLoading];
        if (!self.viewModel.dataSource || self.viewModel.dataSource.count <= 0) {
            @HDWeakify(self);
            [self showNoDataPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
                @HDStrongify(self);
                [self refreshNewData];
            }];
            self.actionBarView.hidden = YES;
        } else {
            [self.tableView successGetNewDataWithNoMoreData:YES];
            self.actionBarView.hidden = NO;
        }

        if ([TNOrderStatePendingPayment isEqualToString:self.viewModel.orderDetails.orderDetail.status]
            && ![self.viewModel.orderDetails.orderDetail.paymentInfo.method isEqualToString:TNPaymentMethodTransfer] && self.viewModel.orderDetails.orderDetail.expire > 0) {
            if (self.timer != nil) {
                [self.timer invalidate];
                self.timer = nil;
            }
            self.timer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            [self.timer fire];
        }
    }];
}

//- (void)queryPaymentState {
//    HDLog(@"定时查询支付状态...");
//    @HDWeakify(self);
//    [self.paymentStateDTO queryOrderPaymentStateWithOrderNo:self.orderNo
//                                                    success:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
//                                                        HDLog(@"当前支付状态为:%zd", rspModel.payState);
//                                                        @HDStrongify(self);
//                                                        if (rspModel.payState != SAPaymentStateInit && rspModel.payState != SAPaymentStatePaying) {
//                                                            [self.paymentStateTimer invalidate];
//                                                            [self.viewModel getNewDataWithOrderNo:self.orderNo];
//                                                        }
//                                                    }
//                                                    failure:nil];
//}
- (void)refreshNewData {
    [self removePlaceHolder];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:YES];
    [self.viewModel getNewDataWithOrderNo:self.orderNo];
}

#pragma mark - Actions
- (void)clickOnCancelButton {
    @HDWeakify(self);
    HDAlertView *alert = [HDAlertView alertViewWithTitle:TNLocalizedString(@"tn_order_cancel_confirm_title", @"确认放弃购买？")
                                                 message:TNLocalizedString(@"tn_order_cancel_confirm_content", @"商品数量有限，还有用户正在抢购哦~")
                                                  config:nil];
    [alert addButton:[HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_order_cancel_continue_title", @"继续购买") type:HDAlertViewButtonTypeCancel
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                }]];
    [alert addButton:[HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_order_cancel_confirm_btn", @"确认取消") type:HDAlertViewButtonTypeCustom
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                    @HDStrongify(self);

                                                    [self.viewModel cancalOrderWithOrderNo:self.orderNo completed:^{
                                                        @HDStrongify(self);
                                                        [self.view showloading];
                                                        [TNEventTrackingInstance trackEvent:@"order_cancel" properties:@{@"orderId": self.orderNo}];
                                                        [self performSelector:@selector(hd_getNewData) withObject:nil afterDelay:2];
                                                    }];
                                                }]];

    [alert show];
}

- (void)clickOnConfirmButton {
    @HDWeakify(self);
    HDAlertView *alert = [HDAlertView alertViewWithTitle:nil message:TNLocalizedString(@"tn_order_confirm_title", @"请确认，你已经收到货~") config:nil];
    [alert addButton:[HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_button_NoYet_title", @"取消") type:HDAlertViewButtonTypeCancel
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                }]];
    [alert addButton:[HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_button_received", @"确定") type:HDAlertViewButtonTypeCustom
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                    @HDStrongify(self);
                                                    [self.viewModel confirmOrderWithOrderNo:self.orderNo completed:^{
                                                        @HDStrongify(self);
                                                        [self.view showloading];
                                                        [self performSelector:@selector(hd_getNewData) withObject:nil afterDelay:2];
                                                    }];
                                                }]];

    [alert show];
}

- (void)clickOnReview {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"orderNo"] = self.orderNo;
    //    [HDMediator.sharedInstance navigaveToTinhNowEvaluationViewController:params];
    [HDMediator.sharedInstance navigaveToTinhNowPostReviewlViewController:params];
}
/// 唤起收银台支付
- (void)openCashierToPayWithPaymentMethod:(HDPaymentMethodType *)paymentMethod {
    if (self.viewModel.orderDetails.orderDetail.amountPayable.cent.integerValue > 0) { // 实付金额>0元时才需要调起收银台
        HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
        buildModel.orderNo = self.viewModel.orderDetails.orderInfo.orderNo;
        //                buildModel.outPayOrderNo = self.viewModel.orderDetails.orderInfo.outPayOrderNo; // 收银台会创建支付单，不需要业务创建
        buildModel.storeNo = self.viewModel.orderDetails.orderInfo.storeNo;
        buildModel.merchantNo = self.viewModel.orderDetails.orderInfo.merchantNo;
        buildModel.payableAmount = self.viewModel.orderDetails.orderDetail.amountPayable;
        buildModel.businessLine = SAClientTypeTinhNow;
        if (!HDIsObjectNil(paymentMethod)) {
            buildModel.selectedPaymentMethod = paymentMethod;
        }
        buildModel.goods = [self.viewModel.orderDetails.orderDetail.items mapObjectsUsingBlock:^id _Nonnull(TNOrderDetailsGoodsInfoModel *_Nonnull obj, NSUInteger idx) {
            SAGoodsModel *item = SAGoodsModel.new;
            item.goodsId = obj.productId;
            item.skuId = obj.skuId;
            item.quantity = obj.quantity.integerValue;
            return item;
        }];

        buildModel.needCheckPaying = YES; //需要校验重新支付的时候改成YES
        [HDCheckStandPresenter payWithTradeBuildModel:buildModel preferedHeight:0 fromViewController:self delegate:self];
    } else {
        self.isNeedGetData = YES;
        [self hd_getNewData]; //重新刷新状态
    }
}

- (void)clickOnPayment {
    if (HDIsStringNotEmpty(self.viewModel.orderDetails.orderDetail.payChannelCode)) {
        HDPaymentMethodType *paymentMethod = [HDPaymentMethodType onlineMethodWithPaymentTool:self.viewModel.orderDetails.orderDetail.payChannelCode];
        //已经有支付方式  查询支付方式是否可用
        [SAChoosePaymentMethodPresenter trialWithPayableAmount:self.viewModel.orderDetails.orderDetail.amountPayable businessLine:SAClientTypeTinhNow
                                       supportedPaymentMethods:@[HDSupportedPaymentMethodOnline]
                                                    merchantNo:self.viewModel.orderDetails.orderInfo.merchantNo
                                                       storeNo:self.viewModel.orderDetails.orderInfo.storeNo
                                                         goods:@[]
                                         selectedPaymentMethod:paymentMethod completion:^(BOOL available, NSString *_Nullable ruleNo, SAMoneyModel *_Nullable discountAmount) {
                                             if (available) {
                                                 paymentMethod.ruleNo = ruleNo;
                                                 [self openCashierToPayWithPaymentMethod:paymentMethod];
                                             } else {
                                                 [self openCashierToPayWithPaymentMethod:nil];
                                             }
                                         }];
    } else {
        [self openCashierToPayWithPaymentMethod:nil];
    }
}

- (void)clickOnExchange {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel queryExchangeOrderExplainSuccess:^(TNQueryExchangeOrderExplainRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
        config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
        config.buttonTitle = TNLocalizedString(@"tn_button_confirm_title", @"取消");
        config.buttonBgColor = HDAppTheme.TinhNowColor.C1;
        config.buttonTitleFont = HDAppTheme.TinhNowFont.standard17B;
        config.buttonTitleColor = UIColor.whiteColor;
        config.iPhoneXFillViewBgColor = HDAppTheme.TinhNowColor.C1;
        const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
        TNExchangeAlertView *view = [[TNExchangeAlertView alloc] initWithFrame:CGRectMake(0, 0, width, 10) model:rspModel];
        [view layoutyImmediately];
        HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
        [actionView show];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}
- (void)clickOnCheckReview {
    [HDMediator.sharedInstance navigaveToTinhNowMyReviewsPage:@{@"index": @"1"}]; //跳转到已评价列表
}
- (void)clickRebuyProduct {
    [self.viewModel rebuyOrderWithOrderNo:self.orderNo completed:^(NSArray *_Nonnull skuIds) {
        [SAWindowManager openUrl:@"SuperApp://TinhNow/ShoppingCar" withParameters:@{@"skuIds": skuIds}];
    }];
}

- (void)clickPlatformPhone:(BOOL)isShowBusiness {
    /// 联系平台
    TNCustomerServiceView *view = [[TNCustomerServiceView alloc] init];

    NSMutableArray *arr = [NSMutableArray arrayWithArray:[view getTinhnowDefaultPlatform]];
    if (isShowBusiness) {
        NSString *phoneStr = self.viewModel.orderDetails.orderDetail.storeInfo.hotline;
        if (HDIsStringEmpty(phoneStr)) {
            phoneStr = TNLocalizedString(@"tn_order_detials_no_business_phone", @"暂无联系方式");
        }

        TNCustomerServiceItemModel *itemModel = TNCustomerServiceItemModel.new;
        itemModel.key = phoneStr;
        itemModel.btnTitle = phoneStr;
        itemModel.btnImage = @"tn_phone_business";
        itemModel.backgroundColors = @[HexColor(0xD0DDFE), [UIColor whiteColor]];

        TNCustomerServiceModel *model = [[TNCustomerServiceModel alloc] init];
        model.title = TNLocalizedString(@"tn_service_phone", @"商家电话");
        model.listArray = @[itemModel];

        [arr insertObject:model atIndex:0];
    }

    view.dataSource = arr;

    [view layoutyImmediately];

    TNPhoneActionAlertView *actionView = [[TNPhoneActionAlertView alloc] initWithContentView:view];
    [actionView show];
}
///倒计时
- (void)countDown {
    NSInteger surplus = self.viewModel.orderDetails.orderDetail.expire / 1000.0 - [NSDate new].timeIntervalSince1970;
    if (surplus > 0 && [TNOrderStatePendingPayment isEqualToString:self.viewModel.orderDetails.orderDetail.status]) {
        HDLog(@"surplus:%zd", surplus);
        if ([self.tableView numberOfSections] > 0) {
            [self.tableView reloadRowsAtIndexPaths:@[self.viewModel.statusIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }

    } else {
        [self.timer invalidate];
        [self hd_getNewData];
    }
}

- (void)clickedOnNearby {
    [self showloading];
    @HDWeakify(self);
    [self.orderDto queryNearByRouteWithOrderNo:self.orderNo storeNo:self.viewModel.orderDetails.orderDetail.storeInfo.storeNo success:^(NSString *_Nullable route) {
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

/// 获取商户客服列表
- (void)getCustomerList:(NSString *)storeNo {
    [self.view showloading];
    [[TNIMManger shared] getCustomerServerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
        [self.view dismissLoading];
        if (rspModelArray.count > 0) {
            TNIMRspModel *imModel = rspModelArray.firstObject;
            // TODO: IM路由入口
            HDLog(@"%@", imModel);
            [self openIMViewControllerWithOperatorNo:imModel.operatorNo storeNo:storeNo];
        } else {
            HDLog(@"没获取到数据");
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self.view dismissLoading];
        HDLog(@"%@", error.domain);
    }];
}

/// 打开IM
- (void)openIMViewControllerWithOperatorNo:(NSString *)operatorNo storeNo:(NSString *)storeNo {
    NSDictionary *dict = @{
        @"operatorType": @(8),
        @"operatorNo": operatorNo ?: @"",
        @"storeNo": storeNo ?: @"",
        @"orderCard": [@{
            @"storeLogo": @"https://img.tinhnow.com/wownow/files/app/M89/89/50/4E/c9049e00672411ed97565796da9bd9e5.png",
            @"storeName": self.viewModel.orderDetails.orderDetail.storeInfo.name,
            @"orderStatusDesc": self.viewModel.orderDetails.orderDetail.statusTitle,
            @"goodsIcon": self.viewModel.orderDetails.orderDetail.items.firstObject.thumbnail,
            @"goodsDesc": self.viewModel.orderDetails.orderDetail.items.firstObject.name,
            @"orderTime": [NSString stringWithFormat:@"%@:%@",
                                                     TNLocalizedString(@"AegA4yhW", @"下单时间"),
                                                     [[NSDate dateWithTimeIntervalSince1970:self.viewModel.orderDetails.orderInfo.orderTimeStamp / 1000] stringWithFormatStr:@"dd/MM/yyyy HH:mm"]],
            @"total": [NSString stringWithFormat:@"%@:%@", TNLocalizedString(@"tn_total", @"总计"), self.viewModel.orderDetails.orderDetail.amount.thousandSeparatorAmount],
            @"bizLine": SAClientTypeTinhNow,
            @"orderNo": self.orderNo,
            @"bizOrderNo": self.viewModel.orderDetails.orderInfo.businessOrderId
        } yy_modelToJSONString],
        @"scene": SAChatSceneTypeTinhNowConsult
    };
    [[HDMediator sharedInstance] navigaveToIMViewController:dict];
}
#pragma mark 弹出联系客服弹窗
- (void)showCustomerServiceAlertView {
    TNCustomerServiceAlertView *alertView = [TNCustomerServiceAlertView alertViewWithContentText:TNLocalizedString(@"7PvHNTC0", @"海外购商品如非质量问题，不支持退款，如需退款，请联系商家客服")
                                                                                         storeNo:self.viewModel.orderDetails.orderDetail.storeInfo.storeNo
                                                                                         orderNo:self.orderNo];
    [alertView show];
}
/// 修改地址
- (void)changeAddressWithAdressModel:(SAShoppingAddressModel *)changeAddressModel indexPath:(NSIndexPath *)indexPath adressCellModel:(TNOrderDetailAdressCellModel *)addressCellModel {
    [self.view showloading];
    @HDWeakify(self);
    [self.viewModel changeOrderAddressWithOrderNo:self.orderNo addressNo:changeAddressModel.addressNo success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        addressCellModel.address = changeAddressModel.address;
        addressCellModel.phone = changeAddressModel.mobile;
        addressCellModel.name = changeAddressModel.consigneeName;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [NAT showToastWithTitle:nil content:TNLocalizedString(@"tn_change_success", @"修改成功") type:HDTopToastTypeSuccess];

        [TNEventTrackingInstance trackEvent:@"ship_switch_addr" properties:@{@"orderId": self.orderNo}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [NAT showToastWithTitle:nil content:TNLocalizedString(@"tn_change_faild", @"修改失败") type:HDTopToastTypeSuccess];
    }];
}

/// 打开地址列表选择
- (void)editAddress:(NSIndexPath *)indexPath cellModel:(TNOrderDetailAdressCellModel *)addressCellModel {
    TNOrderState status = addressCellModel.status;
    if ([self.viewModel canEdit:status]) {
        if ([status isEqualToString:TNOrderStateShipped]) {
            [NAT showAlertWithMessage:TNLocalizedString(@"tn_orderDetails_edit_address_tpis1", @"商品已发货，修改地址请您联系客服处理")
                          buttonTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                              [alertView dismiss];
                          }];
        } else {
            @HDWeakify(self);
            [NAT showAlertWithMessage:TNLocalizedString(@"tn_orderDetails_edit_address_tpis2", @"修改地址可能影响配送，您确定要修改吗?")
                confirmButtonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];

                    void (^callback)(SAShoppingAddressModel *) = ^(SAShoppingAddressModel *addressModel) {
                        @HDStrongify(self);
                        [self.viewModel checkAdressIsOnTargetAreaWithLatitude:addressModel.latitude longitude:addressModel.longitude completed:^{
                            @HDStrongify(self);
                            [self changeAddressWithAdressModel:addressModel indexPath:indexPath adressCellModel:addressCellModel];
                        }];
                    };

                    [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": callback, @"currentAddressModel": SAAddressModel.new}];
                    self.isNeedGetData = NO;
                }
                cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                }];
        }
    }
}

- (void)cancelApplyRefund {
    @HDWeakify(self);
    HDAlertView *alert = [HDAlertView alertViewWithTitle:TNLocalizedString(@"tn_notice", @"提示") message:TNLocalizedString(@"tn_cancel_applyRefund_confirm_content", @"您确定要取消退款吗？")
                                                  config:nil];

    [alert addButton:[HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons") type:HDAlertViewButtonTypeCustom
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                    @HDStrongify(self);

                                                    [self.viewModel cancelApplyRefundWithOrderNo:self.orderNo completed:^{
                                                        @HDStrongify(self);
                                                        [self.view showloading];
                                                        [self performSelector:@selector(hd_getNewData) withObject:nil afterDelay:2];
                                                    }];
                                                }]];

    [alert addButton:[HDAlertViewButton buttonWithTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") type:HDAlertViewButtonTypeCancel
                                                handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                    [alertView dismiss];
                                                }]];

    [alert show];
}

//- (void)gotoPaymentResultWithPaymentType:(SAOrderPaymentType)paymentType orderNo:(NSString *)orderNo amount:(SAMoneyModel *)paymentAmount paymentState:(SAPaymentState)paymentState {
//    TNPaymentResultViewController *vc = TNPaymentResultViewController.new;
//    TNPaymentResultModel *model = TNPaymentResultModel.new;
//
//    model.pageName = TNLocalizedString(@"tn_payment_result", @"支付结果页");
//    model.buttonBackgroundColor = HDAppTheme.TinhNowColor.C3;
//    model.paymentType = paymentType;
//    model.orderNo = orderNo;
//    model.amount = paymentAmount;
//    model.state = paymentState;
//    vc.model = model;
//    vc.backHomeClickedHander = ^(TNPaymentResultModel *_Nonnull model) {
//        [SAWindowManager navigateToBusinessLineHomePageWithClass:TNTabBarViewController.class];
//    };
//    vc.orderDetailClickedHandler = ^(TNPaymentResultModel *_Nonnull model) {
//        [self.navigationController popToRootViewControllerAnimated:NO];
//        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": model.orderNo}];
//    };
//    [SAWindowManager presentViewController:vc parameters:@{}];
//}
#pragma mark - 支付成功埋点
- (void)paySuccessOnPlaceOrder {
    if (HDIsStringNotEmpty(self.viewModel.orderDetails.orderInfo.orderNo) && !HDIsArrayEmpty(self.viewModel.orderDetails.orderDetail.items)) {
        TalkingDataOrder *dataOrder = [TalkingDataOrder createOrder:self.viewModel.orderDetails.orderInfo.orderNo total:[self.viewModel.orderDetails.orderDetail.amountPayable.cent intValue]
                                                       currencyType:self.viewModel.orderDetails.orderDetail.amountPayable.cy];
        for (TNOrderDetailsGoodsInfoModel *item in self.viewModel.orderDetails.orderDetail.items) {
            [dataOrder addItem:item.productId category:@"" name:item.name unitPrice:[item.price.cent intValue] amount:[item.quantity intValue]];
        }
        [TalkingData onOrderPaySucc:SAUser.shared.loginName payType:@"在线支付" order:dataOrder];
    }
}
#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:@{@"orderNo": controller.currentOrderNo, @"businessLine": controller.businessLine, @"merchantNo": controller.merchantNo}];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        //支付成功埋点
        [self paySuccessOnPlaceOrder];
        [HDMediator.sharedInstance
            navigaveToCheckStandPayResultViewController:@{@"orderNo": controller.currentOrderNo, @"businessLine": controller.businessLine, @"merchantNo": controller.merchantNo}];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    //    NSString *tipStr = HDIsStringNotEmpty(resultResp.errStr) ? resultResp.errStr : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    //    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance
            navigaveToCheckStandPayResultViewController:
                @{@"orderNo": controller.currentOrderNo,
                  @"businessLine": controller.businessLine,
                  @"paymentState": @(SAPaymentStatePayFail),
                  @"merchantNo": controller.merchantNo}];
        //                                       [self gotoPaymentResultWithPaymentType:SAOrderPaymentTypeOnline
        //                                                                      orderNo:self.viewModel.orderDetails.orderDetail.unifiedOrderNo
        //                                                                       amount:self.viewModel.orderDetails.orderInfo.payableAmount
        //                                                                 paymentState:SAPaymentStatePayFail];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource[section].list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNOrderDetailsSkeletonCellModel.class]) {
        return kScreenHeight;
    } else {
        return UITableViewAutomaticDimension;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[section];
    if (sectionModel.headerModel && [sectionModel.headerModel isKindOfClass:HDTableHeaderFootViewModel.class]) {
        return 40;
    } else if (sectionModel.commonHeaderModel && [sectionModel.commonHeaderModel isKindOfClass:TNOrderStoreHeaderModel.class]) {
        return 40;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[section];
    if (sectionModel.headerModel && [sectionModel.headerModel isKindOfClass:HDTableHeaderFootViewModel.class]) {
        HDTableHeaderFootView *view = [HDTableHeaderFootView headerWithTableView:tableView];
        view.model = sectionModel.headerModel;
        return view;
    } else if (sectionModel.commonHeaderModel && [sectionModel.commonHeaderModel isKindOfClass:TNOrderStoreHeaderModel.class]) {
        TNOrderStoreHeaderView *view = [TNOrderStoreHeaderView headerWithTableView:tableView];
        view.model = sectionModel.commonHeaderModel;
        @HDWeakify(self);
        view.goStoreTrackEventCallBack = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击店铺入口"]];
        };
        return view;
    } else {
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"SAInfoViewModel + %ld + %ld", indexPath.section, indexPath.row]];
        cell.model = (SAInfoViewModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNOrderDetailAdressCellModel.class]) {
        TNOrderDetailAdressCell *cell = [TNOrderDetailAdressCell cellWithTableView:tableView];
        cell.model = (TNOrderDetailAdressCellModel *)model;
        @HDWeakify(self);
        cell.editClickHanderBlock = ^{
            @HDStrongify(self);
            [self editAddress:indexPath cellModel:model];
        };
        return cell;
    } else if ([model isKindOfClass:TNOrderSubmitGoodsTableViewCellModel.class]) {
        TNOrderSubmitGoodsTableViewCell *cell = [TNOrderSubmitGoodsTableViewCell cellWithTableView:tableView];
        cell.refundStatusDes = self.viewModel.orderDetails.orderDetail.refundStatusDes;
        cell.model = (TNOrderSubmitGoodsTableViewCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNOrderDetailsStatusTableViewCellModel.class]) {
        TNOrderDetailsStatusTableViewCell *cell = [TNOrderDetailsStatusTableViewCell cellWithTableView:tableView];
        cell.model = (TNOrderDetailsStatusTableViewCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNOrderDetailsGoodsSummarizeTableViewCellModel.class]) {
        TNOrderDetailsGoodsSummarizeTableViewCell *cell = [TNOrderDetailsGoodsSummarizeTableViewCell cellWithTableView:tableView];
        cell.model = (TNOrderDetailsGoodsSummarizeTableViewCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNOrderDetailsSkeletonCellModel.class]) {
        TNOrderDetailsSkeletonCell *cell = [TNOrderDetailsSkeletonCell cellWithTableView:tableView];
        return cell;
    } else if ([model isKindOfClass:TNOrderTipCellModel.class]) {
        TNOrderTipCell *cell = [TNOrderTipCell cellWithTableView:tableView];
        cell.model = (TNOrderTipCellModel *)model;
        @HDWeakify(self);
        cell.refreshClickCallBack = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击刷新审核状态"]];
            [self.tableView getNewData];
        };
        return cell;
    } else if ([model isKindOfClass:TNOrderDetailExpressCellModel.class]) {
        TNOrderDetailExpressCell *cell = [TNOrderDetailExpressCell cellWithTableView:tableView];
        cell.model = (TNOrderDetailExpressCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNOrderDetailContactCellModel.class]) {
        TNOrderDetailContactCell *cell = [TNOrderDetailContactCell cellWithTableView:tableView];
        cell.model = (TNOrderDetailContactCellModel *)model;
        @HDWeakify(self);
        cell.customerServiceButtonClickedHander = ^(NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击商家客服"]];
            [TNEventTrackingInstance trackEvent:@"store_im" properties:@{@"orderId": self.orderNo}];
            [self getCustomerList:storeNo];
        };
        cell.phoneButtonClickedHander = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击联系电话"]];
            [TNEventTrackingInstance trackEvent:@"store_tel" properties:@{@"orderId": self.orderNo}];
            [self clickPlatformPhone:YES];
        };
        return cell;
    } else if ([model isKindOfClass:TNOrderSkuSpecifacationCellModel.class]) {
        TNOrderSkuSpecifacationCell *cell = [TNOrderSkuSpecifacationCell cellWithTableView:tableView];
        cell.cellModel = (TNOrderSkuSpecifacationCellModel *)model;
        return cell;
    } else {
        return UITableViewCell.new;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNOrderDetailsSkeletonCellModel.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNOrderSubmitGoodsTableViewCellModel.class]) {
        TNOrderSubmitGoodsTableViewCellModel *trueModel = (TNOrderSubmitGoodsTableViewCellModel *)model;
        if ([trueModel.type isEqualToString:@"GROUPON"] && HDIsStringNotEmpty(trueModel.activityId)) {
            //拼团商品详情
            NSString *groupBuyingGoodsDetailURL = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowGroupBuyingGoodsDetail];
            NSString *openURL = [NSString stringWithFormat:@"%@activityId=%@&productId=%@", groupBuyingGoodsDetailURL, trueModel.activityId, trueModel.productId];
            [SAWindowManager openUrl:openURL withParameters:nil];
        } else if ([trueModel.type isEqualToString:@"BARGAIN"] && HDIsStringNotEmpty(trueModel.activityId)) {
            //砍价商品详情
            [HDMediator.sharedInstance navigaveTinhNowBargainProductDetailViewController:@{@"activityId": trueModel.activityId}];
        } else {
            //普通商品
            [HDMediator.sharedInstance navigaveTinhNowProductDetailViewController:@{@"productId": trueModel.productId, @"sp": trueModel.sp}];
        }
    }
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        if ([trueModel.associatedObject isKindOfClass:NSString.class]) {
            NSString *associatedObjectStr = trueModel.associatedObject;
            if ([associatedObjectStr isEqualToString:@"record"]) {
                HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
                config.containerViewEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
                config.buttonTitle = @"OK";
                config.buttonBgColor = HDAppTheme.TinhNowColor.C1;
                config.buttonTitleFont = HDAppTheme.TinhNowFont.standard17B;
                config.buttonTitleColor = UIColor.whiteColor;
                config.iPhoneXFillViewBgColor = HDAppTheme.TinhNowColor.C1;
                const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
                TNOrderDiffrenceRecordView *view = [[TNOrderDiffrenceRecordView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
                view.model = self.viewModel.orderDetails.orderDetail;
                [view layoutyImmediately];
                HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
                [actionView show];
                view.closeClickedCallBack = ^{
                    [actionView dismiss];
                };
            } else if ([associatedObjectStr isEqualToString:@"refund_record"]) { //电商的 退款详情
                [[HDMediator sharedInstance] navigaveToTinhNowRefundDetailViewController:@{@"orderNo": self.orderNo}];
            }
        }
    }
    //    if ([model isKindOfClass:TNOrderDetailExpressCellModel.class]) {
    //        TNOrderDetailExpressCellModel *expressModel = model;
    //        if (expressModel.isOverseas) {
    //            [[HDMediator sharedInstance] navigaveToTinhNowExpressTrackingViewController:@{@"orderNo": self.orderNo}];
    //        } else {
    //            [[HDMediator sharedInstance] navigaveToExpressDetails:@{@"bizOrderId": self.orderNo}];
    //        }
    //    }
}

#pragma mark - lazy load
/** @lazy tableView */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.needShowErrorView = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 5.0f;
    }
    return _tableView;
}
/** @lazy actionBarView */
- (TNOrderActionBarView *)actionBarView {
    if (!_actionBarView) {
        _actionBarView = [[TNOrderActionBarView alloc] initWithViewModel:self.viewModel];
        _actionBarView.hidden = YES;
        @HDWeakify(self);
        _actionBarView.cancelClicked = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击取消订单"]];
            [self clickOnCancelButton];
        };
        _actionBarView.confirmClicked = ^{
            @HDStrongify(self);
            [self clickOnConfirmButton];
        };
        _actionBarView.paymentClicked = ^{
            @HDStrongify(self);
            @HDWeakify(self);
            [SAWindowManager
                navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                      @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                    SALocalizedString(@"login_new2_Online Shopping Order", @"电商购物")] bindSuccessBlock:^{
                    @HDStrongify(self);
                    [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击支付订单"]];
                    [self clickOnPayment];
                }
                                         cancelBindBlock:nil];
        };
        _actionBarView.reviewClicked = ^{
            @HDStrongify(self);
            [self clickOnReview];
        };
        _actionBarView.exchangeClicked = ^{
            @HDStrongify(self);
            [self clickOnExchange];
        };
        _actionBarView.checkReviewClicked = ^{
            @HDStrongify(self);
            [self clickOnCheckReview];
        };
        _actionBarView.reBuyClicked = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击再次购买"]];
            [self clickRebuyProduct];
        };
        _actionBarView.oneMoreClicked = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"订单详情_点击附近购买"]];
            [self clickedOnNearby];
        };
        _actionBarView.applyRefundClicked = ^{
            @HDStrongify(self);
            // 如果是海外购订单  且已经到已发货或者已完成状态 弹窗联系商家客服
            if ([self.viewModel.orderDetails.orderDetail.type isEqualToString:TNOrderTypeOverseas]
                && ([self.viewModel.orderDetails.orderDetail.status isEqualToString:TNOrderStateShipped] || [self.viewModel.orderDetails.orderDetail.status isEqualToString:TNOrderStateCompleted])) {
                [self showCustomerServiceAlertView];
            } else {
                //申请退款
                if (HDIsStringEmpty(self.viewModel.orderDetails.orderDetail.orderRefundsId)) {
                    [[HDMediator sharedInstance] navigaveToTinhNowApplyRefundViewController:@{@"orderNo": self.orderNo}];
                } else {
                    [self clickPlatformPhone:NO];
                }
            }
        };
        _actionBarView.cancelApplyRefundClicked = ^{
            @HDStrongify(self);
            [self cancelApplyRefund];
        };
        _actionBarView.transferPayClicked = ^{
            @HDStrongify(self);
            [[HDMediator sharedInstance] navigaveToTinhNowTransferViewController:@{@"orderNo": self.orderNo}];
        };
        //        _actionBarView.refreshClicked = ^{
        //            @HDStrongify(self);
        //            [self.tableView getNewData];
        //        };
        _actionBarView.customerServiceClicked = ^{
            @HDStrongify(self);
            [self clickPlatformPhone:YES];
        };
    }
    return _actionBarView;
}
- (SAPaymentDTO *)paymentStateDTO {
    if (!_paymentStateDTO) {
        _paymentStateDTO = [[SAPaymentDTO alloc] init];
    }
    return _paymentStateDTO;
}
- (TNOrderDTO *)orderDto {
    if (!_orderDto) {
        _orderDto = [[TNOrderDTO alloc] init];
    }
    return _orderDto;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNOrderSubmitSkeletonTableViewCell cellWithTableView:tableview];
            } else if (indexPath.row == 1) {
                return [TNOrderSubmitSkeletonPayMentCell cellWithTableView:tableview];
            } else {
                return [TNOrderSubmitSkeletonGoodsCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNOrderSubmitSkeletonTableViewCell skeletonViewHeight];
            } else if (indexPath.row == 1) {
                return [TNOrderSubmitSkeletonPayMentCell skeletonViewHeight];
            } else {
                return [TNOrderSubmitSkeletonGoodsCell skeletonViewHeight];
            }
        }];
        _provider.numberOfRowsInSection = 4;
    }
    return _provider;
}
@end
