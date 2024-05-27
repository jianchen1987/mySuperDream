//
//  WMOrderSubmitV2View.m
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitV2View.h"
#import "HDCheckStandViewController.h"
#import "HDPaymentMethodType.h"
#import "LKDataRecord.h"
#import "SAApolloManager.h"
#import "SACacheManager.h"
#import "SANotificationConst.h"
#import "SAPayResultViewController.h"
#import "SAShoppingAddressModel.h"
#import "SATalkingData.h"
#import "WMChooseAddressViewModel.h"
#import "WMCustomViewActionView.h"
#import "WMHomeViewController.h"
#import "WMOrderChangeReminderView.h"
#import "WMOrderDetailViewController.h"
#import "WMOrderNoticeView.h"
#import "WMOrderResultController.h"
#import "WMOrderSubmitBottomDock.h"
#import "WMOrderSubmitDeliveryInfoView.h"
#import "WMOrderSubmitOrderInfoView.h"
#import "WMOrderSubmitV2ViewModel.h"
#import "WMPromoCodeAlertView.h"
#import <HDKitCore/HDKitCore.h>
#import "WMLocationTipView.h"
#import "WMOrderDeliveryOrToStoreView.h"
#import "WMOrderSubmitToStoreInfoView.h"
#import "SAPhoneFormatValidator.h"


@interface WMOrderSubmitV2View () <HDCheckStandViewControllerDelegate, UITextFieldDelegate, HDActionAlertViewDelegate>
/// VM
@property (nonatomic, weak) WMOrderSubmitV2ViewModel *viewModel;
/// 下单 Dock
@property (nonatomic, strong) WMOrderSubmitBottomDock *submitBottomDockView;
/// 顶部提示
@property (nonatomic, strong) WMOrderNoticeView *noticeView;
/// 配送信息、付款方式等
@property (nonatomic, strong) WMOrderSubmitDeliveryInfoView *deliveryInfoView;

@property (nonatomic, strong) WMOrderSubmitToStoreInfoView *toStoreInfoView;

/// 下单信息
@property (nonatomic, strong) WMOrderSubmitOrderInfoView *orderInfoView;
/// 下单成功返回
@property (nonatomic, strong) WMOrderSubmitRspModel *submitOrderRspModel;
/// 选择地址的返回
@property (nonatomic, assign) NSInteger chooseAddressBack;
/// 是否弹出过找零提示弹窗
@property (nonatomic, assign) BOOL isShowChangeReminderFlag;
/// 正在显示的弹窗
@property (nonatomic, strong) WMCustomViewActionView *actionView;
/// 记录键盘是否弹出
@property (nonatomic, assign) BOOL keyBoardlsVisible;
/// 地址提示
//@property (nonatomic, strong) WMLocationTipView *localTip;

@property (nonatomic, strong) WMOrderDeliveryOrToStoreView *deliveryOrToStoreView;

@property (nonatomic, assign) BOOL hasShowToStoreTip;

/// 外卖备注
@property (nonatomic, copy) NSString *deliveryRemarks;
@property (nonatomic, copy) NSString *deliveryChangeReminder;
@property (nonatomic, strong) NSArray<WMWriteNoteTagRspModel *> *deliveryTagArray;
/// 到店备注
@property (nonatomic, copy) NSString *toStoreRemarks;

@end


@implementation WMOrderSubmitV2View

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.G5;
    [self addSubview:self.scrollView];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, kRealWidth(48) + kRealWidth(4) + kiPhoneXSeriesSafeBottomHeight, 0);
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.noticeView];
    [self.scrollViewContainer addSubview:self.deliveryOrToStoreView];

    [self.scrollViewContainer addSubview:self.deliveryInfoView];
    [self.scrollViewContainer addSubview:self.toStoreInfoView];

    [self.scrollViewContainer addSubview:self.orderInfoView];
