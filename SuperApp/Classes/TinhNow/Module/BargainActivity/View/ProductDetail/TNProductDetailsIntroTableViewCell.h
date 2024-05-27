//
//  TNProductDetailsIntroTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNEnum.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNImageModel;
@class TNSingleVideoCollectionViewCellModel;


@interface TNProductDetailsIntroTableViewCellModel : TNModel

/// 图片
@property (nonatomic, strong) NSArray<TNImageModel *> *images;
/// 产品Id
@property (nonatomic, copy) NSString *productId;
/// 价格区间
@property (nonatomic, copy) NSString *priceRange;
/// 是否收藏
@property (nonatomic, assign) BOOL isCollected;
/// 产品名称
@property (nonatomic, copy) NSString *productName;
/// 原价  下划线处理
@property (nonatomic, copy) NSString *originalPrice;
/// 折扣
@property (nonatomic, copy) NSString *discount;
/// 默认价格
@property (nonatomic, copy) NSString *price;
/// 是否是限购商品
@property (nonatomic, assign) BOOL goodsLimitBuy;
/// 最大限购数量
@property (nonatomic, assign) NSInteger maxLimit;
/// 已售数量
@property (nonatomic, assign) NSInteger sales;
/// 详情样式
@property (nonatomic, assign) TNProductDetailViewType detailViewType;
/// 全网公告
@property (nonatomic, strong) NSString *announcement;
/// 商品编号
@property (nonatomic, strong) NSString *sn;
/// 视频列表
@property (strong, nonatomic) NSArray<NSString *> *videoList;
/// 记录是否已经自动播放  只自动播放一次
@property (nonatomic, assign) BOOL hasAutoPLay;
/// 当前滚动图片位置
@property (nonatomic, assign) NSInteger currentPageIndex;
/// 是否免邮
@property (nonatomic, assign) BOOL isFreeShipping;
/// 商品类型
@property (nonatomic, copy) TNGoodsType type;
///批发价
@property (nonatomic, copy) NSString *tradePrice;
///收益
@property (nonatomic, copy) NSString *revenue;
/// 销量格式化展示  < 100 等等
@property (nonatomic, copy) NSString *salesLabel;
///是否已经加入销售
@property (nonatomic, assign) BOOL isJoinSales;
///
@property (nonatomic, assign) BOOL isHonor;
///  卖家sp
@property (nonatomic, copy) NSString *sp;
/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;
@end


@interface TNProductDetailsIntroTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNProductDetailsIntroTableViewCellModel *model;

/// 将cell 轮播图collection  indexpath传递出去
@property (nonatomic, copy) void (^videoTapClick)(HDCyclePagerView *pagerView, NSIndexPath *indexPath, TNSingleVideoCollectionViewCellModel *cellModel);
///// 轮播图滚动位置
@property (nonatomic, copy) void (^pagerViewChangePage)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
