//
//  GNHomeCustomViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNHomeCustomViewModel.h"


@interface GNHomeCustomViewModel ()
///网络请求
@property (nonatomic, strong) GNHomeDTO *homeDTO;

@end


@implementation GNHomeCustomViewModel

- (void)getColumnStoreDataCode:(nullable NSString *)columnCode
                    columnType:(nullable GNHomeColumnType)columnType
                       pageNum:(NSInteger)pageNum
                    completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion {
    [self.homeDTO getHomeColumnStoreListWithpageNum:pageNum ?: 1 columnCode:columnCode columnType:columnType filter:self.filterModel success:^(GNStorePagingRspModel *_Nonnull rspModel) {
        !completion ?: completion(rspModel, NO);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, YES);
    }];
}

- (void)getColumnArticleDataCode:(nullable NSString *)columnCode
                      columnType:(nullable GNHomeColumnType)columnType
                         pageNum:(NSInteger)pageNum
                      completion:(nullable void (^)(GNArticlePagingRspModel *rspModel, BOOL error))completion {
    [self.homeDTO getHomeColumnArticleListWithpageNum:pageNum columnCode:columnCode columnType:columnType filter:self.filterModel success:^(GNArticlePagingRspModel *_Nonnull rspModel) {
        !completion ?: completion(rspModel, NO);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil, YES);
    }];
}

- (void)getClassificationStoreDataCode:(nullable NSString *)classificationCode
                            parentCode:(nullable NSString *)parentCode
                               pageNum:(NSInteger)pageNum
                            completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion {
    [self.homeDTO getHomeClassificationStoreListWithPageNum:pageNum parentCode:parentCode classificationCode:classificationCode filter:self.filterModel
        success:^(GNStorePagingRspModel *_Nonnull rspModel) {
            !completion ?: completion(rspModel, NO);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !completion ?: completion(nil, YES);
        }];
}

- (void)getClassificatioProductDataCode:(nullable NSString *)classificationCode
                             parentCode:(nullable NSString *)parentCode
                                pageNum:(NSInteger)pageNum
                             completion:(nullable void (^)(GNProductPagingRspModel *rspModel, BOOL error))completion {
    [self.homeDTO getHomeClassificationProductListWithPageNum:pageNum parentCode:parentCode classificationCode:classificationCode filter:self.filterModel
        success:^(GNProductPagingRspModel *_Nonnull rspModel) {
            !completion ?: completion(rspModel, NO);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !completion ?: completion(nil, YES);
        }];
}

- (GNFilterModel *)filterModel {
    if (!_filterModel) {
        _filterModel = GNFilterModel.new;
    }
    return _filterModel;
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

- (NSMutableArray<GNStoreCellModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

@end
