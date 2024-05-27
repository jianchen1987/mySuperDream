//
//  GNOrderResultViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderSubmitViewModel.h"
#import "SACacheManager.h"
#import "SAEnum.h"
#import "SAGuardian.h"


@interface GNOrderSubmitViewModel ()
///网络请求
@property (nonatomic, strong) GNOrderDTO *orderDTO;

@end


@implementation GNOrderSubmitViewModel

///获取抢购信息
- (void)getRushBuyDetailStoreNo:(nonnull NSString *)storeNo code:(nonnull NSString *)code completion:(void (^)(NSString *error))completion {
    [self.orderDTO orderRushBuyRequestStoreNo:storeNo code:code success:^(GNOrderRushBuyModel *_Nonnull rspModel) {
        self.promoCode = nil;
        self.rushBuyModel = rspModel;

        self.dataSource = NSMutableArray.new;
        ///商品内容
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             sectionModel.headerHeight = kRealWidth(12);
                             sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;

                             if (rspModel.whetherHomePurchaseRestrictions == GNHomePurchaseRestrictionsTypeCan) {
                                 if (rspModel.homePurchaseRestrictions > 0)
                                     rspModel.customAmount = 1;
                             } else {
                                 rspModel.customAmount = 1;
                             }
                             rspModel.cellClass = NSClassFromString(@"GNStoreOrderProductTableViewCell");
                             [sectionModel.rows addObject:rspModel];
                         })];

        ///订单信息
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             sectionModel.headerHeight = kRealWidth(8);
                             sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                             ///小计
                             GNCellModel *subtotalModel = GNCellModel.new;
                             subtotalModel.title = GNLocalizedString(@"gn_order_subtotal", @"小计");
                             subtotalModel.detail = GNFillMonEmpty(rspModel.subPrice);
                             subtotalModel.imageHide = YES;
                             subtotalModel.lineHidden = YES;
                             subtotalModel.offset = kRealWidth(16);
                             subtotalModel.bottomOffset = kRealWidth(6);
                             subtotalModel.detailFont = [HDAppTheme.font gn_boldForSize:13];
                             subtotalModel.cellClass = NSClassFromString(@"GNCommonCell");
                             self.subtotalModel = subtotalModel;
                             [sectionModel.rows addObject:subtotalModel];
                             ///增值税
                             GNCellModel *vatModel = GNCellModel.new;
                             vatModel.title = GNLocalizedString(@"gn_order_vat", @"增值税");
                             vatModel.imageHide = YES;
                             vatModel.lineHidden = YES;
                             vatModel.offset = kRealWidth(6);
                             vatModel.bottomOffset = kRealWidth(6);
                             vatModel.detailFont = [HDAppTheme.font gn_boldForSize:13];
                             vatModel.cellClass = NSClassFromString(@"GNCommonCell");
                             vatModel.detail = GNFillMonEmpty(rspModel.vat);
                             self.vatModel = vatModel;
                             [sectionModel.rows addObject:vatModel];

                             sectionModel.footerHeight = kRealWidth(8);
                             sectionModel.footerModel.backgroundColor = HDAppTheme.color.gn_whiteColor;
                             self.productSection = sectionModel;
                         })];

        ///支付
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             sectionModel.headerHeight = kRealWidth(8);
                             sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                             ///支付方式
                             GNCellModel *payModel = GNCellModel.new;
                             payModel.title = GNLocalizedString(@"gn_order_paymethor", @"支付方式");
                             payModel.detailColor = HDAppTheme.color.gn_999Color;
                             if ([rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeAll]) {
                                 payModel.detail = GNLocalizedString(@"gn_order_cash", @"到店付款");
                                 rspModel.payType = WMOrderAvailablePaymentTypeOffline;
                                 payModel.detailColor = HDAppTheme.color.gn_333Color;
                             } else if ([rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline]) {
                                 payModel.detail = GNLocalizedString(@"gn_pay_online", @"在线支付");
                                 rspModel.payType = WMOrderAvailablePaymentTypeOnline;
                                 payModel.detailColor = HDAppTheme.color.gn_333Color;
                             } else if ([rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeCash]) {
                                 payModel.detail = GNLocalizedString(@"gn_order_cash", @"到店付款");
                                 rspModel.payType = WMOrderAvailablePaymentTypeOffline;
                                 payModel.detailColor = HDAppTheme.color.gn_333Color;
                             }

                             WMOrderAvailablePaymentType paymentMethod = [SACacheManager.shared objectForKey:kCacheKeyGroupBuyUserLastTimeChoosedPaymentMethod type:SACacheTypeDocumentNotPublic];
                             if (paymentMethod) {
                                 if ([paymentMethod isEqualToString:WMOrderAvailablePaymentTypeOffline]) {
                                     if ([rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeAll] || [rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeCash]) {
                                         rspModel.payType = paymentMethod;
                                         payModel.detail = GNLocalizedString(@"gn_order_cash", @"到店付款");
                                         payModel.detailColor = HDAppTheme.color.gn_333Color;
                                     }
                                 } else if ([paymentMethod isEqualToString:WMOrderAvailablePaymentTypeOnline]) {
                                     if ([rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeAll] || [rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline]) {
                                         rspModel.payType = paymentMethod;
                                         payModel.detail = GNLocalizedString(@"gn_pay_online", @"在线支付");
                                         payModel.detailColor = HDAppTheme.color.gn_333Color;
                                     }
                                 }
                             }
                             payModel.tag = @"selectPay";
                             payModel.image = [UIImage imageNamed:@"gn_order_more"];
                             payModel.cellClass = NSClassFromString(@"GNCommonCell");
                             payModel.offset = kRealWidth(16);
                             payModel.lineHidden = YES;
                             payModel.bottomOffset = kRealWidth(6);
                             [sectionModel.rows addObject:payModel];

                             ///优惠码
                             GNCellModel *promoCodeModel = GNCellModel.new;
                             promoCodeModel.title = WMLocalizedString(@"yGHLNHRF", @"使用优惠码");
                             promoCodeModel.tag = @"promoCode";
                             promoCodeModel.rightHotArea = YES;
                             promoCodeModel.lineHidden = YES;
                             promoCodeModel.detailColor = HDAppTheme.color.gn_888888;
                             promoCodeModel.detail
                                 = rspModel.couponCodeUsage ? WMLocalizedString(@"wm_use_promo_code", @"可使用优惠码") : GNLocalizedString(@"gn_merchant_notsupport", @"该商家不支持使用优惠码");
                             promoCodeModel.cellClickEnable = rspModel.couponCodeUsage;
                             promoCodeModel.image = [UIImage imageNamed:@"gn_order_more"];
                             promoCodeModel.cellClass = NSClassFromString(@"GNCommonCell");
                             promoCodeModel.offset = kRealWidth(6);
                             promoCodeModel.bottomOffset = kRealWidth(6);
                             self.usePromoCodeModel = promoCodeModel;
                             [sectionModel.rows addObject:promoCodeModel];

                             ///预约信息
                             GNCellModel *reserveModel = GNCellModel.new;
                             reserveModel.title = GNLocalizedString(@"gn_booking_information", @"Appointment Information");
                             reserveModel.lineHidden = YES;
                             reserveModel.tag = @"reserve";
                             reserveModel.rightHotArea = YES;
                             reserveModel.detailColor = HDAppTheme.color.gn_999Color;
                             reserveModel.detail = GNLocalizedString(@"gn_can_be_booked_in_advance", @"Prior reservation");
                             reserveModel.image = [UIImage imageNamed:@"gn_order_more"];
                             reserveModel.cellClass = NSClassFromString(@"GNCommonCell");
                             reserveModel.offset = kRealWidth(6);
                             reserveModel.bottomOffset = kRealWidth(16);
                             self.reserveModel = reserveModel;
                             [sectionModel.rows addObject:reserveModel];
                         })];
        !completion ?: completion(nil);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.rushBuyModel = nil;
        !completion ?: completion(rspModel.code ?: [NSString stringWithFormat:@"%ld", (long)errorType]);
    }];
}

