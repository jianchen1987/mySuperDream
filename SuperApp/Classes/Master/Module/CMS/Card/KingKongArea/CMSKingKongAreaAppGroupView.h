//
//  CMSKingKongAreaAppGroupView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "CMSKingKongAreaAppView.h"
#import "SACollectionViewCell.h"

/// 容器内边距
#define KCMSCollectionEdgeInsets UIEdgeInsetsMake(5, 8, 5, 8)
/// 两个icon容器内边距
#define KCMSTopCollectionEdgeInsets UIEdgeInsetsMake(5, 25, 5, 25)
/// 容器行间距
#define kCMSCollectionViewLineSpacing kRealWidth(0.f)
/// 容器列间距
#define kCMSCollectionViewColSpacing kRealWidth(10.f)

/// 容器列数
#define kCMSCollectionViewColumn 4
/// cell 高宽比
#define kCMSScaleCellHeight2Width ((isScreenHeightLessThan47Inch ? 96 : 96.0) / 90.0)
/// 顶部列数
#define kCMSCollectionViewTopColumn 2
/// 顶部cell高宽比
#define kCMSScaleTopCellHeight2Width ((isScreenHeightLessThan47Inch ? 60.0 : 60.0) / 157.0)

/// 顶部cell 宽
#define kCMSCollectionTopCellW \
    ((kScreenWidth - UIEdgeInsetsGetHorizontalValue(KCMSCollectionEdgeInsets) - (kCMSCollectionViewTopColumn - 1) * kCMSCollectionViewColSpacing) / kCMSCollectionViewTopColumn)
/// 顶部cell 高
#define kCMSCollectionTopCellH (kCMSCollectionTopCellW * kCMSScaleTopCellHeight2Width)

/// cell 宽
#define kCMSCollectionCellW ((kScreenWidth - UIEdgeInsetsGetHorizontalValue(KCMSCollectionEdgeInsets) - (kCMSCollectionViewColumn - 1) * kCMSCollectionViewColSpacing) / kCMSCollectionViewColumn)
/// cell 高
#define kCMSCollectionCellH (kCMSCollectionCellW * kCMSScaleCellHeight2Width)

NS_ASSUME_NONNULL_BEGIN

@class SACMSNode;

UIKIT_EXTERN NSString *const kCMSFunctionThrottleKeyShowKingKongAreaNewFunctionGuide;


@interface CMSKingKongAreaAppGroupView : SACollectionViewCell
- (void)reloadData;
@property (nonatomic, copy) void (^clickKingKongArea)(SACMSNode *node, NSString *link, NSUInteger idx);
@property (nonatomic, copy) NSArray *dataSource; ///< 数据源，可能是本地也可能是服务器获取的
/** 所有要显示新功能提示的 view */
@property (nonatomic, copy, readonly) NSArray<CMSKingKongAreaAppView *> *shouldShowGuideViewArray;
@end

NS_ASSUME_NONNULL_END
