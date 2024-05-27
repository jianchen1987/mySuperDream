//
//  WMShoppingCartPayFeeCalProductModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMRspModel.h"
#import "WMShoppingCartStoreProductProperty.h"
#import "WMStoreGoodsPromotionModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 购物车订单试算返回的商品
@interface WMShoppingCartPayFeeCalProductModel : WMRspModel
/// 数量
@property (nonatomic, assign) NSUInteger count;
/// 可用库存
@property (nonatomic, assign) NSUInteger availableStock;
/// 折扣价
@property (nonatomic, strong) SAMoneyModel *discountPrice;
/// 打包费
@property (nonatomic, strong) SAMoneyModel *packageFee;
/// 单样商品总打包费
@property (nonatomic, strong, readonly) SAMoneyModel *totalPackageFee;
/// 售价
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 包装费策略
@property (nonatomic, assign) WMPackageFeeStrategy packageStrategy;
/// 餐盒费计件方式
@property (nonatomic, assign) NSInteger packageShare;
/// 商品图片
@property (nonatomic, copy) NSString *photo;
/// 商品 id
@property (nonatomic, copy) NSString *productId;
/// 属性
@property (nonatomic, copy) NSArray<WMShoppingCartStoreProductProperty *> *properties;
/// 上架状态
@property (nonatomic, assign) WMGoodsStatus status;
/// 规格 id
@property (nonatomic, copy) NSString *specId;
/// 规格名称
@property (nonatomic, strong) SAInternationalizationModel *specName;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 快照 id
@property (nonatomic, copy) NSString *inEffectVersionId;
/// 商品优惠活动
@property (nonatomic, strong) WMStoreGoodsPromotionModel *productPromotion;
/// 商品优惠的价格
@property (nonatomic, strong) SAMoneyModel *freeProductPromotionAmount;
@end

NS_ASSUME_NONNULL_END
