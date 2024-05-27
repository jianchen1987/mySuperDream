//
//  TNBargainViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainViewModel.h"
#import "SAShoppingAddressDTO.h"
#import "TNBargainDTO.h"
#import "TNBargainGoodListRspModel.h"
#import "TNBargainRecordModel.h"
#import "TNGoodsDTO.h"
#import "TNHomeDTO.h"
#import "TNNotificationConst.h"
#import "TNOrderDTO.h"
#import "TNQueryGoodsRspModel.h"
#import "TNSearchSortFilterModel.h"
#import "TNSpecialActivityDTO.h"


@interface TNBargainViewModel ()
/// DTO
@property (strong, nonatomic) TNBargainDTO *bargainDTO;
/// 地址DTO
@property (strong, nonatomic) SAShoppingAddressDTO *adressDTO;
///
@property (nonatomic, strong) TNOrderDTO *orderDTO;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 记录是否成功
@property (nonatomic, assign) BOOL isSuccess;
/// 定时器
@property (nonatomic, strong) dispatch_source_t timer;
/// 分类DTO
@property (strong, nonatomic) TNHomeDTO *categoryDTO;
/// 搜索dto
@property (strong, nonatomic) TNGoodsDTO *searchDTO;
/// 专题活动的dto
@property (nonatomic, strong) TNSpecialActivityDTO *activityDTO;
@end


