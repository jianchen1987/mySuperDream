//
//  PNMSSettingDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSSettingDTO.h"
#import "PNMSAgreementDataModel.h"
#import "PNRspModel.h"


@implementation PNMSSettingDTO
/// 商户协议地址
- (void)getMSAgreementDataWithMerchantNo:(NSString *)merchantNo success:(void (^)(NSArray<PNMSAgreementDataModel *> *rspList))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/app/mer/agreement/data.do";
    request.requestParameter = @{
        @"merchantNo": merchantNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSArray<PNMSAgreementDataModel *> *arr = [NSArray yy_modelArrayWithClass:PNMSAgreementDataModel.class json:rspModel.data];
        !successBlock ?: successBlock(arr);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
