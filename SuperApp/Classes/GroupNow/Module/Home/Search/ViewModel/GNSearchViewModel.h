//
//  GNSearchViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSearchDTO.h"
#import "GNSearchHistoryHeadCell.h"
#import "GNTagViewCell.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNSearchViewModel : GNViewModel
/// 历史搜索Section
@property (nonatomic, strong) GNSectionModel *historySection;
/// 历史记录model
@property (nonatomic, strong) GNTagViewCellModel *historyModel;
/// 历史记录为空model
@property (nonatomic, strong) GNCellModel *emptyHistoryModel;
/// 搜索无结果Section
@property (nonatomic, strong) GNSectionModel *emptySetion;
/// 搜索结果Section
@property (nonatomic, strong) GNSectionModel *resultSection;
/// 推荐Section
@property (nonatomic, strong) GNSectionModel *recommendSection;
/// dataSource
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *dataSource;
/// historyDataSource
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *historyDataSource;

/// 搜索
- (void)getSearchData:(NSString *)keyword pageNum:(NSInteger)pageNum completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion;

/// 为您推荐
- (void)getRecommendDataMore:(NSInteger)pageNum completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion;

/// 历史记录本地存储逻辑
- (void)localSaveHistory:(id)model;

/// 历史记录清除
- (void)localClearHistory;

/// 获取历史记录
- (NSArray<GNCellModel *> *)getLocalHistory;

@end

NS_ASSUME_NONNULL_END
