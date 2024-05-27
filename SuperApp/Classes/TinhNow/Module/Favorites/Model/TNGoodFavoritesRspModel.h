//
//  TNGoodFavoritesModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//
#import "TNPagingRspModel.h"
@class TNGoodFavoritesModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNGoodFavoritesRspModel : TNPagingRspModel
/// 商品收藏数组
@property (strong, nonatomic) NSArray<TNGoodFavoritesModel *> *list;
@end

NS_ASSUME_NONNULL_END
