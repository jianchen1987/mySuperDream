//
//  SAAppLaunchToDoService.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppLaunchToDoService.h"
#import "LKDataRecord.h"
#import "SAAddressCacheAdaptor.h"
#import "SAAddressModel.h"
#import "SAAddressZoneModel.h"
#import "SAApolloManager.h"
#import "SAAppConfigDTO.h"
#import "SAAppStartUpConfig.h"
#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import "SAChooseLanguageManager.h"
#import "SAChooseZoneDTO.h"
#import "SAContactModel.h"
#import "SALocationUtil.h"
#import "SALoginAdManager.h"
#import "SANotificationConst.h"
#import "SAQueryAvaliableChannelRspModel.h"
#import "SARspModel.h"
#import "SAStartupAdDTO.h"
#import "SAStartupAdManager.h"
#import "SAStartupAdModel.h"
#import "SAUserCenterDTO.h"
#import "SAWOWTokenDTO.h"
#import "SAWOWTokenModel.h"
#import "SAWalletDTO.h"
#import "SAWindowManager.h"
#import "SAWriteDateReadableModel.h"
#import "TNAppConfigDTO.h"
#import "TNGlobalData.h"
#import "TNMicroShopDTO.h"
#import "WMGetUserShoppingCartLocalRspModel.h"
#import "WMShoppingCartDTO.h"
#import "WMStoreShoppingCartDTO.h"
#import <Contacts/Contacts.h>
#import <HDKitCore/HDKitCore.h>
#import <HDServiceKit/HDLocationManager.h>
#import <KSInstantMessagingKit/KSCall.h>
#import "SAUserViewModel.h"
#import "WMQueryMerchantFilterCategoryRspModel.h"


@interface SAAppLaunchToDoService ()
/// App 配置 VM
@property (nonatomic, strong) SAAppConfigDTO *appConfigDTO;
/// 门店购物车 DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 购物车 DTO
@property (nonatomic, strong) WMShoppingCartDTO *shoppingCartDTO;
/// 支付渠道查询
@property (nonatomic, strong) SAWalletDTO *paymentToolsQueryDTO;
/// 用户中心
@property (nonatomic, strong) SAUserCenterDTO *userCenterDTO;
/// WOW口令
@property (nonatomic, strong) SAWOWTokenDTO *wowTokenDTO;
/// 电商卖家DTO
@property (strong, nonatomic) TNMicroShopDTO *microShopDTO;
///城市编码
@property (nonatomic, strong) SAChooseZoneDTO *chooseZoneDTO;
///< currentlyAddress
@property (nonatomic, strong) SAAddressModel *currentlyAddress;
/// 广告DTO
@property (nonatomic, strong) SAStartupAdDTO *adDTO;
/// 电商配置DTO
@property (strong, nonatomic) TNAppConfigDTO *tinhnowConfigDto;

@end


@implementation SAAppLaunchToDoService

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SAAppLaunchToDoService *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];

        // 监听登录成功的通知
        [NSNotificationCenter.defaultCenter addObserver:instance selector:@selector(userLoginSuccessHandler) name:kNotificationNameLoginSuccess object:nil];
        [NSNotificationCenter.defaultCenter addObserver:instance selector:@selector(languageDidChanged) name:kNotificationNameLanguageChanged object:nil];
        //监听地址变化的通知
        [NSNotificationCenter.defaultCenter addObserver:instance selector:@selector(locationDidChanged) name:kNotificationNameLocationChanged object:nil];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLanguageChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
}

- (void)performAll {
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self parsingWOWToken];
//TODO: 用当前位置查询
        [self queryAppStartupConfig];
        [self uploadUserContactsCompletion:nil];
        [self queryTinhnowUserSellerData];
        [self queryBlueAndGreenFlag];
        // 电商因为历史原因  安卓旧版动态配置导航栏数据存在闪退风险 电商单独拉取导航栏
        [self queryAppTinhNowTabBarConfigList];

        [self queryEarnPointBanner];
        //查询用户信息
        [self queryUserInfo];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KSCallManager needShowCallViewWithoperatorNo:SAUser.shared.operatorNo];
    });
}

- (void)performAllAfterChooseLanguage {
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self parsingWOWToken];
        [self startUpDataRecord];
    }];
}

- (void)enterForeground {
    [self parsingWOWToken];
    dispatch_async(dispatch_get_main_queue(), ^{
        //走这个方法必然在前台
        [KSCallKitCenter.sharedInstance enableCallKit:NO];
        [KSCallManager needShowCallViewWithoperatorNo:SAUser.shared.operatorNo];
    });
}

