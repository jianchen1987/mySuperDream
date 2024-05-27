//
//  WMStoreGoodsSkuCountModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreGoodsSkuCountModel : NSObject
/// 规格 id
@property (nonatomic, copy) NSString *skuId;
/// 在购物车中的数量
@property (nonatomic, assign) NSUInteger countInCart;
@end

NS_ASSUME_NONNULL_END
