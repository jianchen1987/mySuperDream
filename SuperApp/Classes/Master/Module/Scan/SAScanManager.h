//
//  SAScanManager.h
//  SuperApp
//
//  Created by Tia on 2023/4/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 监听环境光感的回调
 @param brightness 亮度值
 */
typedef void (^SAScanCodeAmbientLightChangedBlock)(float brightness);


@interface SAScanManager : NSObject
/**
 监听环境光感的回调,如果 != nil 表示开启监测环境亮度功能
 */
@property (nonatomic, copy) SAScanCodeAmbientLightChangedBlock _Nullable ambientLightChangedBlock;

/**
 闪光灯的状态,不需要设置，仅供外边判断状态使用
 */
@property (nonatomic, assign) BOOL flashOpen;

/**
 初始化 扫描工具
 @param preview 展示输出流的视图
 @param scanFrame 扫描中心识别区域范围
 */
- (instancetype)initWithPreview:(UIView *)preview andScanFrame:(CGRect)scanFrame;

/**
 闪光灯开关
 */
- (void)openFlashSwitch:(BOOL)open;

- (void)sessionStartRunning;

- (void)sessionStopRunning;

- (void)takePhotoWithCompletionHandler:(void (^)(UIImage *_Nullable image))completionHandler;

/**
 识别图中二维码
 */
- (void)scanImageQRCode:(UIImage *_Nullable)imageCode;

@end

NS_ASSUME_NONNULL_END
