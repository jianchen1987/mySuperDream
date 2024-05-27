//
//  SAOrderNotLoginView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderNotLoginView.h"


@interface SAOrderNotLoginView ()
/// 容器，控制居中
@property (nonatomic, strong) UIView *containerView;
/// 图片
@property (nonatomic, strong) UIImageView *imageV;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 登录、注册按钮
@property (nonatomic, strong) HDUIGhostButton *signInSignUpBTN;
@end


@implementation SAOrderNotLoginView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.containerView];
    [self addSubview:self.imageV];
    [self addSubview:self.descLB];
    [self addSubview:self.signInSignUpBTN];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^updateConstraintsWithAnimation)(void) = ^(void) {
        @HDStrongify(self);
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutIfNeeded];
        }];
    };

    [self.KVOController hd_observe:self.descLB keyPath:@"text" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        updateConstraintsWithAnimation();
    }];
    [self.KVOController hd_observe:self.signInSignUpBTN.titleLabel keyPath:@"text" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        updateConstraintsWithAnimation();
    }];
    [self.KVOController hd_observe:self.imageV keyPath:@"image" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        updateConstraintsWithAnimation();
    }];
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.center.equalTo(self);
        make.top.equalTo(self.imageV);
        make.bottom.equalTo(self.signInSignUpBTN);
    }];

    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).multipliedBy(0.3);
        if (self.imageV.image) {
            make.height.equalTo(self.imageV.mas_width).multipliedBy(self.imageV.image.size.height / self.imageV.image.size.width);
        } else {
            make.height.equalTo(self.imageV.mas_width).multipliedBy(3 / 4.0);
        }
        make.centerX.equalTo(self);
    }];

    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.containerView);
        make.top.equalTo(self.imageV.mas_bottom).offset(kRealWidth(20));
    }];

    [self.signInSignUpBTN sizeToFit];
    [self.signInSignUpBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLB.mas_bottom).offset(kRealWidth(15));
        make.size.mas_equalTo(self.signInSignUpBTN.bounds.size);
        make.centerX.equalTo(self.containerView);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedSignInSignUpBTNHandler {
    !self.clickedSignInSignUpBTNBlock ?: self.clickedSignInSignUpBTNBlock();
}

#pragma mark - lazy load
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
    }
    return _containerView;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"no_data_placeholder"];
        _imageV = imageView;
    }
    return _imageV;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = SALocalizedString(@"view_order_after_sign_in", @"登录后可查看订单");
        _descLB = label;
    }
    return _descLB;
}

- (HDUIGhostButton *)signInSignUpBTN {
    if (!_signInSignUpBTN) {
        HDUIGhostButton *button = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard4;
        [button setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 15, 8, 15);
        [button addTarget:self action:@selector(clickedSignInSignUpBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = HDAppTheme.color.sa_C1;
        button.cornerRadius = 5;
        _signInSignUpBTN = button;
    }
    return _signInSignUpBTN;
}
@end
