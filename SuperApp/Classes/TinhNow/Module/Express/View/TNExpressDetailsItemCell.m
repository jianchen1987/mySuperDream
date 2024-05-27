//
//  TNExpressDetailsItemCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressDetailsItemCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAGeneralUtil.h"


@interface TNExpressDetailsItemCell ()
/// 物流状态
@property (strong, nonatomic) UILabel *statusLabel;
///
@property (nonatomic, strong) UILabel *eventNameLabel;
///
@property (nonatomic, strong) UILabel *eventTimeLabel;

///
@property (nonatomic, strong) UIView *upLine;
///
@property (nonatomic, strong) UIView *downLine;
/// 圆点
@property (nonatomic, strong) UIView *circleView;
@end


@implementation TNExpressDetailsItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.eventNameLabel];
    [self.contentView addSubview:self.eventTimeLabel];
    [self.contentView addSubview:self.upLine];
    [self.contentView addSubview:self.downLine];
    [self.contentView addSubview:self.circleView];
}

- (void)updateConstraints {
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.isFirst) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10.f);
        } else {
            make.top.mas_equalTo(self.contentView.mas_top);
        }

        make.left.mas_equalTo(self.circleView.mas_right).offset(10.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
    }];

    [self.eventNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(10.f);
        make.leading.equalTo(self.statusLabel.mas_leading);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
    }];

    [self.eventTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.eventNameLabel.mas_bottom).offset(10.f);
        make.leading.equalTo(self.statusLabel.mas_leading);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20.f);
    }];

    [self.upLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleView.mas_centerX);
        make.width.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.circleView.mas_top);
    }];

    [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.width.height.equalTo(@(10.f));
        make.centerY.mas_equalTo(self.statusLabel.mas_centerY);
    }];

    [self.downLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_bottom);
        make.centerX.mas_equalTo(self.circleView.mas_centerX);
        make.width.equalTo(@(PixelOne));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setEventInfoModel:(TNExpressEventInfoModel *)eventInfoModel {
    _eventInfoModel = eventInfoModel;
    self.statusLabel.text = eventInfoModel.status;
    self.eventNameLabel.text = _eventInfoModel.eventDesc;
    NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:[_eventInfoModel.eventTime doubleValue] / 1000.0];
    self.eventTimeLabel.text = [SAGeneralUtil getDateStrWithDate:eventTime format:@"dd/MM/yyyy HH:mm:ss"];
    self.upLine.hidden = self.isFirst ? YES : NO;
    self.downLine.hidden = self.isLast ? YES : NO;
    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _statusLabel.numberOfLines = 0;
        _statusLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
    }
    return _statusLabel;
}
- (UILabel *)eventNameLabel {
    if (!_eventNameLabel) {
        _eventNameLabel = [[UILabel alloc] init];
        _eventNameLabel.textColor = HexColor(0xA4A9B7);
        _eventNameLabel.numberOfLines = 0;
        _eventNameLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
    }
    return _eventNameLabel;
}

- (UILabel *)eventTimeLabel {
    if (!_eventTimeLabel) {
        _eventTimeLabel = [[UILabel alloc] init];
        _eventTimeLabel.textColor = HexColor(0xAAAAAA);
        _eventTimeLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
    }
    return _eventTimeLabel;
}

- (UIView *)upLine {
    if (!_upLine) {
        _upLine = [[UIView alloc] init];
        _upLine.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _upLine;
}

- (UIView *)downLine {
    if (!_downLine) {
        _downLine = [[UIView alloc] init];
        _downLine.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _downLine;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
        _circleView.layer.cornerRadius = 5.f;
    }
    return _circleView;
}

#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
