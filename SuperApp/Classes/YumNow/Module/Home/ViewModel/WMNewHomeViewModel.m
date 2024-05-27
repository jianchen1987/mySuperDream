//
//  WMNewHomeViewModel.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewHomeViewModel.h"
#import "LKDataRecord.h"
#import "SAAddressModel.h"
#import "SAAppConfigDTO.h"
#import "SACacheManager.h"
#import "SAInfoViewModel.h"
#import "SANoDataCellModel.h"
#import "SAWindowModel.h"
#import "SAWriteDateReadableModel.h"
#import "WMAdadvertisingModel.h"
#import "WMCategoryItem.h"
#import "WMCustomizationDTO.h"
#import "WMHomeView.h"
#import "WMKingKongAreaModel.h"
#import "WMNearbyFilterHeaderView.h"
#import "WMNearbyFilterModel.h"
#import "WMPlaceHolderTableViewCell.h"
#import "WMQueryMerchantFilterCategoryRspModel.h"
#import "WMQueryNearbyStoreRspModel.h"
#import "WMStoreDTO.h"
#import "WMStoreSkeletonCell.h"
#import "WMThemeModel.h"
#import "WMeatOnTimeThemeModel.h"
#import "SAAddressCacheAdaptor.h"

@interface WMNewHomeViewModel ()
/// 附近商家标题占位
@property (nonatomic, strong) HDTableViewSectionModel *nearbyTitleSection;
/// 内容
@property (nonatomic, strong) HDTableViewSectionModel *contentSectionModel;
/// app配置DTO
@property (nonatomic, strong) SAAppConfigDTO *appConfigDTO;
/// 商户 VM
@property (nonatomic, strong) WMStoreDTO *storeDTO;
/// 外卖个性业务DTO
@property (nonatomic, strong) WMCustomizationDTO *customizationDTO;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 默认数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 当前page
@property (nonatomic, assign) NSInteger currentPage;
/// 上次选择的地址
@property (nonatomic, strong) SAAddressModel *lastChooseAddress;
/// 布局字典
@property (nonatomic, strong) NSDictionary<NSString *, NSDictionary *> *layoutInfo;

@end


@implementation WMNewHomeViewModel
#pragma mark - Data
- (void)loadOfflineData {
    ///头部骨架
    [self addLayoutConfigSkeleton];
}

- (void)hd_getNewData {
    @HDWeakify(self);
    self.currentPage = 1;
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (HDIsObjectNil(addressModel) || ![HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)])
        return;
    if (!addressModel.lat || !addressModel.lon) {
        ///解析失败 或者  定位失败
        [self getApolloLayoutConfigGetLocal:YES completion:^(id json) {
            @HDStrongify(self)[self dealLayoutData:[json isKindOfClass:NSArray.class] ? json : [self getDefaultLayoutJSON:json]];
        }];
        return;
    }
    self.finishRequestType = 1;
    ///阿波罗页面布局配置
    [self getApolloLayoutConfigGetLocal:NO completion:^(id json) {
        @HDStrongify(self);
        [self dealLayoutData:json];
    }];
    [self getComclumList];
    [self getBannerAndMarketingAd];
}

