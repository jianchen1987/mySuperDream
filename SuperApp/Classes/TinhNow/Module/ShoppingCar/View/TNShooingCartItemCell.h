//
//  TNShooingCartItemCell.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCartProductView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNShooingCartItemCell : SATableViewCell
/// 购物车商品视图
@property (nonatomic, strong) TNShoppingCartProductView *productView;
/// 数据源
@property (nonatomic, strong) TNShoppingCarItemModel *model;
@end

NS_ASSUME_NONNULL_END
