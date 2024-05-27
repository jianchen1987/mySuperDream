//
//  HDCustomNavigationBar.m
//  ViPay
//
//  Created by VanJay on 2019/8/14.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCustomNavigationBar.h"
#import "HDAppTheme.h"
#import "HDCommonButton.h"
#import "HDCommonDefines.h"
#import "HDUIHelperDefines.h"
#import "Masonry.h"
#import "UIButton+EnlargeEdge.h"


@interface PayHDCustomNavigationBar ()
@property (nonatomic, strong) HDCommonButton *titleBtn;
@property (nonatomic, strong) HDCommonButton *leftButton;
@property (nonatomic, strong) HDCommonButton *rightButton;
@property (nonatomic, strong) UIView *private_customLeftView;  ///< 自定义左视图
@property (nonatomic, strong) UIView *private_customRightView; ///< 自定义右视图
@property (nonatomic, strong) UIView *private_customTitleView; ///< 自定义标题视图
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end


@implementation PayHDCustomNavigationBar
#pragma mark - life cycle
+ (instancetype)customNavigationBar {
    PayHDCustomNavigationBar *navigationBar = [[self alloc] init];
    return navigationBar;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.isHeightContainsStatusBar = true;

    [self addSubview:self.backgroundView];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.leftButton];
    [self addSubview:self.titleBtn];
    [self addSubview:self.rightButton];
    [self addSubview:self.bottomLine];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (void)updateConstraints {
    const CGFloat margin = 15;

    // 状态栏高度
    const CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);

    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.backgroundView.isHidden) {
            make.edges.equalTo(self);
        }
    }];

    [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.backgroundImageView.isHidden) {
            make.edges.equalTo(self);
        }
    }];

    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.leftButton.isHidden) {
            make.left.equalTo(self).offset(margin);
            make.centerY.equalTo(self).offset(self.isHeightContainsStatusBar ? statusBarHeight * 0.5 : 0);
            make.size.mas_equalTo(self.leftButton.appropriateSize);
            make.right.lessThanOrEqualTo(self).offset(-margin);
        }
    }];

    [self.private_customLeftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.private_customLeftView) {
            make.left.equalTo(self).offset(margin);
            make.centerY.equalTo(self).offset(self.isHeightContainsStatusBar ? statusBarHeight * 0.5 : 0);
            make.size.mas_equalTo([self private_customLeftViewSize]);
            make.right.lessThanOrEqualTo(self).offset(-margin);
        }
    }];

    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightButton.isHidden) {
            make.right.equalTo(self).offset(-margin);
            make.centerY.equalTo(self).offset(self.isHeightContainsStatusBar ? statusBarHeight * 0.5 : 0);
            make.size.mas_equalTo(self.rightButton.appropriateSize);
            make.left.greaterThanOrEqualTo(self).offset(margin);
        }
    }];

    [self.private_customRightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.private_customRightView) {
            make.right.equalTo(self).offset(-margin);
            make.centerY.equalTo(self).offset(self.isHeightContainsStatusBar ? statusBarHeight * 0.5 : 0);
            make.size.mas_equalTo([self private_customRightViewSize]);
            make.left.greaterThanOrEqualTo(self).offset(margin);
        }
    }];

    // 这里处理没有 frame 布局方便，此处处理保证标题水平居中，考虑了左右按钮有无和宽度不同的所有情况
    void (^makeMiddleViewConstraints)(MASConstraintMaker *) = ^(MASConstraintMaker *make) {
        const CGSize appropriateSize = self.titleBtn.appropriateSize;
        make.centerY.equalTo(self).offset(self.isHeightContainsStatusBar ? statusBarHeight * 0.5 : 0);
        make.height.mas_equalTo(appropriateSize.height);
        const CGFloat titleButtonWidth = appropriateSize.width;
        if (!self.leftButton.isHidden) {
            const CGFloat leftBtnWidth = self.leftButton.appropriateSize.width;
            if (!self.rightButton.isHidden) { // 左按钮
                // 比较宽度
                const CGFloat rightBtnWidth = self.rightButton.appropriateSize.width;

                if (leftBtnWidth >= rightBtnWidth) {
                    if (titleButtonWidth < kScreenWidth - 2 * (leftBtnWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.left.equalTo(self.leftButton.mas_right).offset(margin);
                        make.right.equalTo(self.rightButton.mas_left).offset(-(margin + (leftBtnWidth - rightBtnWidth)));
                    }
                } else {
                    if (titleButtonWidth < kScreenWidth - 2 * (rightBtnWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.right.equalTo(self.rightButton.mas_left).offset(-margin);
                        make.left.equalTo(self.leftButton.mas_right).offset(margin + rightBtnWidth - leftBtnWidth);
                    }
                }
            } else if (self.private_customRightView) {
                const CGFloat rightViewWidth = [self private_customRightViewSize].width;

                if (leftBtnWidth >= rightViewWidth) {
                    if (titleButtonWidth < kScreenWidth - 2 * (leftBtnWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.left.equalTo(self.leftButton.mas_right).offset(margin);
                        make.right.equalTo(self.private_customRightView.mas_left).offset(-(margin + (leftBtnWidth - rightViewWidth)));
                    }

                } else {
                    if (titleButtonWidth < kScreenWidth - 2 * (rightViewWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.right.equalTo(self.private_customRightView.mas_left).offset(-margin);
                        make.left.equalTo(self.leftButton.mas_right).offset(margin + rightViewWidth - leftBtnWidth);
                    }
                }
            } else {
                if (titleButtonWidth < kScreenWidth - 2 * (2 * margin + leftBtnWidth)) {
                    make.width.mas_equalTo(titleButtonWidth);
                    make.centerX.equalTo(self);
                } else {
                    make.left.equalTo(self.leftButton.mas_right).offset(margin);
                    make.right.equalTo(self).offset(-(2 * margin + leftBtnWidth));
                }
            }
        } else if (self.private_customLeftView) { // 左自定义 View
            const CGFloat leftViewWidth = [self private_customLeftViewSize].width;
            if (!self.rightButton.isHidden) {
                // 比较宽度
                const CGFloat rightBtnWidth = self.rightButton.appropriateSize.width;

                if (leftViewWidth >= rightBtnWidth) {
                    if (titleButtonWidth < kScreenWidth - 2 * (leftViewWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.left.equalTo(self.private_customLeftView.mas_right).offset(margin);
                        make.right.equalTo(self.rightButton.mas_left).offset(-(margin + (leftViewWidth - rightBtnWidth)));
                    }

                } else {
                    if (titleButtonWidth < kScreenWidth - 2 * (rightBtnWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.right.equalTo(self.rightButton.mas_left).offset(-margin);
                        make.left.equalTo(self.private_customLeftView.mas_right).offset(margin + rightBtnWidth - leftViewWidth);
                    }
                }
            } else if (self.private_customRightView) {
                const CGFloat rightViewWidth = [self private_customRightViewSize].width;
                if (leftViewWidth >= rightViewWidth) {
                    if (titleButtonWidth < kScreenWidth - 2 * (leftViewWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.left.equalTo(self.private_customLeftView.mas_right).offset(margin);
                        make.right.equalTo(self.private_customRightView.mas_left).offset(-(margin + (leftViewWidth - rightViewWidth)));
                    }

                } else {
                    if (titleButtonWidth < kScreenWidth - 2 * (rightViewWidth + margin)) {
                        make.width.mas_equalTo(titleButtonWidth);
                        make.centerX.equalTo(self);
                    } else {
                        make.left.equalTo(self.private_customLeftView.mas_right).offset(margin + rightViewWidth - leftViewWidth);
                        make.right.equalTo(self.private_customRightView.mas_left).offset(-margin);
                    }
                }
            } else {
                if (titleButtonWidth < kScreenWidth - 2 * (2 * margin + leftViewWidth)) {
                    make.width.mas_equalTo(titleButtonWidth);
                    make.centerX.equalTo(self);
                } else {
                    make.left.equalTo(self.private_customLeftView.mas_right).offset(margin);
                    // 处理左边View 宽度比较宽情况
                    const CGFloat offsetX = 2 * margin + leftViewWidth;
                    if (kScreenWidth * 0.5 - offsetX < 0) {
                        make.width.mas_equalTo(0);
                    } else {
                        make.right.equalTo(self).offset(-offsetX);
                    }
                }
            }
        } else { // 左边无按钮
            // 右按钮
            if (!self.rightButton.isHidden) {
                const CGFloat rightBtnWidth = self.rightButton.appropriateSize.width;

                if (titleButtonWidth < kScreenWidth - 2 * (rightBtnWidth + margin)) {
                    make.width.mas_equalTo(titleButtonWidth);
                    make.centerX.equalTo(self);
                } else {
                    make.right.equalTo(self.rightButton.mas_left).offset(-margin);
                    make.left.equalTo(self).offset(2 * margin + rightBtnWidth);
                }
            } else if (self.private_customRightView) {
                const CGFloat rightViewWidth = [self private_customRightViewSize].width;
                if (titleButtonWidth < kScreenWidth - 2 * (rightViewWidth + margin)) {
                    make.width.mas_equalTo(titleButtonWidth);
                    make.centerX.equalTo(self);
                } else {
                    make.right.equalTo(self.private_customRightView.mas_left).offset(-margin);
                    // 处理右边View 宽度比较宽情况
                    const CGFloat offsetX = 2 * margin + rightViewWidth;
                    if (kScreenWidth * 0.5 - offsetX < 0) {
                        make.width.mas_equalTo(0);
                    } else {
                        make.left.equalTo(self).offset(offsetX);
                    }
                }
            } else {
                if (titleButtonWidth < kScreenWidth - 2 * margin) {
                    make.width.mas_equalTo(titleButtonWidth);
                    make.centerX.equalTo(self);
                } else {
                    make.left.equalTo(self).offset(margin);
                    make.right.equalTo(self).offset(-margin);
                }
            }
        }
    };

    if (!self.titleBtn.isHidden) {
        [self.titleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            makeMiddleViewConstraints(make);
        }];
        [self.titleBtn layoutIfNeeded];
        [self.titleBtn setNeedsLayout];
    }

    [self.private_customTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.private_customTitleView) {
            makeMiddleViewConstraints(make);
            make.height.mas_equalTo([self private_customTitleViewSize].height);
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.width.centerX.bottom.equalTo(self);
            make.height.mas_equalTo(PixelOne);
        }
    }];

    [super updateConstraints];
}

#pragma mark - private methods
- (CGSize)private_customLeftViewSize {
    CGSize size = self.private_customLeftView.bounds.size;
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        [self.private_customLeftView sizeToFit];
        size = self.private_customLeftView.bounds.size;
    }
    return size;
}

- (CGSize)private_customTitleViewSize {
    CGSize size = self.private_customTitleView.bounds.size;
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        [self.private_customTitleView sizeToFit];
        size = self.private_customTitleView.bounds.size;
    }
    return size;
}

- (CGSize)private_customRightViewSize {
    CGSize size = self.private_customRightView.bounds.size;
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        [self.private_customRightView sizeToFit];
        size = self.private_customRightView.bounds.size;
    }
    return size;
}