#pragma mark 处理Apollo模型
- (void)dealLayoutData:(id)json {
    @HDWeakify(self) NSMutableArray<WMHomeLayoutModel *> *resultInfo = nil;
    //    if ([json isKindOfClass:NSArray.class]) {
    //        resultInfo = [NSMutableArray arrayWithArray:[self dealLauouyModelConfig:json]];
    //    } else {
    json = nil;
    resultInfo = [NSMutableArray arrayWithArray:[self dealLauouyModelConfig:[self getDefaultLayoutJSON:json]]];
    //    }

    ///定位地址错误不请求
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (HDIsObjectNil(addressModel) || ![HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)] || !addressModel.lat
        || !addressModel.lon)
        return;
    ///是否加载完所有数据源再刷新 改为NO则分布加载
    BOOL useGroup = YES;
    if (!self.themeList) {
        self.themeList = NSMutableArray.new;
    } else {
        [self.themeList removeAllObjects];
    }

    [resultInfo enumerateObjectsUsingBlock:^(WMHomeLayoutModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (useGroup)
            dispatch_group_enter(self.taskGroup);
        [self getDataSourceWithLayoutModel:obj completion:^(id rspModel, BOOL result) {
            @HDStrongify(self);
            ///判空 没有数据 删除model
            BOOL empty = NO;
            if (obj.sort < 0 || !obj.dataSource) {
                empty = YES;
            }

            if ([obj.dataSource isKindOfClass:NSArray.class] && ![obj.dataSource count]) {
                empty = YES;
            } else if ([obj.dataSource isKindOfClass:WMThemeModel.class]) {
                WMThemeModel *tempModel = (WMThemeModel *)obj.dataSource;
                if ([tempModel.type.code isEqualToString:WMThemeTypeMerchant] && !tempModel.brand.count) {
                    empty = YES;
                }
                if ([tempModel.type.code isEqualToString:WMThemeTypeProduct] && !tempModel.product.count) {
                    empty = YES;
                }
                if ([tempModel.type.code isEqualToString:WMThemeTypeStore] && !tempModel.store.count) {
                    empty = YES;
                }
            } else if ([obj.dataSource isKindOfClass:WMeatOnTimeThemeModel.class]) {
                WMeatOnTimeThemeModel *tempModel = (WMeatOnTimeThemeModel *)obj.dataSource;
                if (!tempModel.rel.count) {
                    empty = YES;
                }
            } else if ([obj.dataSource isKindOfClass:SARspModel.class]) {
                SARspModel *rsp = (SARspModel *)obj.dataSource;
                if (!rsp.data) {
                    empty = YES;
                }
            }

            if (obj.config[@"insertStore"]) {
                [resultInfo removeObject:obj];
            }
            ///穿插广告
            if ([obj.identity isEqualToString:WMHomeLayoutTypeNearStoreAdvertise]) {
                if (!empty) {
                    self.insertModel = obj;
                }
            }

            if ([obj.identity isEqualToString:WMHomeLayoutTypeStoreTheme] || [obj.identity isEqualToString:WMHomeLayoutTypeProductTheme] ||
                [obj.identity isEqualToString:WMHomeLayoutTypeMerchantTheme]) {
                if (!empty) {
                    [self.themeList addObject:obj];
                }
            }


            if (empty && [resultInfo indexOfObject:obj] != NSNotFound)
                [resultInfo removeObject:obj];

            if (useGroup) {
                !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            } else {
                ///分批次 异步加载数据源刷新
                [self.view dismissLoading];
                self.resultInfo = resultInfo;
                [self setUpTableViewDataList:resultInfo];
                self.finishRequestType = 2;
                self.refreshFlag = !self.refreshFlag;
            }
            ///浏览埋点
            if (obj.event && result && !empty)
                [self addColectionData:obj];
        }];
    }];

    if (useGroup) {
        dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
            @HDStrongify(self);
            [self.view dismissLoading];
            //主题排序
            NSSortDescriptor *createTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"dataSource.createTime" ascending:NO];
            [self.themeList sortUsingDescriptors:@[createTimeDesc]];

            [self setUpTableViewDataList:resultInfo];
            self.resultInfo = resultInfo;
            self.finishRequestType = 2;
            self.refreshFlag = !self.refreshFlag;
        });
    }
}

#pragma mark 刷新前修改布局
- (void)setUpTableViewDataList:(NSArray<WMHomeLayoutModel *> *)dataList {
    //    WMHomeLayoutModel *lastObj = nil;
    //    int idx = 0;
    //    for (WMHomeLayoutModel *obj in dataList) {
    //        UIEdgeInsets outset = obj.layoutConfig.outSets;
    //        ///只有第一个有外上边距 其余只保留外下边距
    //        outset.top = 0;
    //        ///保持轮播上下间距都是20
    //        if ([obj.identity isEqualToString:WMHomeLayoutTypeCarouselAdvertise]) {
    //            if (lastObj) {
    //                UIEdgeInsets lastOutset = lastObj.layoutConfig.outSets;
    //                UIEdgeInsets lastInsets = lastObj.layoutConfig.inSets;
    //                if (lastInsets.bottom > 0) {
    //                    lastInsets.bottom = 0;
    //                }
    //                lastOutset.bottom = kRealWidth(20);
    //                lastObj.layoutConfig.inSets = lastInsets;
    //                lastObj.layoutConfig.outSets = lastOutset;
    //            }
    //        } else if ([obj.identity isEqualToString:WMHomeLayoutTypeKingKong]) {
    //            UIEdgeInsets insets = obj.layoutConfig.inSets;
    //            if ([obj.dataSource isKindOfClass:NSArray.class] && [obj.dataSource count] < 9) {
    //                insets.bottom = 0;
    //            }
    //            obj.layoutConfig.inSets = insets;
    //        }
    //        if (idx == dataList.count - 1) {
    //            outset.bottom = kRealWidth(10);
    //        }
    //        obj.layoutConfig.outSets = outset;
    //        lastObj = obj;
    //        idx++;
    //    }
    self.contentSectionModel.list = dataList;
}

