//
//  WMShoppingCartStoreQueryItem.h
//  SuperApp
//
//  Created by VanJay on 2020/6/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMShoppingCartStoreQueryProduct.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartStoreQueryItem : WMModel
/// 更新时间
@property (nonatomic, copy) NSString *updateTime;
/// 门店id
@property (nonatomic, copy) NSString *storeNo;
/// 购物项列表（离线购物车用）
@property (nonatomic, copy) NSArray<WMShoppingCartStoreQueryProduct *> *shopCartItemBOS;
@end

NS_ASSUME_NONNULL_END
