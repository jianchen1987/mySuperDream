//
//  SAImageAccessor.h
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAImageAccessorType) {
    SAImageAccessorTypeTakingPhoto = 0, ///< 拍照
    SAImageAccessorTypeBrowserPhotos    ///< 浏览图片
};

//裁剪形状
typedef NS_ENUM(NSUInteger, SAImageCropMode) {
    SAImageCropModeCircle = 0, ///< 圆型
    SAImageCropModeSquare = 1, ///< 正方形
    SAImageCropMode4To3 = 2,   ///< 4:3
    SAImageCropMode16To9 = 3,  ///< 16:9
};

typedef void (^SAImageAccessorCompletionBlock)(UIImage *_Nullable image, NSError *_Nullable error);
typedef void (^SAImageAccessorMultiImageCompletionBlock)(NSArray<UIImage *> *_Nullable images, NSError *_Nullable error);


@interface SAImageAccessor : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 指定源控制器初始化
/// @param viewController 源控制器
/// @param needCrop 是否要裁剪（只支持单张图片）
- (instancetype)initWithSourceViewController:(UIViewController *)viewController needCrop:(BOOL)needCrop;

/// 获取图片
/// @param type 类型
/// @param completionBlock 完成回调
- (void)fetchImageWithType:(SAImageAccessorType)type completion:(SAImageAccessorCompletionBlock)completionBlock;

/// 获取图片
/// @param type 类型
/// @param maxImageCount 图片张数（只对选图方式有效）
/// @param completionBlock 完成回调
- (void)fetchImageWithType:(SAImageAccessorType)type maxImageCount:(NSUInteger)maxImageCount completion:(SAImageAccessorMultiImageCompletionBlock _Nullable)completionBlock;

/// 获取图片
/// @param type 类型
/// @param cropMode 裁剪类型
/// @param completionBlock 完成回调
- (void)fetchImageWithType:(SAImageAccessorType)type cropMode:(SAImageCropMode)cropMode completion:(SAImageAccessorCompletionBlock)completionBlock;

/// 获取图片 【不需要裁剪，选中后直接上传】
/// @param type 类型
/// @param needCrop 是否需要裁剪
/// @param completionBlock 完成回调
- (void)fetchImageWithType:(SAImageAccessorType)type needCrop:(BOOL)needCrop completion:(SAImageAccessorCompletionBlock)completionBlock;
@end

NS_ASSUME_NONNULL_END
