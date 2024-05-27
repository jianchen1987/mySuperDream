//
//  WMCardCellProtocol.h
//  SuperApp
//
//  Created by wmz on 2022/3/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCollectionView.h"
#import "WMHomeCollectionView.h"
#import "WMIndicatorSliderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WMCardCellProtocol <NSObject>
///列表
@property (nonatomic, strong) UIView *collectionView;
/// bgView
@property (nonatomic, strong) UIView *bgView;
///数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// layout
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// sliderView
@property (nonatomic, strong) WMIndicatorSliderView *sliderView;
/// 骨架
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;

/// cardHeight
- (CGFloat)cardHeight;
/// itemSize
- (CGSize)cardItemSize;
/// itemSize
- (CGSize)cardItemSizeWithIndexPath:(NSIndexPath *)indexPath;
///左右间距
- (CGFloat)cardSpace;
///上下间距
- (CGFloat)lineCardSpace;
/// cell
- (Class)cardClass;
///是否使用hdFlowLayout
- (BOOL)cardHDLayout;
///显示滑动指示条
- (BOOL)cardUseSlider;
///循环
- (BOOL)cardCycle;
///使用轮播图 此处直接使用封装好的轮播图 不重复造轮子
- (BOOL)cardUseBanner;
///轮播图偏移距离 不居中 默认0居中
- (CGFloat)bannerDistance;
///循环时间
- (CGFloat)cardCycleDurtion;
///指示条多少个才显示
- (NSInteger)cardSliderCount;
///点击事件
- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath;
///更多点击事件
- (void)cardMoreClickAction;
///打开路由 携带参数
- (void)openLink:(NSString *)link dic:(nullable NSDictionary *)dic;
/// cellWillDisplayAction
- (void)cellWillDisplayWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
