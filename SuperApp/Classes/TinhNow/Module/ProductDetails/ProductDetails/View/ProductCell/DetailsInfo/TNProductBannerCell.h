//
//  TNProductBannerCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNEnum.h"
@class TNImageModel;
@class TNSingleVideoCollectionViewCellModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNProductBannerCellModel : NSObject
/// 图片
@property (nonatomic, strong) NSArray<TNImageModel *> *images;
/// 视频列表
@property (strong, nonatomic) NSArray<NSString *> *videoList;
/// 记录是否已经自动播放  只自动播放一次
@property (nonatomic, assign) BOOL hasAutoPLay;
/// 当前滚动图片位置
@property (nonatomic, assign) NSInteger currentPageIndex;
/// 是否免邮
@property (nonatomic, assign) BOOL isFreeShipping;
@end


@interface TNProductBannerCell : SATableViewCell
///
@property (strong, nonatomic) TNProductBannerCellModel *model;
/// 将cell 轮播图collection  indexpath传递出去
@property (nonatomic, copy) void (^videoTapClick)(HDCyclePagerView *pagerView, NSIndexPath *indexPath, TNSingleVideoCollectionViewCellModel *cellModel);
///// 轮播图滚动位置
@property (nonatomic, copy) void (^pagerViewChangePage)(NSInteger index);
/// 轮播图右滑到底部后滚动到推荐列表
@property (nonatomic, copy) void (^scrollerToRecommendSection)(void);
@end

NS_ASSUME_NONNULL_END
