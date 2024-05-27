//
//  TNStoreViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNStoreViewModel.h"
#import "SANoDataCellModel.h"
#import "TNCategoryListCell.h"
#import "TNCategoryListSkeletonCell.h"
#import "TNEventTracking.h"
#import "TNGlobalData.h"
#import "TNGoodsDTO.h"
#import "TNMicroShopDTO.h"
#import "TNMicroShopProductSkeletonCell.h"
#import "TNSellerProductRspModel.h"
#import "TNStoreDTO.h"
#import "TNStoreInfoSkeletonCell.h"
#import "TNStoreSceneRspModel.h"


@interface TNStoreViewModel ()
/// storeDTO
@property (nonatomic, strong) TNStoreDTO *storeDTO;
/// 微店dto
@property (strong, nonatomic) TNMicroShopDTO *microShopDto;
/// storeInfoSection
@property (nonatomic, strong) HDTableViewSectionModel *storeInfoSection;
/// categorySection
@property (nonatomic, strong) HDTableViewSectionModel *categorySection;
/// sceneListSection
@property (nonatomic, strong) HDTableViewSectionModel *sceneListSection;
@end


@implementation TNStoreViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.isShowAllProductList = YES;
    }
    return self;
}

/// 获取门店信息
- (void)requestStoreInfoCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.storeDTO queryStoreInfoWithStoreNo:self.storeNo operatorNo:SAUser.shared.operatorNo success:^(TNStoreInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.storeInfo = rspModel;
        self.storeInfo.storeViewShowType = self.storeViewShowType;
        self.storeInfoSection.list = @[rspModel];
        if ([rspModel.storeType isEqualToString:TNStoreTypeOverseasShopping]) {
            self.trackPrefixName = TNTrackEventPrefixNameOverseas;
        } else if ([rspModel.storeType isEqualToString:TNStoreTypePlatfromSelf]) {
            self.trackPrefixName = TNTrackEventPrefixNameFastConsume;
        } else {
            self.trackPrefixName = TNTrackEventPrefixNameOther;
        }
        self.storeInfo.trackPrefixName = self.trackPrefixName;
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self.failGetStoreInfoDataCallBack) {
            self.failGetStoreInfoDataCallBack();
        }
    }];
}

