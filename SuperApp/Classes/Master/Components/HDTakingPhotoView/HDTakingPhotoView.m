//
//  HDTakingPhotoView.m
//  SuperApp
//
//  Created by VanJay on 2019/4/4.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTakingPhotoView.h"
#import "Masonry.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDCommonDefines.h>


@interface HDTakingPhotoView ()
@property (nonatomic, strong) UIButton *takePhotoBtn;    ///< 拍照
@property (nonatomic, strong) UIButton *flashBtn;        ///< 闪光灯
@property (nonatomic, strong) UIButton *cancelBtn;       ///< 取消按钮
@property (nonatomic, strong) UIButton *switchCameraBtn; ///< 切换镜头按钮
@property (nonatomic, strong) UIView *sepLine;           ///< 分割线
@property (nonatomic, strong) UIView *focusView;         ///< 聚焦
@property (nonatomic, assign) BOOL isSessionRunning;     ///< 会话进行
@end


@implementation HDTakingPhotoView
#pragma mark - life cycle

- (void)commonInit {
    [self addSubview:self.takePhotoBtn];
    [self addSubview:self.focusView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.switchCameraBtn];
    [self addSubview:self.flashBtn];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

- (void)updateConstraints {
    [_takePhotoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-kRealHeight(28));
    }];

    _cancelBtn.titleLabel.preferredMaxLayoutWidth = 100;
    [_cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.takePhotoBtn);
        make.height.mas_equalTo(kRealWidth(30));
        make.left.mas_equalTo(self).offset(kRealWidth(25));
    }];

    _switchCameraBtn.titleLabel.preferredMaxLayoutWidth = 100;
    [_switchCameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.takePhotoBtn);
        make.right.mas_equalTo(self).offset(-kRealWidth(25));
    }];

    [_flashBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(28));
        make.top.mas_equalTo(self).offset(kRealWidth(11) + kStatusBarH);
    }];

    [_sepLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PixelOne);
        make.width.equalTo(self);
        make.bottom.mas_equalTo(self.takePhotoBtn.mas_top).offset(-kRealWidth(20));
    }];
    [super updateConstraints];
}

#pragma mark - public methods
- (void)dealingWithButtonsState:(BOOL)isRunning isFrontCamera:(BOOL)isFrontCamera {
    if (isRunning) {
        for (UIView *subView in self.subviews) {
            if (subView != _cancelBtn && subView != _switchCameraBtn && subView != _focusView) {
                subView.hidden = false;
            }
        }
    } else {
        for (UIView *subView in self.subviews) {
            if (subView != _cancelBtn && subView != _switchCameraBtn) {
                subView.hidden = true;
            } else {
                subView.hidden = false;
            }
        }
    }

    self.isSessionRunning = isRunning;
    self.flashBtn.hidden = isFrontCamera || !isRunning;
    if (isRunning) {
        self.takePhotoBtn.selected = NO;
        [self.cancelBtn setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        [self.switchCameraBtn setImage:[UIImage imageNamed:@"change_camera"] forState:UIControlStateNormal];
        [self.switchCameraBtn setTitle:nil forState:UIControlStateNormal];
    } else {
        [self.cancelBtn setTitle:SALocalizedString(@"SCAN_TAKE_PHOTO_RETAKE", @"重拍") forState:UIControlStateNormal];
        [self.switchCameraBtn setTitle:SALocalizedString(@"SCAN_TAKE_PHOTO_USE_PHOTO", @"使用照片") forState:UIControlStateNormal];
        [self.switchCameraBtn setImage:nil forState:UIControlStateNormal];
    }
}

- (void)focusAtPoint:(CGPoint)point {
    self.focusView.center = point;
    self.focusView.hidden = NO;

    [UIView animateWithDuration:0.3 animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.focusView.hidden = YES;
        }];
    }];
}

- (void)isFlashLightEnabled:(BOOL)yor {
    self.flashBtn.hidden = !yor;
}

#pragma mark - event response
- (void)takePhoto:(UIButton *)btn {
    if (self.isSessionRunning) {
        btn.selected = !btn.isSelected;
        if (self.takePhotoBlock) {
            self.takePhotoBlock(btn.isSelected);
        }
    }
}

- (void)cancel {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)changeCamera:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.switchCameraBlock) {
        self.switchCameraBlock(btn.isSelected);
    }
}

- (void)switchFlashLight:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.switchFlashLightBlock) {
        self.switchFlashLightBlock(btn.isSelected);
    }
}

#pragma mark - lazy load
- (UIButton *)takePhotoBtn {
    if (!_takePhotoBtn) {
        _takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePhotoBtn setImage:[UIImage imageNamed:@"shot"] forState:UIControlStateNormal];
        [_takePhotoBtn setImage:[UIImage imageNamed:@"shot_active"] forState:UIControlStateHighlighted];
        [_takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoBtn;
}

- (UIView *)focusView {
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor = [UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)switchCameraBtn {
    if (!_switchCameraBtn) {
        _switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraBtn setImage:[UIImage imageNamed:@"change_camera"] forState:UIControlStateNormal];
        _switchCameraBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_switchCameraBtn addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}

- (UIButton *)flashBtn {
    if (!_flashBtn) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashBtn setBackgroundImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
        [_flashBtn setBackgroundImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateSelected];
        [_flashBtn addTarget:self action:@selector(switchFlashLight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashBtn;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = HexColor(0x888888);
    }
    return _sepLine;
}
@end
