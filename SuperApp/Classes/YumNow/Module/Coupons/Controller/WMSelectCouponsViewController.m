//
//  WMSelectCouponsViewController.m
//  SuperApp
//
//  Created by wmz on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSelectCouponsViewController.h"
#import "GNEvent.h"
#import "WMCouponsDTO.h"
#import "WMOrderSubmitCouponRspModel.h"
#import "WMSelectCouponsView.h"
#import "WMZPageView.h"


@interface WMSelectCouponsViewController ()
///分页
@property (nonatomic, strong) WMZPageView *pageView;
/// 选择回调，不使用优惠券就是 传 nil
@property (nonatomic, copy) void (^callback)(WMOrderSubmitCouponModel *_Nullable couponModel, NSUInteger usableCouponCount);
/// DTO
@property (nonatomic, strong) WMCouponsDTO *DTO;
/// 可用
@property (nonatomic, copy, nullable) NSArray *availableData;
/// 不可用
@property (nonatomic, copy, nullable) NSArray *unAvailableData;
/// 不使用优惠券按钮
@property (nonatomic, strong) HDUIButton *notUseBTN;
/// 不使用优惠券底部视图
@property (nonatomic, strong) UIView *notUseView;
/// 兑换码按钮
@property (nonatomic, strong) HDUIButton *redeemCodeBTN;
/// 请求完数据
@property (nonatomic, assign) BOOL finishData;
/// 选中的优惠券
@property (nonatomic, copy) NSString *couponNo;
/// 限制优惠券
@property (nonatomic, assign) BOOL limitCoupon;
/// 限制运费券
@property (nonatomic, assign) BOOL limitShippingCoupon;
/// 优惠券类型
@property (nonatomic, assign) WMCouponType type;
/// 使用了优惠券
@property (nonatomic, assign) BOOL hasVoucher;
/// 使用了运费券
@property (nonatomic, assign) BOOL hasShippingCoupon;
/// 使用了优惠码
@property (nonatomic, assign) BOOL hasPromoCode;

@end


@implementation WMSelectCouponsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    void (^callback)(WMOrderSubmitCouponModel *_Nullable, NSUInteger) = parameters[@"callback"];
    self.callback = callback;
    self.couponNo = parameters[@"couponNo"];
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)getData {
    @HDWeakify(self) NSString *storeNo = self.parameters[@"storeNo"];
    SACurrencyType currencyType = self.parameters[@"currencyType"];
    NSString *merchantNo = self.parameters[@"merchantNo"];
    NSString *amount = self.parameters[@"amount"];
    NSString *deliveryAmt = self.parameters[@"deliveryAmt"];
    NSString *packingAmt = self.parameters[@"packingAmt"];
    NSString *addressNo = self.parameters[@"addressNo"];
    NSArray *couponType = self.parameters[@"couponType"];
    NSString *hasPromoCode = self.parameters[@"hasPromoCode"] ? @"true" : @"false";
    NSString *hasShippingCoupon = self.parameters[@"hasShippingCoupon"];
    NSString *couponNo = self.parameters[@"hasVoucher"];
    NSArray *activityNos = self.parameters[@"activityNos"];
    self.hasVoucher = couponNo ? YES : NO;
    self.hasShippingCoupon = [hasShippingCoupon isEqualToString:@"true"] ? YES : NO;
    self.hasPromoCode = self.parameters[@"hasPromoCode"] ? true : false;
    ///选择的是运费券
    if ([couponType isKindOfClass:NSArray.class] && [couponType containsObject:@(SACouponTicketTypeFreight)]) {
        self.type = WMCouponTypeShipping;
        if (self.parameters[@"limitShippingCoupon"]) {
            self.limitShippingCoupon = [self.parameters[@"limitShippingCoupon"] boolValue];
        }
        self.boldTitle = WMLocalizedString(@"wm_select_shippingcoupon", @"选择运费券");
        [self.DTO getShippingCouponListWithStoreNo:storeNo amount:amount deliveryAmt:deliveryAmt packingAmt:packingAmt currencyType:currencyType merchantNo:merchantNo hasPromoCode:hasPromoCode
            hasShippingCoupon:hasShippingCoupon
            couponNo:couponNo
            addressNo:addressNo
            activityNos:activityNos success:^(WMOrderSubmitCouponRspModel *_Nonnull rspModel) {
                @HDStrongify(self)[self dealSuccessAction:rspModel];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self)[self dealErrorAction];
            }];
    } else {
        self.type = WMCouponTypeVoucher;
        if (self.parameters[@"limitCoupon"]) {
            self.limitCoupon = [self.parameters[@"limitCoupon"] boolValue];
        }
        self.boldTitle = WMLocalizedString(@"wm_select_cashcoupon", @"选择现金券");
        ///现金券
        [self.DTO getVoucherCouponListWithStoreNo:storeNo amount:amount deliveryAmt:deliveryAmt packingAmt:packingAmt currencyType:currencyType merchantNo:merchantNo hasPromoCode:hasPromoCode
            hasShippingCoupon:hasShippingCoupon
            couponNo:couponNo
            addressNo:addressNo
            activityNos:activityNos success:^(WMOrderSubmitCouponRspModel *_Nonnull rspModel) {
                @HDStrongify(self)[self dealSuccessAction:rspModel];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self)[self dealErrorAction];
            }];
    }
}

