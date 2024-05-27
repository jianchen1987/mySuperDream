//
//  TNMicroShopViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopViewModel.h"
#import "TNFirstLevelCategoryModel.h"
#import "TNGlobalData.h"
#import "TNMicroShopDTO.h"
#import "TNMicroShopDetailInfoModel.h"
#import "TNMicroShopProductSkeletonCell.h"
#import "TNSellerProductModel.h"
#import "TNSellerProductRspModel.h"
#import "TNSellerSearchDTO.h"


@interface TNMicroShopViewModel ()
@property (strong, nonatomic) TNMicroShopDTO *dto;
@property (strong, nonatomic) TNSellerSearchDTO *searchDto;
@end


@implementation TNMicroShopViewModel
- (void)getMyMicroShopInfoComplete:(void (^)(void))complete {
    @HDWeakify(self);
    [self.dto queryMyMicroShopInfoDataSuccess:^(TNSeller *_Nonnull info) {
        !complete ?: complete();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.failGetNewDataCallback ?: self.failGetNewDataCallback();
    }];
}
- (void)getMicroShopCategoryData {
    @HDWeakify(self); //
    [self.dto queryMicroShopCategoryWithSupplierId:[TNGlobalData shared].seller.supplierId success:^(NSArray<TNFirstLevelCategoryModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self.categoryList removeAllObjects];
        [self.categoryList addObjectsFromArray:list];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){
        //            @HDStrongify(self);
        //        [self.categoryList removeAllObjects];
        //        self.refreshFlag = !self.refreshFlag;
    }];
}
- (void)getSellerPricePolicyData {
    [self.dto querySellPricePolicyWithSupplierId:[TNGlobalData shared].seller.supplierId success:^(TNMicroShopPricePolicyModel *_Nonnull policyModel) {
        [TNGlobalData shared].seller.pricePolicyModel = policyModel;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
- (void)getMicroShopInfoBySupplierId:(NSString *)supplierId complete:(nonnull void (^)(TNMicroShopDetailInfoModel *, BOOL))complete {
    [self.dto queryMicroShopInfoDataBySupplierId:supplierId success:^(TNMicroShopDetailInfoModel *_Nonnull info) {
        !complete ?: complete(info, YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !complete ?: complete(nil, NO);
    }];
}
#pragma mark -获取微店商品数据
- (void)getProductsNewData:(BOOL)isNeedShowSkeleton {
    self.currentPage = 1;
    if (isNeedShowSkeleton) {
        [self addProductSkeletonCellMode];
    }
    [self queryProducts:NO];
}

- (void)loadProductMoreData {
    self.currentPage += 1;
    [self queryProducts:YES];
}

- (void)queryProducts:(BOOL)isLoadMore {
    @HDWeakify(self);
    [self.searchDto queryMicroShopProductsWithPageNo:self.currentPage pageSize:20 filterModel:self.searchSortFilterModel success:^(TNSellerProductRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (!isLoadMore) {
            [self.productList removeAllObjects];
            [self.productList addObjectsFromArray:rspModel.list];
        } else {
            [self.productList addObjectsFromArray:rspModel.list];
        }
        self.currentPage = rspModel.pageNum;
        self.hasNextPage = rspModel.hasNextPage;
        self.productsRefreshFlag = !self.productsRefreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.productFailGetNewDataCallback ?: self.productFailGetNewDataCallback();
    }];
}

- (void)addProductSkeletonCellMode {
    NSMutableArray *skeleArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNMicroShopProductSkeletonCellModel *model = TNMicroShopProductSkeletonCellModel.new;
        [skeleArray addObject:model];
    }
    [self.productList removeAllObjects];
    [self.productList addObjectsFromArray:skeleArray];
    self.productsRefreshFlag = !self.productsRefreshFlag;
}

- (void)batchDeleteProductsByProductArr:(NSArray<TNSellerProductModel *> *)productArr complete:(void (^)(void))complete {
    [self.view showloading];
    NSMutableArray *array = [NSMutableArray array];
    for (TNSellerProductModel *model in productArr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"supplierId"] = [TNGlobalData shared].seller.supplierId;
        dict[@"productId"] = model.productId;
        [array addObject:dict];
    }
    @HDWeakify(self);
    [self.dto cancelProductSaleWithParamsArr:array success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        !complete ?: complete();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

//默认的全部分类数据
- (TNFirstLevelCategoryModel *)getDefaultCategoryModel {
    TNFirstLevelCategoryModel *model = [[TNFirstLevelCategoryModel alloc] init];
    model.name = TNLocalizedString(@"tn_store_all_product", @"全部商品");
    model.isSelected = YES;
    return model;
}
/** @lazy dto */
- (TNMicroShopDTO *)dto {
    if (!_dto) {
        _dto = [[TNMicroShopDTO alloc] init];
    }
    return _dto;
}
/** @lazy categoryList */
- (NSMutableArray<TNFirstLevelCategoryModel *> *)categoryList {
    if (!_categoryList) {
        _categoryList = [NSMutableArray array];
    }
    return _categoryList;
}
/** @lazy searchDto */
- (TNSellerSearchDTO *)searchDto {
    if (!_searchDto) {
        _searchDto = [[TNSellerSearchDTO alloc] init];
    }
    return _searchDto;
}
/** @lazy searchSortFilterModel */
- (TNSearchSortFilterModel *)searchSortFilterModel {
    if (!_searchSortFilterModel) {
        _searchSortFilterModel = [[TNSearchSortFilterModel alloc] init];
        _searchSortFilterModel.searchType = TNMicroShopProductSearchTypeSeller;
        _searchSortFilterModel.sp = [TNGlobalData shared].seller.supplierId;
    }
    return _searchSortFilterModel;
}
/** @lazy productList */
- (NSMutableArray *)productList {
    if (!_productList) {
        _productList = [NSMutableArray array];
    }
    return _productList;
}
@end
