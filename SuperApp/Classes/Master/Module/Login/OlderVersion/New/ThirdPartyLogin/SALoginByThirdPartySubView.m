//
//  SALoginByThirdPartySubView.m
//  SuperApp
//
//  Created by Tia on 2022/9/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByThirdPartySubView.h"


@interface SALoginByThirdPartySubView ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *iconView;

@end


@implementation SALoginByThirdPartySubView

+ (instancetype)loginHomePageViewWithText:(NSString *)text iconName:(NSString *)iconName {
    SALoginByThirdPartySubView *view = SALoginByThirdPartySubView.new;
    view.label.text = text;
    if(iconName){
        view.iconView.image = [UIImage imageNamed:iconName];
    }
    view.label.font = HDAppTheme.font.sa_standard14B;
    view.label.textColor = UIColor.sa_C333;
    view.backgroundColor = UIColor.whiteColor;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = UIColor.sa_C333.CGColor;
    [view addGestureRecognizer:view.hd_tapRecognizer];
    return view;
}

+ (instancetype)viewWithText:(NSString *)text iconName:(NSString *)iconName {
    SALoginByThirdPartySubView *view = SALoginByThirdPartySubView.new;
    view.label.text = text;
    view.iconView.image = [UIImage imageNamed:iconName];
    view.layer.borderWidth = 1;
    view.layer.borderColor = HDAppTheme.color.sa_separatorLineColor.CGColor;
    [view addGestureRecognizer:view.hd_tapRecognizer];
    return view;
}

- (void)resetIcon:(NSString *)icon textColor:(UIColor *)textColor text:(NSString *)text backgroundColor:(UIColor *)backgroundColor {
    self.layer.borderWidth = 0;
    self.backgroundColor = backgroundColor;
    self.iconView.image = [UIImage imageNamed:icon];
    self.label.text = text;
    self.label.textColor = textColor;
}

- (void)hd_setupViews {
    [self addSubview:self.label];
    [self addSubview:self.iconView];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.centerY.mas_equalTo(self);
    }];

    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height / 2;
}

- (void)hd_clickedViewHandler {
    !self.clickBlock ?: self.clickBlock();
}

#pragma mark - lazy load
- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.textColor = HDAppTheme.color.sa_C333;
        _label.font = HDAppTheme.font.sa_standard14M;
    }
    return _label;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = UIImageView.new;
    }
    return _iconView;
}

@end