@implementation TNBargainViewModel
#pragma mark - 获取砍价首页数据
- (void)getBargainListIndexNewDataCompletion:(void (^)(BOOL))completion {
    @HDWeakify(self);
    [self.view showloading];
    //记录是否成功
    self.isSuccess = false;
    dispatch_group_enter(self.taskGroup);
    [self.bargainDTO queryBargainBannerSuccess:^(NSString *_Nonnull banner) {
        @HDStrongify(self);
        self.banner = banner;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self loadBargainGoodListDataWithPage:1 size:10 completion:^(BOOL isSuccess) {
        @HDStrongify(self);
        self.isSuccess = isSuccess;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (self.isSuccess == true && completion) {
            completion(YES);
        } else {
            completion(NO);
        }
    });
}
- (void)loadBargainListIndexMoreDataCompletion:(void (^)(BOOL))completion {
    TNHomeCategoryModel *model = self.categoryArr.firstObject;
    TNBargainPageConfig *config = self.goodsDic[model.name];
    config.currentPage += 1;
    [self loadBargainGoodListDataWithPage:config.currentPage size:10 completion:^(BOOL isSuccess) {
        if (completion) {
            completion(isSuccess);
        }
    }];
}
#pragma mark - 获取正在进行中的任务
- (void)getUnderwayTaskDataCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.bargainDTO queryBargainUnderwayTaskListSuccess:^(NSArray<TNBargainRecordModel *> *_Nonnull records) {
        @HDStrongify(self);
        self.records = records;
        if (records.count > 2) { //大于两个 就展示下拉更多按钮
            self.isShowExtendOngoingTask = true;
        }
        if (completion) {
            completion();
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
#pragma mark - 获取砍价列表数据
- (void)loadBargainGoodListDataWithPage:(NSInteger)page size:(NSInteger)size completion:(void (^)(BOOL isSuccess))completion {
    @HDWeakify(self);
    [self.bargainDTO queryBargainListWithPage:page size:10 success:^(TNBargainGoodListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        //推荐列表数据
        TNHomeCategoryModel *model = self.categoryArr.firstObject;
        TNBargainPageConfig *config = self.goodsDic[model.name];
        if (!config) {
            config = [[TNBargainPageConfig alloc] init];
            self.goodsDic[model.name] = config;
        }
        if (page == 1) {
            [config.goods removeAllObjects];
            [config.goods addObjectsFromArray:rspModel.records];
        } else {
            [config.goods addObjectsFromArray:rspModel.records];
        }
        config.currentPage = rspModel.pageNum;
        config.hasNextPage = rspModel.hasNextPage;
        !completion ?: completion(true);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(false);
    }];
}
#pragma mark - 获取规格和地址数据
- (void)getGoodSkuSpecAndAdressByActivityId:(NSString *)activityId completion:(nonnull void (^)(void))completion {
    [self.view showloading];
    dispatch_group_enter(self.taskGroup);
    @HDWeakify(self);
    [self.bargainDTO queryGoodSkuSpecWithActivityId:activityId Success:^(TNProductDetailsRspModel *_Nonnull skuModel) {
        @HDStrongify(self);
        if (skuModel) {
            // 配置sku默认规格选中
            [skuModel setSpecDefaultSku];
            self.skuModel = skuModel;
        }
        dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self.adressDTO getDefaultAddressSuccess:^(SAShoppingAddressModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (rspModel) {
            self.addressModel = rspModel;
        }
        dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completion) {
            completion();
        }
    });
}
#pragma mark - 创建砍价任务
- (void)createBargainTaskWithModel:(TNCreateBargainTaskModel *)taskModel completion:(void (^)(NSString *taskId))completion failure:(CMNetworkFailureBlock)failureBlock {
    [self.view showloading];
    @HDWeakify(self);
    [self.bargainDTO createBargainTaskWithModel:taskModel Success:^(NSString *_Nonnull taskId) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completion) {
            completion(taskId);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}
- (void)getMyRecordNewData {
    self.pageNum = 1;
    [self loadBargainMyrecordListDataWithPage:self.pageNum size:10 completion:nil];
}
- (void)loadMyRecordMoreData {
    self.pageNum += 1;
    [self loadBargainMyrecordListDataWithPage:self.pageNum size:10 completion:nil];
}
#pragma mark - 获取我的砍价记录
- (void)loadBargainMyrecordListDataWithPage:(NSInteger)page size:(NSInteger)size completion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.bargainDTO queryMyBargainTaskListWithPage:page size:size success:^(TNBargainRecordListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.pageNum = rspModel.pageNum;
        self.hasNextPage = rspModel.hasNextPage;
        if (page == 1) {
            [self.myRecords removeAllObjects];
            [self.myRecords addObjectsFromArray:rspModel.records];
        } else {
            [self.myRecords addObjectsFromArray:rspModel.records];
        }
        self.refreshFlag = !self.refreshFlag;
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !completion ?: completion();
        if (page == 1) {
            if (self.queryFailureCallBack) {
                self.queryFailureCallBack();
            }
        }
    }];
}
#pragma mark - 获取砍价详情数据
- (void)getBargainDetailDataWithTaskId:(NSString *)taskId pageType:(NSInteger)pageType {
    @HDWeakify(self);
    [self.view showloading];
    self.isSuccess = false;
    dispatch_group_enter(self.taskGroup);
    [self.bargainDTO queryBargainDetailWithTaskId:taskId pageType:pageType Success:^(TNBargainDetailModel *_Nonnull detailModel) {
        @HDStrongify(self);
        self.detailModel = detailModel;
        self.isSuccess = true;
        //拉取到详情数据就 开启定时器倒计时
        if (self.detailModel != nil && self.detailModel.expiredTimeOut > 0) {
            [self startBargainDetailTimer];
        }
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    //如果是砍价详情  就拉取助力记录数据
    if (pageType == 1) {
        dispatch_group_enter(self.taskGroup);
        [self.bargainDTO queryHelpPeopleRecordByTaskId:taskId page:1 size:10 success:^(TNBargainPeopleRecordRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.recordRspModel = rspModel;
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        }];
    }
    dispatch_group_enter(self.taskGroup);
    [self.bargainDTO queryBargainRulesSuccess:^(TNBargainRuleModel *_Nonnull ruleModel) {
        @HDStrongify(self);
        self.ruleModel = ruleModel;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (self.isSuccess == true) {
            self.refreshFlag = !self.refreshFlag;
        } else {
            if (self.queryFailureCallBack) {
                self.queryFailureCallBack();
            }
        }
    });
}
#pragma mark - 获取砍价成功的展示列表数据
- (void)getSucessTaskListCompletion:(void (^)(NSArray<TNBargainSuccessModel *> *_Nonnull))completion {
    [self.bargainDTO queryBargainSuccessTaskListSuccess:^(NSArray<TNBargainSuccessModel *> *_Nonnull records) {
        if (completion) {
            completion(records);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
#pragma mark - 帮砍一刀
- (void)helpBargainCompletion:(void (^)(BOOL))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.bargainDTO helpBargainWithTaskId:self.detailModel.taskId activityId:self.detailModel.activityId Success:^(TNHelpBargainModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        //停止倒计时
        [self cancelBargainDetailTimer];
        //已经砍过价
        self.detailModel.isHelpedBargain = YES;
        self.detailModel.helpFailMsg = rspModel.info;
        if (rspModel.isBargainSuccess && !HDIsObjectNil(rspModel.bargainPriceMoney) && HDIsStringEmpty(rspModel.info)) {
            //砍价成功
            self.detailModel.operatorHelpedPriceMoney = rspModel.bargainPriceMoney;
            self.detailModel.couponList = rspModel.couponList;
        }
        if (!HDIsObjectNil(rspModel.helpedPriceMoney)) {
            self.detailModel.helpedPriceMoney = rspModel.helpedPriceMoney;
        }
        self.detailModel.bargainDetailList = rspModel.bargainDetailList;
        //已下字段是展示文本用
        self.detailModel.helpCopywritingV2 = rspModel.helpCopywritingV2;
        self.detailModel.userMsgPrice = rspModel.userMsgPrice;
        self.detailModel.userMsg = rspModel.userMsg;
        if (completion) {
            completion(rspModel.isBargainSuccess && !HDIsObjectNil(rspModel.bargainPriceMoney));
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
#pragma mark - 获取砍价分类数据
- (void)getBargainCategoryDataByScene:(TNProductCategoryScene)scene souceId:(NSString *)sourceId completion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.categoryDTO queryProductCategoryWithScene:scene sourceId:sourceId Success:^(NSArray<TNHomeCategoryModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self.categoryArr addObjectsFromArray:list];
        //创建 对应的数据源
        for (TNHomeCategoryModel *model in self.categoryArr) {
            TNBargainPageConfig *config = self.goodsDic[model.name];
            if (!config) {
                config = [[TNBargainPageConfig alloc] init];
                self.goodsDic[model.name] = config;
            }
        }
        if (completion) {
            completion();
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
#pragma mark - 获取砍价分类列表数据
- (void)getCategoryBargainListByCategoryModel:(TNHomeCategoryModel *)model completion:(void (^)(BOOL isSuccess))completion {
    [self.view showloading];
    TNBargainPageConfig *config = self.goodsDic[model.name];
    if (!config) {
        config = [[TNBargainPageConfig alloc] init];
        self.goodsDic[model.name] = config;
    }
    @HDWeakify(self);
    [self.bargainDTO queryBargainCategoryListWithCategoryId:model.categoryId page:config.currentPage size:10 success:^(TNBargainGoodListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (config.currentPage == 1) {
            [config.goods removeAllObjects];
            [config.goods addObjectsFromArray:rspModel.records];
        } else {
            [config.goods addObjectsFromArray:rspModel.records];
        }
        config.currentPage = rspModel.pageNum;
        config.hasNextPage = rspModel.hasNextPage;
        if (completion) {
            completion(YES);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completion) {
            completion(NO);
        }
    }];
}
#pragma mark - 获取砍价专题列表数据
- (void)getCategoryBargainActivityListByActivityId:(NSString *)activityId categoryModel:(TNHomeCategoryModel *)model completion:(void (^)(BOOL))completion {
    [self.view showloading];
    TNBargainPageConfig *config = self.goodsDic[model.name];
    if (!config) {
        config = [[TNBargainPageConfig alloc] init];
        self.goodsDic[model.name] = config;
    }
    @HDWeakify(self);
    [self.bargainDTO queryBargainActivityListActivityId:activityId categoryId:model.categoryId page:config.currentPage size:10 success:^(TNBargainGoodListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (config.currentPage == 1) {
            [config.goods removeAllObjects];
            [config.goods addObjectsFromArray:rspModel.records];
        } else {
            [config.goods addObjectsFromArray:rspModel.records];
        }
        config.currentPage = rspModel.pageNum;
        config.hasNextPage = rspModel.hasNextPage;
        if (completion) {
            completion(YES);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (completion) {
            completion(NO);
        }
    }];
}
#pragma mark - 获取砍价专题配置数据
- (void)getBargainActivityConfigDataByActivityId:(NSString *)activityId successBlock:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.activityDTO querySpecialActivityDetailWithActivityId:activityId success:^(TNSpeciaActivityDetailModel *_Nonnull detailModel) {
        @HDStrongify(self);
        self.configModel = detailModel;
        if (detailModel.advList.count > 0) {
            self.banner = detailModel.advList.firstObject;
        }
        if (successBlock) {
            successBlock();
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        if (failureBlock) {
            failureBlock(rspModel, errorType, error);
        }
    }];
}
- (void)clearChooseGoodSpecData {
    self.addressModel = nil;
    self.skuModel = nil;
    self.selectedSku = nil;
    self.goodModel = nil;
}
- (TNCreateBargainTaskModel *)createBargainTaskModel {
    TNCreateBargainTaskModel *model = [[TNCreateBargainTaskModel alloc] init];
    model.activityId = self.goodModel.activityId;
    model.skuId = self.selectedSku.skuId;
    model.addressId = self.addressModel.addressNo;
    model.operatorNo = self.addressModel.operatorNo;
    model.goodsId = self.goodModel.goodsId;
    model.addressArea = self.addressModel.address;
    return model;
}
#pragma mark - 砍价详情定时器
- (void)startBargainDetailTimer {
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), 1.0 * NSEC_PER_SEC, 0);
        @HDWeakify(self);
        dispatch_source_set_event_handler(timer, ^{
            @HDStrongify(self);
            if (self.detailModel != nil) {
                if (self.detailModel.expiredTimeOut > 0) {
                    self.detailModel.expiredTimeOut = self.detailModel.expiredTimeOut - 1;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameBargainCountTime object:nil];
                    });
                } else {
                    [self cancelBargainDetailTimer];
                }
            } else {
                [self cancelBargainDetailTimer];
            }
            HDLog(@"倒计时===%.f s", self.detailModel.expiredTimeOut);
        });
        self.timer = timer;
        dispatch_resume(self.timer);
    }
}
- (void)cancelBargainDetailTimer {
    if (self.timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
- (void)checkRegion:(void (^)(TNCheckRegionModel *checkModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.orderDTO checkRegionAreaWithLatitude:self.addressModel.latitude longitude:self.addressModel.longitude storeNo:self.skuModel.storeNo paymentMethod:TNPaymentMethodOffLine scene:@""
                                       Success:successBlock
                                       failure:failureBlock];
}

#pragma mark -
/** @lazy bargainDTO */
- (TNBargainDTO *)bargainDTO {
    if (!_bargainDTO) {
        _bargainDTO = [[TNBargainDTO alloc] init];
    }
    return _bargainDTO;
}
- (SAShoppingAddressDTO *)adressDTO {
    if (!_adressDTO) {
        _adressDTO = [[SAShoppingAddressDTO alloc] init];
    }
    return _adressDTO;
}
- (NSMutableArray<TNBargainRecordModel *> *)myRecords {
    if (!_myRecords) {
        _myRecords = [NSMutableArray array];
    }
    return _myRecords;
}
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}
- (BOOL)isExtendOngoingTask {
    if (HDIsArrayEmpty(self.records)) {
        return false;
    }
    if (self.records.count > 2) { //大于两条才下拉
        return true;
    }
    return false;
}
- (NSMutableDictionary<NSString *, TNBargainPageConfig *> *)goodsDic {
    if (!_goodsDic) {
        _goodsDic = [NSMutableDictionary dictionary];
    }
    return _goodsDic;
}
- (NSMutableArray *)categoryArr {
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
        TNHomeCategoryModel *model = [[TNHomeCategoryModel alloc] init];
        model.name = TNLocalizedString(@"tn_recommend", @"推荐");
        [_categoryArr addObject:model];
    }
    return _categoryArr;
}
- (TNHomeDTO *)categoryDTO {
    if (!_categoryDTO) {
        _categoryDTO = [[TNHomeDTO alloc] init];
    }
    return _categoryDTO;
}
- (TNGoodsDTO *)searchDTO {
    if (!_searchDTO) {
        _searchDTO = [[TNGoodsDTO alloc] init];
    }
    return _searchDTO;
}
- (TNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[TNOrderDTO alloc] init];
    }
    return _orderDTO;
}
/** @lazy activityDTO */
- (TNSpecialActivityDTO *)activityDTO {
    if (!_activityDTO) {
        _activityDTO = [[TNSpecialActivityDTO alloc] init];
    }
    return _activityDTO;
}
@end
