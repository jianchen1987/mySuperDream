//
//  SAHomeViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeViewModel.h"
#import "SAAppConfigDTO.h"
#import "SAAppStartUpConfig.h"
#import "SACacheManager.h"
#import "SAKingKongAreaItemConfig.h"
#import "SANoDataCellModel.h"
#import "SANotificationConst.h"
#import "SATableViewViewMoreView.h"
#import "SAWindowDTO.h"
#import "SAWindowItemModel.h"
#import "SAWindowModel.h"
#import "SAWindowRspModel.h"
#import "SAWriteDateReadableModel.h"
#import "TNActivityCardRspModel.h"
#import "TNCarouselViewWrapperCellModel.h"
#import "TNGoodsModel.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNHomeDTO.h"
#import "TNKingKongAreaViewWrapperCell.h"
#import "TNQueryGoodsRspModel.h"
#import "TNScrollContentModel.h"
#import "TNScrollContentRspModel.h"
#import <NotificationCenter/NotificationCenter.h>


@interface TNHomeViewModel ()
/// 金刚区功能
@property (nonatomic, strong) HDTableViewSectionModel *appsSectionModel;
/// 活动
@property (nonatomic, strong) HDTableViewSectionModel *carouselSectionModel;
/// 滚动文字
@property (nonatomic, strong) HDTableViewSectionModel *scrollContentSectionModel;
/// 精选栏目
@property (nonatomic, strong) HDTableViewSectionModel *choicenessSectionModel;
/// 中部广告
@property (nonatomic, strong) HDTableViewSectionModel *activitySectionModel;
/// 卡片活动
@property (nonatomic, strong) HDTableViewSectionModel *activityCardSectionModel;
/// 推荐栏目
@property (nonatomic, strong) HDTableViewSectionModel *recommendSectionModel;
/// 推荐 数据源
@property (nonatomic, strong) NSMutableArray<TNGoodsModel *> *recommendDataSource;
/// 获取广告 DTO
@property (nonatomic, strong) SAWindowDTO *getAdvertisementDTO;
/// 首页 DTO
@property (nonatomic, strong) TNHomeDTO *homeDTO;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 默认数据源
@property (nonatomic, copy) NSMutableArray<HDTableViewSectionModel *> *dataSource;

/// 是否有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// App 配置 VM
@property (nonatomic, strong) SAAppConfigDTO *appConfigDTO;
@end


@implementation TNHomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hideBackButton = YES;
        self.currentPageNo = 1;
        [self registerNotifications];
    }
    return self;
}

- (void)dealloc {
    [self unRegisterNotifications];
}

- (void)registerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(configKingKongAreaWhenReceiveNotifications) name:kNotificationNameSuccessGetTinhNowAppHomeDynamicFunctionList object:nil];
}
- (void)unRegisterNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameSuccessGetTinhNowAppHomeDynamicFunctionList object:nil];
}

