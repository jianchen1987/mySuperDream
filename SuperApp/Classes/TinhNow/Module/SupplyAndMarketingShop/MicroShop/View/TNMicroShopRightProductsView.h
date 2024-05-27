//
//  TNMicroShopRightProductsView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopRightProductsView : TNView
/// 删除全部商品后的回调
@property (nonatomic, copy) void (^deleteAllProductsCallBack)(void);
@end

NS_ASSUME_NONNULL_END
