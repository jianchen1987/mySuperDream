//
//  SASearchViewModel.m
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchViewModel.h"
#import "SACacheManager.h"
#import "SASearchDTO.h"
#import "SASearchThematicModel.h"
#import "SACommonConst.h"
#import "SAAddressCacheAdaptor.h"
#import "GNStorePagingRspModel.h"
#import "LKDataRecord.h"
#import "SAAddressModel.h"
#import "TNQueryGoodsRspModel.h"
#import "WMSearchStoreRspModel.h"


@interface SASearchViewModel ()

@property (nonatomic, strong) SASearchDTO *searchDTO;

@property (nonatomic, strong) HDTableViewSectionModel *historySectionModel; ///< 历史

@property (nonatomic, assign) BOOL refreshFlag;

@end


@implementation SASearchViewModel

- (void)loadDefaultData {
    // 加载历史搜索
    NSArray<NSString *> *historyArray = [SACacheManager.shared objectForKey:kCacheKeyAggregateSearchHistory type:SACacheTypeDocumentPublic relyLanguage:NO];

    NSMutableArray<SAImageLabelCollectionViewCellModel *> *array = @[].mutableCopy;
    for (NSString *str in historyArray) {
        SAImageLabelCollectionViewCellModel *model = SAImageLabelCollectionViewCellModel.new;
        model.title = str;
        [array addObject:model];
    }
    self.historySectionModel.list = array.count ? @[array] : @[];
    [self.dataSource addObject:self.historySectionModel];
    self.refreshFlag = !self.refreshFlag;
}

- (void)saveMerchantHistorySearchWithKeyword:(NSString *)keyword {
    NSArray<NSString *> *historyArray = [SACacheManager.shared objectForKey:kCacheKeyAggregateSearchHistory type:SACacheTypeDocumentPublic relyLanguage:NO];
    // 去除重复当前
    NSMutableArray<NSString *> *copiedArray = [NSMutableArray arrayWithArray:historyArray];
    for (NSString *str in historyArray) {
        if ([str isEqualToString:keyword]) {
            [copiedArray removeObject:str];
        }
    }
    // 生成新关键词模型
    [copiedArray insertObject:keyword atIndex:0];
    static NSUInteger maxHistoryRecordCount = 5;
    if (copiedArray.count > maxHistoryRecordCount) {
        [copiedArray removeObjectsInRange:NSMakeRange(maxHistoryRecordCount, copiedArray.count - maxHistoryRecordCount)];
    }
    // 保存
    [SACacheManager.shared setObject:copiedArray forKey:kCacheKeyAggregateSearchHistory type:SACacheTypeDocumentPublic relyLanguage:NO];
    HDLog(@"保存关键词:%@", keyword);
}

- (void)removeAllHistorySearch {
    // 删除内存中历史搜索纪录
    self.historySectionModel.list = @[];

    [SACacheManager.shared removeObjectForKey:kCacheKeyAggregateSearchHistory type:SACacheTypeDocumentPublic];
}

/// 获取搜索排行 和 搜索发现 数据
- (void)getSearchRankAndDiscoveryData {
    @HDWeakify(self);
    [self.searchDTO queryHotwordWithSuccess:^(SARspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self processSearcFindData:rspModel];
        @HDWeakify(self);
        [self.searchDTO queryThematicWithSuccess:^(SARspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self processSearcRankData:rspModel];
            self.refreshFlag = !self.refreshFlag;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.refreshFlag = !self.refreshFlag;
        }];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

/// 对 搜索发现 的数据进行处理
- (void)processSearcFindData:(SARspModel *)rspModel {
    NSDictionary *data = (NSDictionary *)rspModel.data;
    if ([data isKindOfClass:NSDictionary.class]) {
        NSArray *arr = data[@"list"];
        if ([arr isKindOfClass:NSArray.class] && arr.count > 0) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dic = arr[i];
                SAImageLabelCollectionViewCellModel *model = SAImageLabelCollectionViewCellModel.new;
                model.title = dic[@"keyword"];
                [tempArr addObject:model];
            }
            HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
            sectionModel.list = @[tempArr];
            [self.dataSource addObject:sectionModel];
        }
    }
}

/// 对 搜索排行 的数据进行处理
- (void)processSearcRankData:(SARspModel *)rspModel {
    NSDictionary *data = (NSDictionary *)rspModel.data;
    if ([data isKindOfClass:NSDictionary.class]) {
        NSArray *arr = data[@"list"];
        if ([arr isKindOfClass:NSArray.class] && arr.count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:SASearchThematicModel.class json:arr];
            HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
            sectionModel.list = @[tempArr];
            [self.dataSource addObject:sectionModel];
        }
    }
}