#pragma mark - Notification
- (void)userLoginSuccessHandler {
    HDLog(@"用户登录");
    // 判断本地购物车数据是否需要上传
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = [SACacheManager.shared objectForKey:kCacheKeyLocalShoppingCart type:SACacheTypeDocumentPublic];
    if (!HDIsObjectNil(localShoppingCartRspModel)) {
        NSMutableArray<WMShoppingCartStoreQueryProduct *> *productList = [NSMutableArray array];
        for (WMShoppingCartStoreQueryItem *queryStoreItem in localShoppingCartRspModel.list) {
            [productList addObjectsFromArray:queryStoreItem.shopCartItemBOS];
        }

        [self uploadProductListToServer:productList index:0 completion:^{
            HDLog(@"同步购物车数据成功，共添加 %zd 条购物车数据", productList.count);
            // 删除本地购物车数据
            [SACacheManager.shared removeObjectForKey:kCacheKeyLocalShoppingCart type:SACacheTypeDocumentPublic];

            // 查询购物车
            [self.shoppingCartDTO getUserShoppingCartInfoWithClientType:SABusinessTypeYumNow success:nil failure:nil];
        }];
    }
    // 登陆后重新查一下
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        //重新查询用户卖家身份信息
        [self queryTinhnowUserSellerData];
        [self queryBlueAndGreenFlag];
    }];
}

- (void)languageDidChanged {
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        // TODO: 用当前选择的地址 或当前位置去查
        [self queryAppStartupConfig]; //重新获取配置文件
        [self queryAppTinhNowTabBarConfigList];
        [self queryAppTinhNowHomeDynamicFunctionList];
    }];
}

- (void)locationDidChanged {
    //节流5秒后执行
    dispatch_throttle_by_type(5, HDFunctionThrottleTypeDelayAndInvokeLast, @"superapp.getLatestLaunchAds", ^{
        @HDWeakify(self);
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            @HDStrongify(self);
            if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
                //最新位置
                CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
                if (HDIsObjectNil(self.currentlyAddress)) {
                    self.currentlyAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeMaster];
                }
                // 当前位置空，是第一次，直接赋值
                if (HDIsObjectNil(self.currentlyAddress)) {
                    //                    HDLog(@"no last lcation record，重新解析经纬度，拉取新启动页广告");
                    //解释当前坐标
                    [self resolveCurrentAddress:coordinate2D];
                } else {
                    //之前位置
                    CLLocation *fromeL = [[CLLocation alloc] initWithLatitude:self.currentlyAddress.lat.doubleValue longitude:self.currentlyAddress.lon.doubleValue];
                    //最新位置
                    CLLocation *toL = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
                    //                    HDLog(@"\n%@\n%@",fromeL,toL);

                    // 距离是否大于200
                    if ([HDLocationUtils distanceFromLocation:fromeL toLocation:toL] > 200) {
                        //                        HDLog(@"与last location > 200M，重新拉取新启动页广告");
                        //获取区域code

                        [self resolveCurrentAddress:coordinate2D];
                    } else {
#ifdef DEBUG
                        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"kHDAuxiliaryToolOpenAdsKey"] boolValue]) {
                            HDLog(@"强制走广告刷新接口");
                            [self resolveCurrentAddress:coordinate2D];
                        } else {
                            HDLog(@"不强制走广告刷新接口");
                        }
#endif
                        //                        HDLog(@"与last location < 200M，忽略");
                    }
                }
            }
        }];
    });
}

- (void)uploadProductListToServer:(NSArray<WMShoppingCartStoreQueryProduct *> *)list index:(NSUInteger)index completion:(void (^)(void))completion {
    if (index >= list.count) {
        !completion ?: completion();
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameUploadOfflineShoppingGoodsCompleted object:nil];
        return;
    }
    WMShoppingCartStoreQueryProduct *product = list[index];

    @HDWeakify(self);
    [self.storeShoppingCartDTO addGoodsToShoppingCartWithClientType:product.businessType
                                                           addDelta:product.purchaseQuantity
                                                            goodsId:product.goodsId
                                                         goodsSkuId:product.goodsSkuId
                                                        propertyIds:[product.propertyValues componentsSeparatedByString:@","]
                                                            storeNo:product.storeNo
                                                  inEffectVersionId:product.inEffectVersionId
                                                            success:^(WMShoppingCartAddGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"上传成功");
            @HDStrongify(self);
            // 成功一个减一个
            [self.storeShoppingCartDTO minusGoodsFromLocalShopppingCartWithClientType:product.businessType
                                                                          deleteDelta:product.purchaseQuantity
                                                                           goodsSkuId:product.goodsSkuId
                                                                       propertyValues:[product.propertyValues componentsSeparatedByString:@","]
                                                                              storeNo:product.storeNo];
            // 下一个
            const NSUInteger newIndex = index + 1;
            [self uploadProductListToServer:list index:newIndex completion:completion];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"上传失败");
            @HDStrongify(self);
            // 下一个
            const NSUInteger newIndex = index + 1;
            [self uploadProductListToServer:list index:newIndex completion:completion];
        }];
}

