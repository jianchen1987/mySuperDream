//
//  WMShoppingCartUpdateGoodsRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/11/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;
@class WMShoppingCartStoreItem;
@class WMGetUserShoppingCartRspModel;


@interface WMUpdateShoppingCartGoodsCountModel : WMModel
@property (nonatomic, copy) NSString *goodsId;                   ///< id
@property (nonatomic, copy) NSString *goodsSkuId;                ///< skuid
@property (nonatomic, copy) NSString *itemDisplayNo;             ///< 购物项展示号
@property (nonatomic, strong) SAMoneyModel *totalAmount;         ///< 总金额
@property (nonatomic, strong) SAMoneyModel *totalDiscountAmount; ///< 总折扣金额
@property (nonatomic, copy) NSString *merchantDisplayNo;         ///< 商户展示号
@property (nonatomic, copy) NSString *propertyValue;             ///< 属性值
/// 商品状态
@property (nonatomic, assign) WMGoodsStatus goodsState;
@property (nonatomic, strong) SAMoneyModel *skuSalePrice;     ///< sku销售价
@property (nonatomic, copy) NSString *userDisplayNo;          ///< 用户展示号
@property (nonatomic, strong) SAMoneyModel *skuDiscountPrice; ///< sku折扣价
@property (nonatomic, assign) NSUInteger purchaseQuantity;    ///< 购买数量
@property (nonatomic, copy) NSString *currency;               ///< 币种
@property (nonatomic, copy) NSString *userAccountId;          ///< ？？？不清楚干啥的

@end


@interface WMShoppingCartUpdateGoodsRspModel : WMRspModel

@property (nonatomic, strong) WMUpdateShoppingCartGoodsCountModel *updateItem; ///< 更新项
@property (nonatomic, strong) WMGetUserShoppingCartRspModel *shopCart;         ///< 统一购物车
@property (nonatomic, strong) WMShoppingCartStoreItem *merchantCart;           ///< 门店购物车

@end

NS_ASSUME_NONNULL_END
