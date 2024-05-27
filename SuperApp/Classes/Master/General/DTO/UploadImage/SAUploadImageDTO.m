//
//  SAUploadImageDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAUploadImageDTO.h"
#import "SAAppEnvManager.h"
#import "SABatchUploadFileRspModel.h"
#import "SAUploadFileGetAccessTokenRspModel.h"


@interface SAUploadImageDTO ()

/// 上传图片
@property (nonatomic, strong) CMNetworkRequest *batchUploadRequest;

@end


@implementation SAUploadImageDTO

- (void)dealloc {
    [_batchUploadRequest cancel];
}

- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    return [self batchUploadImages:images singleImageLimitedSize:500 progress:progressBlock success:successBlock failure:failureBlock];
}

- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                 singleImageLimitedSize:(float)singleImageLimitedSize
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    return [self batchUploadImages:images singleImageLimitedSize:singleImageLimitedSize name:nil fileNames:nil imageScale:1.0 imageType:nil progress:progressBlock success:successBlock
                           failure:failureBlock];
}

- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                                   name:(NSString *)name
                              fileNames:(NSArray<NSString *> *)fileNames
                             imageScale:(CGFloat)imageScale
                              imageType:(NSString *)imageType
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    return [self batchUploadImages:images singleImageLimitedSize:500 name:name fileNames:fileNames imageScale:imageScale imageType:imageType progress:progressBlock success:successBlock
                           failure:failureBlock];
}

- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                 singleImageLimitedSize:(float)singleImageLimitedSize
                                   name:(NSString *)name
                              fileNames:(NSArray<NSString *> *)fileNames
                             imageScale:(CGFloat)imageScale
                              imageType:(NSString *)imageType
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    void (^gotToken)(NSString *) = ^(NSString *accessToken) {
        if (self.uploadToBoss) { //上传到fileserver
            self.batchUploadRequest.requestURI = [NSString stringWithFormat:@"/batch-upload.do?group=boss&uploadTicket=%@&loginName=%@", accessToken, SAUser.shared.loginName];
            self.batchUploadRequest.requestParameter = @{@"group": @"boss", @"uploadTicket": accessToken, @"loginName": SAUser.shared.loginName};
        } else {
            self.batchUploadRequest.requestURI = [NSString stringWithFormat:@"/batch-upload.do?uploadTicket=%@&loginName=%@", accessToken, SAUser.shared.loginName];
        }
        self.batchUploadRequest.requestConstructingBody = ^(id<AFMultipartFormData> _Nonnull formData) {
            for (NSUInteger i = 0; i < images.count; i++) {
                UIImage *image = images[i];
                // 图片压缩，单张限制大小
                [HDImageCompressTool compressedImage:image imageKB:singleImageLimitedSize imageBlock:^(NSData *_Nonnull imageData) {
                    NSString *defaultFileName = [NSString stringWithFormat:@"%1.0f%@", [[NSDate date] timeIntervalSince1970], @"superapp"];
                    [formData appendPartWithFileData:imageData name:name ?: @"files" fileName:[NSString stringWithFormat:@"%@.%@", defaultFileName, imageType ?: @"png"]
                                            mimeType:[NSString stringWithFormat:@"image/%@", imageType ?: @"png"]];
                }];
            }
        };
        [self.batchUploadRequest startWithUploadProgress:progressBlock downloadProgress:nil cache:nil success:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            SABatchUploadFileRspModel *data = [SABatchUploadFileRspModel yy_modelWithJSON:rspModel.data];
            NSArray<NSString *> *list = [data.uploadResultDTOList mapObjectsUsingBlock:^id _Nonnull(SABatchUploadFileSingleRspModel *_Nonnull obj, NSUInteger idx) {
                return obj.url;
            }];
            !successBlock ?: successBlock(list);
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

- (void)uploadSingleImage:(UIImage *)image
    singleImageLimitedSize:(float)singleImageLimitedSize
                  progress:(HDRequestProgressBlock)progressBlock
                   success:(nonnull void (^)(NSString *))successBlock
                   failure:(CMNetworkFailureBlock)failureBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CMNetworkRequest *request = [[CMNetworkRequest alloc] init];
        request.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.fileServer;
        request.requestURI = @"/upload_without_auth.do";
        request.requestConstructingBody = ^(id<AFMultipartFormData> _Nonnull formData) {
            // 图片压缩，单张限制大小
            [HDImageCompressTool compressedImage:image imageKB:singleImageLimitedSize imageBlock:^(NSData *_Nonnull imageData) {
                NSString *defaultFileName = [NSString stringWithFormat:@"%1.0f%@", [[NSDate date] timeIntervalSince1970], @"superapp"];
                [formData appendPartWithFileData:imageData name:@"files" fileName:[NSString stringWithFormat:@"%@.%@", defaultFileName, @"png"]
                                        mimeType:[NSString stringWithFormat:@"image/%@", @"png"]];
            }];
        };
        [request startWithUploadProgress:progressBlock downloadProgress:nil cache:nil success:^(HDNetworkResponse *_Nonnull response) {
            SARspModel *rspModel = response.extraData;
            id data = rspModel.data;
            NSString *url = @"";
            if ([data isKindOfClass:[NSDictionary class]]) {
                url = data[@"url"];
            }
            !successBlock ?: successBlock(url);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }];
    });
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
