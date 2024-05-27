//
//  TNSearchViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchViewModel.h"
#import "TNGoodsDTO.h"
#import "TNGoodsModel.h"
#import "TNQueryGoodsRspModel.h"


@interface TNSearchViewModel ()
/// dto
@property (nonatomic, strong) TNGoodsDTO *goodsDTO;
/// 历史搜索记录section
@property (nonatomic, strong) HDTableViewSectionModel *historySectionModel;

@end


@implementation TNSearchViewModel

- (void)requestNewData {
    if (HDIsStringEmpty(self.searchSortFilterModel.specialId)) {
        [self searchGoodsPageNo:1 pageSize:20 success:nil failure:nil];
    } else {
        [self querySpecialActivityNomalListPageNo:1 pageSize:20 hotType:self.specificActivityHotType success:nil
                                          failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                                              if (self.failGetNewDataCallback) {
                                                  self.failGetNewDataCallback();
                                              }
                                          }];
    }
}

- (void)loadMoreData {
    NSInteger pageNum = self.rspModel.pageNum;
    if (pageNum <= 0) {
        pageNum = 1;
    }
    if (HDIsStringEmpty(self.searchSortFilterModel.specialId)) {
        [self searchGoodsPageNo:++pageNum pageSize:20 success:nil failure:nil];
    } else {
        [self querySpecialActivityNomalListPageNo:++pageNum pageSize:20 hotType:self.specificActivityHotType success:nil failure:nil];
    }
}

- (void)searchGoodsPageNo:(NSUInteger)pageNo
                 pageSize:(NSUInteger)pageSize
                  success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                  failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.goodsDTO queryGoodsListWithPageNo:pageNo pageSize:pageSize filterModel:self.searchSortFilterModel success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.searchSortFilterModel.keyWord)) {
            [self saveSearchHistoryWithKeyWord:self.searchSortFilterModel.keyWord];
        }
        self.rspModel = rspModel;
        if (pageNo == 1) {
            self.searchResult = [NSMutableArray arrayWithArray:rspModel.list];
        } else {
            NSMutableArray<TNGoodsModel *> *cache = [NSMutableArray arrayWithArray:self.searchResult];
            [cache addObjectsFromArray:rspModel.list];
            self.searchResult = [NSMutableArray arrayWithArray:cache];
        }
        if (self.scopeType == TNSearchScopeTypeAllMall) {
            self.refreshFlag = !self.refreshFlag;
        } else {
            self.specificRefreshFlag = !self.specificRefreshFlag;
        }
        !successBlock ?: successBlock(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (pageNo == 1) {
            if (self.failGetNewDataCallback) {
                self.failGetNewDataCallback();
            }
        }
    }];
}

- (void)queryHotGoodsList {
    @HDWeakify(self);
    [self.goodsDTO queryHotGoodsListWithCategoryId:self.searchSortFilterModel.categoryId success:^(NSArray<TNGoodsModel *> *_Nonnull goods) {
        @HDStrongify(self);
        self.hotGoodsList = goods;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
- (void)querySpecialActivityHotListDataSuccess:(void (^)(TNQueryGoodsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self.goodsDTO querySpecailHotActivityListWithFilterModel:self.searchSortFilterModel success:successBlock failure:failureBlock];
}

- (void)querySpecialActivityNomalListPageNo:(NSUInteger)pageNo
                                   pageSize:(NSUInteger)pageSize
                                    hotType:(NSInteger)hotType
                                    success:(void (^)(TNQueryGoodsRspModel *_Nonnull))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.goodsDTO querySpecailActivityListWithPageNo:pageNo pageSize:pageSize hotType:hotType filterModel:self.searchSortFilterModel success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.rspModel = rspModel;
        if (pageNo == 1) {
            self.searchResult = [NSMutableArray arrayWithArray:rspModel.list];
        } else {
            NSMutableArray<TNGoodsModel *> *cache = [NSMutableArray arrayWithArray:self.searchResult];
            [cache addObjectsFromArray:rspModel.list];
            self.searchResult = [NSMutableArray arrayWithArray:cache];
        }
        if (self.scopeType == TNSearchScopeTypeAllMall) {
            self.refreshFlag = !self.refreshFlag;
        } else {
            self.specificRefreshFlag = !self.specificRefreshFlag;
        }
        !successBlock ?: successBlock(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

#pragma mark - lazy load
/** @lazy goodsDTO */
- (TNGoodsDTO *)goodsDTO {
    if (!_goodsDTO) {
        _goodsDTO = [[TNGoodsDTO alloc] init];
    }
    return _goodsDTO;
}

/** @lazy searchresult */
- (NSMutableArray<TNGoodsModel *> *)searchResult {
    if (!_searchResult) {
        _searchResult = [[NSMutableArray alloc] init];
    }
    return _searchResult;
}
/** @lazy eventProperty */
- (NSMutableDictionary *)eventProperty {
    if (!_eventProperty) {
        _eventProperty = [NSMutableDictionary dictionary];
    }
    return _eventProperty;
}
@end
