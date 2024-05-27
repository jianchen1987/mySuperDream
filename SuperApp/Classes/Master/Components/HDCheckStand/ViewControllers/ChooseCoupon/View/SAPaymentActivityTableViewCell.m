//
//  SAPaymentActivityTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/5/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPaymentActivityTableViewCell.h"
#import "SAPaymentActivityModel.h"


@interface SAPaymentActivityTableViewCell ()

///< title
@property (nonatomic, strong) SALabel *titleLabel;
///< subtitle
@property (nonatomic, strong) SALabel *subTitleLabel;
/// 提示文言
@property (nonatomic, strong) SALabel *tipLabel;
///< 有效期
@property (nonatomic, strong) SALabel *expiryDateLabel;
///< 活动描述
@property (nonatomic, strong) SALabel *descLabel;
///< 勾选框
@property (nonatomic, strong) UIImageView *tickIV;
///< line
@property (nonatomic, strong) UIView *line;

@end


@implementation SAPaymentActivityTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.tickIV];
    [self.contentView addSubview:self.expiryDateLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        //        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.contentView.mas_top).offset(kRealHeight(15));
    }];

    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(kRealWidth(10));
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];

    [self.tickIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
    }];

    if (!self.tipLabel.hidden) {
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealHeight(20));
        }];
    }

    [self.expiryDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        if (!self.tipLabel.hidden) {
            make.top.equalTo(self.tipLabel.mas_bottom).offset(kRealHeight(20));
        } else {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealHeight(20));
        }
    }];

    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.expiryDateLabel.mas_bottom).offset(kRealHeight(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(15));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(PixelOne);
    }];

    [super updateConstraints];
}

- (void)setModel:(SAPaymentActivityModel *)model {
    _model = model;

    self.titleLabel.text =
        [NSString stringWithFormat:SALocalizedString(@"checksd_activity_full_minus", @"满%@减%@"), model.thresholdAmt.thousandSeparatorAmount, model.discountAmt.thousandSeparatorAmount];
    self.subTitleLabel.text = model.marketingType.message;
    self.expiryDateLabel.text = [NSString stringWithFormat:@"%@:%@ - %@", SALocalizedString(@"valid_time", @"有效期"), model.effectiveDate, model.expireDate];
    self.descLabel.text = model.title;

    self.tipLabel.hidden = YES;
    if (model.fulfill == HDPaymentActivityStateUnavailable) {
        // 不满足
        self.tickIV.image = [UIImage imageNamed:@"chckstand_disable"];

        self.titleLabel.textColor = HDAppTheme.color.G3;
        self.subTitleLabel.backgroundColor = HDAppTheme.color.G3;
        self.expiryDateLabel.textColor = HDAppTheme.color.G3;
        self.descLabel.textColor = HDAppTheme.color.G3;
        self.tipLabel.hidden = NO;

        if (HDIsStringNotEmpty(model.unavailableReason)) {
            //        NSString *text = [NSString stringWithFormat:@"%@:%@",SALocalizedString(@"coupon_match_DiscountNotAllowed", @"优惠不可用"),SALocalizedString(@"coupon_match_use_tip3",
            //        @"订单金额不满足")]; NSString *text = [NSString stringWithFormat:@"%@:%@",SALocalizedString(@"coupon_match_DiscountNotAllowed", @"优惠不可用"),[NSString
            //        stringWithFormat:SALocalizedString(@"coupon_match_use_tip1", @"今日次数已用完(每日%ld次)"),5]]; NSString *text = [NSString
            //        stringWithFormat:@"%@:%@",SALocalizedString(@"coupon_match_DiscountNotAllowed", @"优惠不可用"),[NSString stringWithFormat:SALocalizedString(@"coupon_match_use_tip2",
            //        @"总次数已用完(共%ld次)"),5]];

            NSString *text = [NSString stringWithFormat:@"%@:%@", SALocalizedString(@"coupon_match_DiscountNotAllowed", @"优惠不可用"), model.unavailableReason];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.color.sa_C1}
                         range:[text rangeOfString:[NSString stringWithFormat:@"%@:", SALocalizedString(@"coupon_match_DiscountNotAllowed", @"优惠不可用")]]];

            self.tipLabel.attributedText = str;
            self.tipLabel.hidden = NO;
        }

    } else {
        if (model.selected) {
            self.tickIV.image = [UIImage imageNamed:@"chckstand_selected"];
        } else {
            self.tickIV.image = [UIImage imageNamed:@"chckstand_unselected"];
        }
        self.titleLabel.textColor = HDAppTheme.color.G1;
        self.subTitleLabel.backgroundColor = HDAppTheme.color.sa_C1;
        self.expiryDateLabel.textColor = HDAppTheme.color.G2;
        self.descLabel.textColor = HDAppTheme.color.G2;
    }

    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.model.selected = selected;
    if (self.model.fulfill == HDPaymentActivityStateAvailable) {
        self.tickIV.image = selected ? [UIImage imageNamed:@"chckstand_selected"] : [UIImage imageNamed:@"chckstand_unselected"];
    } else {
        self.tickIV.image = [UIImage imageNamed:@"chckstand_disable"];
    }
}

#pragma mark - lazy load
/** @lazy titlelabel */
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

/** @lazy subtitle */
- (SALabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[SALabel alloc] init];
        _subTitleLabel.textColor = UIColor.whiteColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _subTitleLabel.hd_edgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        _subTitleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _subTitleLabel;
}

- (SALabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[SALabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        //        _tipLabel.text = @"Cannot Be Used: Total time used up(5 times in total)";
        _tipLabel.textColor = [UIColor hd_colorWithHexString:@"#666666"];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

/** @lazy tickivSA */
- (UIImageView *)tickIV {
    if (!_tickIV) {
        _tickIV = [[UIImageView alloc] init];
    }
    return _tickIV;
}
/** @lazy expiryDateLabel */
- (SALabel *)expiryDateLabel {
    if (!_expiryDateLabel) {
        _expiryDateLabel = [[SALabel alloc] init];
        _expiryDateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _expiryDateLabel;
}

/** @lazy descLabel */
- (SALabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[SALabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

@end
