//
//  GNSearchDTO.m
//  SuperApp
//
//  Created by wmz on 2021/6/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSearchDTO.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SACommonConst.h"


@interface GNSearchDTO ()
/// 搜索
@property (nonatomic, strong) CMNetworkRequest *merchantSearchRequest;
/// 为您推荐
@property (nonatomic, strong) CMNetworkRequest *merchantRecommendedForYouRequest;

@end


@implementation GNSearchDTO

/// 搜索
- (CMNetworkRequest *_Nullable)merchantSearchKeyword:(nullable NSString *)keyword
                                             pageNum:(NSInteger)pageNum
                                             success:(nullable void (^)(GNStorePagingRspModel *rspModel))successBlock
                                             failure:(nullable CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *mdic = NSMutableDictionary.new;

    if (keyword) {
        [mdic setObject:keyword forKey:@"keyword"];
    }
    [mdic setObject:self.locationInfo forKey:@"location"];
    [mdic setObject:@(pageNum) forKey:@"pageNum"];
    [mdic setObject:@(20) forKey:@"pageSize"];
    self.merchantSearchRequest.requestParameter = [NSDictionary dictionaryWithDictionary:mdic];
    [self.merchantSearchRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNStorePagingRspModel *model = [GNStorePagingRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.merchantSearchRequest;
}

/// 为您推荐
- (CMNetworkRequest *_Nullable)merchantRecommendedForYouPageNum:(NSInteger)pageNum
                                                        success:(nullable void (^)(GNStorePagingRspModel *rspModel))successBlock
                                                        failure:(nullable CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    [mdic setObject:self.locationInfo forKey:@"location"];
    [mdic setObject:@(pageNum) forKey:@"pageNum"];
    [mdic setObject:@(20) forKey:@"pageSize"];
    self.merchantRecommendedForYouRequest.requestParameter = [NSDictionary dictionaryWithDictionary:mdic];
    [self.merchantRecommendedForYouRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        GNStorePagingRspModel *model = [GNStorePagingRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.merchantRecommendedForYouRequest;
}

- (CMNetworkRequest *)merchantSearchRequest {
    if (!_merchantSearchRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/merchant/search";
        _merchantSearchRequest = request;
    }
    return _merchantSearchRequest;
}

- (CMNetworkRequest *)merchantRecommendedForYouRequest {
    if (!_merchantRecommendedForYouRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/groupon-service/user/merchant/recommended-for-you";
        _merchantRecommendedForYouRequest = request;
    }
    return _merchantRecommendedForYouRequest;
}

@end
