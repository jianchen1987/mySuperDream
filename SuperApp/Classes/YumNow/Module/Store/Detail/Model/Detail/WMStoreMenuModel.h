//
//  WMStoreMenuModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMStoreGoodsItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 门店菜单项
@interface WMStoreMenuModel : WMModel
/// 菜单 id
@property (nonatomic, copy) NSString *menuId;
/// 菜单列表
@property (nonatomic, copy) NSArray<WMStoreGoodsItem *> *list;
@end

NS_ASSUME_NONNULL_END
