//
//  WMShoppingCartStoreQueryProduct.h
//  SuperApp
//
//  Created by VanJay on 2020/6/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartStoreQueryProduct : WMModel
/// 更新时间
@property (nonatomic, copy) NSString *updateTime;
/// 门店id
@property (nonatomic, copy) NSString *storeNo;
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// 商品skuId
@property (nonatomic, copy) NSString *goodsSkuId;
/// sku的购买数量
@property (nonatomic, assign) NSUInteger purchaseQuantity;
/// propertyId , 隔开 toString
@property (nonatomic, copy) NSString *propertyValues;
/// 业务线类型
@property (nonatomic, copy) SABusinessType businessType;
/// 快照 di
@property (nonatomic, copy) NSString *inEffectVersionId;
@end

NS_ASSUME_NONNULL_END