- (void)loadOfflineData {
    // banner广告数据
    SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyTinhNowHomeWindowsList type:SACacheTypeCachePublic relyLanguage:YES];
    NSArray<SAWindowModel *> *windows = [NSArray yy_modelArrayWithClass:SAWindowModel.class json:cacheModel.storeObj];
    if (windows && windows.count > 0) {
        [self configWindosWithWindowList:windows];
    }
    // 滚动文字数据
    cacheModel = [SACacheManager.shared objectForKey:kCacheKeyTinhNowHomeScrollContentText type:SACacheTypeCachePublic relyLanguage:YES];
    TNScrollContentRspModel *scrollRspModel = [TNScrollContentRspModel yy_modelWithJSON:cacheModel.storeObj];
    if (!HDIsObjectNil(scrollRspModel)) {
        [self configScrollTextDataWithRspModel:scrollRspModel completion:nil];
    }
    //金刚区
    [self configKingKongAreaCompletion:nil];

    // 活动卡片数据
    cacheModel = [SACacheManager.shared objectForKey:kCacheKeyTinhNowHomeActivityCardData type:SACacheTypeCachePublic relyLanguage:YES];
    TNActivityCardRspModel *cardRspModel = [TNActivityCardRspModel yy_modelWithJSON:cacheModel.storeObj];
    if (!HDIsObjectNil(cardRspModel)) {
        [self configActivityCardWithRspModel:cardRspModel completion:nil];
    }

    //    //推荐列表数据
    //    cacheModel = [SACacheManager.shared objectForKey:kCacheKeyTinhNowHomeRecommendGoodsData
    //                                                type:SACacheTypeCachePublic
    //                                        relyLanguage:YES];
    //    TNQueryGoodsRspModel *goodsRspModel = [TNQueryGoodsRspModel yy_modelWithJSON:cacheModel.storeObj];
    //    if (!HDIsObjectNil(goodsRspModel)) {
    //        [self configChoicenessDataWithRspModel:goodsRspModel completion:nil];
    //    }
    //如果没有商品数据 加载骨架

    [self addChoicenessSectionSkeletonCellModel];

    if (HDIsArrayEmpty(self.recommendDataSource)) {
        [self addRecommendSectionSkeletonCellModel];
    }

    self.refreshFlag = !self.refreshFlag;
}

- (void)hd_getNewData {
    @HDWeakify(self);
    dispatch_group_enter(self.taskGroup);
    [self requestAdvertisementCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self requestActivityCardDataCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self requestScrollTextCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self configKingKongAreaCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self requestKingKongAreaUseCache:NO completion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self requestNewChoicenessDataCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self requestNewRecommendDataCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
    });
}
///请求首页分类数据
- (void)requestHomeCategoryDataCompletion:(void (^)(NSArray<TNHomeCategoryModel *> *_Nonnull))completion {
    [self.homeDTO queryProductCategoryWithScene:TNProductCategorySceneAll Success:^(NSArray<TNHomeCategoryModel *> *_Nonnull list) {
        if (!HDIsArrayEmpty(list)) {
            !completion ?: completion(list);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
/// 请求广告
- (void)requestAdvertisementCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.getAdvertisementDTO getWindowWithPage:SAPagePositionTinNowHomePage location:SAWindowLocationAll clientType:SAClientTypeTinhNow province:nil district:nil latitude:nil longitude:nil
        success:^(SAWindowRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self configWindosWithWindowList:rspModel.list];
            !completion ?: completion();
            [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:rspModel.list] forKey:kCacheKeyTinhNowHomeWindowsList type:SACacheTypeCachePublic relyLanguage:YES];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !completion ?: completion();
        }];
}

- (void)configWindosWithWindowList:(NSArray<SAWindowModel *> *)list {
    self.activitySectionModel.list = @[];
    self.carouselSectionModel.list = @[];
    if (list.count > 0) {
        for (SAWindowModel *window in list) {
            if (window.location == SAWindowLocationTinhNowPromotion) {
                if (window.bannerList.count > 0) {
                    TNCarouselViewWrapperCellModel *model = [TNCarouselViewWrapperCellModel modelWithType:TNCarouselViewWrapperCellTypeActivity list:window.bannerList];
                    model.cellHeight = (kScreenWidth - kRealWidth(20)) * (80 / 345.0);
                    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), 15, 0, 15);
                    self.activitySectionModel.list = @[model];
                } else {
                }
            } else if (window.location == SAWindowLocationTinhNowFocusBanner) {
                if (window.bannerList.count > 0) {
                    TNCarouselViewWrapperCellModel *model = [TNCarouselViewWrapperCellModel modelWithType:TNCarouselViewWrapperCellTypeAdvertisement list:window.bannerList];
                    model.cellHeight = (kScreenWidth - kRealWidth(20)) * (150 / 375.0);
                    model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    self.carouselSectionModel.list = @[model];
                }
            }
        }
    }
}

