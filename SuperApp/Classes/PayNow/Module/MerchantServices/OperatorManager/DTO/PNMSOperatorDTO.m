//
//  PNMSOperatorDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOperatorDTO.h"
#import "PNMSOperatorInfoModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNMSOperatorDTO

/// 获取操作员列表数据
- (void)getOperatorListData:(void (^)(NSArray<PNMSOperatorInfoModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/queryMerOperatorList.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:PNMSOperatorInfoModel.class json:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 保存/修改 商户服务操作员
- (void)saveOrUpdateOperator:(NSDictionary *)dict success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/saveMerOperator.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 查询商户服务操作员权限详情
- (void)getOperatorDetail:(NSString *)operatorMobile success:(void (^)(PNMSOperatorInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/queryMerOperatorDetail.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [params setValue:operatorMobile forKey:@"operatorMobile"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSOperatorInfoModel *infoModel = [PNMSOperatorInfoModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(infoModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 重置操作员支付密码
- (void)reSetOperatorPwdSendSMS:(NSString *)operatorMobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant/app/mer/role/tradePwd/reset/sendSms.do";
    request.requestParameter = @{
        @"operatorMobile": operatorMobile,
        @"customerType": @"ORG",
        @"smsSendTemplate": @(12),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 解除绑定 操作员
- (void)unBindOperator:(NSString *)operatorMobile success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/merchant/app/mer/role/unbindingOperator.do";

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setValue:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    [params setValue:operatorMobile forKey:@"operatorMobile"];

    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 通过手机号码反查 账号信息
- (void)getCCAmountWithMobile:(NSString *)mobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/info/query.do";
    request.requestParameter = @{
        @"payeeMobile": mobile,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