#pragma mark 添加埋点
- (void)addColectionData:(WMHomeLayoutModel *)obj {
    NSString *plateId = nil;
    NSArray *contentArr = NSArray.new;
    if ([obj.dataSource isKindOfClass:WMThemeModel.class]) {
        WMThemeModel *model = (WMThemeModel *)obj.dataSource;
        plateId = model.themeNo;
        if ([obj.identity isEqualToString:WMHomeLayoutTypeStoreTheme]) {
            contentArr = [model.store mapObjectsUsingBlock:^id _Nonnull(WMStoreThemeModel *_Nonnull obj, NSUInteger idx) {
                return obj.storeNo;
            }];
        } else if ([obj.identity isEqualToString:WMHomeLayoutTypeProductTheme]) {
            contentArr = [model.product mapObjectsUsingBlock:^id _Nonnull(WMProductThemeModel *_Nonnull obj, NSUInteger idx) {
                return obj.productId;
            }];
        } else if ([obj.identity isEqualToString:WMHomeLayoutTypeMerchantTheme]) {
            contentArr = [model.brand mapObjectsUsingBlock:^id _Nonnull(WMBrandThemeModel *_Nonnull obj, NSUInteger idx) {
                return obj.link;
            }];
        }

    } else if ([obj.dataSource isKindOfClass:WMeatOnTimeThemeModel.class]) {
        WMeatOnTimeThemeModel *model = (WMeatOnTimeThemeModel *)obj.dataSource;
        plateId = @(model.id).stringValue;
        contentArr = [model.rel mapObjectsUsingBlock:^id _Nonnull(WMeatOnTimeModel *_Nonnull obj, NSUInteger idx) {
            return obj.productId;
        }];

    } else if ([obj.dataSource isKindOfClass:NSArray.class]
               && ([obj.identity isEqualToString:WMHomeLayoutTypeFoucsAdvertise] || [obj.identity isEqualToString:WMHomeLayoutTypeCarouselAdvertise] ||
                   [obj.identity isEqualToString:WMHomeLayoutTypeNearStoreAdvertise])) {
        NSArray<WMAdadvertisingModel *> *array = (NSArray *)obj.dataSource;
        contentArr = [array mapObjectsUsingBlock:^id _Nonnull(WMAdadvertisingModel *_Nonnull obj, NSUInteger idx) {
            return @(obj.id).stringValue;
        }];
    }
    if (([obj.identity isEqualToString:WMHomeLayoutTypeFoucsAdvertise] || [obj.identity isEqualToString:WMHomeLayoutTypeCarouselAdvertise] ||
         [obj.identity isEqualToString:WMHomeLayoutTypeNearStoreAdvertise])) {
        NSArray<WMAdadvertisingModel *> *array = (NSArray *)obj.dataSource;
        [array enumerateObjectsUsingBlock:^(WMAdadvertisingModel *_Nonnull obj1, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableDictionary *mdics = NSMutableDictionary.new;
            mdics[@"type"] = obj.event[@"type"];
            mdics[@"content"] = contentArr;
            mdics[@"plateId"] = @(obj1.id).stringValue;
            [LKDataRecord.shared traceEvent:obj.event[@"name"] name:obj.event[@"name"] parameters:mdics SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
        }];
    } else {
        NSMutableDictionary *mdics = NSMutableDictionary.new;
        if (plateId)
            mdics[@"plateId"] = plateId;
        mdics[@"type"] = obj.event[@"type"];
        mdics[@"content"] = contentArr;
        [LKDataRecord.shared traceEvent:obj.event[@"name"] name:obj.event[@"name"] parameters:mdics SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
    }
}

#pragma mark 获取外卖栏目配置
- (void)getComclumList {
    self.columnFlag = NO;
    @HDWeakify(self)[self.storeDTO getWMIndexShowColumnSuccess:^(id _Nonnull rspModel) {
        @HDStrongify(self) if (rspModel) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:WMHomeColumnModel.class json:rspModel];
            NSMutableArray *marr = NSMutableArray.new;
            [marr addObject:self.nearColumnModel];
            [marr addObjectsFromArray:arr];
            self.columnArray = [NSArray arrayWithArray:marr];
            self.columnFlag = YES;
        }
        else {
            self.columnFlag = YES;
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) self.columnFlag = YES;
    }];
}

