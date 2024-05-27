//
//  PNUploadImageDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadImageDTO.h"
#import "HDPasswordManagerViewModel.h"
#import "PNRspModel.h"
#import "SAAppEnvManager.h"
#import "VipayUser.h"


@interface PNUploadImageDTO ()
@property (nonatomic, strong) HDPasswordManagerViewModel *pwdVM;
@end


@implementation PNUploadImageDTO

- (void)uploadImages:(NSArray<UIImage *> *)images
            progress:(HDRequestProgressBlock)progressBlock
             success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
             failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self uploadImages:images singleImageLimitedSize:500 name:@"file" fileNames:@[] imageType:@"png" progress:progressBlock success:successBlock failure:failureBlock];
}

/// 单个上传【图片】
- (void)uploadImages:(NSArray<UIImage *> *)images
    singleImageLimitedSize:(float)singleImageLimitedSize
                      name:(NSString *)name
                 fileNames:(NSArray<NSString *> *)fileNames
                 imageType:(NSString *)imageType
                  progress:(HDRequestProgressBlock)progressBlock
                   success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                   failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    void (^gotToken)(NSString *) = ^(NSString *accessToken) {
        // 创建会话管理者
        PNNetworkRequest *request = PNNetworkRequest.new;
        request.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer;

        NSString *url = @"";
        if (accessToken.length > 0) {
            url = [NSString stringWithFormat:@"/file_web/file-service/file/upload.do?accessToken=%@&loginName=%@", accessToken, VipayUser.shareInstance.loginName];
        } else {
            url = @"/file_web/file-service/file/upload_without_auth.do?group=app";
        }

        request.requestURI = url;

        HDLog(@"😄😄😄 请求上传图片接口： %@%@", SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer, url);

        request.requestConstructingBody = ^(id<AFMultipartFormData> _Nonnull formData) {
            for (NSUInteger i = 0; i < images.count; i++) {
                UIImage *image = images[i];
                // 图片压缩，单张限制大小
                [HDImageCompressTool compressedImage:image imageKB:singleImageLimitedSize imageBlock:^(NSData *_Nonnull imageData) {
#ifdef DEBUG
                    NSData *preData = UIImageJPEGRepresentation(image, 1.0f);
                    HDLog(@"压缩前大小：%zd", preData.length);
                    HDLog(@"压缩后大小：%zd", imageData.length);
#endif
                    NSString *defaultFileName = [NSString stringWithFormat:@"%1.0f%@", [[NSDate date] timeIntervalSince1970], @"superapp"];
                    [formData appendPartWithFileData:imageData name:name ?: @"files" fileName:[NSString stringWithFormat:@"%@.%@", defaultFileName, imageType ?: @"png"]
                                            mimeType:[NSString stringWithFormat:@"image/%@", imageType ?: @"png"]];
                }];
            }
        };

        [request startWithUploadProgress:progressBlock downloadProgress:nil cache:nil success:^(HDNetworkResponse *_Nonnull response) {
            PNRspModel *rspModel = response.extraData;
            id data = rspModel.data;
            NSMutableArray *list = [NSMutableArray array];

            if ([data isKindOfClass:NSDictionary.class]) {
                NSDictionary *dict = (NSDictionary *)rspModel.data;
                if ([dict.allKeys containsObject:@"url"]) {
                    [list addObject:[dict objectForKey:@"url"]];
                }
            } else if ([data isKindOfClass:NSString.class]) {
                [list addObject:rspModel.data];
            }
            HDLog(@"🌺🌺🌺上传成功成功url %@", list);
            !successBlock ?: successBlock(list);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }];
    };

    /// 没开通钱包之前 是没有token ，需要走不鉴权的图片上传
    if (VipayUser.shareInstance.mobileToken.length > 0 && VipayUser.shareInstance.loginName.length > 0) {
        [self.pwdVM getAccessTokenWithTokenType:PNTokenTypeUploadImage success:gotToken failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            !failureBlock ?: failureBlock(rspModel, errorType, error);
        }];
    } else {
        gotToken(@"");
    }
}

#pragma mark
- (void)batchUploadImages:(NSArray<UIImage *> *)images
                 progress:(HDRequestProgressBlock)progressBlock
                  success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                  failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self bathUploadImages:images singleImageLimitedSize:500 name:@"files" fileNames:@[] imageType:@"png" progress:progressBlock success:successBlock failure:failureBlock];
}

/// 批量上传【图片】
- (void)bathUploadImages:(NSArray<UIImage *> *)images
    singleImageLimitedSize:(float)singleImageLimitedSize
                      name:(NSString *)name
                 fileNames:(NSArray<NSString *> *)fileNames
                 imageType:(NSString *)imageType
                  progress:(HDRequestProgressBlock)progressBlock
                   success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                   failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    void (^gotToken)(NSString *) = ^(NSString *accessToken) {
        // 创建会话管理者
        PNNetworkRequest *request = PNNetworkRequest.new;
        request.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer;

        NSString *url = [NSString stringWithFormat:@"/file_web/file-service/file/batch-upload.do?accessToken=%@&loginName=%@", accessToken, VipayUser.shareInstance.loginName];

        request.requestURI = url;

        HDLog(@"😄😄😄 请求上传图片接口： %@%@", SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer, url);

        request.requestConstructingBody = ^(id<AFMultipartFormData> _Nonnull formData) {
            for (NSUInteger i = 0; i < images.count; i++) {
                UIImage *image = images[i];
                // 图片压缩，单张限制大小
                [HDImageCompressTool compressedImage:image imageKB:singleImageLimitedSize imageBlock:^(NSData *_Nonnull imageData) {
#ifdef DEBUG
                    NSData *preData = UIImageJPEGRepresentation(image, 1.0f);
                    HDLog(@"压缩前大小：%zd", preData.length);
                    HDLog(@"压缩后大小：%zd", imageData.length);
#endif
                    NSString *defaultFileName = [NSString stringWithFormat:@"%1.0f%@", [[NSDate date] timeIntervalSince1970], @"superapp"];
                    [formData appendPartWithFileData:imageData name:name ?: @"files" fileName:[NSString stringWithFormat:@"%@.%@", defaultFileName, imageType ?: @"png"]
                                            mimeType:[NSString stringWithFormat:@"image/%@", imageType ?: @"png"]];
                }];
            }
        };

        [request startWithUploadProgress:progressBlock downloadProgress:nil cache:nil success:^(HDNetworkResponse *_Nonnull response) {
            PNRspModel *rspModel = response.extraData;
            PNUploadImageRspModel *model = [PNUploadImageRspModel yy_modelWithJSON:rspModel.data];
            NSMutableArray *resultURLArray = [model.uploadResultDTOList mapObjectsUsingBlock:^id _Nonnull(PNUploadImageItemModel *_Nonnull obj, NSUInteger idx) {
                return obj.url;
            }];

            !successBlock ?: successBlock(resultURLArray);
        } failure:^(HDNetworkResponse *_Nonnull response) {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }];
    };

    [self.pwdVM getAccessTokenWithTokenType:PNTokenTypeUploadImage success:gotToken failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

#pragma mark
- (HDPasswordManagerViewModel *)pwdVM {
    return _pwdVM ?: ({ _pwdVM = [[HDPasswordManagerViewModel alloc] init]; });
}
@end


@implementation PNUploadImageItemModel

@end


@implementation PNUploadImageRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"uploadResultDTOList": [PNUploadImageItemModel class], @"uploadFailFileList": [PNUploadImageItemModel class]};
}
@end
