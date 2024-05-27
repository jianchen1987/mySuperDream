//
//  WMCustomizationDTO.m
//  SuperApp
//
//  Created by seeu on 2020/8/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCustomizationDTO.h"
#import "WMSpecialPromotionRspModel.h"
#import "WMTimeBucketsRecommandRspModel.h"


@interface WMCustomizationDTO ()

/// 专题活动
@property (nonatomic, strong) CMNetworkRequest *specialReq;

@end


@implementation WMCustomizationDTO

- (void)dealloc {
    [_specialReq cancel];
}

/// 根据当前位置获取专题活动详情
/// @param promotionNo 专题活动编号
/// @param pageNo 页码
/// @param pageSize 分页大小
/// @param coordinate 当前位置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryYumNowSpecialPromotionWithPromotionNo:(NSString *)promotionNo
                                                          pageNo:(NSUInteger)pageNo
                                                        pageSize:(NSUInteger)pageSize
                                                        location:(CLLocationCoordinate2D)coordinate
                                                         success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    return [self queryYumNowSpecialPromotionWithPromotionNo:promotionNo categoryNo:nil pageNo:pageNo pageSize:pageSize location:coordinate success:successBlock failure:failureBlock];
}

- (CMNetworkRequest *)queryYumNowSpecialPromotionWithPromotionNo:(NSString *)promotionNo
                                                      categoryNo:(NSString *)categoryNo
                                                          pageNo:(NSUInteger)pageNo
                                                        pageSize:(NSUInteger)pageSize
                                                        location:(CLLocationCoordinate2D)coordinate
                                                         success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"topicNo"] = promotionNo;
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    if (HDIsStringNotEmpty(categoryNo)) {
        params[@"categoryNo"] = categoryNo;
    }
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:coordinate];
    if (!isParamsCoordinate2DValid) {
        // 地址无效，使用定位地址
        params[@"location"] = @{
            @"lat": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.latitude].stringValue,
            @"lon": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.longitude].stringValue
        };
    } else {
        params[@"location"] = @{@"lat": [NSString stringWithFormat:@"%f", coordinate.latitude], @"lon": [NSString stringWithFormat:@"%f", coordinate.longitude]};
    }

    self.specialReq.requestParameter = params;
    [self.specialReq startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMSpecialPromotionRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.specialReq;
}

- (CMNetworkRequest *)queryYumNowSpecialPromotionWithPromotionNo:(NSString *)promotionNo
                                                      categoryNo:(NSString *)categoryNo
                                                          pageNo:(NSUInteger)pageNo
                                                        pageSize:(NSUInteger)pageSize
                                                        location:(CLLocationCoordinate2D)coordinate
                                                        sortType:(NSString *)sortType
                                                  marketingTypes:(NSArray<NSString *> *)marketingTypes
                                                    storeFeature:(NSArray<NSString *> *)storeFeature
                                                    businessCode:(NSString *)businessCode
                                                         success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"topicNo"] = promotionNo;
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:pageSize];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    if (HDIsStringNotEmpty(categoryNo)) {
        params[@"categoryNo"] = categoryNo;
    }
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:coordinate];
    if (!isParamsCoordinate2DValid) {
        // 地址无效，使用定位地址
        params[@"location"] = @{
            @"lat": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.latitude].stringValue,
            @"lon": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.longitude].stringValue
        };
    } else {
        params[@"location"] = @{@"lat": [NSString stringWithFormat:@"%f", coordinate.latitude], @"lon": [NSString stringWithFormat:@"%f", coordinate.longitude]};
    }
    
    params[@"sortType"] = sortType ? sortType : @"";
    params[@"businessCode"] = businessCode ? businessCode : @"";

    if (marketingTypes && marketingTypes.count > 0) {
        NSString *strArr = [marketingTypes componentsJoinedByString:@","];
        NSArray<NSString *> *newArr = [strArr componentsSeparatedByString:@","];
        NSMutableArray<NSString *> *lastArr = [NSMutableArray arrayWithArray:newArr];
        [lastArr removeObject:@"99"];
        params[@"marketingTypes"] = lastArr;
    } else {
        params[@"marketingTypes"] = @[];
    }
    
    if (storeFeature.count){
        params[@"storeFeature"] = storeFeature;
    }else{
        params[@"storeFeature"] = @[];
    }

    self.specialReq.requestParameter = params;
    [self.specialReq startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMSpecialPromotionRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.specialReq;
    
}

- (void)queryYumNowEatOnTimeWithId:(NSString *)ID
                            pageNo:(NSUInteger)pageNo
                          location:(CLLocationCoordinate2D)coordinate
                           success:(void (^_Nullable)(WMMoreEatOnTimeRspModel *rspModel))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-eat-on-time-more";
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = ID;
    params[@"pageSize"] = [NSNumber numberWithUnsignedInteger:10];
    params[@"pageNum"] = [NSNumber numberWithUnsignedInteger:pageNo];
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:coordinate];
    if (!isParamsCoordinate2DValid) {
        params[@"geo"] = @{
            @"lat": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.latitude].stringValue,
            @"lon": [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.longitude].stringValue
        };
    } else {
        params[@"geo"] = @{@"lat": [NSString stringWithFormat:@"%f", coordinate.latitude], @"lon": [NSString stringWithFormat:@"%f", coordinate.longitude]};
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMMoreEatOnTimeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

///埋点
+ (void)saveOtherCollectionData:(NSString *)event ext:(NSDictionary *)ext spm:(NSDictionary *)spm {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/warehouse/collection/saveOtherCollectionData.do";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *param = NSMutableDictionary.new;
    param[@"event"] = event;
    param[@"sessionId"] = @"";
    param[@"businessName"] = SAClientTypeYumNow;
    param[@"businessLine"] = SAClientTypeYumNow;
    param[@"operatorNo"] = [SAUser.shared operatorNo];
    param[@"language"] = [HDDeviceInfo getDeviceLanguage];
    param[@"appId"] = @"SuperApp";
    param[@"appNo"] = @"11";
    param[@"channel"] = @"AppStore";
    param[@"appVersion"] = [HDDeviceInfo appVersion];
    param[@"deviceId"] = [HDDeviceInfo getUniqueId];
    param[@"deviceType"] = @"IOS";
    param[@"recordTime"] = @(NSDate.date.timeIntervalSince1970 * 1000).stringValue;
    param[@"ext"] = ext;
    param[@"spm"] = spm;
    if ([HDLocationUtils getCLAuthorizationStatus] == HDCLAuthorizationStatusAuthed && [[HDLocationManager shared] isCurrentCoordinate2DValid]) {
        ///< 经度
        [param setValue:[NSString stringWithFormat:@"%f", [HDLocationManager shared].realCoordinate2D.latitude] forKey:@"latitude"];
        ///< 纬度
        [param setValue:[NSString stringWithFormat:@"%f", [HDLocationManager shared].realCoordinate2D.longitude] forKey:@"longitude"];
    } else {
        ///< 经度
        [param setValue:@"" forKey:@"latitude"];
        ///< 纬度
        [param setValue:@"" forKey:@"longitude"];
    }
    request.requestParameter = @{@"loginName": SAUser.shared.loginName, @"otherCollectionDatas": param};
    [request startWithSuccess:nil failure:nil];
}

#pragma mark - lazy load
- (CMNetworkRequest *)specialReq {
    if (!_specialReq) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/takeaway-merchant/app/super-app/topic";
        request.isNeedLogin = NO;
        _specialReq = request;
    }
    return _specialReq;
}

@end
