//
//  PNPacketRecordsListItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordsListItemCell.h"
#import "PNPacketMessageListItemModel.h"


@interface PNPacketRecordsListItemCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *contentLabel;
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) UIView *line;

@end


@implementation PNPacketRecordsListItemCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.amountLabel];
    [self.bgView addSubview:self.statusLabel];
    [self.bgView addSubview:self.line];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
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

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountLabel);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(kRealWidth(4));
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
- (void)setModel:(PNPacketRecordListItemModel *)model {
    _model = model;

    if ([self.viewType isEqualToString:@"reciver"]) {
        [HDWebImageManager setImageWithURL:self.model.sendHeadUrl placeholderImage:[UIImage imageNamed:@"pn_default_user_neutral"] imageView:self.iconImgView];

        NSString *timeStr = [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTimel.floatValue / 1000]];
        self.contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@", PNLocalizedString(@"pn_from", @"来自"), self.model.senderName, timeStr];

        self.statusLabel.text = [PNCommonUtils packetStatusName:PNPacketMessageStatus_PARTIAL_RECEIVE];
    } else {
        [HDWebImageManager setImageWithURL:self.model.imageUrl placeholderImage:[UIImage imageNamed:@"pn_packet_cover_samll"] imageView:self.iconImgView];

        NSString *timeStr = [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTimel.floatValue / 1000]];

        self.contentLabel.text = [[NSString stringWithFormat:PNLocalizedString(@"pn_number_red_packet", @"包%zd个红包"), self.model.qty] stringByAppendingFormat:@" %@", timeStr];
        self.statusLabel.text = [PNCommonUtils packetReceiveStatusName:model.status];
    }

    NSString *str = self.model.packetType == PNPacketType_Nor ? PNLocalizedString(@"pn_Normal_packet", @"普通红包") : PNLocalizedString(@"pn_lucky_packet", @"口令红包");
    self.titleLabel.text = str;

    self.amountLabel.text = [PNCommonUtils thousandSeparatorAmount:self.model.amt currencyCode:self.model.cy];

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
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.numberOfLines = 1;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.textAlignment = NSTextAlignmentRight;
        _amountLabel = label;
    }
    return _amountLabel;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
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
