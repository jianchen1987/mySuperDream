//
//  GNHomeViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNHomeViewModel.h"
#import "SAAddressModel.h"
#import "SAAppConfigDTO.h"
#import "SAWindowDTO.h"
#import "SAWindowItemModel.h"
#import "SAWindowManager.h"
#import "SAWriteDateReadableModel.h"
#import "SAAddressCacheAdaptor.h"

@interface GNHomeViewModel ()
/// 金刚区网络请求
@property (nonatomic, strong) SAAppConfigDTO *appConfigDTO;
/// 金刚区网络请求
@property (nonatomic, strong) SAWindowDTO *windowDTO;
/// 布局字典
@property (nonatomic, strong) NSDictionary<NSString *, NSDictionary *> *layoutInfo;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;

@end


@implementation GNHomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self addLayoutConfigSkeleton];
    }
    return self;
}

/// 获取信息
- (void)getInfoData {
    @HDWeakify(self);
    ///阿波罗首页配置
    [self getApolloLayoutConfig:^(id json) {
        @HDStrongify(self);
        [self dealLayoutData:json];
    } getLocal:NO];

    ///分类
    [self.homeDTO getHomeColumnListSuccess:^(NSArray<GNColumnModel *> *_Nonnull rspModel) {
        @HDStrongify(self);
        self.columnDataSource = rspModel;
        [SACacheManager.shared setObject:self.columnDataSource forKey:kCacheKeyGroupBuyLivingList type:SACacheTypeDocumentPublic];
    } failure:nil];
}

#pragma mark 获取团购阿波罗布局配置
///@param getLocal 有本地数据直接返回不请求
- (void)getApolloLayoutConfig:(void (^)(id json))completion getLocal:(BOOL)getLocal {
    NSArray<WMHomeLayoutModel *> *resultInfo = [SACacheManager.shared objectForKey:kCacheKeyGroupBuyHomeLayoutApollo type:SACacheTypeDocumentPublic];
    NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
    NSTimeInterval oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"groupnow_home_layout_config"] doubleValue];
    /// 60分钟重新请求
    BOOL reRequest = NO;
    if (currentTime - oldTime >= 60 * 60) {
        reRequest = YES;
    }
    if (resultInfo && (getLocal || !reRequest)) {
        !completion ?: completion(resultInfo);
        return;
    }
    [self.homeDTO getAplioConfigSuccess:^(id _Nonnull rspModel) {
        !completion ?: completion(rspModel);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf", NSDate.date.timeIntervalSince1970] forKey:@"groupnow_home_layout_config"];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(resultInfo);
    }];
}

#pragma mark 处理json
- (NSArray<WMHomeLayoutModel *> *)getDefaultLayoutJSON:(id)json {
    if (!json) {
        NSArray<WMHomeLayoutModel *> *resultInfo = [SACacheManager.shared objectForKey:kCacheKeyGroupBuyHomeLayoutApollo type:SACacheTypeDocumentPublic];
        if (resultInfo)
            return resultInfo;
    }

    BOOL fromLocal = false;
    if (!json) {
        fromLocal = true;
        json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gnHomeLayout" ofType:@"json"]] options:NSJSONReadingMutableLeaves
                                                 error:nil];
    }

    NSArray<WMHomeLayoutModel *> *resultInfo = [NSArray yy_modelArrayWithClass:WMHomeLayoutModel.class json:json];
    if (!fromLocal) {
        [SACacheManager.shared setObject:resultInfo forKey:kCacheKeyGroupBuyHomeLayoutApollo type:SACacheTypeDocumentPublic];
    }
    return resultInfo;
}