//    [self.scrollViewContainer addSubview:self.localTip];
    [self addSubview:self.submitBottomDockView];

    [self.orderInfoView configureWithStoreItem:self.viewModel.storeItem productList:self.viewModel.productList];
    [self.orderInfoView configureWithUserInputNote:nil changeRemind:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [LKDataRecord traceYumNowEvent:@"order_submit_pv" name:@"订单提交页PV" ext:@{
        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : @"",
        @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : @"",
        @"storeNo" : self.viewModel.storeItem.storeNo
    }];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.width.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.noticeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noticeView.isHidden) {
            make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(8));
            make.left.right.equalTo(self.scrollViewContainer);
        }
    }];

    [self.deliveryOrToStoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.noticeView.isHidden) {
            make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(8));
        } else {
            make.top.equalTo(self.noticeView.mas_bottom).offset(kRealWidth(8));
        }
        make.height.mas_equalTo(56);
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.deliveryInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.noticeView.isHidden && self.deliveryOrToStoreView.isHidden) {
            make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(8));
        } else if (self.deliveryOrToStoreView.isHidden) {
            make.top.equalTo(self.noticeView.mas_bottom).offset(kRealWidth(8));
        } else {
            make.top.equalTo(self.deliveryOrToStoreView.mas_bottom);
        }
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.toStoreInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.noticeView.isHidden && self.deliveryOrToStoreView.isHidden) {
            make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(8));
        } else if (self.deliveryOrToStoreView.isHidden) {
            make.top.equalTo(self.noticeView.mas_bottom).offset(kRealWidth(8));
        } else {
            make.top.equalTo(self.deliveryOrToStoreView.mas_bottom);
        }
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.orderInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryInfoView.hidden) {
            make.top.equalTo(self.deliveryInfoView.mas_bottom).offset(kRealWidth(8));
        } else {
            make.top.equalTo(self.toStoreInfoView.mas_bottom).offset(kRealWidth(8));
        }
        make.left.right.equalTo(self.scrollViewContainer);
        make.bottom.equalTo(self.scrollViewContainer).offset(-kRealWidth(8));
    }];

    [self.submitBottomDockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-kRealWidth(24));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kRealWidth(4) - kiPhoneXSeriesSafeBottomHeight);
    }];

    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);

    self.viewModel.choosedAddressBlock = ^(SAShoppingAddressModel *_Nonnull addressModel) {
        @HDStrongify(self);
        [self handlingChooseAddressModel:addressModel];
    };

    ///特殊区域
    [self.KVOController hd_observe:self.viewModel keyPath:@"increaseDeliveryModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        WMOrderSubmitV2ViewModel *vm = self.viewModel;
        if (!HDIsObjectNil(vm.aggregationRspModel.deliveryInfo) && vm.increaseDeliveryModel.increaseFeeFlag && !self.deliveryInfoView.hidden) {
            vm.aggregationRspModel.deliveryInfo.inDeliveryStr = vm.increaseDeliveryModel.feeRemark.desc;
            [self.orderInfoView configureWithDeliveryFeeRspModel:vm.aggregationRspModel.deliveryInfo deliveryFeeReductionMoney:vm.deliveryFeeReductionMoney];
        }

        ///暂停配送
        if (vm.increaseDeliveryModel.stopFlag) {
            [self showSpecialAlert];
        }
        ///增加配送时间
        if (vm.increaseDeliveryModel.increaseTimeFlag) {
            self.noticeView.showTip = vm.increaseDeliveryModel.timeRemark.desc;
        }
        self.noticeView.hidden = !vm.increaseDeliveryModel.increaseTimeFlag;
        if ([self.noticeView.showTip isKindOfClass:NSString.class] && !self.noticeView.showTip.length) {
            self.noticeView.hidden = YES;
        }
        [self setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);

        WMOrderSubmitV2ViewModel *vm = self.viewModel;
        self.orderInfoView.totalDiscountMoney = 0;
        [self.orderInfoView configureWithProductList:self.viewModel.productList];

        //更新收货地址
        if (!self.deliveryInfoView.hidden) {
            [self.deliveryInfoView updateUIWithAddressModel:vm.validAddressModel];
            [self updateUIWithPopAddressModel:self.viewModel.popAddressModel];
        }

        if (!HDIsObjectNil(vm.aggregationRspModel.wmTrial)) {
            [self.orderInfoView configureWithShoppingItemsPayFeeTrialCalRspModel:vm.aggregationRspModel.wmTrial];
        }

        //更新配送费相关
        if (!HDIsObjectNil(vm.aggregationRspModel.deliveryInfo)) {
            if (!self.deliveryInfoView.hidden) {
                [self.orderInfoView configureWithDeliveryFeeRspModel:vm.aggregationRspModel.deliveryInfo deliveryFeeReductionMoney:vm.deliveryFeeReductionMoney];
            }
        }

        if (self.viewModel.serviceType == 20) {
            [self.orderInfoView configureWithSlowToPay:SABoolValueFalse];
        } else {
            [self.orderInfoView configureWithSlowToPay:vm.aggregationRspModel.wmTrial.slowPayMark];
        }

        [self.orderInfoView configureWithPromotionList:vm.promotionList activityMoneyExceptDeliveryFeeReduction:vm.activityMoneyExceptDeliveryFeeReduction
                               cartFeeTrialCalRspModel:vm.aggregationRspModel.wmTrial];

        [self.orderInfoView configureWithCouponModel:vm.couponModel usableCouponCount:self.viewModel.usableCouponCount shouldChangeDiscountView:YES];


        //更新运费券
        if (!self.deliveryInfoView.hidden) {
            [self.orderInfoView configureWithFreightCouponModel:vm.freightCouponModel usableCouponCount:self.viewModel.usableFreightCouponCount shouldChangeDiscountView:YES];
        } else {
            //这个位置同时隐藏配送费和运费券两个UI
            [self.orderInfoView configureWithHiddenDeliveryFeeViewAndFreightView];
        }

        if (!HDIsObjectNil(vm.aggregationRspModel.wmTrial)) {
            [self.orderInfoView configureWithPayFeeTrialCalRspModel:vm.aggregationRspModel.wmTrial productList:vm.productList];
        }

        if (!HDIsObjectNil(vm.aggregationRspModel.trial)) {
            [self.submitBottomDockView setActualPayPrice:[vm.aggregationRspModel.trial.totalTrialPrice minus:self.viewModel.paymentDiscountAmount]];
            [self.submitBottomDockView setPayablePrice:vm.aggregationRspModel.trial.payableMoney];
        }

        //更新店铺信息
        if (!HDIsObjectNil(vm.aggregationRspModel.storeInfo)) {
            if (!self.deliveryInfoView.hidden) {
                [self.deliveryInfoView updateUIWithOrderPreSubmitRspModel:vm.aggregationRspModel userHasRisk:self.viewModel.userHasRisk];
            } else {
                [self.toStoreInfoView updateUIWithOrderPreSubmitRspModel:vm.aggregationRspModel userHasRisk:self.viewModel.userHasRisk];
            }
        }

        if (!HDIsObjectNil(vm.fullGiftRspModel)) {
            [self.orderInfoView configureWithFillGiftRspModel:vm.fullGiftRspModel];
        }

        [self.orderInfoView configureWithUserInputPromoCode:self.viewModel.promoCode rspModel:self.viewModel.aggregationRspModel.promoCodeDiscount];
        // 是否需要完善地址
        BOOL needCompleteAddress = [vm.validAddressModel isNeedCompleteAddressInClientType:SAClientTypeYumNow];
        self.submitBottomDockView.submitBTN.enabled = !HDIsObjectNil(vm.aggregationRspModel.trial) && !needCompleteAddress;


        //优化临时关闭自取刷新页面时UI显示
        if (self.deliveryOrToStoreView.hidden == NO && !self.viewModel.pickUpStatus) {
            self.toStoreInfoView.hidden = YES;
            self.deliveryInfoView.hidden = NO;

            self.orderInfoView.tagArray = self.deliveryTagArray;
            [self.orderInfoView configureWithUserInputNote:self.deliveryRemarks changeRemind:self.deliveryChangeReminder];

            self.viewModel.serviceType = 10;
            [self.viewModel getRenderUIData];
        }

        self.deliveryOrToStoreView.hidden = !self.viewModel.pickUpStatus;

        [self setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshCoupon" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMOrderSubmitV2ViewModel *vm = self.viewModel;
        [self.orderInfoView configureWithCouponModel:vm.couponModel usableCouponCount:self.viewModel.usableCouponCount shouldChangeDiscountView:NO];
        if (!self.deliveryInfoView.hidden) {
            [self.orderInfoView configureWithFreightCouponModel:vm.freightCouponModel usableCouponCount:self.viewModel.usableFreightCouponCount shouldChangeDiscountView:NO];
        }
        [self setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"isLoading" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (isLoading) {
            @HDStrongify(self);
            [self showloading];
        } else {
            [self dismissLoading];
        }
    }];
    // 有支付营销
    [self.KVOController hd_observe:self.viewModel keyPath:@"paymentDiscountAmount" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!HDIsObjectNil(self.viewModel.aggregationRspModel.trial)) {
            // 试算价减去支付营销
            [self.submitBottomDockView setActualPayPrice:[self.viewModel.aggregationRspModel.trial.totalTrialPrice minus:self.viewModel.paymentDiscountAmount]];
            [self.submitBottomDockView setPayablePrice:self.viewModel.aggregationRspModel.trial.payableMoney];
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"changeAddressFail" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL changeAddressFail = [change[NSKeyValueChangeNewKey] boolValue];
        self.submitBottomDockView.submitBTN.enabled = !changeAddressFail;
    }];
}