#pragma mark 获取外卖阿波罗布局配置
///@param getLocal 有本地数据直接返回不请求
- (void)getApolloLayoutConfigGetLocal:(BOOL)getLocal completion:(void (^)(id json))completion {
    self.insertModel = nil;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"yunnow_home_huodongjingxuan"];

    [self.storeDTO getWMAplioConfigAreaNameSuccess:^(id _Nonnull rspModel) {
        !completion ?: completion(rspModel);
        [[NSUserDefaults standardUserDefaults] setObject:rspModel forKey:@"yunnow_home_huodongjingxuan"];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

#pragma mark 处理json
- (NSArray<WMHomeLayoutModel *> *)getDefaultLayoutJSON:(id)json {
    //  测试才有
    //    json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homeNewLayout" ofType:@"json"]] options:NSJSONReadingMutableLeaves
    //    error:nil];

    json = @"[{\"identity\":\"WMTopShortcutOptions\",\"sort\":0},{\"identity\":\"WMFoucsAdvertise\",\"sort\":1},{\"identity\":\"WMKingKong\",\"sort\":2},{\"identity\":\"WMCarouselAdvertise\","
           @"\"sort\":3},{\"identity\":\"WMEatOnTime\",\"sort\":4},{\"identity\":\"WMNearStoreAdvertise\",\"sort\":5},{\"identity\":\"WMMerchantTheme\",\"sort\":6},{\"identity\":\"WMStoreTheme\","
           @"\"sort\":7},{\"identity\":\"WMProductTheme\",\"sort\":8}]";

    NSArray<WMHomeLayoutModel *> *resultInfo = [NSArray yy_modelArrayWithClass:WMHomeLayoutModel.class json:json];

    return resultInfo;
}

#pragma mark 处理layoutModel的默认配置
- (NSArray<WMHomeLayoutModel *> *)dealLauouyModelConfig:(NSArray<WMHomeLayoutModel *> *)resultInfo {
    resultInfo = [resultInfo sortedArrayUsingComparator:^NSComparisonResult(WMHomeLayoutModel *obj1, WMHomeLayoutModel *obj2) {
        return obj1.sort > obj2.sort;
    }];

    [resultInfo enumerateObjectsUsingBlock:^(WMHomeLayoutModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *info = self.layoutInfo[obj.identity];
        if ([info isKindOfClass:NSDictionary.class]) {
            obj.cellClass = NSClassFromString(info[@"cellClass"]);
            obj.URL = info[@"URL"];
            obj.param = info[@"param"];
            obj.config = info[@"config"];
            obj.event = info[@"event"];
            NSDictionary *layoutConfig = info[@"layoutConfig"];
            if ([layoutConfig isKindOfClass:NSDictionary.class]) {
                if (layoutConfig[@"outSets"]) {
                    obj.layoutConfig.outSets = [layoutConfig[@"outSets"] UIEdgeInsetsValue];
                }
                if (layoutConfig[@"inSets"]) {
                    obj.layoutConfig.inSets = [layoutConfig[@"inSets"] UIEdgeInsetsValue];
                }
                if (layoutConfig[@"contenInset"]) {
                    obj.layoutConfig.contenInset = [layoutConfig[@"contenInset"] UIEdgeInsetsValue];
                }
            }
            obj.responseClass = info[@"responseClass"];
        }
    }];

    resultInfo = [resultInfo hd_filterWithBlock:^BOOL(WMHomeLayoutModel *_Nonnull item) {
        return (item.cellClass && item.sort >= 0);
    }];

    return resultInfo;
}

#pragma mark 根据WMHomeLayoutModel配置网络请求和解析
- (void)getDataSourceWithLayoutModel:(WMHomeLayoutModel *)model completion:(void (^)(id rspModel, BOOL result))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = model.URL;
    request.isNeedLogin = NO;
    request.requestTimeoutInterval = 20;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    if ([model.param isKindOfClass:NSDictionary.class])
        [mdic setValuesForKeysWithDictionary:model.param];

    ///带location
    NSString *location = model.config[@"location"];
    if (location) {
        //        SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
        CGFloat lat = addressModel.lat.doubleValue;
        CGFloat lon = addressModel.lon.doubleValue;
        BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
        if (!isParamsCoordinate2DValid) {
            lat = HDLocationManager.shared.coordinate2D.latitude;
            lon = HDLocationManager.shared.coordinate2D.longitude;
        }
        if (location.length > 0) {
            [mdic setObject:@{
                @"lat": @(lat).stringValue,
                @"lon": @(lon).stringValue,
            }
                     forKey:location];
        } else {
            mdic[@"lat"] = @(lat).stringValue;
            mdic[@"lon"] = @(lon).stringValue;
        }
    }
    ///解析响应数据
    ///转model的class
    Class class = nil;
    ///是否是在list层
    NSString *listConfig = model.config[@"responseList"];
    if (model.responseClass) {
        class = NSClassFromString(model.responseClass);
    }
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        id resultModel = rspModel;
        if (class) {
            id yyModel;
            if ([listConfig isKindOfClass:NSString.class]) {
                if (listConfig.length) {
                    NSDictionary *info = (id)rspModel.data;
                    if ([info isKindOfClass:NSDictionary.class]) {
                        yyModel = [NSArray yy_modelArrayWithClass:class json:info[listConfig]];
                    }
                } else {
                    yyModel = [NSArray yy_modelArrayWithClass:class json:rspModel.data];
                }
            } else {
                yyModel = [class yy_modelWithJSON:rspModel.data];
            }
            if (yyModel)
                resultModel = yyModel;
        }

        if ([model.identity isEqualToString:WMHomeLayoutTypeCarouselAdvertise] || [model.identity isEqualToString:WMHomeLayoutTypeFoucsAdvertise]) {
            if ([resultModel isKindOfClass:NSArray.class]) {
                resultModel = [resultModel hd_filterWithBlock:^BOOL(WMAdadvertisingModel *_Nonnull item) {
                    return HDIsStringNotEmpty(item.nImages);
                }];
            }
        }
        model.dataSource = resultModel;
        !completion ?: completion(resultModel, YES);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !completion ?: completion(rspModel, NO);
    }];
}

