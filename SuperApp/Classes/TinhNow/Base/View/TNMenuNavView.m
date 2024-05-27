//
//  TNMenuNavView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNMenuNavView.h"


@interface TNMenuNavView ()
/// 背景
@property (nonatomic, strong) UIView *backgroundView;
/// 左边按钮
@property (nonatomic, strong) HDUIButton *leftBtn;
/// 标题
@property (nonatomic, strong) SALabel *titleLabel;
/// 右边按钮
@property (nonatomic, strong) HDUIButton *rightBtn;
@end


@implementation TNMenuNavView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backgroundView];
    [self addSubview:self.leftBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
}

- (void)updateConstraints {
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    CGFloat offsetY = UIApplication.sharedApplication.statusBarFrame.size.height;

    [self.leftBtn sizeToFit];
    [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.leftImageInset);
        make.centerY.equalTo(self).offset(offsetY * 0.5);
        make.size.mas_equalTo(self.leftBtn.bounds.size);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(offsetY * 0.5);
        make.left.greaterThanOrEqualTo(self.leftBtn.mas_right);
        if (self.rightView) {
            make.right.lessThanOrEqualTo(self.rightView.mas_left);
        } else if (!self.rightBtn.isHidden) {
            make.right.lessThanOrEqualTo(self.rightBtn.mas_left);
        } else {
            make.right.lessThanOrEqualTo(self);
        }
    }];

    if (!self.rightView) {
        [self.rightBtn sizeToFit];
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.rightBtn.isHidden) {
                make.size.mas_equalTo(self.rightBtn.bounds.size);
                make.centerY.equalTo(self).offset(offsetY * 0.5);
                make.right.equalTo(self.mas_right).offset(-self.rightImageInset);
            }
        }];
    } else {
        [self.rightView sizeToFit];
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(offsetY * 0.5);
            make.right.equalTo(self.mas_right).offset(-self.rightImageInset);
        }];
    }

    if (self.bgColor) {
        self.backgroundView.backgroundColor = self.bgColor;
    } else {
        self.backgroundView.backgroundColor = UIColor.whiteColor;
    }

    [super updateConstraints];
}

#pragma mark - setter
- (void)setLeftImageInset:(CGFloat)leftImageInset {
    if (_leftImageInset != leftImageInset) {
        _leftImageInset = leftImageInset;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setRightImageInset:(CGFloat)rightImageInset {
    if (_rightImageInset != rightImageInset) {
        _rightImageInset = rightImageInset;
        [self setNeedsUpdateConstraints];
    }
}
- (void)setHiddenRightImageBtn:(BOOL)hiddenRightImageBtn {
    _hiddenRightImageBtn = hiddenRightImageBtn;
    self.rightBtn.hidden = hiddenRightImageBtn;
}
- (void)setBgAlpha:(CGFloat)bgAlpha {
    _bgAlpha = bgAlpha;
    self.backgroundView.alpha = bgAlpha;
}
#pragma mark - private methods
- (void)leftBtnClick:(HDUIButton *)btn {
    !self.clickedLeftViewBlock ?: self.clickedLeftViewBlock();
}

- (void)rightBtnClick:(HDUIButton *)btn {
    !self.clickedRightViewBlock ?: self.clickedRightViewBlock();
}

- (void)updateConstraintsAfterSetInfo {
    self.leftBtn.hidden = HDIsStringEmpty(self.leftImage);
    if (!self.leftBtn.isHidden) {
        [self.leftBtn setImage:[UIImage imageNamed:self.leftImage] forState:UIControlStateNormal];
    }

    if (!self.rightView) {
        self.rightBtn.hidden = HDIsStringEmpty(self.rightImage);
        if (!self.rightBtn.isHidden) {
            [self.rightBtn setImage:[UIImage imageNamed:self.rightImage] forState:UIControlStateNormal];
        }
    }

    self.titleLabel.hidden = HDIsStringEmpty(self.title);
    if (!self.titleLabel.isHidden) {
        self.titleLabel.text = self.title;
    }

    if (self.rightView) {
        [self.rightView removeFromSuperview];
        [self addSubview:self.rightView];
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)leftBtn {
    if (!_leftBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn = button;
    }
    return _leftBtn;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.textColor = HDAppTheme.color.G1;
        _titleLabel.font = HDAppTheme.font.standard2Bold;
    }
    return _titleLabel;
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = 0.01;
        [button addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn = button;
    }
    return _rightBtn;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = UIView.new;
        _backgroundView.backgroundColor = UIColor.whiteColor;
        _backgroundView.alpha = 1;
    }
    return _backgroundView;
}
@end
