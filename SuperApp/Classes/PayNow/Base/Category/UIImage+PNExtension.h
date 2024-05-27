//
//  UIImage+PNExtension.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/3.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (PNExtension)

/**
 二维码生成

 @param codeDetail 二维码内容
 @param size 二维码大小
 @return 二维码
 */
+ (instancetype)imageQRCodeContent:(NSString *)codeDetail withSize:(CGFloat)size;

/// 二维码生成附带中间logo
+ (UIImage *)imageQRCodeContent:(NSString *)codeDetail withSize:(CGFloat)size centerImage:(UIImage *)centerImage;
+ (UIImage *)imageQRCodeContent:(NSString *)codeDetail withSize:(CGFloat)size centerImage:(UIImage *)centerImage centerImageSize:(CGFloat)centerImageSize;

@end