- (void)updateUIWithPopAddressModel:(SAShoppingAddressModel *)addressModel {
    if (addressModel && HDIsObjectNil(self.viewModel.addressModelToCheck)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewModel selectPopAddress];
        });
    }
}

///展示特殊区域弹窗
- (void)showSpecialAlert {
    HDAlertView *alert =
        [WMCustomViewActionView showTitle:WMLocalizedString(@"wm_suspend_delivery", @"暂停配送服务")
                                  message:[WMLocalizedString(@"wm_suspended_delivery", @"当前地点暂停配送服务") stringByAppendingString:self.viewModel.increaseDeliveryModel.effectTime ?: @""]
                                  confirm:WMLocalizedString(@"wm_please_choose", @"请重新选择地址") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                  }
                                   config:nil];
    [alert show];
}

#pragma mark - event response
- (void)clickedSubmitButtonHandlerNeedCheckCurrentAddress:(BOOL)needCheck submitCompletion:(void (^)(void))submitCompletion {
    // 下单前检查
    // 检查地址（地址必不为空）而且非自取
    if (HDIsStringEmpty(self.viewModel.validAddressModel.address) && self.viewModel.serviceType != 20) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"order_sumit_choose_address_tip", @"选择收货地址") type:HDTopToastTypeError];
        !submitCompletion ?: submitCompletion();
        return;
    }

    if (self.viewModel.serviceType != 20) {
        // 检查支付方式
        if (HDIsObjectNil(self.deliveryInfoView.paymentType)) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"choose_payment_method", @"选择支付方式") type:HDTopToastTypeError];
            !submitCompletion ?: submitCompletion();
            return;
        }
    } else {
        if (HDIsObjectNil(self.toStoreInfoView.paymentType)) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"choose_payment_method", @"选择支付方式") type:HDTopToastTypeError];
            !submitCompletion ?: submitCompletion();
            return;
        }
    }

    if (self.viewModel.serviceType == 20) {
        if (![SAPhoneFormatValidator isCambodia:self.toStoreInfoView.numberTextFieldText]) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"adress_tips_phone_format_error", @"请输入正确的号码") type:HDTopToastTypeError];
            !submitCompletion ?: submitCompletion();
            return;
        }
    }

    if (self.viewModel.serviceType != 20) {
        ///货到付款提示找零
        NSString *key = [NSString stringWithFormat:@"%@_WM_ChangeReminder", SAUser.shared.operatorNo];
        if (self.deliveryInfoView.paymentType.method == SAOrderPaymentTypeCashOnDelivery && ![NSUserDefaults.standardUserDefaults objectForKey:key]
            && self.submitBottomDockView.actualPayPrice.centFace.doubleValue > 5 && !self.orderInfoView.changeReminderText && !self.isShowChangeReminderFlag) {
            HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
            config.containerMinHeight = kRealWidth(100);
            config.marginTitleToContentView = kRealWidth(16);
            config.textAlignment = HDCustomViewActionViewTextAlignmentLeft;
            config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), 0, kRealWidth(12));
            config.title = WMLocalizedString(@"order_submit_Change_reminder", @"找零提醒");
            config.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
            config.titleColor = HDAppTheme.WMColor.B3;
            config.style = HDCustomViewActionViewStyleClose;
            config.iPhoneXFillViewBgColor = UIColor.whiteColor;
            config.contentHorizontalEdgeMargin = 0;
            WMOrderChangeReminderView *reasonView = [[WMOrderChangeReminderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(300))];
            reasonView.isShowDontshowBTN = YES;
            reasonView.payModel = self.submitBottomDockView.actualPayPrice;
            [reasonView layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:reasonView config:config];
            actionView.delegate = self;
            [actionView show];
            self.actionView = actionView;

            @HDWeakify(self);
            @HDWeakify(actionView);
            reasonView.clickedConfirmBlock = ^(NSString *_Nonnull inputStr) {
                @HDStrongify(self);
                @HDStrongify(actionView);
                
                [actionView dismiss];
                self.isShowChangeReminderFlag = YES;
                if (inputStr){
                    NSString *title = [NSString stringWithFormat:WMLocalizedString(@"order_submit_Need_changes", @"希望骑手找零，已备好%@零钱"), inputStr];
                    NSMutableString *text = [[NSMutableString alloc] initWithString:self.orderInfoView.noteText ?: @""];
                    if (self.orderInfoView.changeReminderText && [text rangeOfString:self.orderInfoView.changeReminderText].length > 0) {
                        NSRange range = [text rangeOfString:self.orderInfoView.changeReminderText];
                        [text replaceCharactersInRange:range withString:title];
                    } else {
                        BOOL notEmpty = text.length > 0;
                        [text insertString:title atIndex:0];
                        if (notEmpty) {
                            [text insertString:@"," atIndex:title.length];
                        }
                    }
                    if(HDIsStringEmpty(self.deliveryRemarks)){
                        self.deliveryRemarks = text;
                    }else{
                        self.deliveryRemarks = [NSString stringWithFormat:@"%@,%@",self.deliveryRemarks,text];
                    }
                    [self.orderInfoView configureWithUserInputNote:text changeRemind:title];
                }
                [self clickedSubmitButtonHandlerNeedCheckCurrentAddress:needCheck submitCompletion:nil];
            };
            !submitCompletion ?: submitCompletion();
            return;
        }


        if (needCheck && [HDLocationManager shared].isCurrentCoordinate2DValid) {
            // 检查地址是否是当前地址
            @HDWeakify(self);
            CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[HDLocationManager shared].realCoordinate2D.latitude longitude:[HDLocationManager shared].realCoordinate2D.longitude];
            CLLocation *addressLocation = [[CLLocation alloc] initWithLatitude:self.viewModel.validAddressModel.latitude.doubleValue longitude:self.viewModel.validAddressModel.longitude.doubleValue];
            CLLocationDistance distance = [HDLocationUtils distanceFromLocation:currentLocation toLocation:addressLocation];
            if (distance > 60) {
                [NAT showAlertWithMessage:WMLocalizedString(@"address_inconsistent_tips", @"当前定位地址与配送地址不一致，是否需要更改？")
                    confirmButtonTitle:WMLocalizedStringFromTable(@"cancel", @"Cancel", @"Buttons")
                    confirmButtonColor:HDAppTheme.WMColor.mainRed confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }
                    cancelButtonTitle:WMLocalizedString(@"continue_to_order", @"Continue To Order")
                    cancelButtonColor:nil cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        @HDStrongify(self);
                        [alertView dismiss];
                        [self clickedSubmitButtonHandlerNeedCheckCurrentAddress:NO submitCompletion:submitCompletion];
                    }];
                !submitCompletion ?: submitCompletion();
                return;
            }
        }
    }

    // 下单
    [self showloading];
    @HDWeakify(self);

    [self.viewModel submitOrderWithUserNote:self.viewModel.serviceType == 20 ? self.toStoreRemarks : self.deliveryRemarks                       //备注
                              paymentMethod:self.viewModel.serviceType == 20 ? self.toStoreInfoView.paymentType.method : self.deliveryInfoView.paymentType.method     //支付方式
                          deliveryTimeModel:self.viewModel.serviceType == 20 ? self.toStoreInfoView.subscribeTimeModel : self.deliveryInfoView.subscribeTimeModel //取餐时间
                              toStoreMobile:self.toStoreInfoView.numberTextFieldText   //自取时的电话号码
                                    success:^(WMOrderSubmitRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];
            !submitCompletion ?: submitCompletion();
            self.submitOrderRspModel = rspModel;
            [self handlingSuccessSubmitOrderWithRsp:rspModel];
            ///付费商家
            if (self.viewModel.payFlag) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{
                                @"storeNo": self.viewModel.storeItem.storeNo,
                                @"plateId": self.viewModel.payFlag,
                                @"orderNo": rspModel.orderNo
                }];
                
                [LKDataRecord.shared traceEvent:@"sortCreateOrder"
                                           name:@"sortCreateOrder"
                                     parameters:mdic
                                            SPM:[LKSPM SPMWithPage:@"WMOrderSubmitV2ViewController" area:@"" node:@""]];
            }

            if (self.viewModel.plateId) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{
                    @"type": self.viewModel.collectType,
                    @"plateId": self.viewModel.plateId,
                    @"orderNo": rspModel.orderNo
                    
                }];
                if (self.viewModel.topicPageId)
                    mdic[@"topicPageId"] = self.viewModel.topicPageId;

                [LKDataRecord.shared traceEvent:@"placeOrder"
                                           name:@"placeOrder"
                                     parameters:mdic
                                            SPM:[LKSPM SPMWithPage:@"WMOrderSubmitV2ViewController" area:@"" node:@""]];
            }

            if (self.viewModel.searchId) {
                [LKDataRecord.shared traceEvent:@"takeawaySearchAtPlaceOrder"
                                           name:@"下单"
                                     parameters:@{
                    @"searchId": self.viewModel.searchId,
                    @"orderNo": rspModel.orderNo,
                    @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970],
                }
                                            SPM:[LKSPM SPMWithPage:@"WMOrderSubmitV2ViewController" area:@"" node:@""]];
            }

            /// 埋点事件，请勿删除
            [LKDataRecord traceYumNowEvent:@"order_submitV2" name:@"外卖_下单" ext:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : @"",
                @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : @"",
                @"orderNo": rspModel.orderNo,
                @"storeNo" : self.viewModel.storeItem.storeNo
            }];
            /// end
        
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
            !submitCompletion ?: submitCompletion();
            [self orderCheckFailureWithRspModel:rspModel];
        }];
}

