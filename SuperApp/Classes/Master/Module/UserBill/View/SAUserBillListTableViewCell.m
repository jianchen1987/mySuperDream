//
//  SAUserBillListTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillListTableViewCell.h"
#import "NSDate+SAExtension.h"
#import "SAUserBillDTO.h"


@interface SAUserBillListTableViewCell ()

///< icon
@property (nonatomic, strong) UIImageView *iconImageView;
///< title
@property (nonatomic, strong) UILabel *merchantNameLabel;
///< date
@property (nonatomic, strong) UILabel *dateLabel;
///< amount
@property (nonatomic, strong) UILabel *amountLabel;
///< status
@property (nonatomic, strong) UILabel *statusLabel;
///< bottomLine
@property (nonatomic, strong) UIView *lineView;

@end


@implementation SAUserBillListTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.merchantNameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];

    [self.merchantNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(5));
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(-3);
        make.right.lessThanOrEqualTo(self.amountLabel.mas_left).offset(-kRealWidth(5));
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(5));
        make.top.equalTo(self.iconImageView.mas_centerY).offset(3);
        make.right.lessThanOrEqualTo(self.amountLabel.mas_left).offset(-kRealWidth(5));
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.merchantNameLabel.mas_centerY);
    }];

    if (!self.statusLabel.isHidden) {
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
            make.centerY.equalTo(self.dateLabel.mas_centerY);
        }];
    }

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(PixelOne);
    }];

    [super updateConstraints];
}

- (void)setModel:(SAUserBillListModel *)model {
    _model = model;

    if ([model.businessLine isEqualToString:SAClientTypeYumNow]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_yumnow"];
    } else if ([model.businessLine isEqualToString:SAClientTypeTinhNow]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_tinhnow"];
    } else if ([model.businessLine isEqualToString:SAClientTypePhoneTopUp]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_top_up_icon"];
    } else if ([model.businessLine isEqualToString:SAClientTypeGroupBuy]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_groupbuy"];
    } else if ([model.businessLine isEqualToString:SAClientTypeBillPayment]) {
        self.iconImageView.image = [UIImage imageNamed:@"order_list_billPayment"];
    } else if ([model.businessLine isEqualToString:SAClientTypeGame]) {
        self.iconImageView.image = [UIImage imageNamed:@"message_icon_GameChannel"];
    } else if ([model.businessLine isEqualToString:SAClientTypeHotel]) {
        self.iconImageView.image = [UIImage imageNamed:@"message_icon_HotelChannel"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"business_outsize"];
    }
    if (model.billingAction.code == 2 || model.billingAction.code == 3 || model.billingAction.code == 4) {
        self.merchantNameLabel.text = [model.merchantName stringByAppendingString:SALocalizedString(@"userBillList_tail_refund", @" - 退款")];
    } else {
        self.merchantNameLabel.text = model.merchantName;
    }

    self.dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.createTime.floatValue / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm:ss"];
    if (model.billingType.code == 1) {
        // 支出
        self.amountLabel.text = [@"-" stringByAppendingString:model.amount.thousandSeparatorAmount];
        self.amountLabel.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
    } else if (model.billingType.code == 2) {
        // 收入
        self.amountLabel.text = [@"+" stringByAppendingString:model.amount.thousandSeparatorAmount];
        self.amountLabel.textColor = HDAppTheme.color.C1;
    } else {
        self.amountLabel.text = model.amount.thousandSeparatorAmount;
        self.amountLabel.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
    }

    if (model.existRefundOrder) {
        self.statusLabel.text = SALocalizedString(@"userBillList_refunded", @"已退款");
        self.statusLabel.hidden = NO;
    } else {
        self.statusLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = UIImageView.new;
        _iconImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0];
        };
    }
    return _iconImageView;
}
- (UILabel *)merchantNameLabel {
    if (!_merchantNameLabel) {
        UILabel *label = UILabel.new;
        label.font = [HDAppTheme.font boldForSize:14];
        label.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
        _merchantNameLabel = label;
    }
    return _merchantNameLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *label = UILabel.new;
        label.font = [HDAppTheme.font forSize:12];
        label.textColor = [UIColor hd_colorWithHexString:@"#858994"];
        _dateLabel = label;
    }
    return _dateLabel;
}
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        UILabel *label = UILabel.new;
        label.font = [HDAppTheme.font boldForSize:17];
        label.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
        label.textAlignment = NSTextAlignmentRight;
        _amountLabel = label;
    }
    return _amountLabel;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        UILabel *label = UILabel.new;
        label.font = [HDAppTheme.font forSize:12];
        label.textColor = HDAppTheme.color.C1;
        label.textAlignment = NSTextAlignmentRight;
        _statusLabel = label;
    }
    return _statusLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = [UIColor hd_colorWithHexString:@"#ECECEC"];
    }
    return _lineView;
}

@end