/// 获取微店信息
- (void)requestMircoShopInfoCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.microShopDto queryMicroShopInfoDataBySupplierId:self.sp success:^(TNMicroShopDetailInfoModel *_Nonnull info) {
        @HDStrongify(self);
        self.microShopInfo = info;
        self.storeInfoSection.list = @[info];
        self.trackPrefixName = @"【电商-微店】";
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self.failGetStoreInfoDataCallBack) {
            self.failGetStoreInfoDataCallBack();
        }
    }];
}
//获取分类数据
- (void)requestStoreRecommendCategoryCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.storeDTO queryStoreRecommendCategoryWithStoreNo:self.storeNo success:^(NSArray<TNCategoryModel *> *_Nonnull list) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        self.categoryList = list;
        NSMutableArray *categorys = [NSMutableArray array];
        [categorys addObject:[self getDefaultCategoryModel]];
        if (!HDIsArrayEmpty(list)) {
            [categorys addObjectsFromArray:list];
        }
        TNCategoryListCellModel *cellModel = [[TNCategoryListCellModel alloc] init];
        cellModel.list = categorys;
        cellModel.displayType = TNCategoryListCellDisplayTypeStore;
        self.categorySection.list = @[cellModel];
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self == nil) {
            return;
        }
        NSMutableArray *categorys = [NSMutableArray array];
        [categorys addObject:[self getDefaultCategoryModel]];
        TNCategoryListCellModel *cellModel = [[TNCategoryListCellModel alloc] init];
        cellModel.list = categorys;
        cellModel.displayType = TNCategoryListCellDisplayTypeStore;
        self.categorySection.list = @[cellModel];
        !completion ?: completion();
    }];
}
- (void)requestStoreAllCategoryDataSuccess:(void (^)(NSArray<TNFirstLevelCategoryModel *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self.storeDTO queryStoreAllCategoryWithStoreNo:self.storeNo success:successBlock failure:failureBlock];
}
- (void)requestNewStoreSceneData {
    [self.view showloading];
    [self loadStoreScenePageNo:1];
}
/// 获取店铺实景信息
- (void)requestMoreStoreSceneData {
    [self loadStoreScenePageNo:++self.rspModel.pageNum];
}
- (void)loadStoreScenePageNo:(NSUInteger)pageNo {
    @HDWeakify(self);
    [self.storeDTO queryStoreRealSceneWithStoreNo:self.storeNo pageNum:pageNo success:^(TNStoreSceneRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.rspModel = rspModel;
        self.hasLoadSceneData = YES;
        if (pageNo == 1) {
            self.sceneList = [NSMutableArray arrayWithArray:rspModel.content];
        } else {
            NSMutableArray<TNStoreSceneModel *> *cache = [NSMutableArray arrayWithArray:self.sceneList];
            [cache addObjectsFromArray:rspModel.content];
            self.sceneList = [NSMutableArray arrayWithArray:cache];
        }
        if (!HDIsArrayEmpty(self.sceneList)) {
            self.sceneListSection.list = [NSArray arrayWithArray:self.sceneList];
        } else {
            SANoDataCellModel *cellModel = SANoDataCellModel.new;
            cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
            self.sceneListSection.list = @[cellModel];
        }
        self.sceneRefreshTag = !self.sceneRefreshTag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
//- (void)addStoreToFavoriteWithStoreNo:(NSString *)storeNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
//    [self.storeDTO addStoreFavoritesWithStoreNo:storeNo success:successBlock failure:failureBlock];
//}
//
///// 移除收藏
//- (void)removeStoreFromFavoriteWithStoreNo:(NSString *)storeNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
//    [self.storeDTO cancelStoreFavoriteWithStoreNo:storeNo success:successBlock failure:failureBlock];
//}

- (void)prepareMicroShopCategoryDataByRspModel:(TNSellerProductRspModel *)rspModel {
    self.categoryList = rspModel.aggs.categorys;
    NSMutableArray *categorys = [NSMutableArray array];
    [categorys addObject:[self getDefaultCategoryModel]];
    if (!HDIsArrayEmpty(self.categoryList)) {
        [categorys addObjectsFromArray:self.categoryList];
    }
    TNCategoryListCellModel *cellModel = [[TNCategoryListCellModel alloc] init];
    cellModel.list = categorys;
    cellModel.displayType = TNCategoryListCellDisplayTypeStore;
    self.categorySection.list = @[cellModel];
}

///上送店铺滚动商品埋点
- (void)trackScrollProductsExposure {
    if ([self.dataSource containsObject:self.goodsListSection] && !HDIsArrayEmpty(self.goodsListSection.list)) {
        [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:@{@"storeId": self.storeNo, @"type": @"3"}];
    }
}
- (TNStoreViewShowType)storeViewShowType {
    TNStoreViewShowType showType = TNStoreViewShowTypeNormal;
    if (HDIsStringNotEmpty(self.sp) && self.isFromProductCenter == YES) {
        showType = TNStoreViewShowTypeSellerToAdd;
    } else if (HDIsStringNotEmpty(self.sp) && self.isFromProductCenter == NO) {
        showType = TNStoreViewShowTypeMicroShop;
    } else {
        //普通情况下  如果用户是卖家  进入的全部是选品店铺
        if ([TNGlobalData shared].seller.isSeller) {
            showType = TNStoreViewShowTypeSellerToAdd;
        }
    }
    return showType;
}
- (NSArray<HDTableViewSectionModel *> *)dataSource {
    if (self.storeViewShowType == TNStoreViewShowTypeMicroShop) {
        return @[self.storeInfoSection, self.categorySection, self.goodsListSection];
    } else {
        if (self.isShowAllProductList) {
            return @[self.storeInfoSection, self.categorySection, self.goodsListSection];
        } else {
            return @[self.storeInfoSection, self.sceneListSection];
        }
    }
}
- (TNCategoryModel *)getDefaultCategoryModel {
    TNCategoryModel *allModel = [[TNCategoryModel alloc] init];
    allModel.name = TNLocalizedString(@"tn_title_all", @"全部");
    allModel.unSelectLogoImage = [UIImage imageNamed:@"tn_all_unselect"];
    allModel.selectLogoImage = [UIImage imageNamed:@"tn_all_select"];
    allModel.isSelected = true;
    return allModel;
}

/** @lazy storeDTO */
- (TNStoreDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = [[TNStoreDTO alloc] init];
    }
    return _storeDTO;
}
- (NSMutableArray<TNStoreSceneModel *> *)sceneList {
    if (!_sceneList) {
        _sceneList = [NSMutableArray array];
    }
    return _sceneList;
}
/** @lazy microShopDto */
- (TNMicroShopDTO *)microShopDto {
    if (!_microShopDto) {
        _microShopDto = [[TNMicroShopDTO alloc] init];
    }
    return _microShopDto;
}
/** @lazy storeinfoSection */
- (HDTableViewSectionModel *)storeInfoSection {
    if (!_storeInfoSection) {
        _storeInfoSection = [[HDTableViewSectionModel alloc] init];
        TNStoreInfoSkeletonCellModel *model = [[TNStoreInfoSkeletonCellModel alloc] init];
        _storeInfoSection.list = @[model];
    }
    return _storeInfoSection;
}

/** @lazy goodslistSection */
- (HDTableViewSectionModel *)goodsListSection {
    if (!_goodsListSection) {
        _goodsListSection = [[HDTableViewSectionModel alloc] init];
        _goodsListSection.list = @[];
        _goodsListSection.headerModel = [[HDTableHeaderFootViewModel alloc] init];
    }
    return _goodsListSection;
}
- (HDTableViewSectionModel *)categorySection {
    if (!_categorySection) {
        _categorySection = [[HDTableViewSectionModel alloc] init];
        TNCategoryListSkeletonCellModel *model = [[TNCategoryListSkeletonCellModel alloc] init];
        _categorySection.list = @[model];
    }
    return _categorySection;
}
- (HDTableViewSectionModel *)sceneListSection {
    if (!_sceneListSection) {
        _sceneListSection = [[HDTableViewSectionModel alloc] init];
        _sceneListSection.list = @[];
    }
    return _sceneListSection;
}
@end
