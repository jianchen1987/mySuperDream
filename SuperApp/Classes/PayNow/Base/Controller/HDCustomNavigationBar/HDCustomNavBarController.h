//
//  HDCustomNavBarController.h
//  ViPay
//
//  Created by VanJay on 2019/8/14.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCustomNavigationBar.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDCustomNavigationBarVCWrapperView : UIView

@end


@interface HDCustomNavBarController : UIViewController

@property (nonatomic, strong, readonly) PayHDCustomNavigationBar *navigationBar;         ///< 导航栏
@property (nonatomic, strong, readonly) HDCustomNavigationBarVCWrapperView *viewWrapper; ///< 容器

- (void)setNavLeftBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title;
- (void)setNavRightBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title;

- (void)setNavBottomLineHidden:(BOOL)hidden;
- (void)setNavBackgroundAlpha:(CGFloat)alpha;
- (void)setNavTintColor:(UIColor *)color;

- (void)setNavTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)titleColor;
- (void)setTitleFont:(UIFont *)titleFont;
- (void)setTitleImage:(UIImage *)image;
- (void)setTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image;
- (void)setNavLeftTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image;
- (void)setNavRightTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image;
- (void)setNavBarBackgroundColor:(UIColor *)barBackgroundColor;
- (void)setNavBarBackgroundImage:(UIImage *)barBackgroundImage;

- (void)setNavCustomLeftView:(UIView *__nullable)customView;
- (void)setNavCustomRightView:(UIView *__nullable)customView;
- (void)setNavCustomTitleView:(UIView *__nullable)customView;

/** 同时隐藏导航栏和容器 */
- (void)hideNavigationBarAndWrapperView;

/**
 重写此方法自定义导航栏高度

 @return 导航栏高度
 */
- (CGFloat)navigationBarHeight;

@property (nonatomic, assign, readonly) CGFloat navigationBarContentHeight; ///< 导航栏内容高度（不包括状态栏）

@property (nonatomic, copy) void (^clickedNavLeftBtnHandler)(void);  ///< 点击了左按钮
@property (nonatomic, copy) void (^clickedNavRightBtnHandler)(void); ///< 点击了右按钮
@property (nonatomic, copy) void (^viewWrapperResizedHandler)(void); ///< 容器 view 大小变化

@property (nonatomic, assign) BOOL hideNavigationBar;                      ///< 隐藏导航栏，默认为 false
@property (nonatomic, assign) BOOL hideNavBackButton;                      ///< 隐藏返回按钮，默认为 false
@property (nonatomic, assign) BOOL hideViewWrapper;                        ///< 隐藏ViewWrapper，默认为 false
@property (nonatomic, assign) BOOL disableInteractivePopGestureRecognizer; ///< 禁用滑动返回手势，默认为 false
@end

NS_ASSUME_NONNULL_END