- (void)reloadDataWithLayoutModel:(WMHomeLayoutModel *)model completion:(void (^)(id _Nonnull, BOOL))completion {
    [self getDataSourceWithLayoutModel:model completion:^(id rspModel, BOOL result) {
        completion(rspModel, result);
    }];
}

#pragma mark 获取弹窗广告
- (void)getBannerAndMarketingAd {
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (HDIsObjectNil(addressModel) || ![HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)]) {
        return;
    }
    /// 为null也算相等
    NSString *nowCity = addressModel.city ?: @"";
    NSString *lastCity = self.lastChooseAddress.city ?: @"";
    NSString *subLocality = addressModel.subLocality ?: @"";
    NSString *lastSubLocality = self.lastChooseAddress.subLocality ?: @"";
    /// 地区相同，不重复获取弹窗广告
    if ([nowCity isEqualToString:lastCity] && [subLocality isEqualToString:lastSubLocality])
        return;
    self.lastChooseAddress = addressModel;
    /// 地区不同，重新获取banner和弹窗广告
    [self getMarketingAlert];
}

/// 获取弹窗广告
- (void)getMarketingAlert {
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    @HDWeakify(self);
    [self.appConfigDTO queryAppMarketingAlertWithType:SAClientTypeYumNow province:addressModel.city district:addressModel.subLocality latitude:addressModel.lat longitude:addressModel.lon
        success:^(NSArray<SAMarketingAlertViewConfig *> *_Nonnull list) {
            @HDStrongify(self);
            [self showMarketingAlertWithConfigs:list];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"外卖首页获取弹窗广告失败");
        }];
}