// 货到付款结果页
- (void)navigateToOrderResultPage {
    WMOrderResultController *vc = [[WMOrderResultController alloc] initWithRouteParameters:@{@"orderNo": self.submitOrderRspModel.orderNo}];
    [self.viewController.navigationController pushViewController:vc animated:YES removeSpecClass:self.viewController.class onlyOnce:YES];
}
// 导航到订单详情页（线上支付取消支付情况）
- (void)navigateToOrderDetailPage {
    WMOrderDetailViewController *vc =
        [[WMOrderDetailViewController alloc] initWithRouteParameters:@{@"orderNo": self.submitOrderRspModel.orderNo, @"isFromOrderSubmit": @(1), @"isNeedQueryLottery": @(1)}];
    [SAWindowManager navigateToViewController:vc removeSpecClass:@"WMOrderSubmitV2ViewController"];
}
// 线上支付结果页
- (void)navigationToOnlineResultPageWithParams:(NSDictionary *)params {
    NSMutableDictionary *resultPageParams = params ? params.mutableCopy : [NSMutableDictionary dictionary];
    resultPageParams[@"businessLine"] = SAClientTypeYumNow;
    resultPageParams[@"orderNo"] = self.submitOrderRspModel.orderNo;
    resultPageParams[@"pageLabel"] = @"online_payment_result";
    resultPageParams[@"merchantNo"] = self.viewModel.aggregationRspModel.wmTrial.merchantNo;

    @HDWeakify(self);
    void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
        // 跳转订单详情
        @HDStrongify(self);
        [self navigateToOrderDetailPage];
    };

    resultPageParams[@"orderClickBlock"] = orderDetailBlock;

    SAPayResultViewController *vc = [[SAPayResultViewController alloc] initWithRouteParameters:resultPageParams];
    [self.viewController.navigationController pushViewController:vc animated:YES removeSpecClass:self.viewController.class onlyOnce:YES];
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    HDLog(@"收银台初始化失败，订单未支付，去详情页");
    [self navigateToOrderDetailPage];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    HDLog(@"做了支付动作，但是支付状态未明，去详情页");
    [self navigateToOrderDetailPage];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigationToOnlineResultPageWithParams:nil];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigationToOnlineResultPageWithParams:nil];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    HDLog(@"用户取消支付，进入订单未支付状态，去详情页");
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigateToOrderDetailPage];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *)error {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        [NAT showToastWithTitle:@"" content:rspModel.msg type:HDTopToastTypeError];
        [self navigateToOrderDetailPage];
    }];
}

