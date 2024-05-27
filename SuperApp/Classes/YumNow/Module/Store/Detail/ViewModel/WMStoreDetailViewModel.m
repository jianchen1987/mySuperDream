//
//  WMStoreDetailViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailViewModel.h"


@interface WMStoreDetailViewModel ()

@end


@implementation WMStoreDetailViewModel

- (void)dealloc {
    [_getMenuListRequest cancel];
    [_getGoodsListRequest cancel];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollMenuIndex = NSNotFound;
        self.isMenuListEmpty = true;
        self.isTotalCountZero = true;
    }
    return self;
}
- (void)getGoodListByIndex:(NSInteger)index loadTop:(BOOL)loadTop loadDown:(BOOL)loadDown completion:(void (^)(BOOL isSuccess))completion {
    if (index > self.menuList.count) {
        //回调出去刷新
        if (completion) {
            completion(false);
        }
        return;
    }
    NSArray *menuIds = [self getMenuIdsByIndex:index loadTop:loadTop loadDown:loadDown];
    if (HDIsArrayEmpty(menuIds)) {
        //回调出去刷新
        if (completion) {
            completion(false);
        }
        return;
    }
    [self.view showloading];
    @HDWeakify(self);
    [self getMenuGoodsListByMemuIds:menuIds success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        //填充数据
        [self fillMenuListByGoods];
        //回调出去刷新
        if (completion) {
            completion(true);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        //回调出去刷新
        if (completion) {
            completion(false);
        }
    }];
}
///通过商品ID获取菜单
- (CMNetworkRequest *)getMenuIdByGoodId:(NSString *)goodId Success:(void (^)(NSString *_Nonnull menuId))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = goodId;
    self.getMenuIdRequest.requestParameter = params;
    [self.getMenuIdRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *dataDic = (NSDictionary *)rspModel.data;
        NSString *menuId = [NSString stringWithFormat:@"%@", dataDic[@"menuId"]];
        !successBlock ?: successBlock(menuId);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getMenuIdRequest;
}
///获取所有菜单数据
- (CMNetworkRequest *)getMenuListSuccess:(void (^)(NSArray<WMStoreMenuItem *> *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = self.storeNo;
    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = [SAUser shared].operatorNo;
    }
    self.getMenuListRequest.requestParameter = params;

    @HDWeakify(self);
    [self.getMenuListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *dataDic = (NSDictionary *)rspModel.data;
        NSArray *list = [NSArray yy_modelArrayWithClass:WMStoreMenuItem.class json:dataDic[@"menus"]];
        @HDStrongify(self);
        self.menuList = list;
        self.isMenuListEmpty = HDIsArrayEmpty(list);
        if (!HDIsArrayEmpty(list)) {
            self.isMenuListEmpty = false;
            // 计算所有菜品数量
            NSUInteger totalMenuCount = 0;
            for (WMStoreMenuItem *item in list) {
                //统计商品总数
                totalMenuCount += item.count;
            }
            self.isTotalCountZero = totalMenuCount <= 0;
        } else {
            self.isMenuListEmpty = true;
        }
        // 判断是否包含特价商品菜单
        for (WMStoreMenuItem *menuItem in list) {
            if (menuItem.bestSale) {
                self.hasBestSaleMenu = true;
                self.availableBestSaleCount = menuItem.availableBestSaleCount;
                break;
            }
        }
        !successBlock ?: successBlock(list);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getMenuListRequest;
}
/// 通过菜单id获取商品数
- (CMNetworkRequest *)getMenuGoodsListByMemuIds:(NSArray<NSString *> *)menuIds success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    // 保存已经请求过的菜单id
    [self.alreadyRequestMenuIds addObjectsFromArray:menuIds];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"menuIds"] = menuIds;
    params[@"storeNo"] = self.storeNo;
    self.getGoodsListRequest.requestParameter = params;
    @HDWeakify(self);
    [self.getGoodsListRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        @HDStrongify(self);
        WMStoreGoodsRspModel *model = [WMStoreGoodsRspModel yy_modelWithJSON:rspModel.data];
        self.currentRequestGoods = model.products;
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        // 请求失败，移除对应的菜单id
        [self.alreadyRequestMenuIds removeObjectsInArray:menuIds];
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];

    return self.getGoodsListRequest;
}
// 优先拿到当前门店是否休息，停业
- (void)getInitializedData {
    [self.dataSource removeAllObjects]; //清楚所有数据
    double time = NSDate.date.timeIntervalSince1970;
    @HDWeakify(self);
    HDLog(@"🍌开启请求详情和菜单列表");
    self.taskGroup = dispatch_group_create();

    dispatch_group_enter(self.taskGroup);
    [self getMenuListSuccess:^(NSArray<WMStoreMenuItem *> *_Nonnull list) {
        @HDStrongify(self);
        HDLog(@"🍌菜单完成 %f", NSDate.date.timeIntervalSince1970 - time);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"🍌菜单失败 %f", NSDate.date.timeIntervalSince1970 - time);
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    CMNetworkRequest *getStoreDetailReq = [self.storeDetailDTO getStoreDetailInfoWithStoreNo:self.storeNo success:^(WMStoreDetailRspModel *_Nonnull rspModel) {
        HDLog(@"🍌门店详情完成 %f", NSDate.date.timeIntervalSince1970 - time);
        @HDStrongify(self);
        self.storeName = rspModel.storeName.desc;
        self.detailInfoModel = rspModel;
        self.isStoreClosed = false;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        HDLog(@"🍌门店详情失败 %f", NSDate.date.timeIntervalSince1970 - time);
        // 门店禁用
        if ([rspModel.code isEqualToString:WMOrderCheckFailureReasonStoreStopped]) {
            self.storeClosedMsg = rspModel.msg;
            self.isStoreClosed = true;
        } else {
            self.isStoreClosed = false;
        }
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    getStoreDetailReq.shouldAlertErrorMsgExceptSpecCode = false;

    // 获取购物车项
    dispatch_group_enter(self.taskGroup);
    void (^queryStoreShoppingCart)(void) = ^() {
        [self.storeShoppingCartDTO queryStoreShoppingCartWithClientType:SABusinessTypeYumNow storeNo:self.storeNo success:^(WMShoppingCartStoreItem *_Nonnull rspModel) {
            @HDStrongify(self);
            self.shopppingCartStoreItem = rspModel;
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            HDLog(@"🍌购物项完成 %f", NSDate.date.timeIntervalSince1970 - time);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            HDLog(@"🍌购物项失败 %f", NSDate.date.timeIntervalSince1970 - time);
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        }];
    };

    // 是否为再来一单
    if (HDIsStringNotEmpty(self.onceAgainOrderNo)) {
        [self onceAgainOrderSuccess:^{
            queryStoreShoppingCart();
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        }];
    } else {
        queryStoreShoppingCart();
    }

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        HDLog(@"🍌详情和菜单列表请求完成");
        [self dealHeader];
        self.refreshFlag = !self.refreshFlag;
        [self dealData];
    });
}

- (void)getFirstMenuGoodDataSuccess:(void (^)(void))successBlock {
    @HDWeakify(self);
    /// 首次加载商品数据源  可以根据商品数量来加载类目数量
    if (!HDIsArrayEmpty(self.menuList)) {
        if (HDIsStringNotEmpty(self.productId)) { //有需要定位
            [self getMenuIdByGoodId:self.productId Success:^(NSString *_Nonnull menuId) {
                @HDStrongify(self);
                if (HDIsStringNotEmpty(menuId)) {
                    NSInteger index = 0;
                    for (WMStoreMenuItem *item in self.menuList) {
                        if ([item.menuId isEqualToString:menuId]) {
                            index = [self.menuList indexOfObject:item];
                            self.scrollMenuIndex = index;
                            self.scrollMenuId = item.menuId;
                            break;
                        }
                    }
                    NSArray *menuIds = [self getMenuIdsByIndex:index loadTop:false loadDown:false];
                    HDLog(@"🍌有商品定位 %@ %@ %zd %@", self.productId, self.scrollMenuId, self.scrollMenuIndex, menuIds);
                    if (!HDIsArrayEmpty(menuIds)) {
                        [self getMenuGoodsListByMemuIds:menuIds success:^() {
                            !successBlock ?: successBlock();
                        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                            !successBlock ?: successBlock();
                        }];
                    } else {
                        !successBlock ?: successBlock();
                    }
                } else {
                    !successBlock ?: successBlock();
                }
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                !successBlock ?: successBlock();
            }];
        } else {                                                                       //不需要定位
            NSArray *menuIds = [self getMenuIdsByIndex:0 loadTop:false loadDown:true]; //从0开始 的话  就是往下取
            if (!HDIsArrayEmpty(menuIds)) {
                [self getMenuGoodsListByMemuIds:menuIds success:^() {
                    !successBlock ?: successBlock();
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    !successBlock ?: successBlock();
                }];
            } else {
                !successBlock ?: successBlock();
            }
        }
    } else {
        !successBlock ?: successBlock();
    }
}

- (void)dealHeader {
    @HDWeakify(self)
    void (^addStoreClosedDataSource)(void) = ^(void) {
        @HDStrongify(self)
            // 详情分组
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        if (self.isStoreClosed) {
            SANoDataCellModel *noDataModel = SANoDataCellModel.new;
            noDataModel.marginImageToTop = kRealWidth(160);
            noDataModel.image = [UIImage imageNamed:@"placeholder_store_off"];
            noDataModel.descText = self.storeClosedMsg;
            sectionModel.list = @[noDataModel];
        }
        [self.dataSource addObject:sectionModel];
    };

    void (^addStoreDetailSection)(void) = ^(void) {
        @HDStrongify(self)
            // 详情分组
        HDTableViewSectionModel *sectionModel  = HDTableViewSectionModel.new;
        if (!HDIsObjectNil(self.detailInfoModel)) {
            sectionModel.list = @[self.detailInfoModel];
        } else if (self.noDateCellModel) {
            sectionModel.list = @[self.noDateCellModel];
        }
        [self.dataSource addObject:sectionModel];
    };

    if (self.isStoreClosed) {
        !addStoreClosedDataSource ?: addStoreClosedDataSource();
    } else {
        !addStoreDetailSection ?: addStoreDetailSection();
    }
}

- (void)dealData {
    @HDWeakify(self) void (^addStorePinSection)(void) = ^(void) {
        @HDStrongify(self)
            // 悬停tab，不需要list，仅仅只有一个头部
            HDTableViewSectionModel *sectionModel
            = HDTableViewSectionModel.new;
        [self.dataSource addObject:sectionModel];
    };

    if (!self.isStoreClosed) {
        // 如果菜单项为空或者所有菜单没有数据，展示空
        if (self.isValidMenuListEmpty) {
            SANoDataCellModel *noDataModel = SANoDataCellModel.new;
            HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
            sectionModel.list = @[noDataModel];
            [self.dataSource addObject:sectionModel];
            self.shopppingCartStoreItem = nil;
            self.payFeeTrialCalRspModel = nil;
        } else {
            addStorePinSection();
            int i = 0;
            for (WMStoreMenuItem *menuItem in self.menuList) {
                //按类目生成各类目模型
                HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
                sectionModel.commonHeaderModel = menuItem;
                if (i == 0) {
                    ///无数据占位
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int j = 0; j < 20; j++) {
                        WMStoreGoodsItem *emptyGoodItem = WMStoreGoodsItem.new;
                        [tempArr addObject:emptyGoodItem];
                    }
                    sectionModel.list = tempArr;
                }
                [self.dataSource addObject:sectionModel];
                i++;
            }
            double time = NSDate.date.timeIntervalSince1970;
            [self getFirstMenuGoodDataSuccess:^{
                HDLog(@"🍌首次菜单商品请求完成 %f", NSDate.date.timeIntervalSince1970 - time);
                @HDStrongify(self) for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                    WMStoreMenuItem *menuItem = sectionModel.commonHeaderModel;
                    if ([menuItem isKindOfClass:WMStoreMenuItem.class]) {
                        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
                        headerModel.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
                        headerModel.titleColor = HDAppTheme.WMColor.B3;
                        headerModel.backgroundColor = HDAppTheme.WMColor.bgGray;
                        headerModel.titleNumberOfLines = 0;
                        headerModel.title = menuItem.name;
                        sectionModel.headerModel = headerModel;
                        NSMutableArray *menuList = [NSMutableArray array];
                        NSInteger menuId = [menuItem.menuId integerValue];
                        sectionModel.list = @[];
                        for (WMStoreGoodsItem *goodItem in self.currentRequestGoods) {
                            if ([goodItem.menuIds containsObject:@(menuId)]) {
                                [menuList addObject:goodItem];
                            }
                            goodItem.storeStatus = self.detailInfoModel.storeStatus;
                            WMShoppingCartStoreItem *storeItem = self.shopppingCartStoreItem;
                            if (!self.hasInitializedOrderPayTrialCalculate && storeItem) {
                                self.shopppingCartStoreItem = storeItem;
                                [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
                                self.hasInitializedOrderPayTrialCalculate = true;
                            }
                            [self updateShoppingCartTotalCount];
                        }
                        sectionModel.list = menuList;
                    }
                }
                // 生成滚动到指定 indexPath
                [self setAutoScollerToTargetIndex];
                //设置商品的skCountModel属性
                [self setgoodItemSkuCountModel:self.currentRequestGoods];

                self.refreshFlagFirstGoods = !self.refreshFlagFirstGoods;
            }];

            //            for (WMStoreMenuItem *menuItem in self.menuList) {
            //                //按类目生成各类目模型
            //                HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
            //                headerModel.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
            //                headerModel.titleColor = HDAppTheme.WMColor.B3;
            //                headerModel.backgroundColor = HDAppTheme.WMColor.bgGray;
            //                headerModel.titleNumberOfLines = 0;
            //                headerModel.title = menuItem.name;
            //                HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
            //                sectionModel.headerModel = headerModel;
            //                sectionModel.commonHeaderModel = menuItem; //将menuItem绑定  用于查找对应的menu数据
            //                NSMutableArray *menuList = [NSMutableArray array];
            //                for (WMStoreGoodsItem *goodItem in self.currentRequestGoods) {
            //                    NSInteger menuId = [menuItem.menuId integerValue];
            //                    if ([goodItem.menuIds containsObject:@(menuId)]) {
            //                        [menuList addObject:goodItem];
            //                    }
            //                    // 设置门店状态到商品模型
            //                    goodItem.storeStatus = self.detailInfoModel.storeStatus;
            //                    WMShoppingCartStoreItem *storeItem = self.shopppingCartStoreItem;
            //                    if (!self.hasInitializedOrderPayTrialCalculate && storeItem) {
            //                        self.shopppingCartStoreItem = storeItem;
            //                        // 有购物车项，订单试算
            //                        [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
            //                        self.hasInitializedOrderPayTrialCalculate = true;
            //                    }
            //                    //更新购物车总量
            //                    [self updateShoppingCartTotalCount];
            //                }
            //                sectionModel.list = menuList;
            //                [self.dataSource addObject:sectionModel];
            //            }
            //            // 生成滚动到指定 indexPath
            //            [self setAutoScollerToTargetIndex];
            //            //设置商品的skCountModel属性
            //            [self setgoodItemSkuCountModel:self.currentRequestGoods];
        }
    }
    self.hasGotInitializedData = true;
    self.refreshFlag = !self.refreshFlag;
}

