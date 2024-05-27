//
//  SACouponTicketDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACouponTicketDTO.h"
#import "SABusinessCouponCountRspModel.h"
#import "SACouponInfoRspModel.h"
#import "SACouponTicketModel.h"
#import "SAGetSigninActivityEntranceRspModel.h"
#import "SAGetUserCouponTicketRspModel.h"


@implementation SACouponTicketDTO

- (void)getCouponInfoWithBusinessLine:(SAMarketingBusinessType)businessLine success:(void (^)(SACouponInfoRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        !failureBlock ?: failureBlock(nil, CMResponseErrorTypeLoginExpired, nil);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(businessLine)) {
        params[@"businessType"] = businessLine;
    }
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/coupon/avaliable/count.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SACouponInfoRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getCouponTicketListWithPageSize:(NSUInteger)pageSize
                                pageNum:(NSUInteger)pageNum
                            couponState:(SACouponState)couponState
                           businessLine:(SAClientType)businessLine
                               sortType:(SACouponListSortType)sortType
                                success:(void (^)(SAGetUserCouponTicketRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    params[@"couponState"] = @(couponState);
    if (HDIsStringNotEmpty(businessLine) && ![businessLine isEqualToString:SAClientTypeAll]) {
        params[@"businessLine"] = businessLine;
    }
    params[@"orderByType"] = @(sortType);
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/coupon/list.do";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAGetUserCouponTicketRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getNewSortCouponTicketListWithPageSize:(NSUInteger)pageSize
                                       pageNum:(NSUInteger)pageNum
                                   couponState:(SACouponState)couponState
                                  businessLine:(SAClientType)businessLine
                             topFilterSortType:(SACouponListNewSortType)topFilterSortType
                                    couponType:(SACouponListCouponType)couponType
                                     sceneType:(SACouponListSceneType)sceneType
                                       orderBy:(SACouponListOrderByType)orderBy
                                       success:(void (^)(SAGetUserCouponTicketRspModel *_Nonnull))successBlock
                                       failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pageSize);
    params[@"pageNum"] = @(pageNum);
    params[@"couponState"] = @(couponState);
    params[@"couponType"] = @(couponType); //优惠券类型
    //    params[@"orderByType"] = @(sortType);
    params[@"topFilter"] = @(topFilterSortType); //顶部筛选条件
    params[@"sceneType"] = @(sceneType);         //券类别9-全部 10-平台券 11-门店券
    if (HDIsStringNotEmpty(businessLine) && ![businessLine isEqualToString:SAClientTypeAll]) {
        params[@"businessLine"] = businessLine; //可用范围
    }
    params[@"orderBy"] = @(orderBy); //排序 10-默认 11-新到 12-快过期 13-面额由大到小 14-面额由小到大
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/coupon/queryUserCouponList.do";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAGetUserCouponTicketRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getBusinessCouponCountWithCouponState:(SACouponState)couponState
                                   operatorNo:(NSString *_Nonnull)operatorNo
                                      success:(void (^)(SABusinessCouponCountRspModel *_Nonnull))success
                                      failure:(CMNetworkFailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"couponState"] = @(couponState);
    params[@"userNo"] = operatorNo;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/coupon/aggregation.do";
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !success ?: success([SABusinessCouponCountRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failure ?: failure(response.extraData, response.errorType, response.error);
    }];
}

- (void)getBusinessCouponCountWithOperatorNo:(NSString *_Nonnull)operatorNo success:(void (^)(SABusinessCouponCountRspModel *_Nonnull))success failure:(CMNetworkFailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userNo"] = operatorNo;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/coupon/couponTypeAggregation.do";
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !success ?: success([SABusinessCouponCountRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failure ?: failure(response.extraData, response.errorType, response.error);
    }];
}

- (void)getSigninActivityEntranceSuccess:(void (^)(SAGetSigninActivityEntranceRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/activity/sign-in/getSignInActivityUrl";
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAGetSigninActivityEntranceRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
