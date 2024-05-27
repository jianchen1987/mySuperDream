//
//  WMCouponsTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCouponsTableViewCell.h"


@interface WMCouponsTableViewCell ()
/// bg
@property (nonatomic, strong) UIView *bgView;
///背景图片
@property (nonatomic, strong) UIImageView *bgIV;
/// title
@property (nonatomic, strong) YYLabel *titleLB;
/// detail
@property (nonatomic, strong) YYLabel *detailLB;
/// time
@property (nonatomic, strong) HDLabel *timeLB;
///操作按钮
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// got图片
@property (nonatomic, strong) UIImageView *gotIV;

@end


@implementation WMCouponsTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.bgIV];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.detailLB];
    [self.bgView addSubview:self.timeLB];
    [self.bgView addSubview:self.gotIV];
    [self.bgView addSubview:self.confirmBTN];
    [self.bgView sendSubviewToBack:self.bgIV];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_equalTo(-kRealWidth(12));
    }];

    [self.gotIV sizeToFit];
    [self.gotIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.model.showStockOut) {
            make.right.bottom.mas_equalTo(-kRealWidth(1));
        } else {
            make.right.mas_equalTo(-kRealWidth(8));
            make.top.mas_equalTo(kRealWidth(6));
        }
        make.size.mas_equalTo(self.gotIV.image.size);
    }];

    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(14));
        make.top.mas_equalTo(kRealWidth(16));
        make.right.equalTo(self.confirmBTN.mas_left).offset(-kRealWidth(24));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(8));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.detailLB.mas_bottom).offset(kRealWidth(6));
        make.bottom.mas_equalTo(-kRealWidth(16));
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(28));
        make.centerY.mas_equalTo(0);
    }];

    [self.confirmBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.confirmBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.detailLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [self.detailLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];

    [super updateConstraints];
}

- (void)setGNCellModel:(GNCellModel *)data {
    self.rspModel = data;
}

