//
//  WMGetUserShoppingCartRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "WMShoppingCartStoreItem.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMGetUserShoppingCartRspModel : WMRspModel
/// 用户账号id
@property (nonatomic, copy) NSString *userAccountId;
/// 购物车的创建时间
@property (nonatomic, copy) NSString *gmtCreate;
/// 门店购物车列表
@property (nonatomic, copy) NSArray<WMShoppingCartStoreItem *> *list;
/// 用户购物车展示号
@property (nonatomic, copy) NSString *userDisplayNo;
/// 购物车已满
@property (nonatomic, assign) BOOL shopCartFull;

@end

NS_ASSUME_NONNULL_END