- (void)favouriteStore {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    // 未获取到门店信息时，不做处理
    if (HDIsObjectNil(self.detailInfoModel)) {
        return;
    }

    @HDWeakify(self);
    [self.view showloading];
    if (self.detailInfoModel.favourite) { // 取消收藏
        [self.storeFavouriteDTO removeFavouriteWithStoreNos:@[self.storeNo] success:^() {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.detailInfoModel.favourite = false;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    } else { // 收藏
        [self.storeFavouriteDTO addFavouriteWithStoreNo:self.storeNo success:^() {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.detailInfoModel.favourite = true;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];

            if ([rspModel.code isEqualToString:@"ME008"]) {
                [NAT showAlertWithMessage:WMLocalizedString(@"3wsENp5w", @"收藏失败，收藏数量已达到上限。") confirmButtonTitle:WMLocalizedString(@"wm_button_confirm", @"确认")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }
                    cancelButtonTitle:WMLocalizedString(@"uZ6MJmaQ", @"查看我的收藏") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                        [HDMediator.sharedInstance navigaveToStoreFavoriteViewController:@{}];
                    }];
            } else {
                [NAT showAlertWithMessage:rspModel.msg buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                                  handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                  }];
            }
        }];
    }
}

#pragma mark - 获取最新优惠券
- (void)getNewCouponsCompletion:(void (^)(WMCouponActivityContentModel *rspModel))completion {
    [self.couponDTO getStoreCouponActivityStoreNo:self.storeNo success:^(WMCouponActivityContentModel *_Nonnull rspModel) {
        if (completion)
            completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        if (completion)
            completion(nil);
    }];
}

