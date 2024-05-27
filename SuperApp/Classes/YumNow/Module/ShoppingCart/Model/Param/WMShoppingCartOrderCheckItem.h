//
//  WMShoppingCartOrderCheckItem.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 下单前检查
@interface WMShoppingCartOrderCheckItem : WMModel
/// 数量
@property (nonatomic, assign) NSUInteger count;
/// 商品 id
@property (nonatomic, copy) NSString *productId;
/// 规格 id
@property (nonatomic, copy) NSString *specId;
@end

NS_ASSUME_NONNULL_END