- (void)showMarketingAlertWithConfigs:(NSArray<SAMarketingAlertViewConfig *> *)configs {
    NSMutableArray<SAMarketingAlertViewConfig *> *shouldShow = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (SAMarketingAlertViewConfig *config in configs) {
        if ([config isValidWithLocation:@"10"]) {
            config.showInClass = [self.view.viewController class];
            [shouldShow addObject:config];
        }
    }
    
    if(shouldShow.count) {
        SAMarketingAlertView *alertView = [SAMarketingAlertView alertViewWithConfigs:shouldShow];
        alertView.willJumpTo = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"外卖" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": [NSNumber numberWithUnsignedInteger:SAWindowLocationYumNowAlertWindow],
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"enter",
                @"businessLine": SAClientTypeYumNow
            }];
        };
        alertView.willClose = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"外卖" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": [NSNumber numberWithUnsignedInteger:SAWindowLocationYumNowAlertWindow],
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"close",
                @"businessLine": SAClientTypeYumNow
            }];
        };
        [alertView show];
    }
}

#pragma mark 头部骨架
- (void)addLayoutConfigSkeleton {
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *classArr = @[
        NSClassFromString(@"WMFoucsAdvertiseTableViewCell"),
        NSClassFromString(@"WMThemeTableViewCell"),
        NSClassFromString(@"WMBrandThemeTableViewCell"),
        NSClassFromString(@"WMStoreThemeTableViewCell"),
        NSClassFromString(@"WMThemeTableViewCell")
    ];

    for (NSUInteger i = 0; i < classArr.count; i++) {
        WMHomeLayoutModel *model = WMHomeLayoutModel.new;
        model.cellClass = classArr[i];
        model.shake = YES;
        UIEdgeInsets outset = model.layoutConfig.outSets;
        outset.bottom = 0;
        if (i == 0) {
            outset.top = 0;
        }
        outset.bottom = 0;
        model.layoutConfig.outSets = outset;
        UIEdgeInsets inset = model.layoutConfig.inSets;
        inset.bottom = 0;
        inset.left = 0;
        model.layoutConfig.inSets = inset;
        [tempArray addObject:model];
    }
    self.contentSectionModel.list = tempArray;
}

#pragma mark - lazy load
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[self.contentSectionModel]];
    }
    return _dataSource;
}

/// 动态布局
- (HDTableViewSectionModel *)contentSectionModel {
    if (!_contentSectionModel) {
        _contentSectionModel = HDTableViewSectionModel.new;
    }
    return _contentSectionModel;
}

- (SAAppConfigDTO *)appConfigDTO {
    return _appConfigDTO ?: ({ _appConfigDTO = SAAppConfigDTO.new; });
}

- (WMStoreDTO *)storeDTO {
    return _storeDTO ?: ({ _storeDTO = WMStoreDTO.new; });
}

- (WMCustomizationDTO *)customizationDTO {
    return _customizationDTO ?: ({ _customizationDTO = WMCustomizationDTO.new; });
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (NSDictionary<NSString *, NSDictionary *> *)layoutInfo {
    if (!_layoutInfo) {
        _layoutInfo = @{
            ///顶部选着
            WMHomeLayoutTypeTopShortcutOptions: @{
                @"cellClass": @"WMTopShortcutOptionsTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-advertising",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(8), 0, 0, 0)],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12))],
                },
                @"param": @{@"space": WMHomeTopShortcutOptions},
                @"config": @{
                    @"location": @"geo",
                    @"responseList": @"",
                },
                @"responseClass": @"WMAdadvertisingModel",
