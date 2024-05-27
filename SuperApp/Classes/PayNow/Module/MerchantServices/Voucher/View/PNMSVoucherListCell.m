//
//  PNMSVoucherListCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherListCell.h"
#import "PNCommonUtils.h"
#import "PNMSVoucherInfoModel.h"


@interface PNMSVoucherListCell ()
@property (nonatomic, strong) SALabel *timeLabel;
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNMSVoucherListCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(8));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(16));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(kRealWidth(4));
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.right.mas_equalTo(self.timeLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(16));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(PixelOne));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(1));
    }];

    [super updateConstraints];
}

- (void)setModel:(PNMSVoucherInfoModel *)model {
    _model = model;

    self.timeLabel.text = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm:ss" withDate:[NSDate dateWithTimeIntervalSince1970:self.model.createDate.doubleValue / 1000]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.surname, self.model.name];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)timeLabel {
    if (!_timeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        _timeLabel = label;
    }
    return _timeLabel;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_icon_black_arrow"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line;
}

@end
