//
//  WMShoppingCartStoreProduct.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMGoodsStockModel.h"
#import "WMModel.h"
#import "WMShoppingCartPayFeeCalProductModel.h"
#import "WMShoppingCartStoreProductProperty.h"
#import "WMStoreGoodsPromotionModel.h"

@class WMOrderDetailProductModel;

NS_ASSUME_NONNULL_BEGIN

/// 用于比较是否同一个商品，比较 hash
@interface WMShoppingCartStoreIdentifyableProduct : WMModel
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// 商品skuId
@property (nonatomic, copy) NSString *goodsSkuId;
/// 属性 id
@property (nonatomic, copy) NSArray *propertyArray;
/// 快照 id
@property (nonatomic, copy) NSString *inEffectVersionId;
@end

/// 购物车里每家店的商品模型
@interface WMShoppingCartStoreProduct : WMShoppingCartStoreIdentifyableProduct
/// 购物项名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 购物项名称-英文
@property (nonatomic, copy) NSString *nameEn;
/// 购物项名称-柬文
@property (nonatomic, copy) NSString *nameKm;
/// 购物项名称-中文
@property (nonatomic, copy) NSString *nameZh;
/// 商品sku名称
@property (nonatomic, strong) SAInternationalizationModel *goodsSkuName;
/// 商品sku名称-英文
@property (nonatomic, copy) NSString *goodsSkuNameEn;
/// 商品sku名称-柬文
@property (nonatomic, copy) NSString *goodsSkuNameKM;
/// 商品sku名称-中文
@property (nonatomic, copy) NSString *goodsSkuNameZH;
/// 销售价格
@property (nonatomic, copy) NSString *salePriceCent;
/// 销售价格
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 折扣价格
@property (nonatomic, copy) NSString *discountPriceCent;
/// 折扣价格
@property (nonatomic, strong) SAMoneyModel *discountPrice;
/// 优惠后单价
@property (nonatomic, strong) SAMoneyModel *afterDiscountUnitPrice;
/// 优惠后总价
@property (nonatomic, strong) SAMoneyModel *afterDiscountTotalPrice;
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *totalDiscountAmount;
/// 币种
@property (nonatomic, copy) SACurrencyType currency;
/// 商品库存状态,0-无库存，1-有库存
@property (nonatomic, strong) WMGoodsStockModel *goodsStockStatus;
/// 可用库存
@property (nonatomic, assign) NSUInteger availableStock;
/// 最后操作时间
@property (nonatomic, copy) NSString *updateTime;
/// 商品图片
@property (nonatomic, copy) NSString *picture;
/// 商品状态
@property (nonatomic, assign) WMGoodsStatus goodsState;
/// sku价格
@property (nonatomic, copy) NSString *goodsSkuPriceCent;
/// sku价格
@property (nonatomic, strong) SAMoneyModel *goodsSkuPrice;
/// sku的购买数量
@property (nonatomic, assign) NSUInteger purchaseQuantity;
/// 属性项集合
@property (nonatomic, copy) NSArray<WMShoppingCartStoreProductProperty *> *properties;
/// 门店状态，用于设置数量变化控件状态
@property (nonatomic, copy) WMShopppingCartStoreStatus storeStatus;
/// 商品购物车展示号
@property (nonatomic, copy) NSString *itemDisplayNo;
/// 商品优惠
@property (nonatomic, strong) WMStoreGoodsPromotionModel *productPromotion;
/// 是否为爆款
@property (nonatomic, assign) BOOL bestSale;
/// 原价总价
@property (nonatomic, strong) SAMoneyModel *totalPrice;
/// 是否限制叠加现金券
@property (nonatomic, assign) BOOL useVoucherCoupon;
/// 是否限制叠加运费券
@property (nonatomic, assign) BOOL useShippingCoupon;
/// 是否限制叠加优惠券
@property (nonatomic, assign) BOOL usePromoCode;
/// 是否限制叠加配送费活动
@property (nonatomic, assign) BOOL useDeliveryFeeReduce;
/// 商品优惠数量
@property (nonatomic, assign) NSInteger discountCount;
/// 爆单
@property (nonatomic, assign) BOOL fullOrder;
/// 最大数量
@property (nonatomic, assign) NSInteger maxQuantity;
/// 商品类型
@property (nonatomic, copy) NSString *orderCommodityId;
///是否限制叠加使用门店现金券
@property (nonatomic, assign) BOOL useStoreVoucherCoupon;
///是否限制登加使用平台现金券
@property (nonatomic, assign) BOOL usePlatformVoucherCoupon;


#pragma mark - 绑定属性
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 隐藏原价
@property (nonatomic, assign) BOOL hideOriginalPrice;
/// 是否需要显示底部线默认为NO
@property (nonatomic, assign) BOOL needShowBottomLine;
/// 是否可以选中
@property (nonatomic, assign) BOOL canSelected;
/// 比较对象，用于比较是否同一个商品
@property (nonatomic, strong) WMShoppingCartStoreIdentifyableProduct *identifyObj;
/// 展示原价商品
@property (nonatomic, assign) BOOL showOriginal;
/// 1: 正常, 2: 未到菜单开售时间, 3: 未到活动开售时间
@property (nonatomic, copy) NSString *statusResult;

+ (instancetype)modelWithOrderDetailProductModel:(WMOrderDetailProductModel *)model;

#pragma mark - 绑定属性
/// 展示价
@property (nonatomic, strong) SAMoneyModel *showPrice;
/// 划线价
@property (nonatomic, strong, nullable) SAMoneyModel *linePrice;
///是否是删除选中
@property (nonatomic, assign) BOOL isDeleteSelected;

@end

NS_ASSUME_NONNULL_END
