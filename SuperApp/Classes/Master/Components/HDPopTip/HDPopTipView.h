//
//  HDPopTipView.h
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDPopTipConfig;

NS_ASSUME_NONNULL_BEGIN


@interface HDPopTipView : UIView
- (void)showPopTipInView:(UIView *__nullable)view fromView:(UIView *)fromView config:(HDPopTipConfig *__nullable)config;
- (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopTipConfig *> *)configs onlyInControllerClass:(Class __nullable)controllerClass;
- (void)setCurrentConfigs:(NSArray<HDPopTipConfig *> *)configs onlyInControllerClass:(Class __nullable)controllerClass;

/// 消失
/// @param animated 是否动画
- (void)dismissAnimated:(BOOL)animated;

/// 消失
/// @param animated 是否动画
/// @param shouldCallDismissHandler 是否要触发消失回调
- (void)dismissAnimated:(BOOL)animated shouldCallDismissHandler:(BOOL)shouldCallDismissHandler;
@property (nonatomic, copy) void (^tappedHandler)(void);
///< 消失回调
@property (nonatomic, copy) void (^dismissHandler)(void);
@property (nonatomic, copy, readonly) NSArray<HDPopTipConfig *> *currentLeftConfigs; ///< 当前剩余要展示的配置，用于外部获取
@end

NS_ASSUME_NONNULL_END
