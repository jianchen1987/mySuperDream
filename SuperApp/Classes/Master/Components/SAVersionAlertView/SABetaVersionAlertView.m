//
//  SABetaVersionAlertView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SABetaVersionAlertView.h"
#import "SAVersionAlertViewConfig.h"
#import "SAOperationButton.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDKitCore.h>


@interface SABetaVersionAlertView ()

@property (nonatomic, strong) UIView *backgroundView;          ///< 背景
@property (nonatomic, strong) HDUIButton *closeButton;         ///< 关闭按钮
@property (nonatomic, strong) UIImageView *imageView;          ///< 图片视图
@property (nonatomic, strong) SAOperationButton *updateButton; ///< 更新按钮
@property (nonatomic, strong) UITextView *textView;            ///< 更新内容
@property (nonatomic, strong) UILabel *titleLabel;             ///< 标题
@property (nonatomic, strong) HDUIButton *noExperienceButton;  ///< 暂不体验按钮

@end


@implementation SABetaVersionAlertView

#pragma mark - override
- (void)layoutContainerView {
    CGFloat left = (kScreenWidth - [self containerViewWidth]) * 0.5;
    CGFloat containerHeight = 0;
    containerHeight += [self imageViewSize].height;
    containerHeight += kRealHeight(15);
    containerHeight += [self titleSize].height;
    containerHeight += kRealHeight(26);
    containerHeight += [self textViewSize].height;
    containerHeight += kRealHeight(30);
    containerHeight += [self updateButtonSize].height;
    containerHeight += kRealHeight(10);
    containerHeight += [self noExperienceButtonSize].height;
    containerHeight += kRealHeight(10);
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
    [self.backgroundView addSubview:self.imageView];
    [self.backgroundView addSubview:self.titleLabel];
    [self.backgroundView addSubview:self.textView];
    [self.backgroundView addSubview:self.updateButton];
    [self.backgroundView addSubview:self.closeButton];
    [self.backgroundView addSubview:self.noExperienceButton];
}

- (void)layoutContainerViewSubViews {
    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));

    self.imageView.frame = CGRectMake(0, 0, [self imageViewSize].width, [self imageViewSize].height);
    self.titleLabel.frame = CGRectMake(kRealWidth(15), self.imageView.bottom + kRealHeight(15), [self titleSize].width, [self titleSize].height);
    self.textView.frame = CGRectMake(kRealWidth(15), self.titleLabel.bottom + kRealHeight(26), [self textViewSize].width, [self textViewSize].height);
    self.updateButton.frame = CGRectMake((CGRectGetWidth(self.containerView.frame) - [self updateButtonSize].width) * 0.5,
                                         self.textView.bottom + kRealHeight(30),
                                         [self updateButtonSize].width,
                                         [self updateButtonSize].height);
    self.noExperienceButton.frame = CGRectMake((CGRectGetWidth(self.containerView.frame) - [self noExperienceButtonSize].width) * 0.5,
                                               self.updateButton.bottom + kRealHeight(10),
                                               [self noExperienceButtonSize].width,
                                               [self noExperienceButtonSize].height);

    self.closeButton.frame = (CGRect){CGRectGetWidth(self.containerView.frame) - kRealWidth(8) - [self closeButtonSize].width, kRealHeight(8), [self closeButtonSize]};
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    return kScreenWidth - kRealWidth(60.0f);
}

- (CGSize)imageViewSize {
    return CGSizeMake(self.containerViewWidth, 138.0 / 300.0 * self.containerViewWidth);
}

- (CGSize)titleSize {
    CGFloat width = self.containerViewWidth - kRealWidth(30);
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return CGSizeMake(width, size.height);
}

- (CGSize)textViewSize {
    return CGSizeMake(CGRectGetWidth(self.containerView.frame) - kRealWidth(15) * 2, 80);
}

- (CGSize)updateButtonSize {
    return CGSizeMake(self.containerViewWidth - kRealWidth(30), 45);
}

- (CGSize)noExperienceButtonSize {
    [self.noExperienceButton sizeToFit];
    return self.noExperienceButton.size;
}

- (CGSize)closeButtonSize {
    return CGSizeMake(kRealWidth(30), kRealWidth(30));
}

#pragma mark - Action
- (void)toUpdate {
    if (HDIsStringNotEmpty(self.config.packageLink)) {
        [SAWindowManager openUrl:self.config.packageLink withParameters:nil];
    }

    [super dismiss];
}

#pragma mark - setter
- (void)setConfig:(SAVersionAlertViewConfig *)config {
    [super setConfig:config];
    self.imageView.image = config.illustrationImage ?: [UIImage imageNamed:@"beta_version_img"];
    self.textView.text = config.updateInfo;

    [self setNeedsLayout];
}

#pragma mark - lazy load
/** @lazy closeButton */
- (HDUIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[[UIImage imageNamed:@"icon_close"] hd_imageWithTintColor:UIColor.whiteColor] forState:UIControlStateNormal];
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
    }
    return _imageView;
}

/** @lazy title */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard2Bold;
        _titleLabel.textColor = HDAppTheme.color.G1;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = SALocalizedString(@"get_beta_qualification", @"恭喜获得新版本内测资格");
    }
    return _titleLabel;
}

/** @lazy textview */
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = HDAppTheme.font.standard3;
        _textView.textColor = HDAppTheme.color.G3;
        _textView.editable = NO;
    }
    return _textView;
}

/** @lazy updateButton */
- (SAOperationButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_updateButton addTarget:self action:@selector(toUpdate) forControlEvents:UIControlEventTouchUpInside];
        [_updateButton setTitle:SALocalizedString(@"update_righnow", @"立即更新") forState:UIControlStateNormal];
        [_updateButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_updateButton setTitleEdgeInsets:UIEdgeInsetsMake(9, 35, 9, 35)];
        _updateButton.titleLabel.font = HDAppTheme.font.standard2;
    }
    return _updateButton;
}

/** @lazy updateButton */
- (HDUIButton *)noExperienceButton {
    if (!_noExperienceButton) {
        _noExperienceButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_noExperienceButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_noExperienceButton setTitle:SALocalizedString(@"no_experience", @"暂不体验") forState:UIControlStateNormal];
        [_noExperienceButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [_noExperienceButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 35, 5, 35)];
        _noExperienceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _noExperienceButton;
}

/** @lazy backgroundView */
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = UIColor.whiteColor;
        _backgroundView.layer.cornerRadius = 12.0f;
        _backgroundView.layer.shadowColor = HDAppTheme.color.G4.CGColor;
    }
    return _backgroundView;
}

@end
