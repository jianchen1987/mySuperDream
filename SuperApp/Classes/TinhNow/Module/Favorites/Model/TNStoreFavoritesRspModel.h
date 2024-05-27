//
//  TNStoreFavoritesRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"
@class TNStoreFavoritesModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNStoreFavoritesRspModel : TNPagingRspModel
/// 店铺收藏数组
@property (strong, nonatomic) NSArray<TNStoreFavoritesModel *> *list;
@end

NS_ASSUME_NONNULL_END