- (void)hd_setupViews {
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.redeemCodeBTN];
    @HDWeakify(self) WMZPageParam *param = PageParam();
    param.wTitleArr = @[WMLocalizedString(@"wm_coupon_canuse", @"Available"), WMLocalizedString(@"wm_coupon_cannotuse", @"Unavaiable")];
    param.wMenuHeight = kRealWidth(50);
    param.wMenuTitleUIFontSet([HDAppTheme.WMFont wm_ForSize:14])
        .wMenuTitleSelectUIFontSet([HDAppTheme.WMFont wm_boldForSize:14])
        .wMenuTitleColorSet(HDAppTheme.WMColor.B9)
        .wMenuTitleSelectColorSet(HDAppTheme.WMColor.mainRed);
    param.wMenuPosition = PageMenuPositionCenter;
    param.wMenuIndicatorColorSet(HDAppTheme.WMColor.mainRed);
    param.wMenuTitleWidth = kScreenWidth / 2.0;
    param.wCustomNaviBarY = ^CGFloat(CGFloat nowY) {
        return 0;
    };
    param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
        @HDStrongify(self) WMSelectCouponsView *view = WMSelectCouponsView.new;
        if (self.finishData) {
            if (index == 0) {
                view.dataSource = self.availableData;
            } else {
                view.dataSource = self.unAvailableData;
            }
        }
        return (id)view;
    };

    [self.view addSubview:self.notUseView];
    self.notUseView.frame = CGRectMake(0, kScreenHeight - (kRealWidth(60) + kiPhoneXSeriesSafeBottomHeight), kScreenWidth, kRealWidth(60) + kiPhoneXSeriesSafeBottomHeight);
    [self.notUseView addSubview:self.notUseBTN];

    self.pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH - self.notUseView.hd_height) param:param parentReponder:self];
    [self.view addSubview:self.pageView];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.notUseBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(8));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
    }];
}

