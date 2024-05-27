//
//  PNWalletOrderListCell.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletOrderListCell.h"


@interface PNWalletOrderListCell ()
@property (nonatomic, strong) SALabel *nameLB;
@property (nonatomic, strong) SALabel *timeLB;
@property (nonatomic, strong) SALabel *amountLB;
@property (nonatomic, strong) SALabel *stateLB;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isLastCell;
@end


@implementation PNWalletOrderListCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.amountLB];
    [self.contentView addSubview:self.stateLB];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.right.equalTo(self.amountLB.mas_left).offset(-kRealWidth(5));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(6));
        make.left.equalTo(self.nameLB.mas_left);
    }];

    [self.amountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.nameLB);
    }];

    [self.stateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLB);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.left.equalTo(self.timeLB.mas_right).offset(kRealWidth(15));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLB.mas_bottom).offset(kRealWidth(15));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom);

        if (self.isLastCell) {
            make.height.mas_equalTo(0);
        } else {
            make.height.mas_equalTo(PixelOne);
        }
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNWalletListItemModel *)model {
    _model = model;

    self.nameLB.text = model.title;
    self.timeLB.text = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.doubleValue / 1000]];

    self.amountLB.text = [NSString stringWithFormat:@"%@%@", model.debitCreditFlag ?: @"", model.orderAmt.thousandSeparatorAmount];

    if ([_model.debitCreditFlag isEqualToString:@"+"]) {
        self.amountLB.textColor = [UIColor hd_colorWithHexString:@"#FD7127"];
    } else {
        self.amountLB.textColor = HDAppTheme.PayNowColor.c333333;
    }

    self.stateLB.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"Balance", @"余额"), model.balance.thousandSeparatorAmount];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _nameLB = label;
    }
    return _nameLB;
}
- (SALabel *)timeLB {
    if (!_timeLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textColor = [UIColor hd_colorWithHexString:@"#858994"];
        _timeLB = label;
    }
    return _timeLB;
}
- (SALabel *)amountLB {
    if (!_amountLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.PayNowFont fontDINBold:16];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.textAlignment = NSTextAlignmentRight;
        _amountLB = label;
    }
    return _amountLB;
}
- (SALabel *)stateLB {
    if (!_stateLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.textAlignment = NSTextAlignmentRight;
        _stateLB = label;
    }
    return _stateLB;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _lineView;
}

@end