/// 请求轮播文字
- (void)requestScrollTextCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.homeDTO queryHomeScrollTextSuccess:^(TNScrollContentRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self configScrollTextDataWithRspModel:rspModel completion:^{
            !completion ?: completion();
        }];
        //缓存滚动文字数据
        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:rspModel] forKey:kCacheKeyTinhNowHomeScrollContentText type:SACacheTypeCachePublic relyLanguage:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}
- (void)configScrollTextDataWithRspModel:(TNScrollContentRspModel *)rspModel completion:(void (^)(void))completion {
    if (!HDIsArrayEmpty(rspModel.list)) {
        self.scrollContentSectionModel.list = @[rspModel];
    } else {
        self.scrollContentSectionModel.list = @[];
    }
    !completion ?: completion();
}
#pragma mark - 请求活动卡片数据
- (void)requestActivityCardDataCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.homeDTO queryHomeActivityCardSuccess:^(TNActivityCardRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self configActivityCardWithRspModel:rspModel completion:^{
            !completion ?: completion();
        }];
        //缓存活动卡片数据
        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:rspModel] forKey:kCacheKeyTinhNowHomeActivityCardData type:SACacheTypeCachePublic relyLanguage:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}
- (void)configActivityCardWithRspModel:(TNActivityCardRspModel *)rspModel completion:(void (^)(void))completion {
    //异步处理数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *sortArr = [NSMutableArray arrayWithArray:rspModel.list];
        [sortArr sortUsingComparator:^NSComparisonResult(TNActivityCardModel *obj1, TNActivityCardModel *obj2) {
            return obj1.sort > obj2.sort;
        }];
        NSArray *filterArr = [sortArr hd_filterWithBlock:^BOOL(TNActivityCardModel *item) {
            return item.cardStyle == TNActivityCardStyleText || item.cardStyle == TNActivityCardStyleBanner || item.cardStyle == TNActivityCardStyleScorllItem
                   || item.cardStyle == TNActivityCardStyleSixItem || item.cardStyle == TNActivityCardStyleMultipleBanners || item.cardStyle == TNActivityCardStyleSquareScorllItem;
        }];
        if (!HDIsArrayEmpty(filterArr)) {
            for (int i = 0; i < filterArr.count; i++) {
                TNActivityCardModel *model = filterArr[i];
                model.scene = TNActivityCardSceneIndex;
            }
        }
        rspModel.list = filterArr;
        self.activityCardSectionModel.list = @[rspModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion();
        });
    });
}
- (void)configKingKongAreaWhenReceiveNotifications {
    @HDWeakify(self);
    [self configKingKongAreaCompletion:^{
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
    }];
}
- (void)requestKingKongAreaUseCache:(BOOL)useCache completion:(void (^)(void))completion {
    NSArray<SAKingKongAreaItemConfig *> *list = [SACacheManager.shared objectForKey:kCacheKeyTinhNowAppHomeDynamicFunctionList type:SACacheTypeDocumentPublic relyLanguage:YES];
    if (HDIsArrayEmpty(list) || !useCache) {
        @HDWeakify(self);
        [self.appConfigDTO queryKingKongAreaConfigListWithType:SAClientTypeTinhNow success:^(NSArray<SAKingKongAreaItemConfig *> *_Nonnull list) {
            @HDStrongify(self);
            [SACacheManager.shared setObject:list forKey:kCacheKeyTinhNowAppHomeDynamicFunctionList type:SACacheTypeDocumentPublic relyLanguage:YES];

            [self configKingKongAreaCompletion:^{
                !completion ?: completion();
            }];
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            !completion ?: completion();
        }];
    } else {
        [self configKingKongAreaCompletion:^{
            !completion ?: completion();
        }];
    }
}
- (void)configKingKongAreaCompletion:(void (^)(void))completion {
    NSArray<SAKingKongAreaItemConfig *> *list = [SACacheManager.shared objectForKey:kCacheKeyTinhNowAppHomeDynamicFunctionList type:SACacheTypeDocumentPublic relyLanguage:YES];
    // 过滤不能打开的入口
    list = [list filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SAKingKongAreaItemConfig *_Nullable obj, NSDictionary<NSString *, id> *_Nullable bindings) {
                     return [SAWindowManager canOpenURL:obj.url];
                 }]];
    if (list && list.count > 0) {
        TNKingKongAreaViewWrapperCellModel *appsCellModel = TNKingKongAreaViewWrapperCellModel.new;
        self.appsSectionModel.list = @[appsCellModel];
    } else {
        self.appsSectionModel.list = @[];
    }
    if (completion) {
        completion();
    }
}