#pragma mark - 统一获取配置
/// 查询APP启动需要拉取的配置
- (void)queryAppStartupConfig {
    [self.appConfigDTO queryAppStartupConfigWithSuccess:^(SAAppStartUpConfig *_Nonnull startupConfig) {
        // 处理TabBar配置
        [self splitTabBarConfig:startupConfig.tabbars];
        // 处理金刚区配置
        [self splitKingKongConfig:startupConfig.kingkongArea];
        // 处理支付工具配置
        [self splitPaymentToolConfig:startupConfig.paymentTools];
        // 保存阿波罗配置
        if (startupConfig.apollo) {
            [SAApolloManager saveApolloConfigs:startupConfig.apollo];
        }
        //保存登录广告
        if (startupConfig.loginPage) {
            [SALoginAdManager saveLoginAdConfigs:startupConfig.loginPage];
        }
        // 启动广告
        [SAStartupAdManager saveAdModels:startupConfig.advertising];
        
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"获取app启动配置失败：%zd / %@", error.code, error.localizedDescription);
    }];
}

// 拆分处理tabBar配置
- (void)splitTabBarConfig:(NSArray<SAAppStartUpTabbarConfig *> *)tabBarConfigs {
    for (SAAppStartUpTabbarConfig *tabBarConfig in tabBarConfigs) {
        if ([tabBarConfig.businessLine isEqualToString:SAClientTypeMaster]) {
            [self processTabBarDataWithRemoteList:tabBarConfig.list cacheKey:kCacheKeyAppTabBarConfigList notificationName:kNotificationNameSuccessGetAppTabBarConfigList];
            
        } else if ([tabBarConfig.businessLine isEqualToString:SAClientTypeYumNow]) {
            [self processTabBarDataWithRemoteList:tabBarConfig.list cacheKey:kCacheKeyDeliveryAppTabBarConfigList notificationName:kNotificationNameSuccessGetDeliveryAppTabBarConfigList];
            
        } else if ([tabBarConfig.businessLine isEqualToString:SAClientTypeTinhNow]) {
            ///电商这个版本不用聚合接口  不处理tabBar  tinhnow3.4.1-海外购  版本处理
            //            [self processTabBarDataWithRemoteList:tabBarConfig.list cacheKey:kCacheKeyTinhNowAppTabBarConfigList notificationName:kNotificationNameSuccessGetTinhNowAppTabBarConfigList];
        }
    }
}

// 拆分处理金刚区配置
- (void)splitKingKongConfig:(NSArray<SAAppStartUpKingkongAreaConfig *> *)kingKongConfigs {
    for (SAAppStartUpKingkongAreaConfig *kingKongConfig in kingKongConfigs) {
        if ([kingKongConfig.businessLine isEqualToString:SAClientTypeYumNow]) {
            //TODO: 外卖已经不用，可择机移除
            [self processKingKongAreaDataWithList:kingKongConfig.list cacheKey:kCacheKeyDeliveryAppHomeDynamicFunctionList
                                 notificationName:kNotificationNameSuccessGetDeliveryAppHomeDynamicFunctionList
                                       completion:nil];
        } else if ([kingKongConfig.businessLine isEqualToString:SAClientTypeTinhNow]) {
            [self processKingKongAreaDataWithList:kingKongConfig.list cacheKey:kCacheKeyTinhNowAppHomeDynamicFunctionList notificationName:kNotificationNameSuccessGetTinhNowAppHomeDynamicFunctionList
                                       completion:nil];
        }
    }
}

// 拆分处理支付工具配置
- (void)splitPaymentToolConfig:(NSArray<SAAppStartUpPaymentToolConfig *> *)paymentToolConfigs {
    for (SAAppStartUpPaymentToolConfig *paymentToolConfig in paymentToolConfigs) {
        if ([paymentToolConfig.businessLine isEqualToString:SAClientTypeYumNow]) {
            //TODO: 团购还在用，可择机移除
            [self processPaymentToolDataWithList:paymentToolConfig.list cacheKey:kCacheKeyYumNowPaymentToolsCache];
        } else if ([paymentToolConfig.businessLine isEqualToString:SAClientTypeTinhNow]) {
            //TODO: 不在使用，可择机移除
            [self processPaymentToolDataWithList:paymentToolConfig.list cacheKey:kCacheKeyTinhNowPaymentToolsCache];
        }
    }
}


