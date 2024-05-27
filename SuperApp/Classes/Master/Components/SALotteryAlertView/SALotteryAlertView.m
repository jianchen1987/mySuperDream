//
//  SALotteryAlertView.m
//  SuperApp
//
//  Created by seeu on 2021/8/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SALotteryAlertView.h"
#import "SAAppEnvManager.h"
#import "SAMultiLanguageManager.h"
#import "SAOperationButton.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDVendorKit/HDWebImageManager.h>


@implementation SALotteryAlertViewConfig

@end


@interface SALotteryAlertView ()

@property (nonatomic, strong) HDUIButton *closeButton; ///< 关闭按钮
@property (nonatomic, strong) UIImageView *imageView;  ///< 图片视图

@end


@implementation SALotteryAlertView

#pragma mark - Class methods
+ (NSString *)sharedMapQueueKey {
    // 默认以类名作为映射的 key，也就w意味着不同种继承于此的弹窗默认是可以同时显示的，如果需设置它们不可同时显示，可在其实现种重写此方法返回同一字符串，达到将其置于同一队列的目的
    return @"SAMarketingAlertView";
}

+ (instancetype)alertViewWithConfig:(SALotteryAlertViewConfig *__nullable)config {
    return [[self alloc] initWithConfig:config];
}

- (instancetype)initWithConfig:(SALotteryAlertViewConfig *__nullable)config {
    if (self = [super init]) {
        self.config = config ? config : [[SALotteryAlertViewConfig alloc] init];
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = false;
    }
    return self;
}

#pragma mark - override
- (void)layoutContainerView {
    CGFloat left = (kScreenWidth - [self containerViewWidth]) * 0.5;
    CGFloat containerHeight = 0;
    containerHeight += [self imageViewSize].height;
    containerHeight += 30;
    containerHeight += [self closeButtonSize].height;
    CGFloat top = (kScreenHeight - containerHeight) * 0.5;
    self.containerView.frame = CGRectMake(left, top, [self containerViewWidth], containerHeight);
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.backgroundColor = UIColor.clearColor;
}

- (void)setupContainerSubViews {
    // 给containerview添加子视图
    [self.containerView addSubview:self.imageView];
    [self.containerView addSubview:self.closeButton];
}

- (void)layoutContainerViewSubViews {
    CGFloat left = (CGRectGetWidth(self.containerView.frame) - [self imageViewSize].width) * 0.5;
    self.imageView.frame = CGRectMake(left, 0, [self imageViewSize].width, [self imageViewSize].height);
    self.closeButton.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self closeButtonSize].width) * 0.5, [self imageViewSize].height + 30, [self closeButtonSize]};
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    return kScreenWidth - kRealWidth(37.5 * 2);
}

- (CGSize)imageViewSize {
    return CGSizeMake([self containerViewWidth], [self containerViewWidth] * (345 / 291.0));
}

- (CGSize)closeButtonSize {
    return CGSizeMake(kRealWidth(30), kRealWidth(30));
}

#pragma mark - Action
- (void)clickedOnImageView {
    [self dismiss];
    if (HDIsStringNotEmpty(self.config.url)) {
        [SAWindowManager openUrl:self.config.url withParameters:nil];
    }
}

#pragma mark - setter
- (void)setConfig:(SALotteryAlertViewConfig *)config {
    _config = config;

    [HDWebImageManager setImageWithURL:config.lotteryThemeUrl
                      placeholderImage:[HDHelper placeholderImageWithCornerRadius:10.0 size:CGSizeMake([self containerViewWidth], [self containerViewWidth] * (345 / 291.0))
                                                                         logoSize:CGSizeMake(50, 50)]
                             imageView:self.imageView];

    [self setNeedsLayout];
}

#pragma mark - lazy load
/** @lazy closeButton */
- (HDUIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[[UIImage imageNamed:@"marketingAlertClose"] hd_imageWithTintColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

/** @lazy imageView */
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnImageView)];
        [_imageView addGestureRecognizer:tap];
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10.0f];
        };
    }
    return _imageView;
}

@end