- (void)setGNModel:(WMStoreCouponDetailModel *)data {
    self.model = data;

    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *money = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@", data.faceValueStr]];
    money.yy_color = HDAppTheme.WMColor.mainRed;
    money.yy_font = [HDAppTheme.WMFont wm_ForMoneyDinSize:32];
    [money addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14]} range:[money.string rangeOfString:@"$"]];
    [titleStr appendAttributedString:money];

    NSString *lableStr = @"";
    if (data.threshold.doubleValue == 0) {
        lableStr = SALocalizedString(@"no_threshold", @"无门槛");
    } else {
        lableStr = [NSString stringWithFormat:SALocalizedString(@"coupon_threshold", @"满%@可用"), WMFillMonEmpty(data.threshold)];
    }

    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                      attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                                                           alignment:YYTextVerticalAlignmentCenter];

    [titleStr appendAttributedString:spaceText];

    NSMutableAttributedString *mLabs = [[NSMutableAttributedString alloc] initWithString:lableStr];
    mLabs.yy_color = HDAppTheme.WMColor.B6;
    mLabs.yy_font = [HDAppTheme.WMFont wm_ForSize:11];
    [titleStr appendAttributedString:mLabs];
    self.titleLB.attributedText = titleStr;

    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] initWithString:WMFillEmpty(data.title)];
    detailStr.yy_font = [HDAppTheme.WMFont wm_boldForSize:14];
    detailStr.yy_color = HDAppTheme.WMColor.B3;
    detailStr.yy_lineSpacing = kRealWidth(4);
    self.detailLB.attributedText = detailStr;
    if ([data.effectiveType.code isEqualToString:@(WMStoreCouponEffectiveFixedDate).stringValue]) {
        self.timeLB.text = [NSString stringWithFormat:@"%@：%@ - %@", WMLocalizedString(@"valid_time", @"有效期"), data.effectDate, data.expireDate];
    } else if ([data.effectiveType.code isEqualToString:@(WMStoreCouponEffectiveFixedDuration).stringValue]) {
        self.timeLB.text = [NSString
            stringWithFormat:@"%@：%@", WMLocalizedString(@"valid_time", @"有效期"), [NSString stringWithFormat:WMLocalizedString(@"wm_valid_after_day", @"领取后%ld天后有效"), data.afterExpire]];
    }
    NSString *btnTitle = @"";
    self.confirmBTN.layer.cornerRadius = kRealWidth(14);
    self.confirmBTN.hidden = NO;
    self.confirmBTN.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
    self.bgIV.image = [UIImage imageNamed:@"yn_coupon_bg"];
    self.gotIV.hidden = YES;
    self.model.showStockOut = NO;
    self.titleLB.alpha = self.detailLB.alpha = self.timeLB.alpha = 1;
    if ((data.isReceived && (data.isStockOut || data.isOver)) || data.showUse) {
        btnTitle = WMLocalizedString(@"wm_coupon_go_use", @"去使用");
        self.gotIV.hidden = NO;
        self.gotIV.image = [UIImage imageNamed:@"yn_coupon_got"];
        self.confirmBTN.layer.borderWidth = 1;
        self.confirmBTN.layer.backgroundColor = UIColor.whiteColor.CGColor;
        [self.confirmBTN setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
    } else {
        if (!data.isStockOut) {
            btnTitle = WMLocalizedString(@"wm_coupon_give", @"领取");
            self.confirmBTN.layer.borderWidth = 0;
            self.confirmBTN.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
            [self.confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        } else {
            btnTitle = WMLocalizedString(@"wm_out_of", @"已抢光");
            self.titleLB.alpha = self.detailLB.alpha = self.timeLB.alpha = 0.4;
            self.gotIV.hidden = NO;
            self.model.showStockOut = YES;
            self.bgIV.image = [UIImage imageNamed:@"yn_coupon_bg_disable"];
            self.confirmBTN.hidden = YES;
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
                self.gotIV.image = [UIImage imageNamed:@"yn_coupon_outof_zh"];
            } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeEN]) {
                self.gotIV.image = [UIImage imageNamed:@"yn_coupon_outof_en"];
            } else {
                self.gotIV.image = [UIImage imageNamed:@"yn_coupon_outof_km"];
            }
        }
    }
    [self.confirmBTN setTitle:btnTitle forState:UIControlStateNormal];
    [self setNeedsUpdateConstraints];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.image = [UIImage imageNamed:@"yn_coupon_bg"];
        _bgIV.clipsToBounds = YES;
    }
    return _bgIV;
}

- (YYLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = YYLabel.new;
    }
    return _titleLB;
}

- (YYLabel *)detailLB {
    if (!_detailLB) {
        _detailLB = YYLabel.new;
        _detailLB.numberOfLines = 2;
        _detailLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(130);
    }
    return _detailLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        _timeLB = HDLabel.new;
        _timeLB.textColor = HDAppTheme.WMColor.B9;
        _timeLB.font = [HDAppTheme.WMFont wm_ForSize:11];
    }
    return _timeLB;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _confirmBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:14];
        _confirmBTN.titleEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
        @HDWeakify(self)[_confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"giveCouponAction" indexPath:self.rspModel.indexPath info:@{@"data": self.model}];
        }];
    }
    return _confirmBTN;
}

- (UIImageView *)gotIV {
    if (!_gotIV) {
        _gotIV = UIImageView.new;
        _gotIV.image = [UIImage imageNamed:@"yn_coupon_got"];
    }
    return _gotIV;
}

@end


@interface WMCouponsTitleTableViewCell ()
/// title
@property (nonatomic, strong) HDLabel *titleLB;

@end


@implementation WMCouponsTitleTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.titleLB.text = data.title;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.model.outInsets.left);
        make.right.mas_equalTo(-self.model.outInsets.right);
        make.top.mas_equalTo(self.model.outInsets.top);
        make.bottom.mas_equalTo(-self.model.outInsets.bottom);
        if (!HDIsStringEmpty(self.titleLB.text)) {
            make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        }
    }];
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.textColor = HDAppTheme.WMColor.B3;
        _titleLB.numberOfLines = 0;
        _titleLB.font = [HDAppTheme.WMFont wm_boldForSize:16];
    }
    return _titleLB;
}

@end