#pragma mark - 单独获取配置

/// WOWNOW TabBar配置
- (void)queryAppTabBarConfigList {
    @HDWeakify(self);
    [self.appConfigDTO queryTabBarConfigListWithType:SAClientTypeMaster success:^(NSArray<SATabBarItemConfig *> *_Nonnull remoteList) {
        @HDStrongify(self);
        [self processTabBarDataWithRemoteList:remoteList cacheKey:kCacheKeyAppTabBarConfigList notificationName:kNotificationNameSuccessGetAppTabBarConfigList];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"获取 %@ tabbar 配置失败：%zd / %@", SAClientTypeMaster, error.code, error.localizedDescription);
    }];
}

/// 查询外卖 TabBar配置
- (void)queryAppDeliveryTabBarConfigList {
    @HDWeakify(self);
    [self.appConfigDTO queryTabBarConfigListWithType:SAClientTypeYumNow success:^(NSArray<SATabBarItemConfig *> *_Nonnull remoteList) {
        @HDStrongify(self);
        [self processTabBarDataWithRemoteList:remoteList cacheKey:kCacheKeyDeliveryAppTabBarConfigList notificationName:kNotificationNameSuccessGetDeliveryAppTabBarConfigList];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"获取 %@ tabbar 配置失败：%zd / %@", SAClientTypeYumNow, error.code, error.localizedDescription);
    }];
}

/// 查询TinhNow TabBar配置
- (void)queryAppTinhNowTabBarConfigList {
    @HDWeakify(self);
    [self.tinhnowConfigDto queryTinhnowTabBarConfigListSuccess:^(NSArray<SATabBarItemConfig *> *_Nonnull remoteList) {
        @HDStrongify(self);
        [self processTabBarDataWithRemoteList:remoteList cacheKey:kCacheKeyTinhNowAppTabBarConfigList notificationName:kNotificationNameSuccessGetTinhNowAppTabBarConfigList];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"获取 %@ tabbar 配置失败：%zd / %@", SAClientTypeTinhNow, error.code, error.localizedDescription);
    }];
}

/// 查询TinhNow金刚区配置
- (void)queryAppTinhNowHomeDynamicFunctionList {
    @HDWeakify(self);
    [self.appConfigDTO queryKingKongAreaConfigListWithType:SAClientTypeTinhNow success:^(NSArray<SAKingKongAreaItemConfig *> *_Nonnull list) {
        @HDStrongify(self);
        [self processKingKongAreaDataWithList:list cacheKey:kCacheKeyTinhNowAppHomeDynamicFunctionList notificationName:kNotificationNameSuccessGetTinhNowAppHomeDynamicFunctionList completion:nil];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"获取 %@ 金刚区配置失败：%zd / %@", SAClientTypeTinhNow, error.code, error.localizedDescription);
    }];
}


/// 查询蓝绿标签
- (void)queryBlueAndGreenFlag {
    if (![SAUser hasSignedIn]) {
        return;
    }
    [self.appConfigDTO queryBlueAndGreenFlagCompletion:^(NSString *_Nullable flag) {
        if (HDIsStringNotEmpty(flag)) {
            HDLog(@"拿到蓝绿标识(%@)，存入缓存", flag);
            [SACacheManager.shared setObject:flag forKey:KBlueAndGreenFlag type:SACacheTypeCachePublic];
        } else {
            [SACacheManager.shared setObject:@"" forKey:KBlueAndGreenFlag type:SACacheTypeCachePublic];
        }
    }];
}

//解释当前经纬度
- (void)resolveCurrentAddress:(CLLocationCoordinate2D)coordinate2D {
    @HDWeakify(self);
    [SALocationUtil transferCoordinateToAddress:coordinate2D completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary *_Nullable addressDictionary) {
        @HDStrongify(self);
        SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
        addressModel.lat = @(coordinate2D.latitude);
        addressModel.lon = @(coordinate2D.longitude);
        addressModel.address = address;
        addressModel.consigneeAddress = consigneeAddress;
        addressModel.fromType = SAAddressModelFromTypeLocate;
        [self fuzzyQueryZoneListWithAddressModel:addressModel];
    }];
}

