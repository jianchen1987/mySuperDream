//
//  WMeatOnTimeModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMStoreGoodsPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMeatOnTimeProductPromoModel;


@interface WMeatOnTimeModel : WMModel
///图片
@property (nonatomic, copy) NSString *images;
/// name
@property (nonatomic, copy) NSString *name;
///商品id
@property (nonatomic, copy) NSString *productId;
/// originalPrice
@property (nonatomic, strong) NSDecimalNumber *originalPrice;
/// price
@property (nonatomic, strong) NSDecimalNumber *price;
///商品优惠活动
@property (nonatomic, strong) WMeatOnTimeProductPromoModel *productPromotion;
/// logo
@property (nonatomic, copy) NSString *logo;
///门店号
@property (nonatomic, copy) NSString *storeNo;

@end


@interface WMeatOnTimeProductPromoModel : WMModel

@property (nonatomic, assign) WMStoreGoodsPromotionMode discountMode;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, assign) WMStoreGoodsPromotionLimitType limitType;

@property (nonatomic, assign) NSInteger stock;

@end

NS_ASSUME_NONNULL_END
