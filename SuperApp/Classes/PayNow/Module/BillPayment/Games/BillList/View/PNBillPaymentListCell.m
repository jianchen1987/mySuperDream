//
//  PNBillPaymentListCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillPaymentListCell.h"
#import "PNBillPaymentRspModel.h"


@interface PNBillPaymentListCell ()
///
@property (strong, nonatomic) UIView *bgView;
///
@property (strong, nonatomic) UIImageView *headImageView;
///
@property (strong, nonatomic) UILabel *timeLabel;
///
@property (strong, nonatomic) UILabel *statusLabel;
///
@property (strong, nonatomic) UILabel *descLabel;
///
@property (strong, nonatomic) UILabel *priceLabel;
@end


@implementation PNBillPaymentListCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = HexColor(0xF3F4FA);
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.headImageView];
    [self.bgView addSubview:self.statusLabel];
    [self.bgView addSubview:self.descLabel];
    [self.bgView addSubview:self.priceLabel];
    [self.bgView addSubview:self.timeLabel];

    [self.priceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.descLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}
- (void)setModel:(PNBillPaymentItemModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.paymentCategoryIcon size:CGSizeMake(kRealWidth(56), kRealWidth(56)) placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_square"]
                             imageView:self.headImageView];
    self.timeLabel.text = model.orderTime;
    self.priceLabel.text = model.totalAmount.thousandSeparatorAmount;
    self.descLabel.text = model.remark;
    self.statusLabel.text = model.businessOrderState;
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(12));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(36), kRealWidth(36)));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(4));
        make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(12));
        make.right.lessThanOrEqualTo(self.statusLabel.mas_left).offset(-kRealWidth(8));
        make.height.mas_offset(kRealHeight(16));
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(12));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(4));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
    }];
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(kRealWidth(4));
        make.top.equalTo(self.timeLabel.mas_bottom).offset(kRealWidth(4));
        make.right.lessThanOrEqualTo(self.priceLabel.mas_left).offset(-kRealWidth(8));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-kRealWidth(12));
    }];

    [super updateConstraints];
}
/** @lazy headImageView */
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}
/** @lazy statusLabel */
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textColor = HexColor(0x005BFF);
        _statusLabel = label;
    }
    return _statusLabel;
}
/** @lazy descLabel */
- (UILabel *)descLabel {
    if (!_descLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.numberOfLines = 0;
        _descLabel = label;
    }
    return _descLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [HDAppTheme.PayNowFont fontSemibold:14];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _priceLabel = label;
    }
    return _priceLabel;
}
/** @lazy timeLabel */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textColor = HDAppTheme.PayNowColor.c999999;
        _timeLabel = label;
    }
    return _timeLabel;
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _bgView;
}
@end
