//
//  TNStoreSceneRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNStoreSceneModel;


@interface TNStoreSceneRspModel : TNPagingRspModel
/// 数据源
@property (strong, nonatomic) NSArray<TNStoreSceneModel *> *content;
@end

NS_ASSUME_NONNULL_END
