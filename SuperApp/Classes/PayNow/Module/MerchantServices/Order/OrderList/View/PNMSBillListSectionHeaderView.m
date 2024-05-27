//
//  PNMSBillListSectionHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBillListSectionHeaderView.h"
#import "PNMSBillListCountView.h"
#import "PNMSBillListGroupModel.h"
#import "PNMSGroupItemView.h"
#import "SALabel.h"
#import <Masonry.h>


@interface PNMSBillListSectionHeaderView ()
@property (nonatomic, strong) SALabel *dateTimeLabel;
@property (nonatomic, strong) PNMSGroupItemView *inItemView;
@property (nonatomic, strong) PNMSGroupItemView *outItemView;
@property (nonatomic, strong) PNMSBillListCountView *countView;
@end


@implementation PNMSBillListSectionHeaderView

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.dateTimeLabel];
    [self.contentView addSubview:self.inItemView];
    [self.contentView addSubview:self.outItemView];
    [self.contentView addSubview:self.countView];
}

- (void)updateConstraints {
    [self.dateTimeLabel sizeToFit];
    [self.dateTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(12));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(@(self.dateTimeLabel.hd_width + 48));
        make.height.mas_equalTo(kRealWidth(26));
    }];

    [self.inItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateTimeLabel.mas_bottom).offset(kRealWidth(12));
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
    }];

    [self.outItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inItemView.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.bottom.equalTo(self.inItemView);
    }];

    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.top.mas_equalTo(self.inItemView.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setModel:(PNMSBillListGroupModel *)model {
    _model = model;

    self.dateTimeLabel.text = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:_model.dayTime.floatValue / 1000.0]];

    [self.inItemView setTitle:PNLocalizedString(@"pn_Income", @"收入") usdAmount:model.inUsdAmt khrAmount:model.inKhrAmt];
    [self.outItemView setTitle:PNLocalizedString(@"pn_Expenditures", @"支出") usdAmount:model.outUsdAmt khrAmount:model.outKhrAmt];

    [self.countView setUsdTimes:model.usdNum khrTimes:model.khrNum];
}

#pragma mark
- (SALabel *)dateTimeLabel {
    if (!_dateTimeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.layer.cornerRadius = kRealWidth(15);
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        _dateTimeLabel = label;
    }
    return _dateTimeLabel;
}

- (PNMSGroupItemView *)inItemView {
    if (!_inItemView) {
        _inItemView = [[PNMSGroupItemView alloc] init];
    }
    return _inItemView;
}

- (PNMSGroupItemView *)outItemView {
    if (!_outItemView) {
        _outItemView = [[PNMSGroupItemView alloc] init];
    }
    return _outItemView;
}

- (PNMSBillListCountView *)countView {
    if (!_countView) {
        _countView = [[PNMSBillListCountView alloc] init];
        _countView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    }
    return _countView;
}
@end
