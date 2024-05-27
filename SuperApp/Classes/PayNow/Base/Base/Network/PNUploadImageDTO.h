//
//  PNUploadImageDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNUploadImageItemModel : PNModel
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *visitHost;
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *url;
@end


@interface PNUploadImageRspModel : PNModel
@property (nonatomic, strong) NSArray<PNUploadImageItemModel *> *uploadFailFileList;
@property (nonatomic, strong) NSArray<PNUploadImageItemModel *> *uploadResultDTOList;
@end


@interface PNUploadImageDTO : PNModel

/// 图片上传
/// @param images 上传图片数组 [图片]
/// @param progressBlock 进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)uploadImages:(NSArray<UIImage *> *)images
            progress:(HDRequestProgressBlock)progressBlock
             success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
             failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 图片上传
/// @param images 上传图片数组 [图片]
/// @param singleImageLimitedSize 单张图片最大size [kb]
/// @param name 入参name
/// @param fileNames 图片名
/// @param imageType 图片格式
/// @param progressBlock 进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)uploadImages:(NSArray<UIImage *> *)images
    singleImageLimitedSize:(float)singleImageLimitedSize
                      name:(NSString *)name
                 fileNames:(NSArray<NSString *> *)fileNames
                 imageType:(NSString *)imageType
                  progress:(HDRequestProgressBlock)progressBlock
                   success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                   failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 批量上传 图片
- (void)batchUploadImages:(NSArray<UIImage *> *)images
                 progress:(HDRequestProgressBlock)progressBlock
                  success:(void (^)(NSArray<NSString *> *imageURLArray))successBlock
                  failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