#pragma mark - private methods
- (void)handlingSuccessSubmitOrderWithRsp:(WMOrderSubmitRspModel *_Nonnull)rspModel {
    if (HDIsObjectNil(rspModel))
        return;

    // 发送下单成功的通知
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameOrderSubmitSuccess object:nil];

    // 如果是在线支付，呼起收银台
    HDPaymentMethodType *paymentType;
    if (self.viewModel.serviceType != 20) {
        paymentType = self.deliveryInfoView.paymentType;
    } else {
        paymentType = self.toStoreInfoView.paymentType;
    }
    if (paymentType.method == SAOrderPaymentTypeOnline || paymentType.method == SAOrderPaymentTypeQRCode) {
        if (self.viewModel.aggregationRspModel.trial.totalTrialPrice.cent.doubleValue <= 0) {
            // 支付金额为 0 直接去详情页
            [self navigationToOnlineResultPageWithParams:@{@"paymentState": @(SAPaymentStatePayed), @"paymentAmount": self.viewModel.aggregationRspModel.trial.totalTrialPrice}];
        } else {
            HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
            buildModel.orderNo = rspModel.orderNo;
            buildModel.merchantNo = self.viewModel.aggregationRspModel.wmTrial.merchantNo;
            buildModel.storeNo = self.viewModel.aggregationRspModel.wmTrial.storeNo;
            buildModel.supportedPaymentMethods = @[HDSupportedPaymentMethodOnline];
            //            buildModel.outPayOrderNo = rspModel.outPayOrderNo;
            buildModel.payableAmount = self.viewModel.aggregationRspModel.trial.totalTrialPrice;
            buildModel.businessLine = SAClientTypeYumNow;
            buildModel.selectedPaymentMethod = self.viewModel.serviceType == 20 ? self.toStoreInfoView.paymentType : self.deliveryInfoView.paymentType;
            HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
            checkStandVC.resultDelegate = self;

            [self.viewController presentViewController:checkStandVC animated:YES completion:nil];
        }
    } else if (paymentType.method == SAOrderPaymentTypeCashOnDelivery) {
        // 线下付款直接去详情页
        [self navigateToOrderResultPage];
    }
}

- (void)chooseAddressAction {
    void (^callback)(SAShoppingAddressModel *) = ^(SAShoppingAddressModel *addressModel) {
        self.chooseAddressBack = 2;
        [self dismissLoading];
        [self handlingChooseAddressModel:addressModel];
    };
//    self.localTip.hidden = YES;
    [HDMediator.sharedInstance
        navigaveToOrderSubmitChooseAddressController:
            @{@"callback": callback, @"storeNo": self.viewModel.storeItem.storeNo, @"addressNo": self.viewModel.validAddressModel.addressNo, @"isNeedCompleteAddress": @(self.isNeedCompleteAddress)}];
    self.chooseAddressBack = 1;
}

- (void)handlingChooseAddressModel:(SAShoppingAddressModel *)addressModel {
    [self.deliveryInfoView updateUIWithAddressModel:addressModel];

    [SACacheManager.shared setObject:addressModel forKey:kCacheKeyUserLastOrderSubmitChoosedCurrentAddress type:SACacheTypeDocumentNotPublic];

    self.viewModel.currentAddressModel = addressModel;
    self.viewModel.changeAddress = YES;
    [self.viewModel getRenderUIData];
}

