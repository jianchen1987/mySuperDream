//
//  SAOrderListWaitPayView.m
//  SuperApp
//
//  Created by Tia on 2023/2/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderListWaitPayView.h"


@implementation SAOrderListWaitPayView

- (void)hd_setupViews {
    self.backgroundColor = [HDAppTheme.color.sa_C1 colorWithAlphaComponent:0.1];

    [self addSubview:self.stateLabel];
    [self addSubview:self.timeLabel];
    [self updateConstraints];
}

- (void)updateConstraints {
    //    [self.stateLabel sizeToFit];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        //        make.width.mas_equalTo(self.stateLabel.width);
    }];

    //    [self.timeLabel sizeToFit];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.top.bottom.equalTo(self);
        make.left.greaterThanOrEqualTo(self.stateLabel.mas_right).offset(8);
        //        make.width.mas_equalTo(self.timeLabel.width);
    }];

    [super updateConstraints];
}

- (void)hd_languageDidChanged {
    self.stateLabel.text = SALocalizedString(@"oc_pending_payment", @"待付款");
}

#pragma mark - lazy load

- (SALabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = SALabel.new;
        _stateLabel.font = HDAppTheme.font.sa_standard11;
        _stateLabel.textColor = UIColor.whiteColor;
        _stateLabel.backgroundColor = HDAppTheme.color.sa_C1;
        _stateLabel.hd_edgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        _stateLabel.text = SALocalizedString(@"oc_pending_payment", @"待付款");
        _stateLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomRight radius:view.frame.size.height / 2];
        };
    }
    return _stateLabel;
}

- (SALabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = SALabel.new;
        _timeLabel.font = HDAppTheme.font.sa_standard11;
        _timeLabel.textColor = HDAppTheme.color.sa_C1;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
