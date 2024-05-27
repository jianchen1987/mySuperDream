//
//  TNSearchBaseViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSearchBaseViewModel.h"
#import "SACacheManager.h"
#import "SARspModel.h"
#import "TNGoodsDTO.h"
#import "TNSearchHistoryEmptyCollectionViewCell.h"
#import "TNSearchRankAndDiscoveryModel.h"
#import <HDKitCore/HDKitCore.h>

static NSString *const kTinhNowSearchHistoryKeys = @"com.superapp.tinhnow.search.history";


@interface TNSearchBaseViewModel ()
@property (nonatomic, strong) TNGoodsDTO *goodsDTO;
@end


@implementation TNSearchBaseViewModel
- (void)initHistoryData {
    NSArray<TNSearchHistoryModel *> *tempArray;
    NSArray<TNSearchHistoryModel *> *historyCache = [SACacheManager.shared objectForKey:kTinhNowSearchHistoryKeys];
    if (!historyCache) {
        tempArray = @[TNSearchHistoryEmptyModel.new];
    } else {
        tempArray = [NSArray arrayWithArray:historyCache];
    }

    SACollectionViewSectionModel *sectionModel = [[SACollectionViewSectionModel alloc] init];
    sectionModel.list = tempArray;
    [sectionModel hd_bindObject:kSearchHistory forKey:kSearchSectionType];
    [self.dataSource addObject:sectionModel];

    self.refreshFlag = !self.refreshFlag;
}

/// 获取搜索排行 和 搜索发现 数据
- (void)getSearchRankAndDiscoveryData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @HDWeakify(self);
        dispatch_semaphore_t _sema = dispatch_semaphore_create(1);

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self.goodsDTO searchFind:^(SARspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self processSearcFindData:rspModel];
            self.refreshFlag = !self.refreshFlag;
            dispatch_semaphore_signal(_sema);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            dispatch_semaphore_signal(_sema);
        }];

        HDLog(@"开始调用");
        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self.goodsDTO searchRank:^(SARspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self processSearcRankData:rspModel];
            self.refreshFlag = !self.refreshFlag;
            dispatch_semaphore_signal(_sema);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            dispatch_semaphore_signal(_sema);
        }];
    });
}

/// 对 搜索发现 的数据进行处理
- (void)processSearcFindData:(SARspModel *)rspModel {
    id data = rspModel.data;
    if ([data isKindOfClass:NSArray.class]) {
        NSArray *arr = data;
        if (arr.count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:TNSearchRankAndDiscoveryItemModel.class json:arr];
            for (int i = 0; i < tempArr.count; i++) {
                TNSearchRankAndDiscoveryItemModel *model = tempArr[i];
                //                model.value = [arr objectAtIndex:i];
                ///前面三个 给icon
                if (i == 0 || i == 1 || i == 2) {
                    model.imageName = @"tinhnow_search_find";
                    model.bgColor = HexColor(0xFF8818);
                    model.valueColor = HDAppTheme.TinhNowColor.cFFFFFF;
                } else {
                    model.bgColor = HexColor(0xF5F6FA);
                    model.imageName = @"";
                    model.valueColor = HDAppTheme.TinhNowColor.c5d667f;
                }
            }

            SACollectionViewSectionModel *sectionModel = SACollectionViewSectionModel.new;
            TNSearchRankAndDiscoveryModel *model = TNSearchRankAndDiscoveryModel.new;
            model.rspList = tempArr;
            sectionModel.list = @[model];
            [sectionModel hd_bindObject:kSearchFind forKey:kSearchSectionType];
            [self.dataSource addObject:sectionModel];
        }
    }
}

/// 对 搜索排行 的数据进行处理
- (void)processSearcRankData:(SARspModel *)rspModel {
    id data = rspModel.data;
    if ([data isKindOfClass:NSArray.class]) {
        NSArray *arr = data;
        if (arr.count > 0) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i = 0; i < arr.count; i++) {
                TNSearchRankAndDiscoveryItemModel *model = TNSearchRankAndDiscoveryItemModel.new;
                model.value = [arr objectAtIndex:i];
                model.imageName = [NSString stringWithFormat:@"tn_rank_%d", i];

                [tempArr addObject:model];
            }

            SACollectionViewSectionModel *sectionModel = SACollectionViewSectionModel.new;
            TNSearchRankAndDiscoveryModel *model = TNSearchRankAndDiscoveryModel.new;
            model.rspList = tempArr;
            sectionModel.list = @[model];
            [sectionModel hd_bindObject:kSearchRank forKey:kSearchSectionType];
            [self.dataSource addObject:sectionModel];
        }
    }
}

- (void)clearAllSearchHistory {
    // 删除缓存的搜索纪录
    [SACacheManager.shared removeObjectForKey:kTinhNowSearchHistoryKeys];
    for (SACollectionViewSectionModel *sectionModel in self.dataSource) {
        if ([[sectionModel hd_getBoundObjectForKey:kSearchSectionType] isEqualToString:kSearchHistory]) {
            sectionModel.list = @[TNSearchHistoryEmptyModel.new];
        }
    }
    self.refreshFlag = !self.refreshFlag;
}

- (void)saveSearchHistoryWithKeyWord:(NSString *)keyword {
    if (HDIsStringEmpty(keyword)) {
        return;
    }
    NSArray<TNSearchHistoryModel *> *historyCache = [SACacheManager.shared objectForKey:kTinhNowSearchHistoryKeys];

    if (!historyCache) {
        historyCache = @[];
    }

    NSMutableArray<TNSearchHistoryModel *> *historyKeywordsList = [NSMutableArray arrayWithArray:historyCache];
    // 去除重复当前
    NSArray<TNSearchHistoryModel *> *copiedArray = historyKeywordsList.mutableCopy;
    for (TNSearchHistoryModel *word in copiedArray) {
        if ([word.keyWord isEqualToString:keyword]) {
            [historyKeywordsList removeObjectAtIndex:[copiedArray indexOfObject:word]];
        }
    }
    // 生成新关键词模型
    TNSearchHistoryModel *model = TNSearchHistoryModel.new;
    model.keyWord = keyword;
    [historyKeywordsList insertObject:model atIndex:0];

    static NSUInteger maxHistoryRecordCount = 5;
    if (historyKeywordsList.count > maxHistoryRecordCount) {
        [historyKeywordsList removeObjectsInRange:NSMakeRange(maxHistoryRecordCount, historyKeywordsList.count - maxHistoryRecordCount)];
    }
    // 保存
    [SACacheManager.shared setObject:historyKeywordsList forKey:kTinhNowSearchHistoryKeys];
    for (SACollectionViewSectionModel *sectionModel in self.dataSource) {
        if ([[sectionModel hd_getBoundObjectForKey:kSearchSectionType] isEqualToString:kSearchHistory]) {
            sectionModel.list = [NSArray arrayWithArray:historyKeywordsList];
        }
    }
}

/** @lazy sortFilterModel */
- (TNSearchSortFilterModel *)searchSortFilterModel {
    if (!_searchSortFilterModel) {
        _searchSortFilterModel = [[TNSearchSortFilterModel alloc] init];
    }
    return _searchSortFilterModel;
}
- (TNGoodsDTO *)goodsDTO {
    if (!_goodsDTO) {
        _goodsDTO = [[TNGoodsDTO alloc] init];
    }
    return _goodsDTO;
}

- (NSMutableArray<SACollectionViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
