//
//  SAKingKongAreaAppGroupView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "TNKingKongAreaAppView.h"

/// 容器内边距
#define KCollectionEdgeInsets UIEdgeInsetsMake(5, 8, 5, 8)
/// 容器行间距
#define kCollectionViewLineSpacing kRealWidth(0.f)
/// 容器列间距
#define kCollectionViewColSpacing kRealWidth(0.f)
/// 容器列数
#define kCollectionViewColumn 4
/// cell 高宽比
#define kScaleCellHeight2Width ((isScreenHeightLessThan47Inch ? 96 : 96.0) / 90.0)
/// cell 宽
#define kCollectionCellW ((kScreenWidth - UIEdgeInsetsGetHorizontalValue(KCollectionEdgeInsets) - (kCollectionViewColumn - 1) * kCollectionViewColSpacing) / kCollectionViewColumn)
/// cell 高
#define kCollectionCellH (kCollectionCellW * kScaleCellHeight2Width)

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const kTNFunctionThrottleKeyShowKingKongAreaNewFunctionGuide;


@interface TNKingKongAreaAppGroupView : SACollectionViewCell
- (void)reloadData;
@property (nonatomic, copy) void (^canNotOpenRouteHandler)(NSString *urlString); ///< 无法打开路由
@property (nonatomic, copy) NSArray *dataSource;                                 ///< 数据源，可能是本地也可能是服务器获取的
/** 所有要显示新功能提示的 view */
@property (nonatomic, copy, readonly) NSArray<TNKingKongAreaAppView *> *shouldShowGuideViewArray;
@end

NS_ASSUME_NONNULL_END
