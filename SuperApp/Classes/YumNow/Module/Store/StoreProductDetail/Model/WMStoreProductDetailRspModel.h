//
//  WMStoreProductDetailRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMRspModel.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreGoodsProductProperty.h"
#import "WMStoreGoodsProductSpecification.h"
#import "WMStoreGoodsPromotionModel.h"
#import "WMStoreGoodsSkuCountModel.h"
#import "WMStoreStatusModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductDetailRspModel : WMRspModel
/// 商品描述
@property (nonatomic, copy) NSString *desc;
/// 快照 id
@property (nonatomic, copy) NSString *inEffectVersionId;
/// id
@property (nonatomic, copy) NSString *goodId;
/// 商品图片路径集合
@property (nonatomic, copy) NSArray<NSString *> *imagePaths;
/// 商品菜单 id
@property (nonatomic, copy) NSString *menuId;
/// 商品名称
@property (nonatomic, copy) NSString *name;
/// 上架状态
@property (nonatomic, assign) WMGoodsStatus status;
/// 排序
@property (nonatomic, assign) NSInteger sort;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 商品属性集合
@property (nonatomic, copy) NSArray<WMStoreGoodsProductProperty *> *propertyList;
/// 商品规格集合
@property (nonatomic, copy) NSArray<WMStoreGoodsProductSpecification *> *specificationList;
/// 当前在购物车中的数量
@property (nonatomic, assign, readonly) NSUInteger currentCountInShoppingCart;
/// 所有规格在购物车中的数量模型
@property (nonatomic, copy) NSArray<WMStoreGoodsSkuCountModel *> *skuCountModelList;
/// 门店状态
@property (nonatomic, strong) WMStoreStatusModel *storeStatus;
/// 优惠活动
@property (nonatomic, copy) NSArray<WMStoreDetailPromotionModel *> *promotions;
/// 当前可用库存
@property (nonatomic, assign) NSUInteger availableStock;
/// 初始化库存
@property (nonatomic, assign) NSUInteger initStock;
/// 打包费
@property (nonatomic, strong) SAMoneyModel *packageFee;
/// 商品优惠
@property (nonatomic, strong) WMStoreGoodsPromotionModel *productPromotion;
/// 原价
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 优惠价
@property (nonatomic, strong) SAMoneyModel *discountPrice;
/// 已售数量
@property (nonatomic, assign) NSInteger sold;
/// 是否为爆款
@property (nonatomic, assign) BOOL bestSale;
/// 是否限制叠加现金券
@property (nonatomic, assign) BOOL useVoucherCoupon;
/// 是否限制叠加运费券
@property (nonatomic, assign) BOOL useShippingCoupon;
/// 是否限制叠加优惠券
@property (nonatomic, assign) BOOL usePromoCode;
///是否限制叠加配送费活动
@property (nonatomic, assign) BOOL useDeliveryFeeReduce;
/// 商品服务标签
@property (nonatomic, copy) NSArray<NSString *> *serviceLabel;
///是否限制叠加使用门店现金券
@property (nonatomic, assign) BOOL useStoreVoucherCoupon;
///是否限制登加使用平台现金券
@property (nonatomic, assign) BOOL usePlatformVoucherCoupon;

#pragma mark - 以下属性为绑定属性
/// 商品介绍是否展开
@property (nonatomic, assign) BOOL isProductDescExpanded;
/// 商品介绍超过多少行时就显示查看更多，默认 3，0 代表不显示 readMore，行数限制以 numberOfLinesOfMerchantReplyLabel 为准
@property (nonatomic, assign) NSInteger productDescMaxRowCount;
/// 商品介绍显示行数，默认 3
@property (nonatomic, assign) NSInteger numberOfLinesOfProductDescLabel;
/// 展示价
@property (nonatomic, strong, readonly) SAMoneyModel *showPrice;
/// 划线价
@property (nonatomic, strong, readonly, nullable) SAMoneyModel *linePrice;

@end

NS_ASSUME_NONNULL_END
