//
//  PNUserDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUserDTO.h"
#import "HDReflushTokenRspModel.h"
#import "HDUserRegisterRspModel.h"
#import "PNContactUSModel.h"
#import "PNRspModel.h"
#import "PNWalletLimitModel.h"
#import "SAGeneralUtil.h"
#import "VipayUser.h"


@implementation PNUserDTO

/// 查询我的用户信息
- (void)getPayNowUserInfoSuccess:(void (^_Nullable)(HDUserInfoRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/userinfo/info/query.do";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;

        HDUserInfoRspModel *userInfoModel = [HDUserInfoRspModel yy_modelWithJSON:rspModel.data];
        [VipayUser.shareInstance updateByModel:userInfoModel];

        !successBlock ?: successBlock(userInfoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询我的用户信息V2
- (void)getPayNowUserInfoV2Success:(void (^_Nullable)(HDUserInfoRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/userinfo/info/queryV2.do";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;

        HDUserInfoRspModel *userInfoModel = [HDUserInfoRspModel yy_modelWithJSON:rspModel.data];
        [VipayUser.shareInstance updateByModel:userInfoModel];

        !successBlock ?: successBlock(userInfoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取限额列表
- (void)getWalletLimit:(void (^_Nullable)(NSArray<PNWalletLimitModel *> *list))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/risk/user/limit/level/list";

    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray<PNWalletLimitModel *> *list = [NSArray yy_modelArrayWithClass:PNWalletLimitModel.class json:rspModel.data];
        !successBlock ?: successBlock(list);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询最新提交的KYC信息
- (void)queryUserInfoFromKYC:(void (^_Nullable)(HDUserInfoRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    //    request.requestURI = @"/userinfo/apply/query.do";
    request.requestURI = @"/userinfo/apply/queryV2.do";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;

        HDUserInfoRspModel *userInfoModel = [HDUserInfoRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(userInfoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取服务器当前时间
- (void)getCurrentDay:(void (^_Nullable)(NSString *rspDate))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/kyc/curDate";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.needSessionKey = NO;
    request.isNeedLogin = NO;

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSString *dateStr = [rspModel.data objectForKey:@"date"];
        !successBlock ?: successBlock(dateStr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 联系我们
- (void)getContactUSInfo:(void (^_Nullable)(PNContactUSModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/contactUs";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNContactUSModel *model = [PNContactUSModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取所有公告，
- (void)getAllNoticeSuccess:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/notice/allNotice";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;

        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
