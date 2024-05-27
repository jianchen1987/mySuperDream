//
//  TNQueryUserShoppingCarRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNShoppingCarStoreModel;


@interface TNQueryUserShoppingCarRspModel : TNRspModel
/// 用户购物车展示号
@property (nonatomic, copy) NSString *userDisplayNo;
/// 购物车创建时间
@property (nonatomic, assign) NSTimeInterval gmtCreate;
/// 门店购物车列表
@property (nonatomic, strong) NSArray<TNShoppingCarStoreModel *> *storeShoppingCars;
@end

NS_ASSUME_NONNULL_END
