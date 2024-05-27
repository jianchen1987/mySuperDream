//
//  WMShoppingCartPayFeeCalItem.h
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartOrderCheckItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 购物车订单试算传参对象
@interface WMShoppingCartPayFeeCalItem : WMShoppingCartOrderCheckItem
/// 属性 id 数组
@property (nonatomic, copy) NSArray<NSString *> *properties;
/// 选中
@property (nonatomic, copy) NSString *select;

@end

NS_ASSUME_NONNULL_END