#pragma mark - public methods
- (void)setLeftBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title {
    HDCommonButton *button = _leftButton;
    if (button.isHidden && [self.private_customLeftView isKindOfClass:UIButton.class]) {
        button = (HDCommonButton *)self.private_customLeftView;
    }
    if ([button respondsToSelector:@selector(setImageViewEdgeInsets:)]) {
        button.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, image && title.length > 0 ? 5 : 0);
    }
    button.hidden = !image && title.length <= 0;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)setTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image {
    HDCommonButton *button = _titleBtn;
    if (button.isHidden && [self.private_customTitleView isKindOfClass:UIButton.class]) {
        button = (HDCommonButton *)self.private_customTitleView;
    }
    if ([button respondsToSelector:@selector(setImageViewEdgeInsets:)]) {
        button.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, image && title.length > 0 ? 5 : 0);
    }

    [self setTitle:title];
    [self setTitleImage:image];
    [self setTitleColor:titleColor];
    [self setTitleFont:titleFont];

    [self setNeedsUpdateConstraints];
}

- (void)setLeftTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image {
    self.leftButton.titleLabel.font = titleFont;
    [self.leftButton setTitleColor:titleColor forState:UIControlStateNormal];

    [self setLeftBtnImage:image title:title];
}

- (void)setRightTitle:(NSString *__nullable)title titleFont:(UIFont *__nullable)titleFont titleColor:(UIColor *__nullable)titleColor image:(UIImage *__nullable)image {
    self.rightButton.titleLabel.font = titleFont;
    [self.rightButton setTitleColor:titleColor forState:UIControlStateNormal];

    [self setRightBtnImage:image title:title];
}

