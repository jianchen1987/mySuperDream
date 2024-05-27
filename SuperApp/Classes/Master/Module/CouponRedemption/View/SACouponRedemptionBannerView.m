//
//  SACouponRedemptionView.m
//  SuperApp
//
//  Created by Chaos on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponRedemptionBannerView.h"
#import "SACouponRedemptionRspModel.h"
#import "SATalkingData.h"


@interface SACouponRedemptionBannerView ()

/// 优惠券底图
@property (nonatomic, strong) UIImageView *couponBackIV;
/// 优惠券活动名称
@property (nonatomic, strong) SALabel *couponNameLB;
/// 您已获得
@property (nonatomic, strong) SALabel *haveLB;
/// 点击查看
@property (nonatomic, strong) HDUIButton *clickLookBTN;

@end


@implementation SACouponRedemptionBannerView

- (void)hd_setupViews {
    [self addSubview:self.couponBackIV];
    [self addSubview:self.couponNameLB];
    [self addSubview:self.haveLB];
    [self addSubview:self.clickLookBTN];
}

- (void)updateConstraints {
    [self.couponBackIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(kRealWidth(6));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(6));
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.couponBackIV.mas_width).multipliedBy(118.0 / 363.0);
    }];

    [self.haveLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.couponBackIV).offset(kRealWidth(67));
        make.top.equalTo(self.couponBackIV).offset(kRealWidth(17));
    }];

    [self.clickLookBTN sizeToFit];
    [self.clickLookBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.haveLB);
        make.bottom.equalTo(self.couponBackIV).offset(-kRealWidth(24));
        make.width.mas_equalTo(self.clickLookBTN.size.width);
        make.height.mas_equalTo(kRealWidth(24));
    }];

    [self.couponNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.haveLB.mas_bottom).offset(kRealWidth(10));
        make.centerX.equalTo(self.haveLB);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)couponClickHandler {
    if ([self.clientType isEqualToString:SAClientTypeTinhNow]) {
        [SATalkingData trackEvent:@"[电商]支付结果_点击优惠券入口"];
    }
    [HDMediator.sharedInstance navigaveToCouponRedemptionViewController:@{@"list": self.model.list}];
}

#pragma mark - setter
- (void)setModel:(SACouponRedemptionRspModel *)model {
    _model = model;
    self.couponNameLB.text = model.activityName.desc;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)couponBackIV {
    if (!_couponBackIV) {
        _couponBackIV = UIImageView.new;
        _couponBackIV.image = [UIImage imageNamed:@"coupon_banner_bg"];
    }
    return _couponBackIV;
}

- (UILabel *)couponNameLB {
    if (!_couponNameLB) {
        _couponNameLB = SALabel.new;
        _couponNameLB.textColor = UIColor.whiteColor;
        _couponNameLB.font = HDAppTheme.font.standard3Bold;
    }
    return _couponNameLB;
}

- (SALabel *)haveLB {
    if (!_haveLB) {
        _haveLB = SALabel.new;
        _haveLB.textColor = UIColor.whiteColor;
        _haveLB.font = HDAppTheme.font.standard4;
        _haveLB.text = SALocalizedString(@"Hpvwa3Zz", @"您已获得");
    }
    return _haveLB;
}

- (HDUIButton *)clickLookBTN {
    if (!_clickLookBTN) {
        _clickLookBTN = HDUIButton.new;
        _clickLookBTN.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _clickLookBTN.layer.cornerRadius = kRealWidth(12);
        _clickLookBTN.layer.masksToBounds = true;
        _clickLookBTN.titleLabel.font = HDAppTheme.font.standard3;
        [_clickLookBTN addTarget:self action:@selector(couponClickHandler) forControlEvents:UIControlEventTouchUpInside];
        [_clickLookBTN setTitle:SALocalizedString(@"vKmYX5mn", @"点击查看") forState:UIControlStateNormal];
        [_clickLookBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _clickLookBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setGradualChangingColorFromColor:HexColor(0xFFC938) toColor:HexColor(0xFD1401)];
        };
    }
    return _clickLookBTN;
}

@end
