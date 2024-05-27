//
//  UIImage+PNExtension.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/3.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "UIImage+PNExtension.h"


@implementation UIImage (PNExtension)
+ (instancetype)imageQRCodeContent:(NSString *)codeDetail withSize:(CGFloat)size {
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [codeDetail dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
}

+ (UIImage *)imageQRCodeContent:(NSString *)codeDetail withSize:(CGFloat)size centerImage:(UIImage *)centerImage {
    return [self imageQRCodeContent:codeDetail withSize:size centerImage:centerImage centerImageSize:45];
}
/**
 生成二维码(中间有小图片)
 */

+ (UIImage *)imageQRCodeContent:(NSString *)codeDetail withSize:(CGFloat)size centerImage:(UIImage *)centerImage centerImageSize:(CGFloat)centerImageSize {
    UIImage *startImage = [self imageQRCodeContent:codeDetail withSize:size];

    // 开启绘图, 获取图形上下文
    UIGraphicsBeginImageContext(startImage.size);

    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    CGFloat icon_imageW = centerImageSize ?: centerImage.size.width;
    CGFloat icon_imageH = icon_imageW;
    CGFloat icon_imageX = (startImage.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (startImage.size.height - icon_imageH) * 0.5;
    [centerImage drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];

    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return qrImage;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
