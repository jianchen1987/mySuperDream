//
//  PNMSHomeDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSHomeDTO.h"
#import "PNMSBaseInfoModel.h"
#import "PNMSInfoModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNMSHomeDTO

/// 用户绑定商户信息概览【overall】
- (void)getMerchantServicesInfo:(void (^)(PNMSInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/merchants/overall/5.2.0";
    //    request.requestURI = @"/usercenter/merchants/overall";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSInfoModel *encryptModel = [PNMSInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(encryptModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 商户服务-商户服务首页【balance】
- (void)getMSHomeBalance:(void (^)(NSArray<PNMSBalanceInfoModel *> *rspList))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/privision/balance2.do";
    request.requestParameter = @{
        @"merchantNo": VipayUser.shareInstance.merchantNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray<PNMSBalanceInfoModel *> *arr = [NSArray yy_modelArrayWithClass:PNMSBalanceInfoModel.class json:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 商户基本信息
- (void)getMerchantServicesBaseInfo:(void (^)(PNMSBaseInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/merchants/detail";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSBaseInfoModel *encryptModel = [PNMSBaseInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(encryptModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 解除跟商户绑定
- (void)unBindMerchantServiceWithMerchantNo:(NSString *)merchantNo
                                 operatorNo:(NSString *)operatorNo
                                      index:(NSString *)index
                                        pwd:(NSString *)pwd
                                    success:(void (^)(PNRspModel *rspModel))successBlock
                                    failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/merchants/verify/unbind";
    request.requestParameter = @{
        @"merchantNo": merchantNo,
        @"operatorNo": operatorNo,
        @"index": index,
        @"pwd": pwd,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
