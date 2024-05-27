//
//  TNSearchBaseViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewSectionModel.h"
#import "TNSearchHistoryModel.h"
#import "TNSearchSortFilterModel.h"
#import "TNViewModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *kSearchSectionType = @"tn_search_section_type";
static NSString *kSearchHistory = @"tn_saerch_history";
static NSString *kSearchFind = @"tn_search_find";
static NSString *kSearchRank = @"tn_search_rank";


@interface TNSearchBaseViewModel : TNViewModel
/// 筛选模型
@property (nonatomic, strong) TNSearchSortFilterModel *searchSortFilterModel;
/// 搜索范围  默认全部商城
@property (nonatomic, assign) TNSearchScopeType scopeType;
/// 刷新
@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, strong) NSMutableArray<SACollectionViewSectionModel *> *dataSource;
/// 清空所有搜索历史
- (void)clearAllSearchHistory;
- (void)saveSearchHistoryWithKeyWord:(NSString *)keyword;

- (void)initHistoryData;
- (void)getSearchRankAndDiscoveryData;
@end

NS_ASSUME_NONNULL_END
