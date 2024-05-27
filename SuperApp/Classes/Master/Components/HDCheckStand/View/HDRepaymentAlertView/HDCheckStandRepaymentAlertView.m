//
//  HDCheckStandRepaymentAlertView.m
//  SuperApp
//
//  Created by seeu on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDCheckStandRepaymentAlertView.h"
#import "SAMultiLanguageManager.h"
#import "SAOperationButton.h"
#import <HDKitCore/HDKitCore.h>


@implementation HDCheckStandRepaymentAlertViewConfig

@end


@interface HDCheckStandRepaymentAlertView ()

@property (nonatomic, strong) UIView *backgroundView;            ///< 背景
@property (nonatomic, strong) UILabel *titleLabel;               ///< 标题
@property (nonatomic, strong) UILabel *subTitleLabel;            ///< 副标题
@property (nonatomic, strong) SAOperationButton *continueButton; ///< 继续按钮
@property (nonatomic, strong) SAOperationButton *waitButton;     ///< 等待按钮
@property (nonatomic, strong) HDUIButton *serviceButton;         ///< 客服按钮

@end


@implementation HDCheckStandRepaymentAlertView

+ (instancetype)alertViewWithConfig:(HDCheckStandRepaymentAlertViewConfig *__nullable)config {
    return [[self alloc] initWithConfig:config];
}

- (instancetype)initWithConfig:(HDCheckStandRepaymentAlertViewConfig *__nullable)config {
    if (self = [super init]) {
        self.config = config ? config : [[HDCheckStandRepaymentAlertViewConfig alloc] init];
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
    containerHeight += kRealHeight(17.0);
    containerHeight += [self subTitleSize].height;
    containerHeight += kRealHeight(45.0);
    containerHeight += [self continueButtonSize].height;
    containerHeight += kRealHeight(18.0);
    containerHeight += [self waitButtonSize].height;
    containerHeight += kRealHeight(15.0);
    containerHeight += [self serviceButtonSize].height;
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
    [self.backgroundView addSubview:self.subTitleLabel];
    [self.backgroundView addSubview:self.continueButton];
    [self.backgroundView addSubview:self.waitButton];
    [self.backgroundView addSubview:self.serviceButton];
}

- (void)layoutContainerViewSubViews {
    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));

    self.titleLabel.frame = CGRectMake(kRealWidth(15), kRealHeight(53.0), [self titleSize].width, [self titleSize].height);

    self.subTitleLabel.frame = CGRectMake(kRealWidth(15), self.titleLabel.bottom + kRealHeight(17.0), [self subTitleSize].width, [self subTitleSize].height);

    self.continueButton.frame = CGRectMake(kRealWidth(23), self.subTitleLabel.bottom + kRealHeight(45.0), [self continueButtonSize].width, [self continueButtonSize].height);

    self.waitButton.frame = CGRectMake(kRealWidth(23), self.continueButton.bottom + kRealHeight(18.0), [self waitButtonSize].width, [self waitButtonSize].height);

    self.serviceButton.frame = CGRectMake(kRealWidth(23), self.waitButton.bottom + kRealHeight(18.0), [self serviceButtonSize].width, [self serviceButtonSize].height);
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

- (CGSize)subTitleSize {
    CGFloat width = self.containerViewWidth - kRealWidth(30);
    CGSize size = [self.subTitleLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return CGSizeMake(width, size.height);
}

- (CGSize)continueButtonSize {
    return CGSizeMake(self.containerViewWidth - kRealWidth(23 * 2), kRealWidth(45));
}

- (CGSize)waitButtonSize {
    return CGSizeMake(self.containerViewWidth - kRealWidth(23 * 2), kRealWidth(45));
}

- (CGSize)serviceButtonSize {
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

- (void)clickOnContactService {
    [self dismissCompletion:^{
        !self.config.clickOnServiceHandler ?: self.config.clickOnServiceHandler(self);
    }];
}

#pragma mark - setter
- (void)setConfig:(HDCheckStandRepaymentAlertViewConfig *)config {
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
        _titleLabel.text = SALocalizedString(@"checkstand_repayment_title", @"确认要发起新的支付吗？");
    }
    return _titleLabel;
}

/** @lazy subTitleLabel */
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular];
        _subTitleLabel.textColor = [UIColor hd_colorWithHexString:@"#99000000"];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = SALocalizedString(@"checkstand_repayment_content", @"平台未收到您的支付结果。\n如已完成支付，建议耐心等待。");
    }
    return _subTitleLabel;
}

/** @lazy updateButton */
- (SAOperationButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_continueButton addTarget:self action:@selector(clickOnContinuePayment) forControlEvents:UIControlEventTouchUpInside];
        [_continueButton setTitle:SALocalizedString(@"checkstand_repayment_again", @"没支付，确认继续支付") forState:UIControlStateNormal];
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
        [_waitButton addTarget:self action:@selector(clickOnWailtForResult) forControlEvents:UIControlEventTouchUpInside];
        [_waitButton setTitle:SALocalizedString(@"checkstand_repayment_wait", @"已经支付，等待支付结果") forState:UIControlStateNormal];
        [_waitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _waitButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        _waitButton.cornerRadius = 7.0;
        [_waitButton applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#F83E00"]];
    }
    return _waitButton;
}

/** @lazy updateButton */
- (HDUIButton *)serviceButton {
    if (!_serviceButton) {
        _serviceButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_serviceButton addTarget:self action:@selector(clickOnContactService) forControlEvents:UIControlEventTouchUpInside];
        [_serviceButton setTitle:SALocalizedString(@"suvJBCPM", @"联系客服") forState:UIControlStateNormal];
        [_serviceButton setTitleColor:[UIColor hd_colorWithHexString:@"#717171"] forState:UIControlStateNormal];
        _serviceButton.titleLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
    }
    return _serviceButton;
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