/// 查询用户当前地区code
- (void)fuzzyQueryZoneListWithAddressModel:(SAAddressModel *)addressModel {
    // 获取城市编码
    @HDWeakify(self);
    [self.chooseZoneDTO fuzzyQueryZoneListWithoutDefaultWithProvince:addressModel.city
                                                            district:addressModel.subLocality
                                                             commune:nil
                                                            latitude:addressModel.lat
                                                           longitude:addressModel.lon
                                                             success:^(SAAddressZoneModel *_Nonnull zoneModel) {
                                                                 @HDStrongify(self);
                                                                 //缓存当前用户地址
                                                                 addressModel.districtCode = zoneModel.code;


                                                                [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeMaster addressModel:addressModel];
                                                                 self.currentlyAddress = addressModel;
                                                                 //请求不同地区广告
                                                                 [self.adDTO queryAdSuccess:^(NSArray<SAStartupAdModel *> *_Nonnull advertising) {
                                                                     //更新启动广告
                                                                     [SAStartupAdManager saveAdModels:advertising];
                                                                 } failure:nil];
                                                             }
                                                             failure:nil];
}

#pragma mark - 数据处理
/// 处理金刚区数据
- (void)processKingKongAreaDataWithList:(NSArray<SAKingKongAreaItemConfig *> *)list
                               cacheKey:(NSString *)cacheKey
                       notificationName:(NSNotificationName)notificationName
                             completion:(void (^)(void))completion {
    // 异步处理数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            // 存之前先判断功能引导是否需要显示，设置该标志再缓存
            NSArray<SAKingKongAreaItemConfig *> *oldList = [SACacheManager.shared objectForKey:cacheKey type:SACacheTypeDocumentPublic relyLanguage:YES];

            if (!oldList || oldList.count <= 0) {
                [list enumerateObjectsUsingBlock:^(SAKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    // 没配文字不显示
                    obj.hasUpdated = HDIsStringNotEmpty(obj.guideDesc.desc);
                }];
            } else {
                NSArray<NSString *> *oldIdentifierArr = [oldList mapObjectsUsingBlock:^id _Nonnull(SAKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx) {
                    return obj.identifier;
                }];
                [list enumerateObjectsUsingBlock:^(SAKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    // 新增的项
                    if (![oldIdentifierArr containsObject:obj.identifier]) {
                        obj.hasUpdated = true;
                    } else {
                        SAKingKongAreaItemConfig *oldObj;
                        NSArray *filtered = [oldList
                            filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SAKingKongAreaItemConfig *_Nullable evaluatedObject, NSDictionary<NSString *, id> *_Nullable bindings) {
                                return [evaluatedObject.identifier isEqualToString:obj.identifier];
                            }]];
                        oldObj = filtered.count > 0 ? filtered.firstObject : nil;
                        if (oldObj) {
                            // 如果已经显示过
                            if (oldObj.hasDisplayedNewFunctionGuide) {
                                BOOL hasUpdated = HDIsStringNotEmpty(obj.guideDesc.desc) && obj.funcGuideVersion > oldObj.funcGuideVersion;
                                obj.hasUpdated = hasUpdated;
                                obj.hasDisplayedNewFunctionGuide = !hasUpdated;
                            } else {
                                // 没显示过
                                obj.hasUpdated = HDIsStringNotEmpty(obj.guideDesc.desc);
                            }
                        }
                    }
                }];
            }
            [SACacheManager.shared setObject:list forKey:cacheKey type:SACacheTypeDocumentPublic relyLanguage:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                } else {
                    // 发送通知
                    [NSNotificationCenter.defaultCenter postNotificationName:notificationName object:nil];
                }
            });
        }
    });
}
/// 处理TabBar数据
- (void)processTabBarDataWithRemoteList:(NSArray<SATabBarItemConfig *> *)remoteList cacheKey:(NSString *)cacheKey notificationName:(NSNotificationName)notificationName {
    // 过滤掉无效配置
    NSArray<SATabBarItemConfig *> *list = [remoteList mapObjectsUsingBlock:^id _Nonnull(SATabBarItemConfig *_Nonnull obj, NSUInteger idx) {
        NSString *className = obj.loadPageName;
        Class vcClass = NSClassFromString(className);
        if (!vcClass) {
            return nil;
        } else {
            return obj;
        }
    }];
    // 排序
    list = [list sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(SATabBarItemConfig *_Nonnull obj1, SATabBarItemConfig *_Nonnull obj2) {
        return obj1.index > obj2.index ? NSOrderedDescending : NSOrderedAscending;
    }];
    // 取前五个
    list = [list subarrayWithRange:NSMakeRange(0, 5)];
    // 异步处理数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            // 存之前先判断功能引导是否需要显示，设置该标志再缓存
            NSArray<SATabBarItemConfig *> *oldList = [SACacheManager.shared objectForKey:cacheKey type:SACacheTypeDocumentPublic relyLanguage:YES];
            if (!oldList || oldList.count <= 0) {
                [list enumerateObjectsUsingBlock:^(SATabBarItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    // 没配文字不显示
                    obj.hasUpdated = HDIsStringNotEmpty(obj.guideDesc.desc);
                }];
            } else {
                NSArray<NSString *> *oldIdentifierArr = [oldList mapObjectsUsingBlock:^id _Nonnull(SATabBarItemConfig *_Nonnull obj, NSUInteger idx) {
                    return obj.identifier;
                }];
                [list enumerateObjectsUsingBlock:^(SATabBarItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    // 新增的项
                    if (![oldIdentifierArr containsObject:obj.identifier]) {
                        obj.hasUpdated = true;
                    } else {
                        SATabBarItemConfig *oldObj;
                        NSArray *filtered = [oldList
                            filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SATabBarItemConfig *_Nullable evaluatedObject, NSDictionary<NSString *, id> *_Nullable bindings) {
                                return [evaluatedObject.identifier isEqualToString:obj.identifier];
                            }]];
                        oldObj = filtered.count > 0 ? filtered.firstObject : nil;
                        if (oldObj) {
                            // 如果已经显示过
                            if (oldObj.hasDisplayedNewFunctionGuide) {
                                BOOL hasUpdated = HDIsStringNotEmpty(obj.guideDesc.desc) && obj.funcGuideVersion > oldObj.funcGuideVersion;
                                obj.hasUpdated = hasUpdated;
                                obj.hasDisplayedNewFunctionGuide = !hasUpdated;
                            } else {
                                // 没显示过
                                obj.hasUpdated = HDIsStringNotEmpty(obj.guideDesc.desc);
                            }
                        }
                    }
                }];
            }
            [SACacheManager.shared setObject:list forKey:cacheKey type:SACacheTypeDocumentPublic relyLanguage:YES];
            /// 导航栏动态化之后，通知由各自导航栏启动时发起
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                        // 发送通知
            //                        [NSNotificationCenter.defaultCenter postNotificationName:notificationName object:nil];
            //                    });
        }
    });
}
/// 处理支付工具配置
- (void)processPaymentToolDataWithList:(NSArray<SAPaymentChannelModel *> *)list cacheKey:(NSString *)cacheKey {
    NSMutableArray<NSString *> *channels = [[NSMutableArray alloc] initWithCapacity:5];
    for (SAPaymentChannelModel *model in list) {
        if (HDWalletPaymethodBalance == model.code) {
            [channels addObject:@"ic_channel_wallet"];
        }
        if (HDWalletPaymethodWechat == model.code) {
            [channels addObject:@"ic_channel_wechat"];
        }
        if (HDWalletPaymethodABAPay == model.code) {
            [channels addObject:@"ic_channel_aba"];
        }
        if (HDWalletPaymethodCreditCard == model.code) {
            [channels addObject:@"ic_channel_visa"];
            [channels addObject:@"ic_channel_master"];
            [channels addObject:@"ic_channel_union"];
        }
        if (HDWalletPaymethodWingPay == model.code) {
            [channels addObject:@"ic_channel_wing"];
        }
        if (HDWalletPaymethodPrince == model.code) {
            [channels addObject:@"ic_channel_prince"];
        }
    }
    [SACacheManager.shared setObject:channels forKey:cacheKey type:SACacheTypeCachePublic];
}

