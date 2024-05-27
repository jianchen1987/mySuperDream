//
//  SACMSWaterfallDataSourceRspModel.h
//  SuperApp
//
//  Created by seeu on 2022/2/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SACMSWaterfallCellType) {
    SACMSWaterfallCellTypeDiscovery = 1,    ///< 发现页
    SACMSWaterfallCellTypeHomeRecommand = 2 ///< 首页推荐
};

@class SACMSWaterfallCellModel;
@class SADiscoveryStatisticsModel;


@interface SACMSWaterfallDataSourceRspModel : SACommonPagingRspModel

///< 列表
@property (nonatomic, strong) NSArray<SACMSWaterfallCellModel *> *list;

@end


@interface SACMSWaterfallCellModel : SAModel
///< 标题
@property (nonatomic, copy) NSString *contentTitle;
///< 编号
@property (nonatomic, copy) NSString *contentNo;
///< 发布时间
@property (nonatomic, assign) NSTimeInterval publishTime;
///< 语言
@property (nonatomic, copy) NSString *contentLanguage;
///< 封面
@property (nonatomic, copy) NSString *cover;
///< 封面宽
@property (nonatomic, assign) CGFloat coverWidth;
///< 封面高
@property (nonatomic, assign) CGFloat coverHeight;
///< 内容标签
@property (nonatomic, strong) NSArray<NSString *> *contentTags;
///< 跳转
@property (nonatomic, copy) NSString *contentLink;
///< 视频链接
@property (nonatomic, copy) NSString *videoLink;
///< 是否已经点赞
@property (nonatomic, assign) BOOL hasLike;
///< 数据
@property (nonatomic, strong) SADiscoveryStatisticsModel *statistics;
///< 类型
@property (nonatomic, assign) SACMSWaterfallCellType cellType;
///< 标签
@property (nonatomic, strong) NSArray<NSString *> *tags;
///< 业务线
@property (nonatomic, copy) NSString *bizLine;
@property (nonatomic, copy) NSString *bizType;     ///< 数据类型，埋点用
@property (nonatomic, copy) NSString *showBizLine; ///< 是否显示业务线标签
///< 任务id，用于完成点赞任务
@property (nonatomic, copy) NSString *taskId;

/// 价格
@property (nonatomic, copy) NSString *price;

#pragma mark - layout
@property (nonatomic, assign) CGFloat cellWidth;  ///< cell的宽度
@property (nonatomic, assign) CGFloat cellHeight; ///< cell的高度

- (CGFloat)heightWithWidth:(CGFloat)width;

@end


@interface SADiscoveryStatisticsModel : SAModel
///< 点赞数
@property (nonatomic, strong) NSNumber *likeCount;
@end

NS_ASSUME_NONNULL_END