- (void)setRightBtnImage:(UIImage *__nullable)image title:(NSString *__nullable)title {
    HDCommonButton *button = _rightButton;
    if (button.isHidden && [self.private_customRightView isKindOfClass:UIButton.class]) {
        button = (HDCommonButton *)self.private_customRightView;
    }
    if ([button respondsToSelector:@selector(setImageViewEdgeInsets:)]) {
        button.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, image && title.length > 0 ? 5 : 0);
    }

    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.hidden = !image && title.length <= 0;
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)setBottomLineHidden:(BOOL)hidden {
    self.bottomLine.hidden = hidden;
}

- (void)setBackgroundAlpha:(CGFloat)alpha {
    self.backgroundView.alpha = alpha;
    self.backgroundImageView.alpha = alpha;
    self.bottomLine.alpha = alpha;
}

- (void)setNavTintColor:(UIColor *)color {
    [self.leftButton setTitleColor:color forState:UIControlStateNormal];
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)setCustomLeftView:(UIView *__nullable)customView {
    if (customView) {
        self.leftButton.hidden = true;

        [self.private_customLeftView removeFromSuperview];
        [self addSubview:customView];
        self.private_customLeftView = customView;
    } else {
        self.leftButton.hidden = NO;
        [self.private_customLeftView removeFromSuperview];
        self.private_customLeftView = nil;
    }

    [self setNeedsUpdateConstraints];
}

