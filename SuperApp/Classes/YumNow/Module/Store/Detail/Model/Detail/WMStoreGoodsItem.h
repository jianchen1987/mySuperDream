//
//  WMStoreGoodsItem.h
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMModel.h"
#import "WMStoreGoodsProductProperty.h"
#import "WMStoreGoodsProductSpecification.h"
#import "WMStoreGoodsSkuCountModel.h"
#import "WMStoreStatusModel.h"

typedef NS_ENUM(NSUInteger, WMStoreGoodsStatus) {
    WMStoreGoodsStatusOnSale = 10,          ///< 上架
    WMStoreGoodsStatusOffSale = 11,         ///< 下架
    WMStoreGoodsStatusOnNewItem = 12,       ///< 新品
    WMStoreGoodsStatusOffNewITen = 13,      ///< 不是新品
    WMStoreGoodsStatusShowOnHome = 14,      ///< 首页展示
    WMStoreGoodsStatusOnShowOnHome = 15,    ///< 不是首页展示
    WMStoreGoodsStatusInDiscount = 16,      ///< 加入折扣
    WMStoreGoodsStatusOffDiscount = 17,     ///< 未加入折扣
    WMStoreGoodsStatusInFullReduction = 18, ///< 加入满减
};

NS_ASSUME_NONNULL_BEGIN

@class WMStoreProductDetailRspModel, WMStoreDetailPromotionModel, WMStoreGoodsPromotionModel;


@interface WMStoreGoodsItem : WMModel
/// code
@property (nonatomic, copy) NSString *code;
/// 商品描述
@property (nonatomic, copy) NSString *desc;
/// 商品 id
@property (nonatomic, copy) NSString *goodId;
/// 商品图片路径集合
@property (nonatomic, copy) NSArray<NSString *> *imagePaths;
/// 商品菜单 id
@property (nonatomic, copy) NSString *menuId;
/// 商品名称
@property (nonatomic, copy) NSString *name;
/// 打包费
@property (nonatomic, strong) SAMoneyModel *packageFee;
/// 包装费策略
@property (nonatomic, assign) WMPackageFeeStrategy packageStrategy;
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
/// 快照 id
@property (nonatomic, copy) NSString *inEffectVersionId;
/// 门店状态
@property (nonatomic, strong) WMStoreStatusModel *storeStatus;
/// 优惠活动
@property (nonatomic, copy) NSArray<WMStoreDetailPromotionModel *> *promotions;
/// 是否是新品
@property (nonatomic, assign) BOOL isNew;
/// 状态标签
@property (nonatomic, strong) NSArray *statusEnums;
/// 当前可用库存
@property (nonatomic, assign) NSUInteger availableStock;
/// 初始化库存
@property (nonatomic, assign) NSUInteger initStock;
/// 商品优惠
@property (nonatomic, strong) WMStoreGoodsPromotionModel *productPromotion;
///// 原价
//@property (nonatomic, strong) SAMoneyModel *salePrice;
///// 优惠价
//@property (nonatomic, strong) SAMoneyModel *discountPrice;

/// 原价
@property (nonatomic, strong) NSString *salePrice;
/// 优惠价
@property (nonatomic, strong) NSString *discountPrice;

/// 原价
@property (nonatomic, assign) NSInteger salePriceCent;
/// 优惠价
@property (nonatomic, assign) NSInteger discountPriceCent;

/// 已售数量
@property (nonatomic, assign) NSInteger sold;
/// 所属菜单id数组
@property (strong, nonatomic) NSArray<NSNumber *> *menuIds;
/// 是否为爆款
@property (nonatomic, assign) BOOL bestSale;
/// 是否限制叠加现金券(弃用，使用useStoreVoucherCoupon、UsePlatformVoucherCoupon判断)
@property (nonatomic, assign) BOOL useVoucherCoupon;
/// 是否限制叠加运费券
@property (nonatomic, assign) BOOL useShippingCoupon;
/// 是否限制叠加优惠券
@property (nonatomic, assign) BOOL usePromoCode;
/// 是否限制叠加配送费活动
@property (nonatomic, assign) BOOL useDeliveryFeeReduce;
/// 商品服务标签
@property (nonatomic, copy) NSArray<NSString *> *serviceLabel;
///是否限制叠加使用门店现金券
@property (nonatomic, assign) BOOL useStoreVoucherCoupon;
///是否限制登加使用平台现金券
@property (nonatomic, assign) BOOL usePlatformVoucherCoupon;

#pragma mark - 绑定属性
/// 当前在购物车中的数量
@property (nonatomic, assign, readonly) NSUInteger currentCountInShoppingCart;
/// 所有规格在购物车中的数量模型
@property (nonatomic, copy, nullable) NSArray<WMStoreGoodsSkuCountModel *> *skuCountModelList;

+ (instancetype)modelWithProductDetailRspModel:(WMStoreProductDetailRspModel *)productDetailRspModel;

#pragma mark - 绑定属性
/// 是否需要显示底部现（默认NO）
@property (nonatomic, assign) BOOL needHideBottomLine;
///// 展示价
//@property (nonatomic, strong, readonly) SAMoneyModel *showPrice;
///// 划线价
//@property (nonatomic, strong, readonly, nullable) SAMoneyModel *linePrice;

/// 展示价
@property (nonatomic, strong, readonly) NSString *showPrice;
/// 划线价
@property (nonatomic, strong, readonly, nullable) NSString *linePrice;

#pragma mark - 绑定属性
/// 搜索关键词
@property (nonatomic, copy) NSString *keyWord;

/// 是否为闪送
@property (nonatomic, assign) BOOL isSpeedService;

@end

NS_ASSUME_NONNULL_END