- (void)orderCheckFailureWithRspModel:(SARspModel *)rspModel {
    void (^showAlert)(NSString *, void (^)(void)) = ^void(NSString *msg, void (^afterBlock)(void)) {
        [NAT showAlertWithMessage:HDIsStringNotEmpty(msg) ? msg : SALocalizedString(@"network_not_available", @"网络异常") buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                              [alertView dismiss];
                              !afterBlock ?: afterBlock();
                          }];
    };

    SAResponseType code = rspModel.code;
    if ([code isEqualToString:WMOrderCheckFailureReasonStoreClosed]) { // 门店休息
        showAlert(rspModel.msg, ^() {
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameReloadStoreDetail object:nil];
            [self.viewController dismissAnimated:YES completion:nil];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonStoreStopped]) { // 门店停业/停用
        showAlert(rspModel.msg, ^() {
            switch (self.viewModel.from) {
                case WMOrderSubmitFromStore: {
                    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameReloadStoreDetail object:nil];
                    [self.viewController dismissAnimated:YES completion:nil];
                } break;
                case WMOrderSubmitFromShoppingCart:
                    [self.viewController dismissAnimated:YES completion:nil];
                    break;
            }
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonBeyondDeliveryScope]) { // 超出配送范围
        showAlert(rspModel.msg, ^() {
            self.viewModel.addressModelToCheck = nil;
            [self handlingChooseAddressModel:nil];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonPromotionEnded] || [code isEqualToString:WMOrderCheckFailureReasonDeliveryFeeChanged]) { // 活动已结束或停用、配送费活动变更
        showAlert(rspModel.msg, ^() {
            [self.viewModel getInitializedData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonProductInfoChanged]) { // 商品信息变更
        showAlert(rspModel.msg, ^() {
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameReloadStoreDetail object:nil];
            [self.viewController dismissAnimated:YES completion:nil];
        });
    } else {
        showAlert(rspModel.msg, nil);
    }
}

- (void)showInputPromoCodeAlert {
    @HDWeakify(self) WMPromoCodeAlertView *codeView = [[WMPromoCodeAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(240))];
    codeView.promoCode = self.viewModel.promoCode;
    WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:codeView block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.title = WMLocalizedString(@"OkaO8L5F", @"优惠码");
    }];
    @HDWeakify(actionView) codeView.clickedConfirmBlock = ^(NSString *_Nullable inputStr) {
        @HDStrongify(self) @HDStrongify(actionView)[actionView dismiss];
        self.viewModel.promoCode = inputStr;
        [self.viewModel getRenderUIData];
    };
    [codeView layoutyImmediately];
    [actionView show];
    self.actionView = actionView;
}

- (BOOL)isNeedCompleteAddress {
    BOOL needCheck = [[SAApolloManager getApolloConfigForKey:ApolloConfigKeyOrderSubmitNeedCheckAddress][SAClientTypeYumNow] boolValue];
    return needCheck;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger length = textField.text.length - range.length + string.length;
    return length <= 20;
}

///键盘打开
- (void)keyBoardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    CGRect keyBoardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    if (self.actionView && !self.keyBoardlsVisible) {
        [UIView animateWithDuration:0.3 animations:^{
            self.actionView.containerView.hd_top -= keyBoardHeight;
        }];
        self.keyBoardlsVisible = YES;
    }
}
///键盘收起
- (void)keyBoardWillHide:(NSNotification *)note {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    CGRect keyBoardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    if (self.actionView && self.keyBoardlsVisible) {
        [UIView animateWithDuration:0.3 animations:^{
            self.actionView.containerView.hd_top += keyBoardHeight;
        }];
        self.keyBoardlsVisible = NO;
    }
}

