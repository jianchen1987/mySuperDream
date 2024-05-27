//
//  TNShoppingCarCountModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNShoppingCarCountModel : TNModel
/// 单个购物车数量
@property (nonatomic, assign) NSInteger singleShoppingCartCount;
/// 批量购物车数量
@property (nonatomic, assign) NSInteger batchShoppingCartCount;
/// 购物车总数
@property (nonatomic, assign) NSInteger totalItems;
@end

NS_ASSUME_NONNULL_END
