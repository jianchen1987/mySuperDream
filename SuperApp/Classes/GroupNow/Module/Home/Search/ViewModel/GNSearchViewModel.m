//
//  GNSearchViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSearchViewModel.h"
#import "SACacheManager.h"


@interface GNSearchViewModel ()
/// 网络请求
@property (nonatomic, strong) GNSearchDTO *searchDTO;
/// 搜索页码
@property (nonatomic, assign) NSInteger pageNum;
/// 推荐页码
@property (nonatomic, assign) NSInteger recomendPageNum;

@end


@implementation GNSearchViewModel

/// 搜索
- (void)getSearchData:(NSString *)keyword pageNum:(NSInteger)pageNum completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion {
    @HDWeakify(self)[self.searchDTO merchantSearchKeyword:keyword pageNum:pageNum success:^(GNStorePagingRspModel *_Nonnull rspModel) {
        @HDStrongify(self)[rspModel.list enumerateObjectsUsingBlock:^(GNStoreCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.keyWord = keyword;
        }];
        if (pageNum > 1) {
            [self.resultSection.rows addObjectsFromArray:rspModel.list ?: @[]];
        } else {
            self.resultSection.rows = [NSMutableArray arrayWithArray:rspModel.list ?: @[]];
        }
        if (self.resultSection.rows.count == 0) {
            if (pageNum == 1) {
                [self getRecommendDataMore:pageNum completion:^(GNStorePagingRspModel *_Nonnull rspModel1, BOOL error) {
                    [self.dataSource removeAllObjects];
                    [self.dataSource addObject:self.emptySetion];
                    [self.dataSource addObject:self.recommendSection];
                    !completion ?: completion(rspModel1, NO);
                }];
            } else {
                !completion ?: completion(rspModel, NO);
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:self.resultSection];
            !completion ?: completion(rspModel, NO);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, YES);
    }];
}

/// 为您推荐
- (void)getRecommendDataMore:(NSInteger)pageNum completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion {
    @HDWeakify(self)[self.searchDTO merchantRecommendedForYouPageNum:pageNum success:^(GNStorePagingRspModel *_Nonnull rspModel) {
        @HDStrongify(self) if (pageNum > 1) {
            [self.recommendSection.rows addObjectsFromArray:rspModel.list ?: @[]];
        }
        else {
            self.recommendSection.rows = [NSMutableArray arrayWithArray:rspModel.list ?: @[]];
        }
        !completion ?: completion(rspModel, NO);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, YES);
    }];
}

/// 历史记录本地存储逻辑
- (void)localSaveHistory:(id)model {
    GNCellModel *compareModel = nil;
    if ([model isKindOfClass:NSString.class]) {
        compareModel = GNCellModel.new;
        compareModel.title = model;
    } else if ([model isKindOfClass:GNCellModel.class]) {
        compareModel = (GNCellModel *)model;
    }
    if (![compareModel isKindOfClass:GNCellModel.class])
        return;
    if (!compareModel.title || !compareModel.title.length)
        return;
    NSArray *infaceArr = [SACacheManager.shared objectForKey:kCacheKeyGroupBuySearchHistory type:SACacheTypeDocumentPublic];
    NSMutableArray *saveMarr = [NSMutableArray arrayWithArray:infaceArr];
    if (infaceArr.count) {
        NSInteger index = NSNotFound;
        for (GNCellModel *sa in infaceArr) {
            if ([sa.title isEqualToString:compareModel.title]) {
                index = [infaceArr indexOfObject:sa];
                break;
            }
        }
        if (index == NSNotFound) {
            if (infaceArr.count >= 10) {
                [saveMarr removeObjectAtIndex:0];
            }
        } else {
            if (index < infaceArr.count) {
                [saveMarr removeObjectAtIndex:index];
            }
        }
    }
    if ([saveMarr indexOfObject:compareModel] == NSNotFound) {
        [saveMarr addObject:compareModel];
        [SACacheManager.shared setObject:[NSArray arrayWithArray:saveMarr] forKey:kCacheKeyGroupBuySearchHistory type:SACacheTypeDocumentPublic];
    }
    NSArray *arr = [self getLocalHistory];
    if (arr.count) {
        if ([_historySection.rows indexOfObject:self.emptyHistoryModel] != NSNotFound) {
            [_historySection.rows removeObject:self.emptyHistoryModel];
        }
        if ([_historySection.rows indexOfObject:self.historyModel] == NSNotFound) {
            [_historySection.rows addObject:self.historyModel];
        }
    }
    self.historyModel.tagArr = arr;
}