#pragma mark - 获取所有优惠券
- (void)getAllCouponsCompletion:(void (^)(WMCouponActivityModel *rspModel))completion {
    [self.couponDTO getStoreAllCouponActivityStoreNo:self.storeNo success:^(WMCouponActivityModel *_Nonnull rspModel) {
        if (completion)
            completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        if (completion)
            completion(nil);
    }];
}

#pragma mark - 一键领券
- (void)oneClickCouponWithActivityNo:(NSString *)activityNo
                            couponNo:(NSArray<NSString *> *)couponNo
                         storeJoinNo:(NSString *)storeJoinNo
                          completion:(void (^)(WMOneClickResultModel *rspModel))completion {
    if (!SAUser.hasSignedIn) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    [self.couponDTO getOneClickCouponWithActivityNo:activityNo couponNo:couponNo storeJoinNo:storeJoinNo storeNo:self.storeNo success:^(WMOneClickResultModel *_Nonnull rspModel) {
        if (completion)
            completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        if (completion)
            completion(nil);
    }];
}

#pragma mark - 通过index获取menuIds集合
- (NSMutableArray<NSString *> *)getMenuIdsByIndex:(NSInteger)index loadTop:(BOOL)loadTop loadDown:(BOOL)loadDown {
    NSMutableArray<NSString *> *menuIds = [NSMutableArray array];
    if (HDIsArrayEmpty(self.menuList)) {
        return menuIds;
    }
    NSArray *frontPartArr = @[]; //要把自己加进来
    NSArray *lastPartArr = @[];
    if (loadTop == true && loadDown == false) {
        frontPartArr = [self.menuList subarrayWithRange:NSMakeRange(0, index + 1)]; //要把自己加进来
        //向上取所有的数据
        if (!HDIsArrayEmpty(frontPartArr)) {
            NSInteger goodsCount = 0;
            for (WMStoreMenuItem *item in [[frontPartArr reverseObjectEnumerator] allObjects]) { //倒叙筛选
                //累加的时候  需要判断当前菜单是否已经请求过数据了
                BOOL hasData = false;
                for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                    if (sectionModel.commonHeaderModel != nil) {
                        WMStoreMenuItem *targetItem = (WMStoreMenuItem *)sectionModel.commonHeaderModel;
                        if ([targetItem.menuId isEqualToString:item.menuId] && [self.alreadyRequestMenuIds containsObject:targetItem.menuId]) {
                            hasData = true;
                            break;
                        }
                    }
                }
                if (hasData == true) { // 请求过数据就过滤掉
                    continue;
                }
                goodsCount += item.count;
                if (![menuIds containsObject:item.menuId]) {
                    [menuIds insertObject:item.menuId atIndex:0]; //因为是倒叙遍历  插入的时候 还是要按顺序来
                }
                if (goodsCount >= getGoodsMaxCount && menuIds.count > 1) { //最少拿两个类目的数据
                    break;
                }
            }
        }
    } else if (loadTop == false && loadDown == true) {
        lastPartArr = [self.menuList subarrayWithRange:NSMakeRange(index, self.menuList.count - index)];
        //向下取所有的数据
        if (!HDIsArrayEmpty(lastPartArr)) {
            NSInteger goodsCount = 0;
            for (WMStoreMenuItem *item in lastPartArr) { //倒叙筛选
                //累加的时候  需要判断当前菜单是否已经请求过数据了
                BOOL hasData = false;
                for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                    if (sectionModel.commonHeaderModel != nil) {
                        WMStoreMenuItem *targetItem = (WMStoreMenuItem *)sectionModel.commonHeaderModel;
                        if ([targetItem.menuId isEqualToString:item.menuId] && [self.alreadyRequestMenuIds containsObject:targetItem.menuId]) {
                            hasData = true;
                            break;
                        }
                    }
                }
                if (hasData == true) { //请求过数据就过滤掉
                    continue;
                }
                goodsCount += item.count;
                if (![menuIds containsObject:item.menuId]) {
                    [menuIds addObject:item.menuId];
                }
                if (goodsCount >= getGoodsMaxCount && menuIds.count > 1) {
                    break;
                }
            }
        }
    } else {
        frontPartArr = [self.menuList subarrayWithRange:NSMakeRange(0, index)]; //要把自己加进来
        lastPartArr = [self.menuList subarrayWithRange:NSMakeRange(index, self.menuList.count - index)];
        //按index将菜单截断  获取index前后的数据
        if (!HDIsArrayEmpty(frontPartArr)) {
            NSInteger goodsCount = 0;
//            for (WMStoreMenuItem *item in [[frontPartArr reverseObjectEnumerator] allObjects]) { //倒叙筛选
            for (WMStoreMenuItem *item in frontPartArr ) { //倒叙筛选
                //累加的时候  需要判断当前菜单是否已经请求过数据了
                BOOL hasData = false;
                for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                    if (sectionModel.commonHeaderModel != nil) {
                        WMStoreMenuItem *targetItem = (WMStoreMenuItem *)sectionModel.commonHeaderModel;
                        if ([targetItem.menuId isEqualToString:item.menuId] && [self.alreadyRequestMenuIds containsObject:targetItem.menuId]) {
                            hasData = true;
                            break;
                        }
                    }
                }
                if (hasData == true) { //请求过数据就过滤掉
                    continue;
                }
                goodsCount += item.count;
                if (![menuIds containsObject:item.menuId]) {
//                    [menuIds insertObject:item.menuId atIndex:0]; //因为是倒叙遍历  插入的时候 还是要按顺序来
                    [menuIds addObject:item.menuId];
                }
                if (goodsCount >= getGoodsMaxCount / 2 && menuIds.count > 1) { //最少拿两个类目的数据
                    break;
                }
            }
            
            WMStoreMenuItem *item  = frontPartArr.lastObject;
            if (![menuIds containsObject:item.menuId]) {
                BOOL hasData = false;
                for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                    if (sectionModel.commonHeaderModel != nil) {
                        WMStoreMenuItem *targetItem = (WMStoreMenuItem *)sectionModel.commonHeaderModel;
                        if ([targetItem.menuId isEqualToString:item.menuId] && [self.alreadyRequestMenuIds containsObject:targetItem.menuId]) {
                            hasData = true;
                            break;
                        }
                    }
                }
                if (!hasData) {
                    goodsCount += item.count;
                    if (![menuIds containsObject:item.menuId]) {
                        [menuIds addObject:item.menuId];
                    }
                }
            }
        }

        if (!HDIsArrayEmpty(lastPartArr)) {
            NSInteger goodsCount = 0;
            for (WMStoreMenuItem *item in lastPartArr) { //倒叙筛选
                //累加的时候  需要判断当前菜单是否已经请求过数据了
                BOOL hasData = false;
                for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                    if (sectionModel.commonHeaderModel != nil) {
                        WMStoreMenuItem *targetItem = (WMStoreMenuItem *)sectionModel.commonHeaderModel;
                        if ([targetItem.menuId isEqualToString:item.menuId] && [self.alreadyRequestMenuIds containsObject:targetItem.menuId]) {
                            hasData = true;
                            break;
                        }
                    }
                }
                if (hasData == true) { //请求过数据就过滤掉
                    continue;
                }
                goodsCount += item.count;
                if (![menuIds containsObject:item.menuId]) {
                    [menuIds addObject:item.menuId];
                }
                if (goodsCount >= getGoodsMaxCount / 2 && menuIds.count > 1) { //最少拿两个类目的数据
                    break;
                }
            }
        }
    }
    // 查看需要请求数据的数组  是否已经请求过了  请求过的话就过滤掉
    if (!HDIsArrayEmpty(self.dataSource)) {
        [menuIds enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                if (sectionModel.commonHeaderModel != nil) {
                    WMStoreMenuItem *menuItem = (WMStoreMenuItem *)sectionModel.commonHeaderModel;
                    if (!HDIsObjectNil(menuItem) && [obj isEqualToString:menuItem.menuId]) {
                        if ([self.alreadyRequestMenuIds containsObject:menuItem.menuId]) {
                            //已经请求过了
                            [menuIds removeObject:obj];
                        }
                    }
                }
            }
        }];
    }
    return menuIds;
}
#pragma mark - 定位cell 自动滚动
- (void)setAutoScollerToTargetIndex {
    // 只赋值一次即可，并且不需要多次自动滚动
    if (self.hasAutoScrolledToSpecIndexPath || HDIsStringEmpty(self.productId))
        return;


    for (HDTableViewSectionModel *sectionModel in self.dataSource) {
        for (id model in sectionModel.list) {
            if ([model isKindOfClass:[WMStoreGoodsItem class]]) {
                WMStoreGoodsItem *goodItem = (WMStoreGoodsItem *)model;
                // 只赋值一次即可，并且不需要多次自动滚动
                if ([goodItem.goodId isEqualToString:self.productId] || [goodItem.code isEqualToString:self.productId]) {
                    NSInteger destSectionIndex = [self.dataSource indexOfObject:sectionModel];
                    NSInteger destRowIndex = [sectionModel.list indexOfObject:goodItem];
                    self.autoScrolledToIndexPath = [NSIndexPath indexPathForRow:destRowIndex inSection:destSectionIndex];
                    return;
                }
            }
        }
    }
    //    const NSUInteger defaultIndex = 0;
    //    NSUInteger destSectionIndex = defaultIndex;
    //    NSUInteger destRowIndex = defaultIndex;
    //    int num = 0;
    //    for (HDTableViewSectionModel *sectionModel in self.dataSource) {
    //        for (id model in sectionModel.list) {
    //            if ([model isKindOfClass:[WMStoreGoodsItem class]]) {
    //                WMStoreGoodsItem *goodItem = (WMStoreGoodsItem *)model;
    //                // 只赋值一次即可，并且不需要多次自动滚动
    //                if (!self.hasAutoScrolledToSpecIndexPath && destSectionIndex == defaultIndex && destRowIndex == defaultIndex
    //                    && ((self.scrollMenuIndex != NSNotFound) ? (num == self.scrollMenuIndex) : YES)
    //                    && (self.scrollMenuId ? [goodItem.menuIds indexOfObject:@(self.scrollMenuId.integerValue)] != NSNotFound : YES) && HDIsStringNotEmpty(self.productId)
    //                    && ([goodItem.goodId isEqualToString:self.productId] || [goodItem.code isEqualToString:self.productId])) {
    //                    destSectionIndex = [self.dataSource indexOfObject:sectionModel];
    //                    destRowIndex = [sectionModel.list indexOfObject:goodItem];
    //                    self.autoScrolledToIndexPath = [NSIndexPath indexPathForRow:destRowIndex inSection:destSectionIndex];
    //                    return;
    //                }
    //            }
    //        }
    //        num++;
    //    }
}
#pragma mark - 设置商品的sku数据
- (void)setgoodItemSkuCountModel:(NSArray<WMStoreGoodsItem *> *)goodsArr {
    if (!HDIsArrayEmpty(goodsArr) && self.shopppingCartStoreItem) {
        for (WMStoreGoodsItem *goodItem in goodsArr) {
            NSArray<WMShoppingCartStoreProduct *> *productList = [WMStoreDetailAdaptor shoppingCardStoreProductListInStoreItem:self.shopppingCartStoreItem goodsId:goodItem.goodId];
            if (HDIsArrayEmpty(productList)) {
                goodItem.skuCountModelList = nil;
                continue;
            }
            goodItem.skuCountModelList = [productList mapObjectsUsingBlock:^WMStoreGoodsSkuCountModel *_Nonnull(WMShoppingCartStoreProduct *_Nonnull productModel, NSUInteger idx) {
                WMStoreGoodsSkuCountModel *skuCountModel = WMStoreGoodsSkuCountModel.new;
                skuCountModel.skuId = productModel.goodsSkuId;
                skuCountModel.countInCart = productModel.purchaseQuantity;
                return skuCountModel;
            }];
        }
    }
}
#pragma mark - 将请求来的商品数据  塞进对应类目里面
- (void)fillMenuListByGoods {
    if (!HDIsArrayEmpty(self.currentRequestGoods)) {
        for (WMStoreGoodsItem *goodItem in self.currentRequestGoods) {
            for (HDTableViewSectionModel *sectionModel in self.dataSource) {
                if (sectionModel.commonHeaderModel != nil) {
                    NSMutableArray *listArr = [NSMutableArray arrayWithArray:sectionModel.list];
                    WMStoreMenuItem *menuItem = (WMStoreMenuItem *)sectionModel.commonHeaderModel;
                    NSInteger menuId = [menuItem.menuId integerValue];
                    if ([goodItem.menuIds containsObject:@(menuId)]) {
                        if (![self isAlreadyExistInGoodslistByGoodId:goodItem.goodId list:listArr]) { //菜单没有这个商品 就添加
                            [listArr addObject:goodItem];
                        }
                    }
                    sectionModel.list = listArr;
                }
            }
        }
        //同步商品和购物车的数据
        [self updateDataSourceWithLatestShoppingCardRspModelAndPayFeeTrialCalRspModel];
    }
}
// 查看商品是否已经存在
- (BOOL)isAlreadyExistInGoodslistByGoodId:(NSString *)goodId list:(NSArray<WMStoreGoodsItem *> *)list {
    BOOL isExist = false;
    for (WMStoreGoodsItem *item in list) {
        if ([item.goodId isEqualToString:goodId]) {
            isExist = true;
            break;
        }
    }
    return isExist;
}

