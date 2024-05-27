//
//  TNAddItemToShoppingCarRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNAddItemToShoppingCarRspModel : TNRspModel
/// 商品购物车展示号
@property (nonatomic, copy) NSString *itemDisplayNo;
/// 用户购物车展示号
@property (nonatomic, copy) NSString *userDisplayNo;
/// 门店购物车展示号
@property (nonatomic, copy) NSString *merchantDisplayNo;
@end

NS_ASSUME_NONNULL_END
