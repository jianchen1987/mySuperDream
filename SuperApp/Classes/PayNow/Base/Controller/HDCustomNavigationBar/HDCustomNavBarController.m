//
//  HDCustomNavBarController.m
//  ViPay
//
//  Created by VanJay on 2019/8/14.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCustomNavBarController.h"
#import "FBKVOController+HDKitCore.h"
#import "Masonry.h"


@implementation HDCustomNavigationBarVCWrapperView

@end


@interface HDCustomNavBarController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) PayHDCustomNavigationBar *navigationBar;         ///< 导航栏
@property (nonatomic, strong) HDCustomNavigationBarVCWrapperView *viewWrapper; ///< 导航栏
@property (nonatomic, assign) BOOL isNavBarTransparent;                        ///< 导航栏是否透明
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> delegate;          ///< 代理
@property (nonatomic, strong) FBKVOController *KVOController;                  ///< 监听外部设置 text
@end


@implementation HDCustomNavBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self observeViewFrameChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.navigationController.viewControllers.count > 1) {
        // 添加手势代理
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)addOrUpdateNavigationBarFrame {
    if (_navigationBar && !self.navigationBar.isHidden) {
        self.navigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.navigationBarHeight);
    }
}

- (void)addOrUpdateWrapperViewFrame {
    CGRect oldFrame = self.view.frame;

    if (self.isNavBarTransparent) {
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    } else {
        if (_navigationBar && !self.navigationBar.isHidden) {
            self.view.frame = CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationBar.frame));
        } else {
            self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        }
    }
    CGRect newFrame = self.view.frame;
    if (!CGRectEqualToRect(oldFrame, newFrame)) {
        !self.viewWrapperResizedHandler ?: self.viewWrapperResizedHandler();
    }
}

- (void)addOrUpdateFrame {
    [self addOrUpdateNavigationBarFrame];
    [self addOrUpdateWrapperViewFrame];
}

- (void)updateViewConstraints {
    [self addOrUpdateFrame];

    [super updateViewConstraints];
}

#pragma mark - KVO
- (void)observeViewFrameChanged {
    __weak __typeof(self) weakSelf = self;
    [self.KVOController hd_observe:self.view keyPath:@"frame" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        CGRect oldFrame = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect newFrame = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (!CGRectEqualToRect(newFrame, oldFrame)) {
            [strongSelf addOrUpdateWrapperViewFrame];
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    const BOOL moreThanOneVC = self.navigationController.viewControllers.count > 1;
    const BOOL recognizerEnabled = !self.disableInteractivePopGestureRecognizer;

    return moreThanOneVC && recognizerEnabled;
}

#pragma mark - public methods
- (CGFloat)navigationBarContentHeight {
    return self.navigationBarHeight - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

- (CGFloat)navigationBarHeight {
    return 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

- (void)setNavLeftBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title {
    [self.navigationBar setLeftBtnImage:image title:title];
}

- (void)setNavRightBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title {
    [self.navigationBar setRightBtnImage:image title:title];
}

- (void)setNavBottomLineHidden:(BOOL)hidden {
    [self.navigationBar setBottomLineHidden:hidden];
}

- (void)setNavBackgroundAlpha:(CGFloat)alpha {
    [self.navigationBar setBackgroundAlpha:alpha];
}

- (void)setNavTintColor:(UIColor *)color {
    [self.navigationBar setNavTintColor:color];
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.navigationBar.titleColor = titleColor;
}

- (void)setTitleImage:(UIImage *)image {
    self.navigationBar.titleImage = image;
}

- (void)setTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image {
    [self.navigationBar setTitle:title titleFont:titleFont titleColor:titleColor image:image];
}

- (void)setNavLeftTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image {
    [self.navigationBar setLeftTitle:title titleFont:titleFont titleColor:titleColor image:image];
}

- (void)setNavRightTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image {
    [self.navigationBar setRightTitle:title titleFont:titleFont titleColor:titleColor image:image];
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.navigationBar.titleFont = titleFont;
}

- (void)setNavBarBackgroundColor:(UIColor *)barBackgroundColor {
    self.navigationBar.barBackgroundColor = barBackgroundColor;

    if (CGColorEqualToColor(barBackgroundColor.CGColor, UIColor.clearColor.CGColor)) { // 透明
        self.isNavBarTransparent = true;
    }
}

- (void)setNavBarBackgroundImage:(UIImage *)barBackgroundImage {
    self.navigationBar.barBackgroundImage = barBackgroundImage;
}

- (void)setNavCustomLeftView:(UIView *__nullable)customView {
    [self.navigationBar setCustomLeftView:customView];
}

- (void)setNavCustomRightView:(UIView *__nullable)customView {
    [self.navigationBar setCustomRightView:customView];
}

- (void)setNavCustomTitleView:(UIView *__nullable)customView {
    [self.navigationBar setCustomTitleView:customView];
}

- (void)hideNavigationBarAndWrapperView {
    self.navigationBar.hidden = true;
    self.view.hidden = true;

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - override
- (void)setNavTitle:(NSString *)title {
    [self.navigationBar setTitle:title];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];

    [self.navigationBar setTitle:title];
}

#pragma mark - getters and setters
- (void)setHideNavigationBar:(BOOL)hideNavigationBar {
    if (_hideNavigationBar == hideNavigationBar)
        return;

    _hideNavigationBar = hideNavigationBar;

    self.navigationBar.hidden = hideNavigationBar;

    [self.view setNeedsUpdateConstraints];
}

- (void)setHideNavBackButton:(BOOL)hideNavBackButton {
    if (_hideNavBackButton == hideNavBackButton)
        return;

    _hideNavBackButton = hideNavBackButton;

    self.navigationBar.hideBackButton = hideNavBackButton;
}

- (void)setIsNavBarTransparent:(BOOL)isNavBarTransparent {
    if (_isNavBarTransparent == isNavBarTransparent)
        return;

    _isNavBarTransparent = isNavBarTransparent;

    [self.view setNeedsUpdateConstraints];
}

- (void)setHideViewWrapper:(BOOL)hideViewWrapper {
    _hideViewWrapper = hideViewWrapper;

    self.view.hidden = hideViewWrapper;
}

#pragma mark - lazy load
- (PayHDCustomNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [PayHDCustomNavigationBar customNavigationBar];

        __weak __typeof(self) weakSelf = self;
        _navigationBar.clickedLeftBtnHandler = ^{
            if (weakSelf.clickedNavLeftBtnHandler) {
                weakSelf.clickedNavLeftBtnHandler();
            } else {
                [weakSelf.navigationController popViewControllerAnimated:true];
            }
        };

        _navigationBar.clickedRightBtnHandler = ^{
            !weakSelf.clickedNavRightBtnHandler ?: weakSelf.clickedNavRightBtnHandler();
        };

        [self.view addSubview:_navigationBar];

        [self addOrUpdateNavigationBarFrame];
    }
    return _navigationBar;
}

- (HDCustomNavigationBarVCWrapperView *)viewWrapper {
    if (!_viewWrapper) {
        _viewWrapper = [[HDCustomNavigationBarVCWrapperView alloc] init];
        _viewWrapper.backgroundColor = UIColor.whiteColor;
        [self.view insertSubview:_viewWrapper belowSubview:self.navigationBar];

        [self addOrUpdateWrapperViewFrame];
    }
    return _viewWrapper;
}

- (FBKVOController *)KVOController {
    if (!_KVOController) {
        _KVOController = [FBKVOController controllerWithObserver:self];
    }
    return _KVOController;
}
@end