- (CMNetworkRequest *)getAssociateSearchKeyword:(NSString *)keyword success:(void (^)(NSArray<SASearchAssociateModel *> *list))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-associate-search";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyword"] = keyword;
    params[@"lang"] = [HDDeviceInfo getDeviceLanguage];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            lat = HDLocationManager.shared.coordinate2D.latitude;
            lat = HDLocationManager.shared.coordinate2D.longitude;
        } else {
            lat = kDefaultLocationPhn.latitude;
            lon = kDefaultLocationPhn.longitude;
        }
    }
    params[@"geo"] = @{@"lat": [NSString stringWithFormat:@"%f", lat], @"lon": [NSString stringWithFormat:@"%f", lon]};
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:SASearchAssociateModel.class json:rspModel.data];
        if ([arr isKindOfClass:NSArray.class]) {
            !successBlock ?: successBlock([NSArray yy_modelArrayWithClass:SASearchAssociateModel.class json:rspModel.data]);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return request;
}


- (void)getSystemConfigWithKey:(NSString *)key success:(void (^)(NSString *value))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/h5/no-auth/findSystemConfigs";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = key;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if ([info isKindOfClass:NSDictionary.class] && info[key]) {
            NSDictionary *dic = info[key];
            if ([dic isKindOfClass:NSDictionary.class]) {
                !successBlock ?: successBlock(dic[@"value"]);
            } else {
                !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
            }
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)searchWithKeyWord:(NSString *)keyWord complete:(nonnull void (^)(NSArray * _Nonnull))complete {
    NSMutableArray *mArr = @[@(0),@(0),@(0)].mutableCopy;
    
    dispatch_group_t taskGroup = dispatch_group_create();
    
    if(HDIsObjectNil(self.currentlyAddress)) {
        self.currentlyAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    }
    //外卖
    dispatch_group_enter(taskGroup);
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.currentlyAddress) {
            params[@"location"] = @{@"lat": self.currentlyAddress.lat.stringValue, @"lon": self.currentlyAddress.lon.stringValue};
            params[@"province"] = self.currentlyAddress.city;
            params[@"district"] = self.currentlyAddress.subLocality;
        }
    
        params[@"pageSize"] = @(1);
        params[@"pageNum"] = @(1);
        params[@"keyword"] = keyWord;
        params[@"type"] = @"all";
        params[@"inRange"] = @(1);
        
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/takeaway-merchant/app/super-app/search/v2";
        request.isNeedLogin = NO;
        request.requestParameter = params;
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            NSDictionary *dic = (NSDictionary *)rspModel.data;
            if([dic isKindOfClass:NSDictionary.class]){
                NSInteger count = [dic[@"total"] integerValue];
                if(count > 0) {
                    mArr[0] = @(count);
                }
            }
            dispatch_group_leave(taskGroup);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            dispatch_group_leave(taskGroup);
        }];
    }
    //电商
    dispatch_group_enter(taskGroup);
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"pageNum"] = @(1);
        params[@"pageSize"] = @(1);

        if (HDIsStringNotEmpty(keyWord)) {
            params[@"key"] = keyWord;
        }

        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/tapi/es/product/searchV3";
        request.isNeedLogin = NO;
        request.requestParameter = params;
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            NSDictionary *dic = (NSDictionary *)rspModel.data;
            if([dic isKindOfClass:NSDictionary.class]){
                NSInteger count = [dic[@"total"] integerValue];
                if(count > 0) {
                    mArr[1] = @(count);
                }
            }
            dispatch_group_leave(taskGroup);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            dispatch_group_leave(taskGroup);
        }];
    }
    //团购
    dispatch_group_enter(taskGroup);
    {
        NSMutableDictionary *mdic = NSMutableDictionary.new;

        if (keyWord) {
            [mdic setObject:keyWord forKey:@"keyword"];
        }

        if (self.currentlyAddress) {
            [mdic setObject:@{@"lat": self.currentlyAddress.lat.stringValue, @"lon": self.currentlyAddress.lon.stringValue} forKey:@"location"];
        }
        [mdic setObject:@(1) forKey:@"pageNum"];
        [mdic setObject:@(1) forKey:@"pageSize"];

        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/groupon-service/user/merchant/search";
        request.isNeedLogin = NO;

        request.requestParameter = mdic;
        
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            NSDictionary *dic = (NSDictionary *)rspModel.data;
            if([dic isKindOfClass:NSDictionary.class]){
                NSInteger count = [dic[@"total"] integerValue];
                if(count > 0) {
                    mArr[2] = @(count);
                }
            }
            dispatch_group_leave(taskGroup);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            dispatch_group_leave(taskGroup);
        }];
    }

    dispatch_group_notify(taskGroup, dispatch_get_global_queue(0, 0), ^{
        !complete?:complete(mArr);
    });
}


#pragma mark - lazy load
- (SASearchDTO *)searchDTO {
    if (!_searchDTO) {
        _searchDTO = [[SASearchDTO alloc] init];
    }
    return _searchDTO;
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

- (HDTableViewSectionModel *)historySectionModel {
    if (!_historySectionModel) {
        _historySectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = WMLocalizedString(@"history_search", @"最近");
        headerModel.rightButtonImage = [UIImage imageNamed:@"search_icon_del"];
        //        headerModel.rightButtonTitle = WMLocalizedStringFromTable(@"button_title_clear", @"清除", @"Buttons");
        //        headerModel.rightTitleToImageMarin = kRealWidth(3);
        _historySectionModel.headerModel = headerModel;
    }
    return _historySectionModel;
}

@end
