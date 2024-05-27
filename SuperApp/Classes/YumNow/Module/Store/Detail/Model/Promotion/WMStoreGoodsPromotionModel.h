//
//  WMStoreGoodsPromotionModel.h
//  SuperApp
//
//  Created by Chaos on 2020/9/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMModel.h"
#import "WMUIButton.h"
#import <HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreGoodsPromotionModel : WMModel
/// 活动限制
@property (nonatomic, assign) WMStoreGoodsPromotionLimitType type;
/// 优惠模式
@property (nonatomic, assign) WMStoreGoodsPromotionMode mode;
/// 优惠值
@property (nonatomic, strong) NSNumber *value;
/// 可用优惠库存（减去购物车中的数量）
//@property (nonatomic, assign) NSUInteger stock;
/// 可用优惠库存
@property (nonatomic, assign) NSUInteger limitValue;
////activityNo
@property (nonatomic, strong) NSString *activityNo;

/// 根据商品活动和当前的售价计算当前商品展示价
+ (SAMoneyModel *)calculateShowPriceWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions salePrice:(SAMoneyModel *)salePrice;
/// 根据商品活动和当前的售价计算当前商品划线价
+ (SAMoneyModel *)calculateLinePriceWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions salePrice:(SAMoneyModel *)salePrice;

+ (NSArray<WMUIButton *> *)configProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions;
+ (NSArray<WMUIButton *> *)configProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions backGroundColor:(nullable UIColor *)bgColor;

/// 商品活动折扣的显示字符串
+ (NSString *)preferentialLabelTextWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions;

/// 是否超过最大限购数量(例：最大库存为3，超过（不包含） 4 时返回YES，其余都返回NO)
/// 正好为4时会自动弹toast提示，外部无需再次提示

+ (BOOL)isJustOverMaxStockWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions currentCount:(NSUInteger)currentCount otherSkuCount:(NSUInteger)otherSkuCount;

@end

NS_ASSUME_NONNULL_END
