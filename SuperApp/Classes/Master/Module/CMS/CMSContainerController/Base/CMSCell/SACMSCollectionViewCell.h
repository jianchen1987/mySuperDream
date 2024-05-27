//
//  TNCMSCollectionViewCell.h
//  SuperApp
//
//  Created by Chaos on 2021/7/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSCardView.h"
#import "SACollectionViewCell.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSPlaceholderCollectionViewCell;
@class SACMSPlaceholderCollectionViewCellModel;
@class SACMSCustomCollectionCellModel;


#pragma mark - CMS卡片的cell
@interface SACMSCollectionViewCellModel : SAModel

/// 生成的cms页面
@property (nonatomic, strong) SACMSCardView *cardView;
/// cms配置
@property (nonatomic, strong) SACMSCardViewConfig *cardConfig;

@end


@interface SACMSCollectionViewCell : SACollectionViewCell

@property (nonatomic, strong) SACMSCollectionViewCellModel *model;
/// 刷新卡片回调
@property (nonatomic, copy) void (^refreshCell)(void);
/// 播放视频，仅视频卡片有效（CMSPlayerCardView）
- (void)startPlayer;
/// 暂停视频，仅视频卡片有效（CMSPlayerCardView）
- (void)stopPlayer;

@end


#pragma mark - 自定义视图Cell
@interface SACMSCustomCollectionCell : SACollectionViewCell
///< 模型
@property (nonatomic, strong) SACMSCustomCollectionCellModel *model;
@end


@interface SACMSCustomCollectionCellModel : SAModel
///< 自定义视图
@property (nonatomic, strong) UIView *view;
///< 视图高度
@property (nonatomic, assign) CGFloat height;
@end


#pragma mark - CMS卡片加载骨架
@interface SACMSSkeletonCollectionViewCellModel : SAModel
@property (nonatomic, assign) NSUInteger cellHeight; ///< 高度
@end
///< 加载骨架Cell
@interface SACMSSkeletonCollectionViewCell : SACollectionViewCell <HDSkeletonLayerLayoutProtocol>
///< model
@property (nonatomic, strong) SACMSSkeletonCollectionViewCellModel *model;
@end


#pragma mark - 占位图
///< 占位图Cell
@interface SACMSPlaceholderCollectionViewCell : SACollectionViewCell

@end
///< 占位图model
@interface SACMSPlaceholderCollectionViewCellModel : SAModel

///< cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
