//
//  GNNaviView.m
//  SuperApp
//
//  Created by wmz on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNNaviView.h"
#import "GNEvent.h"


@implementation GNNaviView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.bgIV];
    [self.bgIV addSubview:self.leftBTN];
    [self.bgIV addSubview:self.rightBTN];
    [self.bgIV addSubview:self.titleLB];
}

- (void)updateConstraints {
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kStatusBarH);
    }];

    [self.leftBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(self.bgIV);
    }];

    [self.rightBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgIV);
        make.right.mas_equalTo(-kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBTN.mas_right).offset(3);
        make.right.equalTo(self.rightBTN.mas_left).offset(-3);
        make.centerY.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (HDUIButton *)leftBTN {
    if (!_leftBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImage:[UIImage imageNamed:@"gn_home_nav_back"] forState:UIControlStateNormal];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [GNEvent eventResponder:self target:btn key:@"dissmiss"];
        }];
        _leftBTN = button;
    }
    return _leftBTN;
}

- (HDUIButton *)rightBTN {
    if (!_rightBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [GNEvent eventResponder:self target:btn key:@"rightAction"];
        }];
        _rightBTN = button;
    }
    return _rightBTN;
}

- (UIView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIView.new;
    }
    return _bgIV;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [HDAppTheme.font gn_boldForSize:16];
        _titleLB.textColor = HDAppTheme.color.gn_333Color;
    }
    return _titleLB;
}

@end