- (void)setCustomRightView:(UIView *__nullable)customView {
    if (customView) {
        self.rightButton.hidden = true;

        [self.private_customRightView removeFromSuperview];
        [self addSubview:customView];
        self.private_customRightView = customView;
    } else {
        self.rightButton.hidden = NO;
        [self.private_customRightView removeFromSuperview];
        self.private_customRightView = nil;
    }

    [self setNeedsUpdateConstraints];
}

- (void)setCustomTitleView:(UIView *__nullable)customView {
    if (customView) {
        self.titleBtn.hidden = true;

        [self.private_customTitleView removeFromSuperview];
        [self addSubview:customView];
        self.private_customTitleView = customView;
    } else {
        self.titleBtn.hidden = NO;

        [self.private_customTitleView removeFromSuperview];
        self.private_customTitleView = nil;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedLeftBtn {
    NSLog(@"click on left");
    !self.clickedLeftBtnHandler ?: self.clickedLeftBtnHandler();
}

- (void)clickedRightBtn {
    !self.clickedRightBtnHandler ?: self.clickedRightBtnHandler();
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    _title = title;

    self.titleBtn.hidden = (!self.titleBtn.imageView.image && title.length <= 0) || self.private_customTitleView;

    [self.titleBtn setTitle:title forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;

    [self.titleBtn setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;

    self.titleBtn.titleLabel.font = titleFont;
}

- (void)setTitleAlpha:(CGFloat)titleAlpha {
    _titleAlpha = titleAlpha;

    if (!self.titleBtn.isHidden) {
        self.titleBtn.alpha = titleAlpha;
    }
}

- (void)setTitleImage:(UIImage *)titleImage {
    _titleImage = titleImage;

    self.titleBtn.hidden = (!titleImage && self.titleBtn.titleLabel.text.length <= 0) || self.private_customTitleView;

    [_titleBtn setImage:[titleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    self.backgroundImageView.hidden = YES;
    _barBackgroundColor = barBackgroundColor;
    self.backgroundView.hidden = NO;
    self.backgroundView.backgroundColor = _barBackgroundColor;
}

- (void)setBarBackgroundImage:(UIImage *)barBackgroundImage {
    self.backgroundView.hidden = YES;
    _barBackgroundImage = barBackgroundImage;
    self.backgroundImageView.hidden = NO;
    self.backgroundImageView.image = _barBackgroundImage;
}

- (void)setHideBackButton:(BOOL)hideBackButton {
    if (self.private_customLeftView) {
        self.private_customLeftView.hidden = hideBackButton;
    } else {
        self.leftButton.hidden = hideBackButton;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [HDCommonButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(clickedLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.imageView.contentMode = UIViewContentModeCenter;
        [_leftButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        _leftButton.hidden = NO;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [HDCommonButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(clickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.imageView.contentMode = UIViewContentModeCenter;
        //        _rightButton.imageViewSize = CGSizeMake(40, 40);
        [_rightButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        _rightButton.hidden = YES;
    }
    return _rightButton;
}

- (HDCommonButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [HDCommonButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.enabled = NO;
        _titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleBtn.adjustsImageWhenDisabled = NO;
        _titleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_titleBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _titleBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:(CGFloat)(218.0 / 255.0) green:(CGFloat)(218.0 / 255.0) blue:(CGFloat)(218.0 / 255.0) alpha:1.0];
    }
    return _bottomLine;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.hidden = YES;
    }
    return _backgroundImageView;
}
@end