- (void)requestNewChoicenessDataCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.homeDTO queryChoicenessInfoWithPageSize:20 pageNum:1 success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (rspModel.list.count) {
            if (![self.dataSource containsObject:self.choicenessSectionModel]) {
                NSInteger belowIndex = [self.dataSource indexOfObject:self.recommendSectionModel];
                [self.dataSource insertObject:self.choicenessSectionModel atIndex:belowIndex - 1];
            }
            self.choicenessSectionModel.list = rspModel.list;
        } else {
            [self.dataSource removeObject:self.choicenessSectionModel];
        }
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.dataSource removeObject:self.choicenessSectionModel];
        !completion ?: completion();
    }];
}

- (void)requestNewRecommendDataCompletion:(void (^)(void))completion {
    self.currentPageNo = 1;
    [self getRecommendDataWithPageNum:self.currentPageNo completion:^{
        !completion ?: completion();
    }];
}
- (void)loadMoreRecommendData {
    self.currentPageNo += 1;
    @HDWeakify(self);
    [self getRecommendDataWithPageNum:self.currentPageNo completion:^{
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
    }];
}

- (void)getRecommendDataWithPageNum:(NSUInteger)pageNum completion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.homeDTO queryRecommendListWithPageSize:20 pageNum:pageNum success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self configRecommendDataWithRspModel:rspModel completion:^{
            !completion ?: completion();
        }];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (pageNum == 1 && HDIsArrayEmpty(self.recommendDataSource)) {
            self.dataSource = nil;
            !self.networkFailBlock ?: self.networkFailBlock();
        } else {
            !self.failedLoadMoreDataBlock ?: self.failedLoadMoreDataBlock();
        }
        !completion ?: completion();
    }];
}

- (void)configRecommendDataWithRspModel:(TNQueryGoodsRspModel *)rspModel completion:(void (^)(void))completion {
    NSArray<TNGoodsModel *> *list = rspModel.list;
    if (self.currentPageNo == 1) {
        [self.recommendDataSource removeAllObjects];
        if (list.count) {
            [self.recommendDataSource addObjectsFromArray:list];
        }
    } else {
        if (list.count) {
            [self.recommendDataSource addObjectsFromArray:list];
        }
    }
    // 修正 number
    self.currentPageNo = rspModel.pageNum;
    self.hasNextPage = rspModel.hasNextPage;
    if (!HDIsArrayEmpty(self.recommendDataSource)) {
        self.recommendSectionModel.list = self.recommendDataSource;
        self.recommendSectionModel.headerModel.tag = TNHomeGoodCellIdentity;
    } else {
        SANoDataCellModel *cellModel = SANoDataCellModel.new;
        cellModel.descText = TNLocalizedString(@"tn_page_nodata_title", @"No more result");
        self.recommendSectionModel.list = @[cellModel];
        self.recommendSectionModel.headerModel.tag = TNHomeNoDataCellIdentity;
    }
    !completion ?: completion();
}

