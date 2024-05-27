//
//  SAUploadImageDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUploadImageDTO : SAViewModel
/// 是否boss上传
@property (nonatomic, assign) BOOL uploadToBoss;

/// 批量上传图片
/// @param images 图片数组
/// @param progressBlock 上传进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock;

/// 批量上传图片
/// @param images 图片数组
/// @param singleImageLimitedSize 单张图片最大尺寸，内部会压缩图片，单位：KB，默认 500
/// @param progressBlock 上传进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                 singleImageLimitedSize:(float)singleImageLimitedSize
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock;

/// 批量上传图片
/// @param images 图片数组
/// @param name 默认 files
/// @param fileNames 默认当前时间时间戳拼接 superapp
/// @param imageScale 图片缩放比例，默认 1.0
/// @param imageType 图片类型默认 png
/// @param progressBlock 上传进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                                   name:(NSString *_Nullable)name
                              fileNames:(NSArray<NSString *> *_Nullable)fileNames
                             imageScale:(CGFloat)imageScale
                              imageType:(NSString *_Nullable)imageType
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock;

/// 批量上传图片
/// @param images 图片数组
/// @param singleImageLimitedSize 单张图片最大尺寸，内部会压缩图片，单位：KB，默认 500
/// @param name 默认 files
/// @param fileNames 默认当前时间时间戳拼接 superapp
/// @param imageScale 图片缩放比例，默认 1.0
/// @param imageType 图片类型默认 png
/// @param progressBlock 上传进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)batchUploadImages:(NSArray<UIImage *> *)images
                 singleImageLimitedSize:(float)singleImageLimitedSize
                                   name:(NSString *_Nullable)name
                              fileNames:(NSArray<NSString *> *_Nullable)fileNames
                             imageScale:(CGFloat)imageScale
                              imageType:(NSString *_Nullable)imageType
                               progress:(HDRequestProgressBlock)progressBlock
                                success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock;

/// 单个上传图片 使用了不用登录上传接口
/// @param image 图片数组
/// @param singleImageLimitedSize 单张图片最大尺寸，内部会压缩图片，单位：KB，默认 500
/// @param progressBlock 上传进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)uploadSingleImage:(UIImage *)image
    singleImageLimitedSize:(float)singleImageLimitedSize
                  progress:(HDRequestProgressBlock)progressBlock
                   success:(void (^)(NSString *imageUrl))successBlock
                   failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
