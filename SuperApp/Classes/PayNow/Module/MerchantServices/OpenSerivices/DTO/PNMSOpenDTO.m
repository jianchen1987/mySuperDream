//
//  PNMSOpenDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOpenDTO.h"
#import "PNMSCategoryRspModel.h"
#import "PNMSOpenModel.h"
#import "PNRspModel.h"
#import "PNUtilMacro.h"


@implementation PNMSOpenDTO
/// 获取经营品类
- (void)getCategory:(void (^)(PNMSCategoryRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/category/tree.do";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSCategoryRspModel *encryptModel = [PNMSCategoryRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(encryptModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 开通商户
- (void)openMerchantServices:(NSDictionary *)paramDict
                  merchantNo:(NSString *)merchantNo
                     success:(void (^)(PNMSCategoryRspModel *rspModel))successBlock
                     failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    // 根据是否有merchantNo 来决定是开通 还是 修改
    if (WJIsStringNotEmpty(merchantNo)) {
        request.requestURI = @"/usercenter/merchants/edit";
    } else {
        request.requestURI = @"/usercenter/merchants/create";
    }

    request.requestParameter = paramDict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSCategoryRspModel *encryptModel = [PNMSCategoryRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(encryptModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取审核失败商户信息 【用于拒绝后填充数据】
- (void)getMMSApplyDetailsWithMerchantNo:(NSString *)merchantNo success:(void (^)(PNMSOpenModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/merchants/apply/detail";
    request.requestParameter = @{
        @"merchantNo": merchantNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSOpenModel *encryptModel = [PNMSOpenModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(encryptModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