#pragma mark 处理Apollo模型
- (void)dealLayoutData:(id)json {
    NSMutableArray<WMHomeLayoutModel *> *resultInfo = nil;
    if ([json isKindOfClass:NSArray.class]) {
        resultInfo = [NSMutableArray arrayWithArray:[self dealLauouyModelConfig:json]];
    } else {
        resultInfo = [NSMutableArray arrayWithArray:[self dealLauouyModelConfig:[self getDefaultLayoutJSON:json]]];
    }

    @HDWeakify(self)
        ///是否加载完所有数据源再刷新 改为NO则分布加载
        BOOL useGroup
        = YES;
    [resultInfo enumerateObjectsUsingBlock:^(WMHomeLayoutModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (useGroup)
            dispatch_group_enter(self.taskGroup);

        [self getDataSourceWithLayoutModel:obj completion:^(id rspModel, BOOL result) {
            @HDStrongify(self);
            ///判空 没有数据 删除model
            BOOL empty = NO;
            if (obj.sort < 0)
                empty = YES;
            if (!obj.dataSource)
                empty = YES;
            if ([obj.dataSource isKindOfClass:NSArray.class] && ![obj.dataSource count])
                empty = YES;
            if ([obj.dataSource isKindOfClass:SARspModel.class]) {
                SARspModel *rsp = (SARspModel *)obj.dataSource;
                if (!rsp.data)
                    empty = YES;
            }
            ///金刚区有缓存数据的时候赋值 防止网络加载失败的时候 覆盖掉
            if ([obj.identity isEqualToString:GNHomeLayoutTypeKingKong] && ![obj.dataSource isKindOfClass:NSArray.class]) {
                NSArray<SAKingKongAreaItemConfig *> *list = [SACacheManager.shared objectForKey:kCacheKeyGroupBuyAppHomeDynamicFunctionList type:SACacheTypeDocumentPublic relyLanguage:YES];
                if (list)
                    obj.dataSource = list;
                empty = !([list isKindOfClass:NSArray.class] && list.count);
            }
            if (empty && [resultInfo indexOfObject:obj] != NSNotFound)
                [resultInfo removeObject:obj];

            if (useGroup) {
                !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            } else {
                ///分批次 异步加载数据源刷新
                [self setUpTableViewDataList:resultInfo];
                self.refreshFlag = YES;
            }
        }];
    }];

    if (useGroup) {
        dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
            @HDStrongify(self);
            [self setUpTableViewDataList:resultInfo];
            self.refreshFlag = YES;
        });
    }
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

#pragma mark 处理金刚区数据
- (NSArray *)dealKingKongData:(NSArray<SAKingKongAreaItemConfig *> *_Nonnull)list {
    list = [list filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SAKingKongAreaItemConfig *_Nullable obj, NSDictionary<NSString *, id> *_Nullable bindings) {
                     if ([obj isKindOfClass:SAKingKongAreaItemConfig.class]) {
                         return [SAWindowManager canOpenURL:obj.url];
                     }
                     return NO;
                 }]];
    if (list && list.count > 0) {
        list = [list sortedArrayUsingComparator:^NSComparisonResult(SAKingKongAreaItemConfig *_Nonnull obj1, SAKingKongAreaItemConfig *_Nonnull obj2) {
            return obj1.index > obj2.index;
        }];
    }
    [SACacheManager.shared setObject:list forKey:kCacheKeyGroupBuyAppHomeDynamicFunctionList type:SACacheTypeDocumentPublic relyLanguage:YES];
    return list;
}

#pragma mark 根据WMHomeLayoutModel配置网络请求和解析
- (void)getDataSourceWithLayoutModel:(WMHomeLayoutModel *)model completion:(void (^)(id rspModel, BOOL result))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = model.URL;
    request.isNeedLogin = NO;
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
        if ([resultModel isKindOfClass:NSArray.class] && [model.identity isEqualToString:GNHomeLayoutTypeKingKong])
            resultModel = [self dealKingKongData:resultModel];
        if ([resultModel isKindOfClass:NSArray.class] && [resultModel count] && [model.identity isEqualToString:GNHomeLayoutTypeCarouselAdvertise]) {
            NSArray *resultArr = [NSArray arrayWithArray:resultModel];
            NSString *sonConfig = model.config[@"responseListSon"];
            if (sonConfig) {
                resultModel = [resultArr.firstObject valueForKey:sonConfig];
            }
        }

        model.dataSource = resultModel;
        !completion ?: completion(resultModel, YES);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !completion ?: completion(rspModel, NO);
    }];
}

#pragma mark 刷新前修改布局
- (void)setUpTableViewDataList:(NSArray<WMHomeLayoutModel *> *)dataList {
    WMHomeLayoutModel *lastObj = nil;
    int idx = 0;
    for (WMHomeLayoutModel *obj in dataList) {
        UIEdgeInsets outset = obj.layoutConfig.outSets;
        ///只有第一个有外上边距 其余只保留外下边距
        outset.top = (idx == 0) ? kRealWidth(15) : 0;
        ///保持轮播上下间距都是15
        if ([obj.identity isEqualToString:GNHomeLayoutTypeCarouselAdvertise]) {
            if (lastObj) {
                UIEdgeInsets lastOutset = lastObj.layoutConfig.outSets;
                UIEdgeInsets lastInsets = lastObj.layoutConfig.inSets;
                if (lastInsets.bottom > 0) {
                    lastInsets.bottom = 0;
                }
                if (![lastObj.identity isEqualToString:GNHomeLayoutTypeKingKong]) {
                    lastOutset.bottom = kRealWidth(15);
                }
                lastObj.layoutConfig.inSets = lastInsets;
                lastObj.layoutConfig.outSets = lastOutset;
            }
        } else if ([obj.identity isEqualToString:GNHomeLayoutTypeKingKong]) {
            UIEdgeInsets insets = obj.layoutConfig.inSets;
            if ([obj.dataSource isKindOfClass:NSArray.class] && [obj.dataSource count] < 9) {
                insets.bottom = 0;
                outset.bottom = 0;
            }
            obj.layoutConfig.inSets = insets;
        }
        obj.layoutConfig.outSets = outset;
        lastObj = obj;
        idx++;
    }
    self.dataSource = [NSMutableArray arrayWithArray:dataList];
}

