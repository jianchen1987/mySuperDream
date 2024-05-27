//
//  CMSFourImageScrolledCardCellConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CMSFourImageScrolledItemConfig;


@interface CMSFourImageScrolledCardCellConfig : SAModel

/// 左右距离
@property (nonatomic, assign) CGFloat left2RightScale;
/// 上下距离
@property (nonatomic, assign) CGFloat top2BottomScale;
/// edg
@property (nonatomic, assign) UIEdgeInsets cellEdge;
/// 数据源
@property (nonatomic, copy) NSArray<CMSFourImageScrolledItemConfig *> *list;

@end

NS_ASSUME_NONNULL_END
