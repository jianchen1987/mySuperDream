//
//  WMSpecialActivesProductModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMNextServiceTimeModel.h"
#import "WMStoreGoodsPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;
@class SAInternationalizationModel;


@interface WMSpecialActivesProductModel : WMModel
/// logo
@property (nonatomic, copy) NSString *logo;
/// 评分
@property (nonatomic, strong) NSNumber *reviewScore;
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 配送费
@property (nonatomic, strong) SAMoneyModel *deliveryFee;
/// 销售价
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 优惠价
@property (nonatomic, strong) SAMoneyModel *discountPrice;
/// 配送时间：分钟
@property (nonatomic, strong) NSString *deliveryTime;

@property (nonatomic, strong) NSString *estimatedDeliveryTime;
/// 门店名
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 背景图
@property (nonatomic, copy) NSString *photo;
/// 销量
@property (nonatomic, strong) NSNumber *sold;
/// 商品名
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;

/// cell宽度
@property (nonatomic, assign) CGFloat preferredWidth;
/// cell高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/// cell高度-给新版商品专题用的
@property (nonatomic, assign, readonly) CGFloat cellNewHeight;
/// 内边距
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
/// 商品优惠
@property (nonatomic, strong) WMStoreGoodsPromotionModel *productPromotion;
/// 爆单状态 10正常 20爆单 30爆单停止接单
@property (nonatomic, assign) WMStoreFullOrderState fullOrderState;
/// 出餐慢状态 10正常 20出餐慢
@property (nonatomic, assign) WMStoreSlowMealState slowMealState;

#pragma mark - 绑定属性
/// 展示价
@property (nonatomic, strong, readonly) SAMoneyModel *showPrice;
/// 划线价
@property (nonatomic, strong, readonly, nullable) SAMoneyModel *linePrice;
/// 休息中
@property (nonatomic, strong) WMNextServiceTimeModel *nextServiceTime;
@end

NS_ASSUME_NONNULL_END