#pragma mark - WOW口令
/// 解析WOW口令
- (void)parsingWOWToken {
    // 选择语言页面，直接返回
    if ([SAChooseLanguageManager isVisible]) {
        return;
    }

    NSString *switchPasteboard = [SAAppSwitchManager.shared switchForKey:SAAppSwitchPasteboardRead];
    if (HDIsStringNotEmpty(switchPasteboard) && [switchPasteboard.lowercaseString isEqualToString:@"off"]) {
        // 不读取粘贴板
        return;
    }

    NSString *pasteboardText = [UIPasteboard generalPasteboard].string;
    // 不匹配WOW口令正则，直接返回
    NSString *wowToken = [pasteboardText hd_stringMatchedByPattern:@"WOW.*!"];
    if (HDIsStringEmpty(wowToken)) {
        return;
    }
    wowToken = [wowToken substringWithRange:NSMakeRange(3, wowToken.length - 4)];
    [self.wowTokenDTO parsingWOWTokenWithToken:wowToken success:^(SAWOWTokenModel *_Nonnull wowTokenModel) {
        [UIPasteboard generalPasteboard].string = @"";
        [SAWindowManager openUrl:wowTokenModel.link withParameters:nil];
    } failure:nil];
}

/// 记录首次打开app
/// 同时记录邀请关系
- (void)startUpDataRecord {
    // 从粘贴板获取邀请信息
    // superapp://h5.lifekh.com/wakeup?activityNo=1507172209996230656&invitedCode=46822WN
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    NSString *pasteboardText = [UIPasteboard generalPasteboard].string;
    NSURL *url = [NSURL URLWithString:pasteboardText];
    if (url && ([url.scheme.lowercaseString isEqualToString:@"superapp"] || [url.host containsString:@"lifekh"])) {
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSArray<NSURLQueryItem *> *activityNo = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
            return [item.name isEqualToString:@"activityNo"];
        }];
        if (activityNo.count) {
            [tmp setObject:activityNo.firstObject.value forKey:@"activityNo"];
            [NSUserDefaults.standardUserDefaults setObject:activityNo.firstObject.value forKey:@"activityNo"];
        }

        NSArray<NSURLQueryItem *> *invitedCode = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
            return [item.name isEqualToString:@"invitedCode"];
        }];
        if (invitedCode.count) {
            [tmp setObject:invitedCode.firstObject.value forKey:@"invitedCode"];
            [NSUserDefaults.standardUserDefaults setObject:invitedCode.firstObject.value forKey:@"invitedCode"];
        }

        NSArray<NSURLQueryItem *> *channel = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
            return [item.name isEqualToString:@"channel"];
        }];
        if (channel.count) {
            [tmp setObject:channel.firstObject.value forKey:@"channel"];
            [NSUserDefaults.standardUserDefaults setObject:channel.firstObject.value forKey:@"shareChannel"];
        }

        NSArray<NSURLQueryItem *> *shortID = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
            return [item.name isEqualToString:@"shortID"];
        }];

        if (shortID.count) {
            [SACacheManager.shared setObject:shortID.firstObject.value forKey:kCacheKeyShortIDTrace duration:60 * 60 * 24 type:SACacheTypeDocumentPublic];
        }
    }

    [LKDataRecord.shared traceFirstOpenWithExt:tmp];
}

