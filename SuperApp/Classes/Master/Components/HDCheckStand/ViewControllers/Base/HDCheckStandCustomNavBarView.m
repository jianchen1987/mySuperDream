//
//  HDCheckStandCustomNavBarView.m
//  SuperApp
//
//  Created by VanJay on 2019/5/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandCustomNavBarView.h"
#import "SAView.h"


@interface HDCheckStandCustomNavBarView ()
@property (nonatomic, strong) HDUIButton *leftBtn;  ///< 左按钮
@property (nonatomic, strong) HDUIButton *rightBtn; ///< 右按钮
@property (nonatomic, strong) HDUIButton *titleBtn; ///< 标题
@property (nonatomic, strong) UIView *bottomLine;   ///< 底部线条
@end


@implementation HDCheckStandCustomNavBarView
#pragma mark - life cycle
- (void)commonInit {
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.titleBtn];
    [self addSubview:self.bottomLine];

    [self.leftBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleBtn setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
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

- (void)updateConstraints {
    [self.leftBtn sizeToFit];
    [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7);
        make.centerY.equalTo(self);
        CGSize size = self.leftBtn.bounds.size;
        make.size.mas_equalTo(size);
    }];

    [self.rightBtn sizeToFit];
    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-7);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(self.rightBtn.bounds.size);
    }];

    [self.titleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.greaterThanOrEqualTo(self.leftBtn.mas_right);
        make.right.lessThanOrEqualTo(self.rightBtn.mas_left);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - event response
- (void)clickedLeftBtn {
    !self.clickedLeftBtnHandler ?: self.clickedLeftBtnHandler();
}

- (void)clickedRightBtn {
    !self.clickedRightBtnHandler ?: self.clickedRightBtnHandler();
}

#pragma mark - public methods
- (void)setLeftBtnImage:(NSString *)imageName title:(NSString *)title {
    [self.leftBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.leftBtn setTitle:title forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)setTitleBtnImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font {
    if (imageName) {
        self.titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    }
    if (font) {
        self.titleBtn.titleLabel.font = font;
    } else {
        self.titleBtn.titleLabel.font = HDAppTheme.font.standard2Bold;
    }

    [self.titleBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.titleBtn setTitle:title forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)setRightBtnImage:(NSString *)imageName title:(NSString *)title {
    [self.rightBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.rightBtn setTitle:title forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)leftBtn {
    if (!_leftBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [button addTarget:self action:@selector(clickedLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn = button;
    }
    return _leftBtn;
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [button addTarget:self action:@selector(clickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn = button;
    }
    return _rightBtn;
}

- (HDUIButton *)titleBtn {
    if (!_titleBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        button.userInteractionEnabled = false;
        _titleBtn = button;
    }
    return _titleBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