- (void)submitOrderWithInfo:(nonnull GNOrderRushBuyModel *)info completion:(void (^)(WMOrderSubmitRspModel *rspModel, NSString *errorCode))completion {
    SAOrderPaymentType paymentType = SAOrderPaymentTypeUnknown;
    if ([info.payType isEqualToString:WMOrderAvailablePaymentTypeOnline]) {
        paymentType = SAOrderPaymentTypeOnline;
    } else if ([info.payType isEqualToString:WMOrderAvailablePaymentTypeOffline]) {
        paymentType = SAOrderPaymentTypeCashOnDelivery;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    params[@"userName"] = SAUser.shared.loginName;
    params[@"currency"] = @"USD";
    params[@"description"] = @"";
    params[@"loginName"] = SAUser.shared.loginName;
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"autoCreatePayOrder"] = @"false";
    params[@"businessLine"] = SAClientTypeGroupBuy;
    params[@"payType"] = @(paymentType);
    params[@"storeNo"] = info.storeNo;

    ///营销参数
    NSDictionary * (^addActivityParams)(NSString *, NSString *, GNPromoCodeRspModel *) = ^NSDictionary *(NSString *activityNo, NSString *amt, GNPromoCodeRspModel *promoCodeRspModel) {
        if (amt.doubleValue <= 0) {
            return nil;
        }
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        item[@"discountNo"] = activityNo;
        item[@"businessType"] = SAMarketingBusinessTypeGroupBuy;
        item[@"currencyType"] = @"USD";
        item[@"userNo"] = SAUser.shared.operatorNo;
        item[@"amt"] = amt;
        item[@"deliveryAmt"] = @"0";
        item[@"merchantNo"] = info.merchantNo;
        item[@"packingAmt"] = @"0";
        item[@"storeNo"] = info.storeNo;
        item[@"userPhone"] = SAUser.shared.loginName;
        item[@"vatAmt"] = info.vat;
        item[@"promotionCode"]
            = HDIsStringNotEmpty(promoCodeRspModel.promotionCode) ? [promoCodeRspModel.promotionCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
        if (!HDIsObjectNil(promoCodeRspModel)) {
            item[@"marketingType"] = @(promoCodeRspModel.marketingType);
        }
        return item;
    };
    NSMutableDictionary *marketingReqDTO = [NSMutableDictionary dictionary];
    NSMutableArray<NSDictionary *> *verificationPromotions = [NSMutableArray array];
    ///优惠码
    if (!HDIsObjectNil(info.promoCodeRspModel)) {
        NSDictionary *activityParam = addActivityParams(info.promoCodeRspModel.activityNo, info.subPrice.stringValue, info.promoCodeRspModel);
        if (activityParam) {
            [verificationPromotions addObject:activityParam];
        }
    }
    if (!HDIsArrayEmpty(verificationPromotions)) {
        marketingReqDTO[@"verificationPromotions"] = verificationPromotions;
        params[@"marketingReqDTO"] = marketingReqDTO;
    }

    // 业务参数
    NSMutableDictionary *businessParams = [NSMutableDictionary dictionary];
    businessParams[@"actualAmount"] = [NSString stringWithFormat:@"%@", info.allPrice];
    businessParams[@"commissionRate"] = @(info.commissionRate);
    businessParams[@"customerNo"] = SAUser.shared.operatorNo;
    businessParams[@"deviceId"] = [HDDeviceInfo getUniqueId];
    businessParams[@"merchantNo"] = info.merchantNo;
    businessParams[@"originalPrice"] = [NSString stringWithFormat:@"%lf", info.originalPrice.doubleValue];
    businessParams[@"salePrice"] = [NSString stringWithFormat:@"%lf", info.price.doubleValue];
    businessParams[@"originalPriceAmount"] = [NSString stringWithFormat:@"%@", info.orginAllPrice];
    businessParams[@"priceAmount"] = [NSString stringWithFormat:@"%@", info.subPrice];
    businessParams[@"prodCode"] = info.codeId;
    businessParams[@"prodCount"] = [NSString stringWithFormat:@"%ld", (long)info.customAmount];
    businessParams[@"theVat"] = [NSString stringWithFormat:@"%ld", (long)info.theVat];
    businessParams[@"vat"] = info.vat;
    if (info.promoCodeRspModel && info.promoCodeRspModel.promotionCode) {
        businessParams[@"promotionCode"] = info.promoCodeRspModel.promotionCode;
        businessParams[@"discountFee"] = info.promoCodeRspModel.discountAmount.amount;
        businessParams[@"subsidiesPrice"] = info.promoCodeRspModel.platformAmount.amount;
    }
    if ([self.reserveModel.object isKindOfClass:GNReserveRspModel.class]) {
        GNReserveRspModel *reserveRspModel = self.reserveModel.object;
        businessParams[@"reservationInfo"] = @{
            @"reservationTime": reserveRspModel.reservationTime,
            @"reservationNum": reserveRspModel.reservationNum,
            @"reservationUser": reserveRspModel.reservationUser,
            @"reservationPhone": reserveRspModel.reservationPhone,
        };
    }
    params[@"businessParams"] = businessParams;

    /// item
    NSMutableArray *itemMarr = NSMutableArray.new;
    NSMutableDictionary *itemParams = [NSMutableDictionary dictionary];
    itemParams[@"code"] = info.codeId;
    itemParams[@"currencyType"] = @"USD";
    itemParams[@"num"] = [NSString stringWithFormat:@"%ld", (long)info.customAmount];
    itemParams[@"price"] = [NSString stringWithFormat:@"%lf", info.price.doubleValue];
    itemParams[@"servicePrice"] = @"";
    itemParams[@"taxesPrice"] = info.vat;
    [itemMarr addObject:itemParams];
    params[@"items"] = itemMarr;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/shop/order/v2/save";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !completion ?: completion([WMOrderSubmitRspModel yy_modelWithJSON:rspModel.data], rspModel ? nil : rspModel.code);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !completion ?: completion(nil, rspModel.code ?: [NSString stringWithFormat:@"%ld", (long)response.errorType]);
    }];
}