#pragma mark - lazy load
- (WMOrderSubmitOrderInfoView *)orderInfoView {
    if (!_orderInfoView) {
        _orderInfoView = WMOrderSubmitOrderInfoView.new;
        @HDWeakify(self);
        _orderInfoView.chooseCouponBlock = ^(WMOrderSubmitCouponModel *_Nonnull model) {
            @HDStrongify(self);
            @HDWeakify(self);
            void (^callback)(WMOrderSubmitCouponModel *_Nullable, NSUInteger) = ^(WMOrderSubmitCouponModel *_Nullable couponModel, NSUInteger usableCouponCount) {
                @HDStrongify(self);
                ///移除选中
                if (couponModel.clearSelect) {
                    if (self.viewModel.aggregationRspModel.promoCodeDiscount && self.viewModel.promoCode) {
                        self.viewModel.promoCode = nil;
                        [self.orderInfoView configureWithUserInputPromoCode:nil rspModel:nil];
                    } else {
                        self.viewModel.freightCouponModel = nil;
                        couponModel.clearSelect = NO;
                        [self.orderInfoView configureWithFreightCouponModel:self.viewModel.freightCouponModel usableCouponCount:self.viewModel.usableFreightCouponCount shouldChangeDiscountView:YES];
                    }
                }
                self.viewModel.couponModel = couponModel;
                // 为空就是选择了不使用优惠券
                [self.orderInfoView configureWithCouponModel:couponModel usableCouponCount:usableCouponCount shouldChangeDiscountView:YES];

                [self.viewModel getRenderUIData];
            };
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
            params[@"storeNo"] = self.viewModel.storeItem.storeNo;
            params[@"currencyType"] = self.viewModel.storeItem.currency;
            params[@"amount"] = self.viewModel.amountToQueryCoupon.centFace;
            params[@"deliveryAmt"] = self.viewModel.aggregationRspModel.deliveryInfo.deliverFee.centFace;
            params[@"merchantNo"] = self.viewModel.storeItem.merchantNo;
            params[@"callback"] = callback;
            params[@"couponType"] = @[@(SACouponTicketTypeDefault), @(SACouponTicketTypeDiscount), @(SACouponTicketTypeMinus), @(SACouponTicketTypeReduction)];
            params[@"couponNo"] = model.couponCode;
            params[@"packingAmt"] = self.viewModel.storeItem.packingFee.centFace;
            params[@"addressNo"] = self.viewModel.validAddressModel.addressNo;
            if(self.viewModel.serviceType ==20){
                params[@"hasShippingCoupon"] = @"false";
            }else{
                params[@"hasShippingCoupon"] = self.viewModel.freightCouponModel ? @"true" : @"false";
            }
            if (self.viewModel.aggregationRspModel.promoCodeDiscount && self.viewModel.promoCode) {
                params[@"hasPromoCode"] = self.viewModel.promoCode;
            }
            if (self.viewModel.couponModel) {
                params[@"hasVoucher"] = self.viewModel.couponModel.couponCode;
            }
            ///有优惠码
            if (self.viewModel.aggregationRspModel.promoCodeDiscount && self.viewModel.promoCode) {
                params[@"limitCoupon"] = @(self.viewModel.aggregationRspModel.promoCodeDiscount.voucherCouponLimit);
            } else {
                if (self.viewModel.freightCouponModel) {
                    params[@"limitCoupon"] = @(self.viewModel.freightCouponModel.useVoucherCoupon);
                }
            }
            params[@"activityNos"] = self.viewModel.aggregationRspModel.wmTrial.activityNos;
            [HDMediator.sharedInstance navigaveToOrderSubmitChooseCouponController:params];
        };
        _orderInfoView.chooseFreightCouponBlock = ^(WMOrderSubmitCouponModel *_Nonnull model) {
            @HDStrongify(self);
            @HDWeakify(self);
            void (^callback)(WMOrderSubmitCouponModel *_Nullable, NSUInteger) = ^(WMOrderSubmitCouponModel *_Nullable couponModel, NSUInteger usableCouponCount) {
                @HDStrongify(self);
                ///移除选中
                if (couponModel.clearSelect) {
                    if (self.viewModel.aggregationRspModel.promoCodeDiscount && self.viewModel.promoCode) {
                        self.viewModel.promoCode = nil;
                        [self.orderInfoView configureWithUserInputPromoCode:nil rspModel:nil];
                    } else {
                        self.viewModel.couponModel = nil;
                        couponModel.clearSelect = NO;
                        [self.orderInfoView configureWithCouponModel:self.viewModel.couponModel usableCouponCount:self.viewModel.usableCouponCount shouldChangeDiscountView:YES];
                    }
                }
                self.viewModel.freightCouponModel = couponModel;
                // 为空就是选择了不使用运费券
                [self.orderInfoView configureWithFreightCouponModel:couponModel usableCouponCount:usableCouponCount shouldChangeDiscountView:YES];

                [self.viewModel getRenderUIData];
            };

            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
            params[@"storeNo"] = self.viewModel.storeItem.storeNo;
            params[@"currencyType"] = self.viewModel.storeItem.currency;
            params[@"amount"] = self.viewModel.amountToQueryCoupon.centFace;
            params[@"deliveryAmt"] = self.viewModel.aggregationRspModel.deliveryInfo.deliverFee.centFace;
            params[@"merchantNo"] = self.viewModel.storeItem.merchantNo;
            params[@"callback"] = callback;
            params[@"couponType"] = @[@(SACouponTicketTypeFreight)];
            params[@"couponNo"] = model.couponCode;
            params[@"packingAmt"] = self.viewModel.storeItem.packingFee.centFace;
            params[@"addressNo"] = self.viewModel.validAddressModel.addressNo;
            if (self.viewModel.aggregationRspModel.promoCodeDiscount && self.viewModel.promoCode) {
                params[@"hasPromoCode"] = self.viewModel.promoCode;
            }
            params[@"hasShippingCoupon"] = self.viewModel.freightCouponModel ? @"true" : @"false";
            if (self.viewModel.aggregationRspModel.promoCodeDiscount && self.viewModel.promoCode) {
                params[@"limitShippingCoupon"] = @(self.viewModel.aggregationRspModel.promoCodeDiscount.shippingCouponLimit);
            } else {
                if (self.viewModel.couponModel) {
                    params[@"limitShippingCoupon"] = @(self.viewModel.couponModel.useShippingCoupon);
                }
            }
            if (self.viewModel.couponModel) {
                params[@"hasVoucher"] = self.viewModel.couponModel.couponCode;
            }
            params[@"activityNos"] = self.viewModel.aggregationRspModel.wmTrial.activityNos;
            [HDMediator.sharedInstance navigaveToOrderSubmitChooseCouponController:params];
        };

        _orderInfoView.clickedNoteBlock = ^{
            @HDStrongify(self);
            void (^callback)(NSString *_Nullable, NSString *_Nullable) = ^(NSString *content, NSString *changeReminder) {
                @HDStrongify(self);
                if (self.viewModel.serviceType == 20) {
                    self.toStoreRemarks = content;
                } else {
                    self.deliveryRemarks = content;
                    self.deliveryChangeReminder = changeReminder;
                }
                [self.orderInfoView configureWithUserInputNote:content changeRemind:changeReminder];
            };

            void (^tagCallback)(NSArray<WMWriteNoteTagRspModel *> *_Nullable) = ^(NSArray<WMWriteNoteTagRspModel *> *tagArray) {
                @HDStrongify(self);
                self.deliveryTagArray = tagArray;
                self.orderInfoView.tagArray = tagArray;
            };

            [HDMediator.sharedInstance navigaveToOrderSubmitWriteNoteViewController:@{
                @"callback": callback,
                @"tagCallback": tagCallback,
                @"changeReminderText": self.orderInfoView.changeReminderText,
                @"onCashPay": self.viewModel.serviceType == 20 ? @(NO) : @(self.deliveryInfoView.paymentType.method == SAOrderPaymentTypeCashOnDelivery),
                @"payMoney": self.submitBottomDockView.actualPayPrice,
                @"contentText": self.viewModel.serviceType == 20 ? self.toStoreRemarks : self.deliveryRemarks,
                @"serviceType": @(self.viewModel.serviceType),
            }];
        };
        _orderInfoView.clickedPromoCodeBlock = ^{
            @HDStrongify(self);
            [self showInputPromoCodeAlert];
        };
        _orderInfoView.clickedAgeBlock = ^{
            @HDStrongify(self);
            [self.viewModel getNewAgeData];
        };
    }
    return _orderInfoView;
}

