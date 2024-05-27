//
//  HDCustomNavigationBar.h
//  ViPay
//
//  Created by VanJay on 2019/8/14.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 自定义导航栏 */
@interface PayHDCustomNavigationBar : UIView
+ (instancetype)customNavigationBar;

- (void)setLeftBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title;
- (void)setTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image;
- (void)setLeftTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image;
- (void)setRightTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image;
- (void)setRightBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title;

- (void)setBottomLineHidden:(BOOL)hidden;
- (void)setBackgroundAlpha:(CGFloat)alpha;
- (void)setNavTintColor:(UIColor *)color;

@property (nonatomic, copy) void (^clickedLeftBtnHandler)(void);  ///< 点击了左按钮
@property (nonatomic, copy) void (^clickedRightBtnHandler)(void); ///< 点击了右按钮
@property (nonatomic, assign) BOOL isHeightContainsStatusBar;     ///< 高度是否包含状态栏，默认包含
@property (nonatomic, assign) BOOL hideBackButton;                ///< 隐藏返回按钮

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIImage *titleImage;
@property (nonatomic, strong) UIColor *barBackgroundColor;
@property (nonatomic, strong) UIImage *barBackgroundImage;
@property (nonatomic, assign) CGFloat titleAlpha;

- (void)setCustomLeftView:(UIView *__nullable)customView;
- (void)setCustomRightView:(UIView *__nullable)customView;
- (void)setCustomTitleView:(UIView *__nullable)customView;
@end

NS_ASSUME_NONNULL_END