- (void)getPromoCodeInfoWithPromoCode:(NSString *)promoCode completion:(void (^)(GNPromoCodeRspModel *rspModel, NSString *errorCode))completion {
    if (HDIsStringEmpty(promoCode)) {
        self.rushBuyModel.promoCodeRspModel = nil;
        !completion ?: completion(nil, nil);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = [NSString stringWithFormat:@"%@", self.rushBuyModel.subPrice];
    params[@"currencyType"] = @"USD";
    params[@"packingAmt"] = @"0";
    params[@"paymentType"] = SAMarketingBusinessTypeGroupBuy;
    params[@"promotionCode"] = [promoCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    params[@"merchantNo"] = self.rushBuyModel.merchantNo;
    params[@"storeNo"] = self.rushBuyModel.storeNo;
    params[@"deliveryAmt"] = @"0";

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/app/marketing/promocode/activity/getPromoCode.do";
    request.isNeedLogin = true;
    request.requestParameter = params;
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        GNPromoCodeRspModel *model = [GNPromoCodeRspModel yy_modelWithJSON:rspModel.data];
        self.rushBuyModel.promoCodeRspModel = model;
        !completion ?: completion(model, rspModel ? nil : rspModel.code);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        self.rushBuyModel.promoCodeRspModel = nil;
        !completion ?: completion(nil, rspModel.code ?: [NSString stringWithFormat:@"%ld", (long)response.errorType]);
    }];
}

- (GNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = GNOrderDTO.new;
    }
    return _orderDTO;
}

- (GNCellModel *)promoCodeModel {
    if (!_promoCodeModel) {
        GNCellModel *vatModel = GNCellModel.new;
        vatModel.title = WMLocalizedString(@"OkaO8L5F", @"优惠码");
        vatModel.imageHide = YES;
        vatModel.lineHidden = YES;
        vatModel.offset = kRealWidth(6);
        vatModel.bottomOffset = kRealWidth(6);
        vatModel.detailFont = [HDAppTheme.font gn_boldForSize:13];
        vatModel.cellClass = NSClassFromString(@"GNCommonCell");
        _promoCodeModel = vatModel;
    }
    return _promoCodeModel;
}

@end
