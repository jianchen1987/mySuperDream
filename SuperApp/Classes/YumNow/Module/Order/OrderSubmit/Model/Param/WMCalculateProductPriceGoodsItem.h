//
//  WMCalculateProductPriceGoodsItem.h
//  SuperApp
//
//  Created by VanJay on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 商品规格信息检查或核算，单商品模型
@interface WMCalculateProductPriceGoodsItem : WMModel
/// 商品 id
@property (nonatomic, copy) NSString *productId;
/// 规格 id
@property (nonatomic, copy) NSString *productSpecId;
/// 数量
@property (nonatomic, assign) NSUInteger quantity;
/// 版本
@property (nonatomic, copy) NSString *version;
@end

NS_ASSUME_NONNULL_END