#warning-- event需处理
                @"event": @{@"name": @"browseADS", @"type": @"CALOUSEL"}

            },

            ///轮播广告(原焦点广告)
            WMHomeLayoutTypeFoucsAdvertise: @{
                @"cellClass": @"WMNewCarouselAdvertiseTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-advertising",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(12), 12, kRealWidth(1), 12)],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
                },
                @"param": @{@"space": WMHomeFoucsAdviseType},
                @"config": @{
                    @"location": @"geo",
                    ///响应参数是个数组
                    @"responseList": @"",
                },
                @"responseClass": @"WMAdadvertisingModel", ///响应model yyModel转换对应的model
                @"event": @{
                    ///埋点对应的参数
                    @"name": @"browseADS",
                    @"type": @"ADS"
                }
            },
            ///金刚区
            WMHomeLayoutTypeKingKong: @{
                @"cellClass": @"WMNewKingKongTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-king-kong-area",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(12), 0, kRealWidth(1), 0)],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, kRealWidth(12), 0)],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)],
                },
                @"config": @{
                    @"responseList": @"details", ///响应数据在list层
                    @"location": @"",
                },
                @"responseClass": @"WMKingKongAreaModel",
            },

            //活动精选（原轮播广告）
            WMHomeLayoutTypeCarouselAdvertise: @{
                @"cellClass": @"WMFeaturedActivitiesTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-advertising",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(16), 0, kRealWidth(1), 0)],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12))],
                },
                @"param": @{@"space": WMHomeCarouselAdviseType},
                @"config": @{
                    @"location": @"geo",
                    @"responseList": @"",
                },
                @"responseClass": @"WMAdadvertisingModel",
                @"event": @{@"name": @"browseADS", @"type": @"CALOUSEL"}

            },

            ///按时吃饭
            WMHomeLayoutTypeEatOnTime: @{
                @"cellClass": @"WMNewEatOnTimeTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-eat-on-time",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(16), 0, kRealWidth(6), 0)],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12))],
                },
                @"config": @{@"location": @""},

                @"responseClass": @"WMeatOnTimeThemeModel",
                @"event": @{@"name": @"browseEOT", @"type": @"EOT"}
            },

            ///商家主题
            WMHomeLayoutTypeMerchantTheme: @{
                @"cellClass": @"WMNewBrandThemeTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-theme",

                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), 0, kRealWidth(12))],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, kRealWidth(8), 0)],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(8), 0, kRealWidth(8))],
                },
                @"param": @{@"type": WMThemeTypeMerchant, @"operatorNo": SAUser.shared.operatorNo},
                @"config": @{
                    @"insertStore": @(YES), ///插入门店里 不加入首页布局里
                    @"location": @"geoPointDTO"
                },
                @"responseClass": @"WMThemeModel",
                @"event": @{@"name": @"browseTheme", @"type": @"THEME"}
            },
            ///门店主题
            WMHomeLayoutTypeStoreTheme: @{
                @"cellClass": @"WMNewStoreThemeTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-theme",

                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), 0, kRealWidth(12))],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, kRealWidth(8), 0)],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(8), 0, kRealWidth(8))],
                },
                @"param": @{@"type": WMThemeTypeStore, @"operatorNo": SAUser.shared.operatorNo},
                @"config": @{
                    @"insertStore": @(YES), ///插入门店里 不加入首页布局里
                    @"location": @"geoPointDTO"
                },
                @"responseClass": @"WMThemeModel",
                @"event": @{@"name": @"browseTheme", @"type": @"THEME"}
            },
            ///商品主题
            WMHomeLayoutTypeProductTheme: @{
                @"cellClass": @"WMNewThemeTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-theme",

                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), 0, kRealWidth(12))],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, kRealWidth(8), 0)],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(8), 0, kRealWidth(8))],
                },
                @"param": @{@"type": WMThemeTypeProduct, @"operatorNo": SAUser.shared.operatorNo},
                @"config": @{
                    @"insertStore": @(YES), ///插入门店里 不加入首页布局里
                    @"location": @"geoPointDTO"
                },
                @"responseClass": @"WMThemeModel",
                @"event": @{@"name": @"browseTheme", @"type": @"THEME"}
            },

            ///附近门店穿插广告
            WMHomeLayoutTypeNearStoreAdvertise: @{
                @"cellClass": @"WMNewNearStoreAdvertiseTableViewCell",
                @"URL": @"/takeaway-merchant/app/super-app/get-advertising",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), 0, kRealWidth(12))],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
                },
                @"param": @{@"space": WMHomeNearStoreAdviseType},
                @"config": @{
                    @"insertStore": @(YES), ///插入门店里 不加入首页布局里
                    @"location": @"geo",
                    @"responseList": @"",
                },
                @"responseClass": @"WMAdadvertisingModel",
                @"event": @{@"name": @"browseADS", @"type": @"NEARBY"}
            },


        };
    }
    return _layoutInfo;
}

- (NSArray<WMHomeColumnModel *> *)columnArray {
    if (!_columnArray) {
        _columnArray = @[self.nearColumnModel ?: [WMHomeColumnModel addDefaultTag]];
    }
    return _columnArray;
}

- (WMHomeColumnModel *)nearColumnModel {
    if (!_nearColumnModel) {
        _nearColumnModel = [WMHomeColumnModel addDefaultTag];
    }
    return _nearColumnModel;
}
@end