///数据处理
- (void)dealSuccessAction:(WMOrderSubmitCouponRspModel *)rspModel {
    self.finishData = YES;
    self.availableData = [rspModel.list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
        item.amount = self.parameters[@"amount"];
        item.customCouponType = self.type;
        item.selected = [item.couponCode isEqualToString:self.couponNo];
        return [item.usable isEqualToString:SABoolValueTrue];
    }];
    self.unAvailableData = [rspModel.list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
        item.amount = self.parameters[@"amount"];
        item.customCouponType = self.type;
        return ![item.usable isEqualToString:SABoolValueTrue];
    }];
    [self.pageView updateMenuData];
}
///错误处理
- (void)dealErrorAction {
    self.finishData = YES;
    self.availableData = self.unAvailableData = nil;
    [self.pageView updateMenuData];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    ///选中回调
    if ([event.key isEqualToString:@"selcctCouponAction"]) {
        WMOrderSubmitCouponModel *model = event.info[@"data"];
        if ([model isKindOfClass:WMOrderSubmitCouponModel.class]) {
            WMSelectCouponsView *currentView = (WMSelectCouponsView *)self.pageView.upSc.currentVC;
            if ([currentView isKindOfClass:WMSelectCouponsView.class]) {
                [currentView.dataSource enumerateObjectsUsingBlock:^(WMOrderSubmitCouponModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    obj.selected = (obj == model);
                }];
                [currentView.tableView reloadData];
            }
            ///运费券
            if (self.type == WMCouponTypeShipping) {
                if (self.hasVoucher && (self.limitShippingCoupon || model.useShippingCoupon)) {
                    [self showAlert:WMLocalizedString(@"wm_delivery_fee_remove_vonder", @"运费券不可与现金券同时使用，点击确认移除选择的现金券") model:model];
                    return;
                } else if (self.hasPromoCode && (self.limitShippingCoupon || model.useShippingCoupon)) {
                    [self showAlert:[NSString stringWithFormat:WMLocalizedString(@"wm_promocode_ship_remove_promo", @"优惠码%@不可与优惠券同时使用，点击确认移除已输入的优惠码"),
                                                               WMFillEmpty(self.parameters[@"hasPromoCode"])]
                              model:model];
                    return;
                }
            }
            ///现金券
            else if (self.type == WMCouponTypeVoucher) {
                if (self.hasShippingCoupon && (self.limitCoupon || model.useVoucherCoupon)) {
                    [self showAlert:WMLocalizedString(@"wm_delivery_fee_remove_ship", @"运费券不可与现金券同时使用，点击确认移除选择的运费券") model:model];
                    return;
                } else if (self.hasPromoCode && (self.limitCoupon || model.useVoucherCoupon)) {
                    [self showAlert:[NSString stringWithFormat:WMLocalizedString(@"wm_promocode_remove_promo", @"优惠码%@不可与优惠券同时使用，点击确认移除已输入的优惠码"),
                                                               WMFillEmpty(self.parameters[@"hasPromoCode"])]
                              model:model];
                    return;
                }
            }
            !self.callback ?: self.callback(model, self.availableData.count);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissAnimated:true completion:nil];
            });
        }
    }
}

- (void)showAlert:(NSString *)title model:(WMOrderSubmitCouponModel *)model {
    [NAT showAlertWithMessage:title confirmButtonTitle:WMLocalizedString(@"wm_button_confirm", @"确认") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
        [alertView dismiss];
        model.clearSelect = YES;
        !self.callback ?: self.callback(model, self.availableData.count);
        [self dismissAnimated:true completion:nil];
    } cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
        [alertView dismiss];
        [self dismissAnimated:true completion:nil];
    }];
}

- (WMCouponsDTO *)DTO {
    if (!_DTO) {
        _DTO = WMCouponsDTO.new;
    }
    return _DTO;
}

- (HDUIButton *)notUseBTN {
    if (!_notUseBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.layer.backgroundColor = UIColor.whiteColor.CGColor;
        button.layer.cornerRadius = kRealWidth(22);
        button.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
        button.layer.borderWidth = 1;
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
        [button setTitle:WMLocalizedString(@"not_use", @"Cancel") forState:UIControlStateNormal];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.callback ?: self.callback(nil, self.availableData.count);
            [self dismissAnimated:true completion:nil];
        }];
        _notUseBTN = button;
    }
    return _notUseBTN;
}

- (HDUIButton *)redeemCodeBTN {
    if (!_redeemCodeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        [button setTitle:SALocalizedString(@"coupon_match_ExchangeCode", @"coupon_match_ExchangeCode") forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/redemption-code"}];
        }];
        _redeemCodeBTN = button;
    }
    return _redeemCodeBTN;
}

- (UIView *)notUseView {
    if (!_notUseView) {
        _notUseView = UIView.new;
        _notUseView.backgroundColor = UIColor.whiteColor;
    }
    return _notUseView;
}

@end
