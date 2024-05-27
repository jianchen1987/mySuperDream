//
//  SANewVersionAlertView.m
//  SuperApp
//
//  Created by seeu on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SANewVersionAlertView.h"
#import "NSDate+SAExtension.h"
#import "SAOperationButton.h"
#import "SAWindowManager.h"
#import "SAVersionAlertViewConfig.h"
#import <HDVendorKit.h>


@interface SANewVersionAlertView ()

@property (nonatomic, strong) UIView *backgroundView;          ///< 背景
@property (nonatomic, strong) HDUIButton *closeButton;         ///< 关闭按钮
@property (nonatomic, strong) UIImageView *imageView;          ///< 图片视图
@property (nonatomic, strong) SAOperationButton *updateButton; ///< 更新按钮
@property (nonatomic, strong) UITextView *textView;            ///< 更新内容
@property (nonatomic, strong) UILabel *titleLabel;             ///< 标题
@property (nonatomic, strong) UILabel *descLabel;              ///< 副标题

@end


@implementation SANewVersionAlertView

#pragma mark - override
- (void)layoutContainerView {
    CGFloat left = (kScreenWidth - [self containerViewWidth]) * 0.5;
    CGFloat containerHeight = 0;
    containerHeight += kRealHeight(28);
    containerHeight += [self imageViewSize].height;
    containerHeight += kRealHeight(24);
    containerHeight += [self titleSize].height;
    containerHeight += kRealHeight(5);
    containerHeight += [self descSize].height;
    containerHeight += kRealHeight(15);
    containerHeight += [self textViewSize].height;
    containerHeight += kRealHeight(30);
    containerHeight += [self updateButtonSize].height;
    containerHeight += kRealHeight(30);
    containerHeight += kRealHeight(30);
    containerHeight += [self closeButtonSize].height;
    CGFloat top = (kScreenHeight - containerHeight) * 0.5;
    self.containerView.frame = CGRectMake(left, top, [self containerViewWidth], containerHeight);
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    //        self.containerView.layer.masksToBounds = YES;
    //        self.containerView.layer.cornerRadius = 10.0f;
    self.containerView.backgroundColor = UIColor.clearColor;
}

- (void)setupContainerSubViews {
    // 给containerview添加子视图
    [self.containerView addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.imageView];
    [self.backgroundView addSubview:self.titleLabel];
    [self.backgroundView addSubview:self.descLabel];
    [self.backgroundView addSubview:self.textView];
    [self.backgroundView addSubview:self.updateButton];
    [self.containerView addSubview:self.closeButton];
}

- (void)layoutContainerViewSubViews {
    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame) - kRealHeight(30) - [self closeButtonSize].height);

    CGFloat left = (CGRectGetWidth(self.containerView.frame) - [self imageViewSize].width) * 0.5;
    self.imageView.frame = CGRectMake(left, kRealHeight(28), [self imageViewSize].width, [self imageViewSize].height);
    self.titleLabel.frame = CGRectMake(kRealWidth(15), self.imageView.bottom + kRealHeight(24), [self titleSize].width, [self titleSize].height);
    self.descLabel.frame = CGRectMake(kRealWidth(15), self.titleLabel.bottom + kRealHeight(5), [self descSize].width, [self descSize].height);
    self.textView.frame = CGRectMake(kRealWidth(15), self.descLabel.bottom + kRealHeight(15), [self textViewSize].width, [self textViewSize].height);
    self.updateButton.frame = CGRectMake((CGRectGetWidth(self.containerView.frame) - [self updateButtonSize].width) * 0.5,
                                         self.textView.bottom + kRealHeight(30),
                                         [self updateButtonSize].width,
                                         [self updateButtonSize].height);

    self.closeButton.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self closeButtonSize].width) * 0.5, self.backgroundView.bottom + kRealHeight(30), [self closeButtonSize]};
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    return kScreenWidth - kRealWidth(60.0f);
}

- (CGSize)imageViewSize {
    return CGSizeMake(kRealWidth(189.0), kRealWidth(126.0));
}

- (CGSize)titleSize {
    [self.titleLabel sizeToFit];
    return self.titleLabel.frame.size;
}

- (CGSize)descSize {
    [self.descLabel sizeToFit];
    return self.descLabel.frame.size;
}

- (CGSize)textViewSize {
    return CGSizeMake(CGRectGetWidth(self.containerView.frame) - kRealWidth(15) * 2, 80);
}

- (CGSize)updateButtonSize {
    NSString *text = SALocalizedString(@"update_righnow", @"立即更新");
    CGSize textSize = [text boundingAllRectWithSize:CGSizeMake(CGRectGetWidth(self.containerView.frame) - kRealWidth(30) - kRealWidth(36) * 2, CGFLOAT_MAX) font:HDAppTheme.font.standard2
                                        lineSpacing:5];
    return CGSizeMake(textSize.width + kRealWidth(36) * 2, 40);
}

- (CGSize)closeButtonSize {
    return CGSizeMake(kRealWidth(30), kRealWidth(30));
}

#pragma mark - Action
- (void)toUpdate {
    if (HDIsStringNotEmpty(self.config.AppId)) {
        [HDSystemCapabilityUtil gotoAppStoreForAppID:self.config.AppId];
    }

    [super dismiss];
}

#pragma mark - setter
- (void)setConfig:(SAVersionAlertViewConfig *)config {
    [super setConfig:config];
    self.imageView.image = config.illustrationImage ?: [UIImage imageNamed:@"new_version_img"];
    self.descLabel.text = HDIsStringNotEmpty(config.updateVersion) ? [NSString stringWithFormat:@"V%@", config.updateVersion] : @"";
    self.textView.text = config.updateInfo;
    if ([config.updateModel isEqualToString:SAVersionUpdateModelCoerce]) {
        self.closeButton.hidden = YES;
    }

    [self setNeedsLayout];
}

#pragma mark - lazy load
/** @lazy closeButton */
- (HDUIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"marketingAlertClose"] forState:UIControlStateNormal];
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
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = SALocalizedString(@"find_new_version", @"发现新版本");
    }
    return _titleLabel;
}

/** @lazy desclabel */
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = HDAppTheme.font.standard3;
        _descLabel.textColor = HDAppTheme.color.G2;
        _descLabel.numberOfLines = 1;
    }
    return _descLabel;
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

/** @lazy backgroundView */
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = UIColor.whiteColor;
        _backgroundView.layer.cornerRadius = 10.0f;
        _backgroundView.layer.shadowColor = HDAppTheme.color.G4.CGColor;
    }
    return _backgroundView;
}

@end
