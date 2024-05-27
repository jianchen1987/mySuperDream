//
//  HDCheckStandRepaymentShortAlertView.m
//  SuperApp
//
//  Created by Tia on 2023/2/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "HDCheckStandRepaymentShortAlertView.h"
#import "SAMultiLanguageManager.h"
#import "SAOperationButton.h"
#import <HDKitCore/HDKitCore.h>


@implementation HDCheckStandRepaymentShortAlertViewConfig

@end


@interface HDCheckStandRepaymentShortAlertView ()

@property (nonatomic, strong) UIView *backgroundView; ///< 背景
@property (nonatomic, strong) UILabel *titleLabel;    ///< 标题
@property (nonatomic, strong) SAOperationButton *continueButton; ///< 继续按钮
@property (nonatomic, strong) SAOperationButton *waitButton;     ///< 等待按钮

@end


@implementation HDCheckStandRepaymentShortAlertView

+ (instancetype)alertViewWithConfig:(HDCheckStandRepaymentShortAlertViewConfig *__nullable)config {
    return [[self alloc] initWithConfig:config];
}

- (instancetype)initWithConfig:(HDCheckStandRepaymentShortAlertViewConfig *__nullable)config {
    if (self = [super init]) {
        self.config = config ? config : [[HDCheckStandRepaymentShortAlertViewConfig alloc] init];
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
    containerHeight += kRealHeight(53.0);
    containerHeight += [self titleSize].height;
    containerHeight += kRealHeight(45.0);
    containerHeight += [self continueButtonSize].height;
    containerHeight += kRealHeight(18.0);
    containerHeight += [self waitButtonSize].height;
    containerHeight += kRealHeight(15.0);
    CGFloat top = (kScreenHeight - containerHeight) * 0.5;
    self.containerView.frame = CGRectMake(left, top, [self containerViewWidth], containerHeight);
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.backgroundColor = UIColor.clearColor;
}

- (void)setupContainerSubViews {
    // 给containerview添加子视图
    [self.containerView addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.titleLabel];
    [self.backgroundView addSubview:self.continueButton];
    [self.backgroundView addSubview:self.waitButton];
}

- (void)layoutContainerViewSubViews {
    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    self.titleLabel.frame = CGRectMake(kRealWidth(15), kRealHeight(53.0), [self titleSize].width, [self titleSize].height);
    self.continueButton.frame = CGRectMake(kRealWidth(23), self.titleLabel.bottom + kRealHeight(45.0), [self continueButtonSize].width, [self continueButtonSize].height);
    self.waitButton.frame = CGRectMake(kRealWidth(23), self.continueButton.bottom + kRealHeight(18.0), [self waitButtonSize].width, [self waitButtonSize].height);

}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    return kScreenWidth - kRealWidth(32.0 * 2);
}

- (CGSize)titleSize {
    CGFloat width = self.containerViewWidth - kRealWidth(30);
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return CGSizeMake(width, size.height);
}

- (CGSize)continueButtonSize {
    return CGSizeMake(self.containerViewWidth - kRealWidth(23 * 2), kRealWidth(45));
}

- (CGSize)waitButtonSize {
    return CGSizeMake(self.containerViewWidth - kRealWidth(23 * 2), kRealWidth(45));
}

#pragma mark - Action
- (void)clickOnContinuePayment {
    [self dismissCompletion:^{
        !self.config.clickOnContinuePaymentHandler ?: self.config.clickOnContinuePaymentHandler(self);
    }];
}

- (void)clickOnWailtForResult {
    [self dismissCompletion:^{
        !self.config.clickOnWailtPaymentResultHandler ?: self.config.clickOnWailtPaymentResultHandler(self);
    }];
}

#pragma mark - setter
- (void)setConfig:(HDCheckStandRepaymentShortAlertViewConfig *)config {
    _config = config;

    [self setNeedsLayout];
}

#pragma mark - lazy load
/** @lazy title */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = SALocalizedString(@"checkstand_repayment_title1", @"确认要发起新的支付吗？");
    }
    return _titleLabel;
}

/** @lazy updateButton */
- (SAOperationButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_continueButton addTarget:self action:@selector(clickOnWailtForResult) forControlEvents:UIControlEventTouchUpInside];
        [_continueButton setTitle:SALocalizedString(@"checkstand_repayment_again1", @"我还没有付款") forState:UIControlStateNormal];
        [_continueButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        _continueButton.cornerRadius = 7.0;
        [_continueButton applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#F83E00"]];
    }
    return _continueButton;
}

/** @lazy closeButton */
- (SAOperationButton *)waitButton {
    if (!_waitButton) {
        _waitButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_waitButton addTarget:self action:@selector(clickOnContinuePayment) forControlEvents:UIControlEventTouchUpInside];
        [_waitButton setTitle:SALocalizedString(@"checkstand_repayment_wait1", @"我已完成付款") forState:UIControlStateNormal];
        [_waitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _waitButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        _waitButton.cornerRadius = 7.0;
        [_waitButton applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#F83E00"]];
    }
    return _waitButton;
}

/** @lazy backgroundView */
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = UIColor.whiteColor;
        _backgroundView.layer.cornerRadius = 10.0f;
        _backgroundView.layer.shadowColor = HDAppTheme.color.G4.CGColor;
        _backgroundView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FFEFEA"] toColor:UIColor.whiteColor endPoint:CGPointMake(0, 1)];
            [view setRoundedCorners:UIRectCornerAllCorners radius:10.0f];
        };
    }
    return _backgroundView;
}

@end