- (void)reGetShoppingCartItems {
    [self reGetShoppingCartItemsSuccess:nil failure:nil];
}

- (void)reGetShoppingCartItemsSuccess:(void (^)(WMShoppingCartStoreItem *storeItem))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.storeShoppingCartDTO queryStoreShoppingCartWithClientType:SABusinessTypeYumNow storeNo:self.storeNo success:^(WMShoppingCartStoreItem *_Nonnull rspModel) {
        HDLog(@"重拿购物车数据成功");
        @HDStrongify(self);
        // 更新
        self.shopppingCartStoreItem = rspModel;
        [self updateShoppingCartTotalCount];

        // 回调
        !successBlock ?: successBlock(self.shopppingCartStoreItem);
        // 获取购物车成功，订单试算
        [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"重拿购物车数据失败");
        @HDStrongify(self);
        [self.view dismissLoading];
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

/// 更新本地购物车的商品数量
- (void)updateLocalShoppingCartItemCountWithUpdateGoodsRspMode:(WMShoppingCartUpdateGoodsRspModel *)rspModel {
    // 未登录状态，重新刷新购物车
    if (!SAUser.hasSignedIn) {
        [self reGetShoppingCartItems];
        return;
    }
    NSArray<WMShoppingCartStoreProduct *> *filterArr = [self.shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull item) {
        return [item.itemDisplayNo isEqualToString:rspModel.updateItem.itemDisplayNo];
    }];

    if (filterArr.count > 0) {
        // 当前购物车有
        if (rspModel.updateItem.purchaseQuantity > 0) {
            // 数量不为0 更新数量
            WMShoppingCartStoreProduct *tmp = filterArr.firstObject;
            tmp.purchaseQuantity = rspModel.updateItem.purchaseQuantity;
            tmp.totalDiscountAmount = rspModel.updateItem.totalDiscountAmount;
        } else {
            // 数量为0 删除当前购物车商品
            NSMutableArray<WMShoppingCartStoreProduct *> *tmpList = [[NSMutableArray alloc] initWithArray:self.shopppingCartStoreItem.goodsList];
            [tmpList removeObject:filterArr.firstObject];
            self.shopppingCartStoreItem.goodsList = [NSArray arrayWithArray:tmpList];
        }
    } else {
        // 当前购物车没有
        if (rspModel.updateItem.purchaseQuantity > 0) {
            // 插入
            [self reGetShoppingCartItems];
            return;
        } else {
            // 不处理
        }
    }
    // 重新试算
    [self updateShoppingCartTotalCount];
    [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
}

- (void)updateShoppingCartTotalCount {
    self.storeProductTotalCount = 0;
    for (WMShoppingCartStoreProduct *product in self.shopppingCartStoreItem.goodsList) {
        self.storeProductTotalCount += product.purchaseQuantity;
    }
}

- (void)payFeeTrialCalculateWithCalItem:(NSArray<WMShoppingCartPayFeeCalItem *> *)items
                                success:(void (^)(WMShoppingItemsPayFeeTrialCalRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    // 过滤不可用商品
    NSArray<WMShoppingCartStoreProduct *> *validProductList = [self.shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull model) {
        return model.goodsState == WMGoodsStatusOn && model.availableStock > 0;
        //        return model.availableStock > 0;
    }];

    // 如果没有选中项，直接 return
    if (HDIsArrayEmpty(items)) {
        items = [validProductList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
            WMShoppingCartPayFeeCalItem *item = WMShoppingCartPayFeeCalItem.new;
            item.productId = obj.goodsId;
            item.count = obj.purchaseQuantity;
            item.properties = [obj.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull property, NSUInteger idx) {
                return property.propertyId;
            }];
            item.specId = obj.goodsSkuId;
            if ((obj.productPromotion.type == WMStoreGoodsPromotionLimitTypeDayProNum || obj.productPromotion.type == WMStoreGoodsPromotionLimitTypeActivityTotalNum) &&
                [item.productId isEqualToString:WMManage.shareInstance.selectGoodId]) {
                item.select = @"";
                WMManage.shareInstance.selectGoodId = nil;
            }
            return item;
        }];
    }

    // 如果 items 还是为 nil，说明没有购物项，清空了购物车
    if (HDIsArrayEmpty(items)) {
        WMShoppingItemsPayFeeTrialCalRspModel *rspModel = WMShoppingItemsPayFeeTrialCalRspModel.new;
        self.payFeeTrialCalRspModel = rspModel;
        [self updateDataSourceWithLatestShoppingCardRspModelAndPayFeeTrialCalRspModel];
        !successBlock ?: successBlock(rspModel);
        [self.view dismissLoading];
        return;
    }

    @HDWeakify(self);
    [self.storeShoppingCartDTO orderPayFeeTrialCalculateWithItems:items success:^(WMShoppingItemsPayFeeTrialCalRspModel *_Nonnull rspModel) {
        HDLog(@"门店购物车订单试算成功");
        @HDStrongify(self);
        [self.view dismissLoading];
        self.payFeeTrialCalRspModel = rspModel;

        // 更新 tableView 数据源和商品价格信息
        [self updateDataSourceWithLatestShoppingCardRspModelAndPayFeeTrialCalRspModel];
        self.refreshFlag = !self.refreshFlag;
        !successBlock ?: successBlock(rspModel);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"门店购物车订单试算失败");
        [self.view dismissLoading];
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

#pragma mark - private methods
/// 根据最新购物车数据和试算数据更新数据源和商品价格信息
- (void)updateDataSourceWithLatestShoppingCardRspModelAndPayFeeTrialCalRspModel {
    if (HDIsArrayEmpty(self.dataSource))
        return;

    for (HDTableViewSectionModel *sectionModel in self.dataSource) {
        NSArray<WMStoreGoodsItem *> *goodsList = sectionModel.list;
        BOOL hasFindGoods = false;
        for (WMStoreGoodsItem *goodsItem in goodsList) {
            if (![goodsItem isKindOfClass:WMStoreGoodsItem.class])
                continue;
            WMShoppingCartStoreItem *storeItem = self.shopppingCartStoreItem;

            // 如果是选中的（试算里面只会有选中的商品信息），从试算数据中获取最新商品价格更新本地显示
            for (WMShoppingCartPayFeeCalProductModel *feeCalProductModel in self.payFeeTrialCalRspModel.products) {
                if ([feeCalProductModel.productId isEqualToString:goodsItem.goodId]) {
                    // 找到商品之后再查找相同规格 id 的
                    for (WMStoreGoodsProductSpecification *specificationModel in goodsItem.specificationList) {
                        if ([specificationModel.specificationId isEqualToString:feeCalProductModel.specId]) {
                            goodsItem.inEffectVersionId = feeCalProductModel.inEffectVersionId;
                        }
                    }
                }
            }
            NSArray<WMShoppingCartStoreProduct *> *productList = [WMStoreDetailAdaptor shoppingCardStoreProductListInStoreItem:storeItem goodsId:goodsItem.goodId];
            if (HDIsArrayEmpty(productList)) {
                goodsItem.skuCountModelList = nil;
                continue;
            }
            goodsItem.skuCountModelList = [productList mapObjectsUsingBlock:^WMStoreGoodsSkuCountModel *_Nonnull(WMShoppingCartStoreProduct *_Nonnull productModel, NSUInteger idx) {
                WMStoreGoodsSkuCountModel *skuCountModel = WMStoreGoodsSkuCountModel.new;
                skuCountModel.skuId = productModel.goodsSkuId;
                skuCountModel.countInCart = productModel.purchaseQuantity;
                return skuCountModel;
            }];
            hasFindGoods = true;
        }
        // 如果在这一组都都没找到，跳下一组
        if (!hasFindGoods) {
            continue;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.refreshFlag = !self.refreshFlag;
    });
}

- (BOOL)isValidMenuListEmpty {
    BOOL isValidMenuListEmpty = HDIsArrayEmpty(self.currentRequestGoods);
    isValidMenuListEmpty = NO;
    return self.isMenuListEmpty || self.isTotalCountZero || isValidMenuListEmpty;
}

- (void)onceAgainOrderSuccess:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    if ([self.detailInfoModel.storeStatus.status isEqualToString:WMStoreStatusResting]) { // 休息
        [NAT showAlertWithMessage:WMLocalizedString(@"store_closed", @"The store is closed.") buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                              [alertView dismiss];
                          }];
        !successBlock ?: successBlock();
        self.onceAgainOrderNo = nil;
        return;
    }
    if (self.isStoreClosed) { // 停业
        !successBlock ?: successBlock();
        self.onceAgainOrderNo = nil;
        return;
    }

    @HDWeakify(self);
    void (^addProducts)(void) = ^() {
        @HDStrongify(self);
        [self.orderDetailDTO onceAgainOrderWithOrderNo:self.onceAgainOrderNo success:^{
            !successBlock ?: successBlock();
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            if ([rspModel.code isEqualToString:@"ME1049"]       // 包含库存不足的商品
                || [rspModel.code isEqualToString:@"ME1003"]) { // 包含下架的商品
                !successBlock ?: successBlock();
            } else {
                !failureBlock ?: failureBlock(rspModel, errorType, error);
            }
        }];
    };

    [self.storeShoppingCartDTO removeStoreGoodsFromShoppingCartWithClientType:SABusinessTypeYumNow storeNo:self.storeNo success:^(WMShoppingCartRemoveStoreGoodsRspModel *_Nonnull rspModel) {
        HDLog(@"删除整个门店商品成功");
        addProducts();
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"删除整个门店商品失败");
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}
// 更新起送价
- (void)updateRequiredPrice {
    BOOL diff = (self.detailInfoModel.minOrderAmount.cent.intValue != self.detailInfoModel.oldMinOrderAmount.cent.intValue);
    self.requiredDiffStr = diff ? self.detailInfoModel.priceRemark.desc : nil;
    SAMoneyModel *requiredPrice = self.detailInfoModel.minOrderAmount.copy;
    for (WMStoreDetailPromotionModel *promotion in self.payFeeTrialCalRspModel.promotions) {
        if (promotion.requiredPrice.cent.integerValue > requiredPrice.cent.integerValue) {
            requiredPrice = promotion.requiredPrice.copy;
        }
    }
    if (!HDIsObjectNil(self.requiredPrice) && requiredPrice.cent.integerValue > self.requiredPrice.cent.integerValue && self.needShowRequiredPriceChangeToast) {
        [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"IBjwzhJw", @"该优惠活动商品的起送价为%@"), requiredPrice.thousandSeparatorAmount] type:HDTopToastTypeInfo];
    }
    self.needShowRequiredPriceChangeToast = false;
    self.requiredPrice = requiredPrice;
}