/// 历史记录清除
- (void)localClearHistory {
    [SACacheManager.shared removeObjectForKey:kCacheKeyGroupBuySearchHistory type:SACacheTypeDocumentPublic];
    self.historyModel.tagArr = @[];
    if ([self.historySection.rows indexOfObject:self.historyModel] != NSNotFound) {
        [self.historySection.rows removeObject:self.historyModel];
    }
}

/// 获取历史记录
- (NSArray<GNCellModel *> *)getLocalHistory {
    NSArray *arr = [SACacheManager.shared objectForKey:kCacheKeyGroupBuySearchHistory type:SACacheTypeDocumentPublic];
    return [[arr reverseObjectEnumerator] allObjects];
}

- (GNSectionModel *)historySection {
    if (!_historySection) {
        _historySection = addSection(^(GNSectionModel *_Nonnull sectionModel) {
            GNCellModel *historyModel = GNCellModel.new;
            historyModel.cellClass = GNSearchHistoryHeadCell.class;
            historyModel.title = GNLocalizedString(@"gn_search_history", @"历史搜索");
            historyModel.cellHeight = kRealHeight(40);
            [sectionModel.rows addObject:historyModel];
            [sectionModel.rows addObject:self.historyModel];
        });
    }
    if (_historySection && _historyModel) {
        _historyModel.tagArr = [self getLocalHistory];
        if (!_historyModel.tagArr || _historyModel.tagArr.count == 0) {
            if ([_historySection.rows indexOfObject:self.historyModel] != NSNotFound) {
                [_historySection.rows removeObject:self.historyModel];
            }
            if ([_historySection.rows indexOfObject:self.emptyHistoryModel] == NSNotFound) {
                [_historySection.rows addObject:self.emptyHistoryModel];
            }
        } else {
            if ([_historySection.rows indexOfObject:self.emptyHistoryModel] != NSNotFound) {
                [_historySection.rows removeObject:self.emptyHistoryModel];
            }
            if ([_historySection.rows indexOfObject:self.historyModel] == NSNotFound) {
                [_historySection.rows addObject:self.historyModel];
            }
        }
    }
    return _historySection;
}

- (GNTagViewCellModel *)historyModel {
    if (!_historyModel) {
        _historyModel = GNTagViewCellModel.new;
        _historyModel.cellClass = GNTagViewCell.class;
        _historyModel.history = YES;
        _historyModel.height = kRealHeight(500);
        _historyModel.lineHidden = YES;
        _historyModel.cornerRadius = kRealHeight(15);
        _historyModel.itemSizeH = kRealHeight(30);
        _historyModel.bgColor = UIColor.whiteColor;
        _historyModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    }
    return _historyModel;
}

- (GNSectionModel *)resultSection {
    if (!_resultSection) {
        _resultSection = GNSectionModel.new;
    }
    return _resultSection;
}

- (GNSectionModel *)emptySetion {
    if (!_emptySetion) {
        _emptySetion = GNSectionModel.new;
        GNCellModel *model = GNCellModel.new;
        model.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        model.cellClass = NSClassFromString(@"GNSearchNoDataCell");
        model.image = [UIImage imageNamed:@"gn_search_nodata"];
        model.title = GNLocalizedString(@"gn_search_recommend", @"当前无相关搜索\n推荐以下内容");
        [_emptySetion.rows addObject:model];
    }
    return _emptySetion;
}

- (GNCellModel *)emptyHistoryModel {
    if (!_emptyHistoryModel) {
        _emptyHistoryModel = GNCellModel.new;
        _emptyHistoryModel.cellClass = NSClassFromString(@"GNSearchNoDataCell");
        _emptyHistoryModel.title = GNLocalizedString(@"gn_history_nodata", @"暂无历史搜索");
        _emptyHistoryModel.lineHidden = YES;
        _emptyHistoryModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    }
    return _emptyHistoryModel;
}
- (GNSectionModel *)recommendSection {
    if (!_recommendSection) {
        _recommendSection = GNSectionModel.new;
        _recommendSection.headerModel.title = GNLocalizedString(@"gn_search_recommendFor", @"为您推荐");
        _recommendSection.headerModel.titleFont = [HDAppTheme.font gn_boldForSize:16];
        _recommendSection.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _recommendSection.headerHeight = kRealHeight(44);
    }
    return _recommendSection;
}

- (GNSearchDTO *)searchDTO {
    if (!_searchDTO) {
        _searchDTO = GNSearchDTO.new;
    }
    return _searchDTO;
}

- (NSMutableArray<GNSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

- (NSMutableArray<GNSectionModel *> *)historyDataSource {
    if (!_historyDataSource) {
        _historyDataSource = NSMutableArray.new;
        [_historyDataSource addObject:self.historySection];
    }
    return _historyDataSource;
}

@end
