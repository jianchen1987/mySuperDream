//
//  PNWalletDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWalletDTO.h"
#import "PNRspModel.h"
#import "PNUtilMacro.h"
#import "PNWalletAcountModel.h"
#import "PNWalletFunctionModel.h"
#import "PNWalletListConfigModel.h"
#import "SAUser.h"
#import "VipayUser.h"


@implementation PNWalletDTO

/// 查询我的账户余额
- (void)getMyWalletInfoSuccess:(void (^_Nullable)(PNWalletAcountModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    //    request.requestURI = @"/userinfo/account/balance/query2"; /// 旧接口
    request.requestURI = @"/userinfo/account/balance/query3"; /// 新接口 区分开 余额的定义【v5.0.1】
    request.isNeedLogin = YES;

    request.requestParameter = @{
        @"loginName": VipayUser.shareInstance.loginName ?: SAUser.shared.loginName,
    };
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNWalletAcountModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取钱包列表配置
- (void)getWalletListConfig:(void (^_Nullable)(NSArray<PNWalletListConfigModel *> *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/bill/user/home/config.do";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:[PNWalletListConfigModel class] json:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// KYC用户营销信息
- (void)getWalletMarketingInfo:(void (^_Nullable)(NSString *showMsg))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/balance/queryMarketing/info";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSString *marketingInformationStr = @"";
        if (!WJIsObjectNil(rspModel.data)) {
            NSDictionary *dict = rspModel.data;
            if ([dict.allKeys containsObject:@"marketingInformation"]) {
                marketingInformationStr = [dict objectForKey:@"marketingInformation"];
            }
        }
        !successBlock ?: successBlock(marketingInformationStr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取APP 功能配置
- (void)getAllWalletFunctionConfig:(void (^_Nullable)(PNWalletFunctionModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/bill/user/home/config.do/v2";

    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNWalletFunctionModel *model = [PNWalletFunctionModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
