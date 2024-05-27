//
//  SACarouselViewWrapperCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAWindowItemModel.h"

typedef NS_ENUM(NSUInteger, TNCarouselViewWrapperCellType) {
    TNCarouselViewWrapperCellTypeActivity = 18,     ///< 活动
    TNCarouselViewWrapperCellTypeAdvertisement = 17 ///< 顶部滚动广告
};

NS_ASSUME_NONNULL_BEGIN


@interface TNCarouselViewWrapperCellModel : SAModel
@property (nonatomic, assign) TNCarouselViewWrapperCellType type; ///< 轮播类型
@property (nonatomic, copy) NSArray<SAWindowItemModel *> *list;   ///< 广告列表
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 内边距
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

+ (instancetype)modelWithType:(TNCarouselViewWrapperCellType)type list:(NSArray<SAWindowItemModel *> *)list;

@end

NS_ASSUME_NONNULL_END
