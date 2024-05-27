//
//  SACMSUserGeneratedContentCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2022/11/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallDataSourceRspModel.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSUserGeneratedContentCollectionViewCell : SACollectionViewCell
///< model
@property (nonatomic, strong) SACMSWaterfallCellModel *model;

/// cell删除
@property (nonatomic, copy) void (^cellDidDeletedHandler)(SACMSWaterfallCellModel *model);

@end

@interface SACMSWaterfallSkeletonCollectionViewCellModel : SAModel
@property (nonatomic, assign) NSUInteger cellHeight; ///< 高度
@end
///< 加载骨架Cell
@interface SACMSWaterfallSkeletonCollectionViewCell : SACollectionViewCell <HDSkeletonLayerLayoutProtocol>
///< model
@property (nonatomic, strong) SACMSWaterfallSkeletonCollectionViewCellModel *model;
@end

NS_ASSUME_NONNULL_END
