//
//  TNFavoritesCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNGoodFavoritesModel;
@class TNStoreFavoritesModel;
NS_ASSUME_NONNULL_BEGIN

//*商品收藏页面和 店铺收藏页面公用一个cell  赋值对应的模型即可*/


@interface TNFavoritesCell : SATableViewCell
/// 收藏商品模型
@property (strong, nonatomic) TNGoodFavoritesModel *goodModel;
/// 收藏店铺模型
@property (strong, nonatomic) TNStoreFavoritesModel *storeModel;
/// 收藏商品删除按钮 点击回调
@property (nonatomic, copy) void (^goodDeleteCallBack)(TNGoodFavoritesModel *model);
/// 收藏店铺删除按钮 点击回调
@property (nonatomic, copy) void (^storeDeleteCallBack)(TNStoreFavoritesModel *model);
@end

NS_ASSUME_NONNULL_END
