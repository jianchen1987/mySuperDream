//
//  TNShopCarHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
@class TNShoppingCarStoreModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNShopCarHeaderView : SATableHeaderFooterView
/// 点击店铺全选按钮
@property (nonatomic, copy) void (^clickAllSelectedStoreProductCallBack)(void);
/// 店铺模型
@property (strong, nonatomic) TNShoppingCarStoreModel *model;
@end

NS_ASSUME_NONNULL_END
