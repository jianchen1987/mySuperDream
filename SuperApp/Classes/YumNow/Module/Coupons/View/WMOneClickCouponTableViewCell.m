//
//  WMOneClickCouponTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOneClickCouponTableViewCell.h"
#import "GNMultiLanguageManager.h"


@interface WMOneClickCouponTableViewCell ()
/// bg
@property (nonatomic, strong) UIImageView *bgIV;
/// leftView
@property (nonatomic, strong) UIView *leftView;
/// money
@property (nonatomic, strong) HDLabel *moneyLB;
/// title
@property (nonatomic, strong) HDLabel *titleLB;
/// detail
@property (nonatomic, strong) HDLabel *detailLB;
/// time
@property (nonatomic, strong) HDLabel *timeLB;
///已领完
@property (nonatomic, strong) HDLabel *overLB;

@end


@implementation WMOneClickCouponTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgIV];
    [self.contentView addSubview:self.leftView];
    [self.leftView addSubview:self.moneyLB];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.detailLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.overLB];
    [self.contentView sendSubviewToBack:self.bgIV];
}

- (void)updateConstraints {
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kRealWidth(8));
        make.height.mas_equalTo(kRealWidth(74));
    }];

    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.equalTo(self.bgIV);
    }];

    [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(kRealWidth(73));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(24));
        make.right.mas_equalTo(-kRealWidth(16));
        make.left.equalTo(self.leftView.mas_right).offset(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(8));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(1));
        make.left.right.equalTo(self.titleLB);
        make.height.mas_equalTo(kRealWidth(16));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLB.mas_bottom).offset(kRealWidth(1));
        make.left.right.equalTo(self.titleLB);
        make.height.mas_equalTo(kRealWidth(16));
    }];
    [self.overLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.overLB.isHidden) {
            make.right.centerY.equalTo(self.bgIV);
        }
    }];

    [self.moneyLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moneyLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setGNModel:(WMStoreCouponDetailModel *)data {
    if ([data isKindOfClass:WMStoreCouponDetailModel.class]) {
        self.overLB.hidden = YES;
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *money = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@", data.faceValueStr]];
        money.yy_color = HDAppTheme.WMColor.mainRed;
        if (HDIsStringNotEmpty(data.faceValueStr) && data.faceValueStr.length > 4) {
            money.yy_font = [HDAppTheme.WMFont wm_ForMoneyDinSize:20];
        } else {
            money.yy_font = [HDAppTheme.WMFont wm_ForMoneyDinSize:32];
        }
        [money addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14]} range:[money.string rangeOfString:@"$"]];
        [titleStr appendAttributedString:money];
        self.moneyLB.attributedText = titleStr;
        NSString *lableStr = @"";
        if (data.threshold.doubleValue == 0) {
            lableStr = SALocalizedString(@"no_threshold", @"无门槛");
        } else {
            lableStr = [NSString stringWithFormat:SALocalizedString(@"coupon_threshold", @"满%@可用"), WMFillMonEmpty(data.threshold)];
        }
        NSMutableAttributedString *mLabs = [[NSMutableAttributedString alloc] initWithString:lableStr];
        mLabs.yy_color = HDAppTheme.WMColor.B6;
        mLabs.yy_font = [HDAppTheme.WMFont wm_ForSize:11];
        [titleStr appendAttributedString:mLabs];
        self.detailLB.attributedText = mLabs;

        if ([data.effectiveType.code isEqualToString:@(WMStoreCouponEffectiveFixedDate).stringValue]) {
            self.timeLB.text = [NSString stringWithFormat:@"%@: %@ - %@", WMLocalizedString(@"valid_time", @"有效期"), data.effectDate, data.expireDate];
        } else if ([data.effectiveType.code isEqualToString:@(WMStoreCouponEffectiveFixedDuration).stringValue]) {
            self.timeLB.text = [NSString
                stringWithFormat:@"%@: %@", WMLocalizedString(@"valid_time", @"有效期"), [NSString stringWithFormat:WMLocalizedString(@"wm_valid_after_day", @"领取后%ld天后有效"), data.afterExpire]];
        }
        self.contentView.backgroundColor = HexColor(0xFFF3E8);

        if ([data isKindOfClass:GNCouponDetailModel.class]) {
            GNCouponDetailModel *temp = (id)data;
            self.titleLB.text = WMFillEmpty(temp.couponName);
            for (UIView *view in self.contentView.subviews) {
                view.alpha = 1;
            }
            if (temp.remainNum == 0 && !temp.finish) {
                self.overLB.hidden = NO;
                for (UIView *view in self.contentView.subviews) {
                    if (view != self.overLB && view != self.bgIV) {
                        view.alpha = 0.5;
                    }
                }
            }
        } else {
            self.titleLB.text = WMFillEmpty(data.title);
        }
    }
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = UIView.new;
        _leftView.clipsToBounds = YES;
    }
    return _leftView;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _titleLB = label;
    }
    return _titleLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B6;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        _detailLB = label;
    }
    return _detailLB;
}

- (HDLabel *)moneyLB {
    if (!_moneyLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.textAlignment = NSTextAlignmentCenter;
        _moneyLB = label;
    }
    return _moneyLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B6;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        _timeLB = label;
    }
    return _timeLB;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.image = [UIImage imageNamed:@"yn_coupon_oneclick_cell_bg"];
    }
    return _bgIV;
}

- (HDLabel *)overLB {
    if (!_overLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = UIColor.whiteColor;
        label.text = GNLocalizedString(@"gn_finished", @"已领完");
        label.layer.backgroundColor = HexColor(0xCCCCCC).CGColor;
        label.font = [HDAppTheme.WMFont wm_boldForSize:14];
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(4), kRealWidth(12));
        label.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(kRealWidth(8), kRealWidth(8))];
        };
        _overLB = label;
    }
    return _overLB;
}
@end
