//
//  WMOrderSubmitCalPayFeeProductItem.h
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitCalPayFeeProductItem : WMModel
/// 销售价格
@property (nonatomic, copy) NSString *salePrice;
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// sku的购买数量
@property (nonatomic, assign) NSUInteger purchaseQuantity;
/// 折扣后价格
@property (nonatomic, copy) NSString *discountPrice;
/// 商品skuId(对应外卖的规格id)
@property (nonatomic, copy) NSString *goodsSkuId;
/// 属性 id 数组
@property (nonatomic, copy) NSArray<NSString *> *properties;
/// 图片
@property (nonatomic, copy) NSString *picture;
@end

NS_ASSUME_NONNULL_END
