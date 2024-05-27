//
//  WMOrderSubmitCouponModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMModel.h"
#import "SAInternationalizationModel.h"

@class SACouponTicketModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitCouponModel : WMModel
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmount;
/// 优惠券号
@property (nonatomic, copy) NSString *couponCode;
/// 优惠券是否可用
@property (nonatomic, copy) SABoolValue usable;

/// 门槛(满减券)
@property (nonatomic, strong) SAMoneyModel *thresholdMoney;
/// 现金券面值
@property (nonatomic, strong) SAMoneyModel *couponMoney;
/// 币种 KHR(10, "KHR")
@property (nonatomic, copy) SACurrencyType currencyType;
/// 优惠类型
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;
/// 优惠描述
@property (nonatomic, strong) NSString *desc;
/// 优惠标题
@property (nonatomic, copy) NSString *title;
/// 不可用原因
@property (nonatomic, strong) WMUnUseCouponReasonType unavaliableReson;
/// 其他不可用原因
@property (nonatomic, strong) SAInternationalizationModel *unavaliableOtherReson;
/// 优惠提示
@property (nonatomic, copy) NSString *discountTips;
/// 可用币种
@property (nonatomic, copy) SACurrencyType ableCurrencyType;
/// 默认选中
@property (nonatomic, copy) SABoolValue checked;
/// 有效开始时间
@property (nonatomic, copy) NSString *effectiveDate;
/// 有效结果时间
@property (nonatomic, copy) NSString *expireDate;
/// 折扣比例(折扣类型(活动和优惠券)要用)
@property (nonatomic, strong) NSNumber *discountRatio;
/// 优惠金额Double类型 (用于排序)
@property (nonatomic, assign) double doubleDiscountAmount;
/// 业务线 (13:外卖 14: 电商 15:民生业务(话费充值、网络缴费))
@property (nonatomic, copy) SAMarketingBusinessType businessType;
/// 优惠券类型 13-折扣券 14-满减券 15-代金券 34-运费券
@property (nonatomic, assign) SACouponTicketType couponType;
/// 是否限制叠加现金券
@property (nonatomic, assign) BOOL useVoucherCoupon;
/// 是否限制叠加运费券
@property (nonatomic, assign) BOOL useShippingCoupon;
/// 是否限制叠加优惠券
@property (nonatomic, assign) BOOL usePromoCode;
///是否限制叠加配送费活动
@property (nonatomic, assign) BOOL useDeliveryFeeReduce;
/// 活动主体类型
@property (nonatomic, assign) WMPromotionSubjectType activitySubject;

/// custom属性
/// 选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;
/// 展开
@property (nonatomic, assign, getter=isOpen) BOOL open;
/// 移除选中
@property (nonatomic, assign, getter=isClearSelect) BOOL clearSelect;
/// 不可用原因对应的文本
@property (nonatomic, copy) NSString *unavaliableResonStr;
/// 传入的金额
@property (nonatomic, copy) NSString *amount;
/// 类型
@property (nonatomic, assign) WMCouponType customCouponType;

@end

NS_ASSUME_NONNULL_END