#pragma mark - private methods
- (void)addChoicenessSectionSkeletonCellModel {
    NSMutableArray<TNHomeChoicenessSkeletonCellModel *> *skeletonModelArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
        [skeletonModelArray addObject:model];
    }
    self.choicenessSectionModel.list = skeletonModelArray;
    self.choicenessSectionModel.headerModel.tag = TNHomeGoodCellIdentity;
}

- (void)addRecommendSectionSkeletonCellModel {
    NSMutableArray<TNHomeChoicenessSkeletonCellModel *> *skeletonModelArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
        [skeletonModelArray addObject:model];
    }
    self.recommendSectionModel.list = skeletonModelArray;
    self.recommendSectionModel.headerModel.tag = TNHomeGoodCellIdentity;
}
- (NSInteger)getChoicenessSection {
    return [self.dataSource indexOfObject:self.choicenessSectionModel];
}
- (NSInteger)getRecommedSection {
    return [self.dataSource indexOfObject:self.recommendSectionModel];
}
#pragma mark - lazy load
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:self.carouselSectionModel,
                                                       self.scrollContentSectionModel,
                                                       self.appsSectionModel,
                                                       self.activitySectionModel,
                                                       self.activityCardSectionModel,
                                                       self.choicenessSectionModel,
                                                       self.recommendSectionModel,
                                                       nil];
    }
    return _dataSource;
}

/// 金刚区
- (HDTableViewSectionModel *)appsSectionModel {
    if (!_appsSectionModel) {
        _appsSectionModel = HDTableViewSectionModel.new;
        _appsSectionModel.list = @[];
    }
    return _appsSectionModel;
}

/// banner
- (HDTableViewSectionModel *)carouselSectionModel {
    if (!_carouselSectionModel) {
        _carouselSectionModel = HDTableViewSectionModel.new;
    }
    return _carouselSectionModel;
}

/// 精选列表
- (HDTableViewSectionModel *)choicenessSectionModel {
    if (!_choicenessSectionModel) {
        _choicenessSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = TNLocalizedString(@"tn_page_choiceness_title", @"Choiceness");
        headerModel.tag = TNHomeGoodCellIdentity;
        _choicenessSectionModel.headerModel = headerModel;
    }
    return _choicenessSectionModel;
}

/// 推荐列表
- (HDTableViewSectionModel *)recommendSectionModel {
    if (!_recommendSectionModel) {
        _recommendSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = TNLocalizedString(@"tn_recomend_for_you", @"为您推荐");
        _recommendSectionModel.headerModel = headerModel;
    }
    return _recommendSectionModel;
}
/// 活动广告
- (HDTableViewSectionModel *)activitySectionModel {
    if (!_activitySectionModel) {
        _activitySectionModel = HDTableViewSectionModel.new;
    }
    return _activitySectionModel;
}
///活动卡片
- (HDTableViewSectionModel *)activityCardSectionModel {
    if (!_activityCardSectionModel) {
        _activityCardSectionModel = HDTableViewSectionModel.new;
    }
    return _activityCardSectionModel;
}
/// 轮播文字
- (HDTableViewSectionModel *)scrollContentSectionModel {
    if (!_scrollContentSectionModel) {
        _scrollContentSectionModel = [[HDTableViewSectionModel alloc] init];
        _scrollContentSectionModel.list = @[];
    }
    return _scrollContentSectionModel;
}
- (NSMutableArray<TNGoodsModel *> *)recommendDataSource {
    return _recommendDataSource ?: ({ _recommendDataSource = NSMutableArray.array; });
}

- (TNHomeDTO *)homeDTO {
    return _homeDTO ?: ({ _homeDTO = TNHomeDTO.new; });
}

- (SAWindowDTO *)getAdvertisementDTO {
    return _getAdvertisementDTO ?: ({ _getAdvertisementDTO = SAWindowDTO.new; });
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}
- (SAAppConfigDTO *)appConfigDTO {
    return _appConfigDTO ?: ({ _appConfigDTO = SAAppConfigDTO.new; });
}

@end
