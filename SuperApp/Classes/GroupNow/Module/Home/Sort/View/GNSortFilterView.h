//
//  GNSortFilterView.h
//  SuperApp
//
//  Created by wmz on 2022/6/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNClassificationModel.h"
#import "GNCollectionView.h"
#import "GNProductFilterView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNSortFilterView : GNProductFilterView
///数据源
@property (nonatomic, copy) NSArray<GNClassificationModel *> *cateDatasource;
/// collectionView
@property (nonatomic, strong) GNCollectionView *collectionView;
/// 选中的model
@property (nonatomic, copy) void (^viewSelectModel)(GNClassificationModel *model, NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
