//
//  WMStoreMenuItem.h
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreMenuItem : WMModel
/// 类目id
@property (nonatomic, copy) NSString *menuId;
/// 类目名称  后台已根据UA的语言返回
@property (nonatomic, copy) NSString *name;
/// 类目下商品数量
@property (nonatomic, assign) NSInteger count;
/// 是否为爆款菜单
@property (nonatomic, assign) BOOL bestSale;
/// 当天剩余可用爆品数
@property (nonatomic, assign) NSInteger availableBestSaleCount;
/// select
@property (nonatomic, assign, getter=isSelected) BOOL select;
@end

NS_ASSUME_NONNULL_END
