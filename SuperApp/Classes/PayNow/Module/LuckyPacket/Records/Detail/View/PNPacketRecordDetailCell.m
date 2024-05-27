//
//  PNPacketRecordDetailCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordDetailCell.h"


@interface PNPacketRecordDetailCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *contentLabel;
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNPacketRecordDetailCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.amountLabel];
    [self.bgView addSubview:self.line];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.bottom.mas_equalTo(self.contentView);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(34), kRealWidth(34)));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(16));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(4));
        make.top.mas_equalTo(self.iconImgView.mas_top).offset(kRealWidth(5));
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(4));
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(16));
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(kRealWidth(12));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(-1);
    }];

    [self.amountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPacketDetailListItemModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:self.model.hearUrl placeholderImage:[UIImage imageNamed:@"pn_default_user_neutral"] imageView:self.iconImgView];

    self.titleLabel.text = self.model.recevierName;
    self.contentLabel.text = [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTimel.floatValue / 1000]];
    self.amountLabel.text = [PNCommonUtils thousandSeparatorAmount:_model.currentAmt currencyCode:PNCurrencyTypeKHR];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bgView = view;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _iconImgView = imageView;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;

        _iconImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
        };
    }
    return _iconImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"pn_red_packet_title", @"CoolCash 红包");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 1;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINMedium:18];
        label.textAlignment = NSTextAlignmentRight;
        _amountLabel = label;
    }
    return _amountLabel;
}

- (UIView *)line {
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _line = view;
    }
    return _line;
}
@end