#pragma mark - 通讯录
// 老板需求，上传用户通讯录
- (void)uploadUserContactsCompletion:(void (^)(void))completion {
    // 如果未登录，返回
    if (![SAUser hasSignedIn]) {
        !completion ?: completion();
        return;
    }
    // 开关状态是关闭，返回
    NSString *uploadSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchUploadContacts];
    if (HDIsStringEmpty(uploadSwitch) || [uploadSwitch isEqualToString:@"off"]) {
        return;
    }

    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (CNAuthorizationStatusAuthorized == status) {
        NSArray *kesToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactMiddleNameKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:kesToFetch];
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        NSMutableArray<SAContactModel *> *contacts = [[NSMutableArray alloc] initWithCapacity:20];

        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact *_Nonnull contact, BOOL *_Nonnull stop) {
            for (CNLabeledValue *phone in contact.phoneNumbers) {
                SAContactModel *model = SAContactModel.new;
                CNPhoneNumber *phoneNumber = phone.value;
                model.phone = phoneNumber.stringValue;
                model.name = [NSString stringWithFormat:@"%@%@%@",
                                                        HDIsStringEmpty(contact.familyName) ? @"" : contact.familyName,
                                                        HDIsStringEmpty(contact.middleName) ? @"" : contact.middleName,
                                                        HDIsStringEmpty(contact.givenName) ? @"" : contact.givenName];
                [contacts addObject:model];
            }
        }];

        [self uploadContactsWithArray:contacts];
    } else {
        !completion ?: completion();
    }
}

- (void)uploadContactsWithArray:(NSArray<SAContactModel *> *)contacts {
    NSArray<SAContactModel *> *uploadedCache = [SACacheManager.shared objectForKey:kCacheKeyUserContactListCache type:SACacheTypeCachePublic];
    NSArray<SAContactModel *> *filterContacts = [contacts hd_filterWithBlock:^BOOL(SAContactModel *_Nonnull item) {
        return ![uploadedCache containsObject:item];
    }];
    if (!filterContacts.count) {
        HDLog(@"没有可上传的内容");
        return;
    }
    // 分组 每次上传20条
    NSArray<NSArray *> *groupArr = [filterContacts hd_splitArrayWithEachCount:20];
    dispatch_semaphore_t sema = dispatch_semaphore_create(1); // 每次请求1组
    for (NSUInteger i = 0; i < groupArr.count; i++) {
        dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC))); // 等10秒
        HDLog(@"开始上传第%zd组", i);
        [self.userCenterDTO uploadUserContactsWithDataArray:groupArr[i] operatorNo:SAUser.shared.operatorNo success:^(NSArray<SAContactModel *> *uploaded) {
            HDLog(@"上传成功");
            NSArray<SAContactModel *> *uploadedCache = [SACacheManager.shared objectForKey:kCacheKeyUserContactListCache type:SACacheTypeCachePublic];
            NSMutableArray<SAContactModel *> *tmp = [[NSMutableArray alloc] initWithArray:uploadedCache];
            [tmp addObjectsFromArray:uploaded];
            [SACacheManager.shared setObject:tmp forKey:kCacheKeyUserContactListCache type:SACacheTypeCachePublic];

            dispatch_semaphore_signal(sema); // 释放
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"上传失败");
            dispatch_semaphore_signal(sema); // 释放
        }];
    }
}

