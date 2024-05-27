//
//  PNIDVerifyDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNIDVerifyDTO.h"
#import "PNGetCardTypeRspModel.h"
#import "PNRspModel.h"
#import "SAUser.h"


@implementation PNIDVerifyDTO

/// 获取 注册的证件类型
- (void)getCardType:(void (^_Nullable)(PNGetCardTypeRspModel *model))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/getCardType";

    ///没有进入到支付，需要用中台的loginName
    request.requestParameter = @{
        @"loginName": SAUser.shared.loginName,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNGetCardTypeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 客户信息校验
- (void)verifyCustomerInfo:(NSDictionary *)requestParam success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/verifyCustomerInfo";
    /*
     surname 姓  => lastName
     name 名称 => firstName
     */
    ///没有进入到支付，需要用中台的loginName
    request.requestParameter = requestParam;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 激活钱包
- (void)walletActivation:(NSString *)index
                     pwd:(NSString *)pwd
             verifyParam:(NSDictionary *)verifyParam
                 success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
                 failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/wallet/activation.do";

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:verifyParam];
    [dict setValue:index forKey:@"index"];
    [dict setValue:pwd forKey:@"pwd"];

    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