#pragma mark - lazy load
- (NSMutableArray<GNCellModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

#pragma mark 头部骨架
- (void)addLayoutConfigSkeleton {
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *classArr = @[
        NSClassFromString(@"WMFoucsAdvertiseTableViewCell"),
        NSClassFromString(@"WMBrandThemeTableViewCell"),
        NSClassFromString(@"WMBrandThemeTableViewCell"),
        NSClassFromString(@"WMBrandThemeTableViewCell")
    ];
    for (NSUInteger i = 0; i < classArr.count; i++) {
        WMHomeLayoutModel *model = WMHomeLayoutModel.new;
        model.cellClass = classArr[i];
        model.shake = YES;
        UIEdgeInsets outset = model.layoutConfig.outSets;
        outset.bottom = 0;
        if (i == 0) {
            outset.top = kRealWidth(15);
        }
        outset.bottom = 0;
        model.layoutConfig.outSets = outset;
        UIEdgeInsets inset = model.layoutConfig.inSets;
        inset.bottom = 0;
        inset.left = 0;
        model.layoutConfig.inSets = inset;
        [tempArray addObject:model];
    }
    self.dataSource = [NSMutableArray arrayWithArray:tempArray];
    self.refreshFlag = NO;
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

- (SAWindowDTO *)windowDTO {
    return _windowDTO ?: ({ _windowDTO = SAWindowDTO.new; });
}

- (SAAppConfigDTO *)appConfigDTO {
    return _appConfigDTO ?: ({ _appConfigDTO = SAAppConfigDTO.new; });
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (NSDictionary<NSString *, NSDictionary *> *)layoutInfo {
    if (!_layoutInfo) {
        SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyGroupBuyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        _layoutInfo = @{
            ///金刚区
            GNHomeLayoutTypeKingKong: @{
                @"cellClass": @"GNKingKongTableViewCell",
                @"URL": @"/app/config/funcGuide/query.do",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, kRealWidth(15), 0)],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, kRealWidth(3), 0)],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15))],
                },
                @"param": ![SAUser hasSignedIn] ? ///请求携带的额外参数
                    @{@"clientType": SAClientTypeGroupBuy} :
                    @{@"clientType": SAClientTypeGroupBuy, @"loginName": SAUser.shared.loginName},
                @"config": @{
                    @"responseList": @"list", ///响应数据在list层
                },
                @"responseClass": @"SAKingKongAreaItemConfig",
            },
            ///轮播广告
            GNHomeLayoutTypeCarouselAdvertise: @{
                @"cellClass": @"GNCarouselAdvertiseTableViewCell",
                @"URL": @"/advertisement/v2/list.do",
                @"layoutConfig": @{
                    @"outSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, kRealWidth(12.5), kRealWidth(15), 0)],
                    @"inSets": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
                    @"contenInset": [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
                },
                @"param": @{
                    @"clientType": SAClientTypeGroupBuy,
                    @"pageType": [NSNumber numberWithUnsignedInteger:SAPagePositionGroupBuyHomePage],
                    @"location": [NSNumber numberWithUnsignedInteger:SAWindowLocationYumNowFocusBanner],
                    @"province": addressModel.city,
                    @"district": addressModel.subLocality,
                    @"latitude": @(kDefaultLocationPhn.latitude),
                    @"longitude": @(kDefaultLocationPhn.longitude),
                },
                @"config": @{
                    @"responseList": @"list",
                    @"responseListSon": @"bannerList",
                },
                @"responseClass": @"SAWindowModel",
                @"event": @{@"name": @"browseADS", @"type": @"CALOUSEL"}
            }
        };
    }
    return _layoutInfo;
}

@end
