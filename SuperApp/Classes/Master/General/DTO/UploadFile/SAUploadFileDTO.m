//
//  SAUploadFileDTO.m
//  SuperApp
//
//  Created by Tia on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUploadFileDTO.h"
#import "SAAppEnvManager.h"
#import "SABatchUploadFileRspModel.h"
#import "SAUploadFileGetAccessTokenRspModel.h"


@interface SAUploadFileDTO ()

/// 上传文件的网络请求
@property (nonatomic, strong) CMNetworkRequest *batchUploadRequest;

@end


@implementation SAUploadFileDTO

- (CMNetworkRequest *)batchUploadFileData:(NSData *)fileData
                                 fileName:(NSString *)fileName
                                 fileType:(NSString *)fileType
                                 mimeType:(NSString *)mimeType
                                 progress:(HDRequestProgressBlock)progressBlock
                                  success:(nonnull void (^)(NSString *_Nonnull))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock {
    void (^gotToken)(NSString *) = ^(NSString *accessToken) {
        self.batchUploadRequest.requestURI = [NSString stringWithFormat:@"/batch-upload.do?uploadTicket=%@&loginName=%@", accessToken, SAUser.shared.loginName];
        self.batchUploadRequest.requestConstructingBody = ^(id<AFMultipartFormData> _Nonnull formData) {
            NSString *defaultFileName = [NSString stringWithFormat:@"%1.0f%@", [[NSDate date] timeIntervalSince1970], @"superapp"];
            [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.%@", defaultFileName, fileType] mimeType:mimeType];
        };

        [self.batchUploadRequest startWithUploadProgress:progressBlock downloadProgress:nil cache:nil success:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            SABatchUploadFileRspModel *data = [SABatchUploadFileRspModel yy_modelWithJSON:rspModel.data];
            NSArray<NSString *> *list = [data.uploadResultDTOList mapObjectsUsingBlock:^id _Nonnull(SABatchUploadFileSingleRspModel *_Nonnull obj, NSUInteger idx) {
                return obj.url;
            }];
            !successBlock ?: successBlock(list.firstObject ? list.firstObject : @"");
        } failure:^(HDNetworkResponse *_Nonnull response) {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }];
    };
    // 先获取 accessToken
    CMNetworkRequest *getAccessTokenRequest = CMNetworkRequest.new;
    getAccessTokenRequest.retryCount = 2;
    getAccessTokenRequest.requestURI = @"/authcenter/apply/ticket.do";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bizType"] = @"17";
    getAccessTokenRequest.requestParameter = params;
    [getAccessTokenRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        SAUploadFileGetAccessTokenRspModel *tokenRspModel = [SAUploadFileGetAccessTokenRspModel yy_modelWithJSON:rspModel.data];
        !gotToken ?: gotToken(tokenRspModel.uploadTicket);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
    return self.batchUploadRequest;
}

#pragma mark - lazy load
- (CMNetworkRequest *)batchUploadRequest {
    if (!_batchUploadRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.fileServer;

        _batchUploadRequest = request;
    }
    return _batchUploadRequest;
}

@end
