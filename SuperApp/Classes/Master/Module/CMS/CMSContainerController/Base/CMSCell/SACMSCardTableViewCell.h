//
//  SACMSCardTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2021/9/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSCardView;
@class SACMSCardViewConfig;


@interface SACMSCardTableViewCellModel : SAModel

/// 生成的cms卡片
@property (nonatomic, strong) SACMSCardView *cardView;
/// 卡片配置
@property (nonatomic, strong) SACMSCardViewConfig *cardConfig;

@end


@interface SACMSCardTableViewCell : SATableViewCell

@property (nonatomic, strong) SACMSCardTableViewCellModel *model; ///< 模型
/// 刷新卡片回调
@property (nonatomic, copy) void (^refreshCell)(void);
/// 播放视频，仅视频卡片有效（CMSPlayerCardView）
- (void)startPlayer;
/// 暂停视频，仅视频卡片有效（CMSPlayerCardView）
- (void)stopPlayer;

@end


@interface SACMSSkeletonTableViewCellModel : SAModel
@property (nonatomic, assign) NSUInteger cellHeight; ///< 高度
@end


@interface SACMSSkeletonTableViewCell : SATableViewCell <HDSkeletonLayerLayoutProtocol>
@property (nonatomic, strong) SACMSSkeletonTableViewCellModel *model; ///<
@end

NS_ASSUME_NONNULL_END