#pragma mark -电商查询用户卖家信息
- (void)queryTinhnowUserSellerData {
    if (![SAUser hasSignedIn]) {
        return;
    }
    @HDWeakify(self);
    [self.microShopDTO queryMyMicroShopInfoDataSuccess:^(TNSeller *_Nonnull info) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(info.supplierId)) {
            //获取加价策略
            [self.microShopDTO querySellPricePolicyWithSupplierId:info.supplierId success:^(TNMicroShopPricePolicyModel *_Nonnull policyModel) {
                [TNGlobalData shared].seller.pricePolicyModel = policyModel;
            } failure:nil];
        }
    } failure:nil];
}

#pragma mark -查询Banner类型为未达门槛和已达门槛的启用中banner
- (void)queryEarnPointBanner {
    if (![SAUser hasSignedIn]) {
        return;
    }
    [self.userCenterDTO queryEarnPointBannerSuccess:^(SAEarnPointBannerRspModel *_Nonnull rspModel) {
        [SACacheManager.shared setObject:rspModel forKey:kCacheKeyEarnPointBannerCache duration:60 * 60 * 24 type:SACacheTypeCachePublic];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"获取查询Banner类型为未达门槛和已达门槛的启用中banner数据失败");
    }];
}

- (void)queryUserInfo {
    if (![SAUser hasSignedIn]) {
        return;
    }
    NSString *needUpdateUserInfo = [SAAppSwitchManager.shared switchForKey:SAAppSwitchOpenAppUpdateUserInfo];
    if (!HDIsObjectNil(needUpdateUserInfo) && HDIsStringNotEmpty(needUpdateUserInfo) && [needUpdateUserInfo.lowercaseString isEqualToString:@"on"]) {
        [[SAUserViewModel new] getUserInfoWithOperatorNo:SAUser.shared.operatorNo success:^(SAGetUserInfoRspModel *_Nonnull rspModel) {
            [SAUser.shared saveWithUserInfo:rspModel];
        } failure:nil];
    }
}

#pragma mark - lazy load
- (SAAppConfigDTO *)appConfigDTO {
    return _appConfigDTO ?: ({ _appConfigDTO = SAAppConfigDTO.new; });
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

- (WMShoppingCartDTO *)shoppingCartDTO {
    if (!_shoppingCartDTO) {
        _shoppingCartDTO = WMShoppingCartDTO.new;
    }
    return _shoppingCartDTO;
}
/** @lazy  */
- (SAWalletDTO *)paymentToolsQueryDTO {
    if (!_paymentToolsQueryDTO) {
        _paymentToolsQueryDTO = [[SAWalletDTO alloc] init];
    }
    return _paymentToolsQueryDTO;
}
/** @lazy usercenter */
- (SAUserCenterDTO *)userCenterDTO {
    if (!_userCenterDTO) {
        _userCenterDTO = [[SAUserCenterDTO alloc] init];
    }
    return _userCenterDTO;
}

- (SAWOWTokenDTO *)wowTokenDTO {
    if (!_wowTokenDTO) {
        _wowTokenDTO = SAWOWTokenDTO.new;
    }
    return _wowTokenDTO;
}
/** @lazy microShopDTO */
- (TNMicroShopDTO *)microShopDTO {
    if (!_microShopDTO) {
        _microShopDTO = [[TNMicroShopDTO alloc] init];
    }
    return _microShopDTO;
}

- (SAChooseZoneDTO *)chooseZoneDTO {
    if (!_chooseZoneDTO) {
        _chooseZoneDTO = SAChooseZoneDTO.new;
    }
    return _chooseZoneDTO;
}

- (SAStartupAdDTO *)adDTO {
    if (!_adDTO) {
        _adDTO = SAStartupAdDTO.new;
    }
    return _adDTO;
}
/** @lazy tinhnowConfigDto */
- (TNAppConfigDTO *)tinhnowConfigDto {
    if (!_tinhnowConfigDto) {
        _tinhnowConfigDto = [[TNAppConfigDTO alloc] init];
    }
    return _tinhnowConfigDto;
}

@end
