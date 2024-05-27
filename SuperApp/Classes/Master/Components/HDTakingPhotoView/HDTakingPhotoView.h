//
//  HDTakingPhotoView.h
//  SuperApp
//
//  Created by VanJay on 2019/4/4.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTakingPhotoViewConfig.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HDTakingPhotoViewVoidBlock)(void);
typedef void (^HDTakingPhotoViewSwitchValueBlock)(BOOL isOn);


@interface HDTakingPhotoView : UIView

@property (nonatomic, strong) HDTakingPhotoViewConfig *config;                       ///< 配置
@property (nonatomic, copy) HDTakingPhotoViewSwitchValueBlock takePhotoBlock;        ///< 拍照回调
@property (nonatomic, copy) HDTakingPhotoViewVoidBlock cancelBlock;                  ///< 取消/重拍回调
@property (nonatomic, copy) HDTakingPhotoViewSwitchValueBlock switchFlashLightBlock; ///< 闪光灯开关回调
@property (nonatomic, copy) HDTakingPhotoViewSwitchValueBlock switchCameraBlock;     ///< 切换镜头回调

- (void)isFlashLightEnabled:(BOOL)yor;
- (void)dealingWithButtonsState:(BOOL)isRunning isFrontCamera:(BOOL)isFrontCamera;
- (void)focusAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
