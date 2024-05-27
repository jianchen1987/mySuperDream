//
//  SAScanView.h
//  SuperApp
//
//  Created by Tia on 2023/4/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDScanCodeDefines.h"

typedef void (^HDScanCodeClickedFlashLightBlock)(BOOL isOpen);

NS_ASSUME_NONNULL_BEGIN


@interface SAScanView : UIView

/**
 点击拍照
 */
@property (nonatomic, copy) dispatch_block_t photoClickBlock;

/**
 打开/关闭闪光灯的回调
 */
@property (nonatomic, copy) HDScanCodeClickedFlashLightBlock clickedFlashLightBlock;

#pragma mark - 扫码区域

/// 扫码区域 默认为正方形，边长为宽 0.7倍, 居中
@property (nonatomic, assign) CGRect scanRetangleRect;
/// 是否需要绘制扫码矩形框，默认YES
@property (nonatomic, assign) BOOL isNeedShowRetangle;
/// 矩形框线条颜色
@property (nonatomic, strong, nullable) UIColor *colorRetangleLine;

#pragma mark - 矩形框(扫码区域)周围 4 个角
/// 4个角的颜色
@property (nonatomic, strong, nullable) UIColor *colorAngle;
/// 扫码区域4个角的宽度 默认为 20
@property (nonatomic, assign) CGFloat photoframeAngleW;
/// 扫码区域4个角的高度 默认为 20
@property (nonatomic, assign) CGFloat photoframeAngleH;
/// 扫码区域4个角的线条宽度，默认 6
@property (nonatomic, assign) CGFloat photoframeLineW;
/// 扫描类型，1为身份证，2为护照
@property (nonatomic, assign) NSInteger type;

//@property (nonatomic, strong) UIImageView *iv;

#pragma mark - 动画效果

/**
 非识别区域颜色,默认 RGBA (0,0,0,0.5)
 */
@property (nonatomic, strong, nullable) UIColor *notRecoginitonAreaColor;

/**
 正在处理扫描到的结果
 */
- (void)handlingResultsOfScan;

/**
 完成扫描结果处理
 */
- (void)finishedHandle;

/**
 是否显示闪光灯开关
 @param show YES or NO
 */
- (void)showFlashSwitch:(BOOL)show;


@end

NS_ASSUME_NONNULL_END