- (void)actionAlertViewDidDismiss:(HDActionAlertView *)alertView {
    // 页面缓存，用户当前页面关闭过一次找零弹窗之后不再弹出
    self.isShowChangeReminderFlag = YES;
}

- (WMOrderSubmitDeliveryInfoView *)deliveryInfoView {
    if (!_deliveryInfoView) {
        _deliveryInfoView = [[WMOrderSubmitDeliveryInfoView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        // 获取用户上次选择的地址，如果没选择过就获取用户默认收货地址（如果可用），否则让用户选择或者新增
        SAShoppingAddressModel *savedAddressModel = [SACacheManager.shared objectForKey:kCacheKeyUserLastOrderSubmitChoosedCurrentAddress type:SACacheTypeDocumentNotPublic];
        if (!HDIsObjectNil(savedAddressModel)) {
            self.viewModel.addressModelToCheck = savedAddressModel;
        }
        _deliveryInfoView.chooseAddressBlock = ^{
            @HDStrongify(self);
            [self chooseAddressAction];
        };
        _deliveryInfoView.choosedDeliveryTimeBlock = ^(WMOrderSubscribeTimeModel *_Nonnull subscribeTimeModel) {
            @HDStrongify(self);
            // 首次设置不重新获取数据
            if (HDIsObjectNil(self.viewModel.deliverySubscribeTimeModel)) {
                self.viewModel.deliverySubscribeTimeModel = subscribeTimeModel;
            } else {
                self.viewModel.deliverySubscribeTimeModel = subscribeTimeModel;
                // 重新获取数据，渲染页面
                [self.viewModel getRenderUIData];
            }
        };
    }
    return _deliveryInfoView;
}

- (WMOrderSubmitBottomDock *)submitBottomDockView {
    if (!_submitBottomDockView) {
        _submitBottomDockView = WMOrderSubmitBottomDock.new;
        @HDWeakify(self);
        _submitBottomDockView.clickedSubmitBTNBlock = ^(void (^submitCompletion)(void)) {
            @HDStrongify(self);
            @HDWeakify(self);
            [SAWindowManager
                navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                      @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                    SALocalizedString(@"login_new2_Food Delivery Order", @"外卖点餐")] bindSuccessBlock:^{
                    @HDStrongify(self);
                    if (!self.deliveryInfoView.hidden) {
                        [self clickedSubmitButtonHandlerNeedCheckCurrentAddress:YES submitCompletion:submitCompletion];
                    } else {
                        [self clickedSubmitButtonHandlerNeedCheckCurrentAddress:NO submitCompletion:submitCompletion];
                    }
                }
                                         cancelBindBlock:nil];
        };
    }
    return _submitBottomDockView;
}

- (void)setWillAppeal:(BOOL)willAppeal {
    _willAppeal = willAppeal;
    if (willAppeal) {
        if (self.chooseAddressBack == 1) {
            [self.viewModel getSpecialAddress];
        }
        if (self.chooseAddressBack) {
            self.chooseAddressBack = 0;
        }
    }
}

- (WMOrderNoticeView *)noticeView {
    if (!_noticeView) {
        _noticeView = WMOrderNoticeView.new;
        _noticeView.hidden = YES;
    }
    return _noticeView;
}


- (WMOrderDeliveryOrToStoreView *)deliveryOrToStoreView {
    if (!_deliveryOrToStoreView) {
        _deliveryOrToStoreView = WMOrderDeliveryOrToStoreView.new;
        @HDWeakify(self);
        _deliveryOrToStoreView.pickupMethod = ^(BOOL toStore) {
            @HDStrongify(self);
            //隐藏地址浮窗UI
//            [self.localTip dissmiss];

            self.toStoreInfoView.hidden = !toStore;
            self.deliveryInfoView.hidden = toStore;

            //处理备注
            if (toStore) {
                self.orderInfoView.tagArray = nil;
                [self.orderInfoView configureWithUserInputNote:self.toStoreRemarks changeRemind:nil];
            } else {
                self.orderInfoView.tagArray = self.deliveryTagArray;
                [self.orderInfoView configureWithUserInputNote:self.deliveryRemarks changeRemind:self.deliveryChangeReminder];
            }


            [self setNeedsUpdateConstraints];

            self.viewModel.serviceType = toStore ? 20 : 10;
            [self.viewModel getRenderUIData];

            if (toStore && !self.hasShowToStoreTip) {
                self.hasShowToStoreTip = YES;
                WMNormalAlertConfig *config = WMNormalAlertConfig.new;
                config.confirmHandle = ^(WMNormalAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
                    [alertView dismiss];
                };
                config.title = WMLocalizedString(@"wm_pickup_Kind reminder", @"温馨提示");
                config.contentAligment = NSTextAlignmentLeft;
                config.content = WMLocalizedString(@"wm_pickup_tips01", @"您选择的用餐方式为到店自取，您需要前往商家用餐。");
                config.confirm = WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons");

                [WMCustomViewActionView WMAlertWithConfig:config];
            }
        };
        _deliveryOrToStoreView.hidden = YES;
    }
    return _deliveryOrToStoreView;
}

- (WMOrderSubmitToStoreInfoView *)toStoreInfoView {
    if (!_toStoreInfoView) {
        _toStoreInfoView = [[WMOrderSubmitToStoreInfoView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _toStoreInfoView.choosedDeliveryTimeBlock = ^(WMOrderSubscribeTimeModel *_Nonnull subscribeTimeModel) {
            @HDStrongify(self);
            // 首次设置不重新获取数据
            if (HDIsObjectNil(self.viewModel.toStoreSubscribeTimeModel)) {
                self.viewModel.toStoreSubscribeTimeModel = subscribeTimeModel;
            } else {
                self.viewModel.toStoreSubscribeTimeModel = subscribeTimeModel;
                // 重新获取数据，渲染页面
                [self.viewModel getRenderUIData];
            }
        };
        _toStoreInfoView.hidden = YES;
    }
    return _toStoreInfoView;
}

@end
