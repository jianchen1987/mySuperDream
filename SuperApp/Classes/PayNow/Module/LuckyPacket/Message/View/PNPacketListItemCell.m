//
//  PNPacketListItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketListItemCell.h"
#import "PNPacketMessageListItemModel.h"


@interface PNPacketListItemCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *contentLabel;
@property (nonatomic, strong) SALabel *timeLabel;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNPacketListItemCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.statusLabel];
    [self.bgView addSubview:self.line];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
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

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(16));
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(kRealWidth(12));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.timeLabel);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(kRealWidth(4));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(-1);
    }];

    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPacketMessageListItemModel *)model {
    _model = model;

    self.contentLabel.text = model.senderName;
    self.timeLabel.text = [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.floatValue / 1000]];
    self.statusLabel.text = [PNCommonUtils packetStatusName:model.messageStatus];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_packet_cover_samll"];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"pn_red_packet_title", @"红包");
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

- (SALabel *)timeLabel {
    if (!_timeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textAlignment = NSTextAlignmentRight;
        _timeLabel = label;
    }
    return _timeLabel;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textAlignment = NSTextAlignmentRight;
        _statusLabel = label;
    }
    return _statusLabel;
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
