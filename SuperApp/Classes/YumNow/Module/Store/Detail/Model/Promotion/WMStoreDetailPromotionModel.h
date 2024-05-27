//
//  WMStoreDetailPromotionModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAMoneyModel.h"
#import "WMCouponActivityContentModel.h"
#import "WMOrderRelatedEnum.h"
#import "WMStoreFillGiftRuleModel.h"
#import "WMStoreLadderRuleModel.h"

@class WMUIButton;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreDetailPromotionModel : SAModel
/// 活动ID
@property (nonatomic, copy) NSString *activityNo;
/// 折扣比例
@property (nonatomic, strong) NSNumber *discountRatio;
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmount;
/// 满减阶梯
@property (nonatomic, copy) NSArray<WMStoreLadderRuleModel *> *ladderRules;
/// 优惠类型
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;
/// 优惠时间
@property (nonatomic, copy) NSString *openingTimes;
/// 优惠日期
@property (nonatomic, copy) NSString *openingWeekdays;
/// 优惠描述
@property (nonatomic, copy, readonly) NSString *promotionDesc;
/// 在使用中的满减优惠梯度模型
@property (nonatomic, strong, readonly) WMStoreLadderRuleModel *inUseLadderRuleModel;
/// 折扣描述
@property (nonatomic, copy, readonly) NSString *discountRadioStr;
/// 首单
@property (nonatomic, strong) SAMoneyModel *firstOrderReductionAmount;
/// 下一阶梯优惠（针对满减）
@property (nonatomic, strong) WMStoreLadderRuleModel *nextLadder;
/// 当前活动设置的起送价
@property (nonatomic, strong) SAMoneyModel *requiredPrice;
/// 活动描述
@property (nonatomic, copy) NSString *title;
/// 满赠活动
@property (nonatomic, copy) NSArray<WMStoreFillGiftRuleModel *> *activityContentResps;
/// 是否是门店优惠券
@property (nonatomic, assign) BOOL isStoreCoupon;
/// 门店优惠券活动信息
@property (nonatomic, strong) WMCouponActivityContentModel *storeCouponActivitys;

+ (NSArray<WMUIButton *> *)configPromotions:(NSArray *)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService;

+ (NSArray<WMUIButton *> *)configPromotions:(NSArray *)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService shouldAddStoreCoupon:(BOOL)shouldAdd;

+ (NSArray<WMUIButton *> *)configserviceLabel:(NSArray *)serviceLabel;

+ (NSArray<WMUIButton *> *)configPromotions:(NSArray *)promotions
                           productPromotion:(nullable NSArray *)productPromotion
                             hasFastService:(BOOL)hasFastService
                       shouldAddStoreCoupon:(BOOL)shouldAdd
                                   newStyle:(BOOL)newStyle;

+ (NSArray<WMUIButton *> *)configNewPromotions:(NSArray<NSString *>*)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService;

+ (NSArray<WMUIButton *> *)configNewPromotions:(NSArray<NSString *> *)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService shouldAddStoreCoupon:(BOOL)shouldAdd;

+ (NSArray<WMUIButton *> *)configNewPromotions:(NSArray<NSString *>*)promotions
                              productPromotion:(nullable NSArray *)productPromotion
                                hasFastService:(BOOL)hasFastService
                          shouldAddStoreCoupon:(BOOL)shouldAdd
                                      newStyle:(BOOL)newStyle;

+ (NSArray<WMUIButton *> *)configserviceLabel:(NSArray *)serviceLabel newStyle:(BOOL)newStyle;

@end

NS_ASSUME_NONNULL_END