#pragma mark - setter
- (void)setDetailInfoModel:(WMStoreDetailRspModel *)detailInfoModel {
    _detailInfoModel = detailInfoModel;
    [self updateRequiredPrice];
}

- (void)setPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel {
    _payFeeTrialCalRspModel = payFeeTrialCalRspModel;
    [self updateRequiredPrice];
}

#pragma mark - lazy load
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.array; });
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

- (WMStoreDetailDTO *)storeDetailDTO {
    if (!_storeDetailDTO) {
        _storeDetailDTO = WMStoreDetailDTO.new;
    }
    return _storeDetailDTO;
}

- (WMOrderDetailDTO *)orderDetailDTO {
    if (!_orderDetailDTO) {
        _orderDetailDTO = WMOrderDetailDTO.new;
    }
    return _orderDetailDTO;
}

- (WMCouponsDTO *)couponDTO {
    if (!_couponDTO) {
        _couponDTO = WMCouponsDTO.new;
    }
    return _couponDTO;
}

- (WMStoreFavouriteDTO *)storeFavouriteDTO {
    if (!_storeFavouriteDTO) {
        _storeFavouriteDTO = WMStoreFavouriteDTO.new;
    }
    return _storeFavouriteDTO;
}

- (CMNetworkRequest *)getMenuListRequest {
    if (!_getMenuListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        // 2.5.0版本接口
        request.requestURI = @"/takeaway-product/app/user/menu";
        request.isNeedLogin = false;
        _getMenuListRequest = request;
    }
    return _getMenuListRequest;
}

- (CMNetworkRequest *)getGoodsListRequest {
    if (!_getGoodsListRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
//        request.requestURI = @"/takeaway-product/app/user/product/list";
        request.requestURI = @"/takeaway-product/app/user/product/list-v2";
        request.isNeedLogin = false;
        _getGoodsListRequest = request;
    }
    return _getGoodsListRequest;
}

- (CMNetworkRequest *)getMenuIdRequest {
    if (!_getMenuIdRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-product/app/user/get-menu-id";
        request.isNeedLogin = false;
        _getMenuIdRequest = request;
    }
    return _getMenuIdRequest;
}

- (NSMutableArray<NSString *> *)alreadyRequestMenuIds {
    if (!_alreadyRequestMenuIds) {
        _alreadyRequestMenuIds = [NSMutableArray array];
    }
    return _alreadyRequestMenuIds;
}

- (SANoDataCellModel *)noDateCellModel {
    if (!_noDateCellModel) {
        _noDateCellModel = SANoDataCellModel.new;
    }
    return _noDateCellModel;
}

@end
