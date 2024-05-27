//
//  WMGetUserShoppingCartLocalRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "WMShoppingCartStoreQueryItem.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMGetUserShoppingCartLocalRspModel : WMRspModel
/// 购物车的创建时间
@property (nonatomic, copy) NSString *gmtCreate;
/// 门店购物车列表
@property (nonatomic, copy) NSArray<WMShoppingCartStoreQueryItem *> *list;
@end

NS_ASSUME_NONNULL_END
