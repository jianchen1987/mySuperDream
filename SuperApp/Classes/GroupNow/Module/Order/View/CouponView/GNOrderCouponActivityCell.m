//
//  GNOrderCouponActivityCell.m
//  SuperApp
//
//  Created by wmz on 2022/8/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderCouponActivityCell.h"


@interface GNOrderCouponActivityCell ()
///底图
@property (nonatomic, strong) UIImageView *bgIV;
///日期
@property (nonatomic, strong) HDLabel *dateLB;
///标题
@property (nonatomic, strong) HDLabel *titleLB;
///查看
@property (nonatomic, strong) HDUIButton *confirmBTN;
///渐变图层
@property (nonatomic, strong) CAGradientLayer *gl;

@end


@implementation GNOrderCouponActivityCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgIV];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.dateLB];
    [self.contentView addSubview:self.confirmBTN];
}

- (void)setGNModel:(GNCellModel *)data {
    self.contentView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    self.dateLB.text = GNFillEmpty(data.title);
    self.titleLB.text = GNFillEmpty(data.detail);
    self.dateLB.hidden = data.leftHigh;
}

- (void)updateConstraints {
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_equalTo(0);
    }];

    [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.dateLB.isHidden) {
            make.left.equalTo(self.bgIV.mas_left).offset(kRealWidth(16));
            make.top.equalTo(self.bgIV.mas_top).offset(kRealWidth(10));
            make.right.equalTo(self.bgIV.mas_right).offset(-kRealWidth(10));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        }
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.dateLB.isHidden) {
            make.left.equalTo(self.dateLB);
            make.top.equalTo(self.dateLB.mas_bottom);
        } else {
            make.left.equalTo(self.bgIV.mas_left).offset(kRealWidth(16));
            make.top.equalTo(self.bgIV.mas_top).offset(kRealWidth(10));
        }
        make.right.equalTo(self.bgIV.mas_right).offset(-kRealWidth(10));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(32));
        make.left.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(6));
        make.bottom.equalTo(self.bgIV.mas_bottom).offset(-kRealWidth(10));
    }];

    [super updateConstraints];
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.color.gn_mainColor;
        label.font = [HDAppTheme.font gn_boldForSize:16];
        _titleLB = label;
    }
    return _titleLB;
}

- (HDLabel *)dateLB {
    if (!_dateLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HexColor(0x9E3611);
        label.font = [HDAppTheme.font gn_ForSize:12];
        _dateLB = label;
    }
    return _dateLB;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _confirmBTN.layer.cornerRadius = kRealWidth(18);
        [_confirmBTN setTitle:GNLocalizedString(@"gn_view_coupons", @"查看优惠券") forState:UIControlStateNormal];
        [_confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(24), kRealWidth(6), kRealWidth(24));
        _confirmBTN.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _confirmBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.backgroundColor =
                [HDAppTheme.color gn_ColorGradientChangeWithSize:view.size direction:GNGradientChangeDirectionLevel colors:@[HexColor(0xFFA425), HexColor(0xFE634A), HexColor(0xFF2CD8)]].CGColor;
        };
        @HDWeakify(self)[_confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"enterCouponAction"];
        }];
    }
    return _confirmBTN;
}

- (CAGradientLayer *)gl {
    if (!_gl) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.startPoint = CGPointMake(0, 0.5);
        gl.cornerRadius = kRealWidth(18);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:164 / 255.0 blue:37 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:254 / 255.0 green:99 / 255.0 blue:74 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:44 / 255.0 blue:216 / 255.0 alpha:1.0].CGColor
        ];
        gl.locations = @[@(0), @(0.4f), @(1.0f)];
        _gl = gl;
    }
    return _gl;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.image = [UIImage imageNamed:@"gn_order_coupn"];
    }
    return _bgIV;
}

@end
