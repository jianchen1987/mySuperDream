//
//  PNMSReceiveCodeDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSReceiveCodeDTO.h"
#import "PNCommonUtils.h"
#import "PNMSStoreOperatorInfoModel.h"
#import "PNRspModel.h"


@implementation PNMSReceiveCodeDTO
/// 获取收款码
- (void)genQRCode:(NSDictionary *)params success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.requestURI = @"/app/mer/bakong/qr/querySceneBakongQrData.do";
    request.requestParameter = params;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 检查qrData 是否可用
- (void)checkQRData:(NSString *)qrData success:(void (^)(BOOL spValue))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/app/mer/bakong/qr/checkSceneIdAlreadyUsed.do";

    request.requestParameter = @{@"qrdata": qrData};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        /// true 代表已经使用过
        BOOL isValid = YES;
        if ([rspModel.data isKindOfClass:NSDictionary.class]) {
            NSDictionary *dic = rspModel.data;

            if ([dic.allKeys containsObject:@"valid"]) {
                isValid = [[dic objectForKey:@"valid"] boolValue];
            }
        }
        !successBlock ?: successBlock(isValid);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 根据loginName 查商户角色权限详情
- (void)getMerRoleDetail:(void (^)(PNMSStoreOperatorInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = [PNNetworkRequest new];
    request.isNeedLogin = YES;
    request.requestURI = @"/merchant/app/mer/role/queryMerRoleDetailByLoginName.do";

    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNMSStoreOperatorInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
