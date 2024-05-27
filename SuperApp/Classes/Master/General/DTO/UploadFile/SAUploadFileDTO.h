//
//  SAUploadFileDTO.h
//  SuperApp
//
//  Created by Tia on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUploadFileDTO : SAViewModel

/// 上传文件
/// @param fileData The data to be encoded and appended to the form data.
/// @param fileName The name to be associated with the specified data. This parameter must not be `nil`.
/// @param fileType The fileType to be associated with the specified data. This parameter must not be `nil`.
/// @param mimeType The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/.
/// This parameter must not be `nil`.
/// @param progressBlock 上传进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)batchUploadFileData:(nonnull NSData *)fileData
                                 fileName:(nonnull NSString *)fileName
                                 fileType:(nonnull NSString *)fileType
                                 mimeType:(nonnull NSString *)mimeType
                                 progress:(HDRequestProgressBlock)progressBlock
                                  success:(void (^)(NSString *fileURLString))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
