//
//  PNInterTransferRecordCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRecordCell.h"
#import "PNCommonUtils.h"


@interface PNInterTransferRecordCell ()
@property (nonatomic, strong) UIImageView *iconLogoImgView;
/// 名字
@property (strong, nonatomic) UILabel *nameLabel;
/// 时间
@property (strong, nonatomic) UILabel *timeLabel;
/// 金额
@property (strong, nonatomic) UILabel *amountLabel;
/// 状态
@property (strong, nonatomic) UILabel *statusLabel;
///
@property (strong, nonatomic) UIView *lineView;
@end


@implementation PNInterTransferRecordCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconLogoImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)setModel:(PNInterTransRecordModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:self.model.logoPath placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(25), kRealWidth(25))] imageView:self.iconLogoImgView];

    self.nameLabel.text = [NSString stringWithFormat:@"%@-%@", PNLocalizedString(@"unSuGzr5", @"国际转账"), model.fullName];
    self.timeLabel.text = [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.floatValue / 1000]];
    self.amountLabel.text = [NSString stringWithFormat:@"%@%@", HDIsStringNotEmpty(model.sign) ? model.sign : @"", model.totalPayoutAmount.thousandSeparatorAmount];
    self.statusLabel.text = [PNCommonUtils getInterTransferOrderStatus:model.status];
    if (model.status == PNInterTransferOrderStatusFinish) {
        //成功
        self.amountLabel.textColor = HexColor(0x9ED24B);
        self.statusLabel.textColor = HexColor(0x9ED24B);
    } else if (model.status == PNInterTransferOrderStatusCancel) {
        //取消
        self.amountLabel.textColor = HDAppTheme.PayNowColor.cCCCCCC;
        self.statusLabel.textColor = HDAppTheme.PayNowColor.cCCCCCC;
    } else if (model.status == PNInterTransferOrderStatusFaild || model.status == PNInterTransferOrderStatusRejuect || model.status == PNInterTransferOrderStatusABNORMAL) {
        //失败
        self.amountLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.statusLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
    } else {
        self.amountLabel.textColor = HDAppTheme.PayNowColor.c333333;
        self.statusLabel.textColor = HDAppTheme.PayNowColor.c333333;
    }
}

- (void)updateConstraints {
    [self.iconLogoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(@(CGSizeMake(kRealWidth(25), kRealWidth(25))));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(17));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(17));
        make.left.equalTo(self.iconLogoImgView.mas_right).offset(kRealWidth(12));
        make.right.lessThanOrEqualTo(self.amountLabel.mas_left).offset(-kRealWidth(10));
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(5));
        make.leading.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(self.statusLabel.mas_left).offset(-kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(17));
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.trailing.equalTo(self.amountLabel);
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.height.mas_equalTo(0.5);
    }];

    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

#pragma mark
- (UIImageView *)iconLogoImgView {
    if (!_iconLogoImgView) {
        _iconLogoImgView = [[UIImageView alloc] init];
    }
    return _iconLogoImgView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [HDAppTheme.PayNowFont fontMedium:14];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _nameLabel = label;
    }
    return _nameLabel;
}
/** @lazy timeLabel */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [HDAppTheme.PayNowFont fontRegular:12];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        _timeLabel = label;
    }
    return _timeLabel;
}
/** @lazy amountLabel */
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [HDAppTheme.PayNowFont fontRegular:17];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _amountLabel = label;
    }
    return _amountLabel;
}
/** @lazy statusLabel */
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [HDAppTheme.PayNowFont fontRegular:12];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _statusLabel = label;
    }
    return _statusLabel;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _lineView;
}
@end
