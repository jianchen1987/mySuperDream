//
//  PNGuaranteeListCell.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/5.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuaranteeListCell.h"
#import "SAMoneyModel.h"


@interface PNGuaranteeListCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *buyerLabel;
@property (nonatomic, strong) SALabel *salerLabel;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SALabel *timeLabel;
@end


@implementation PNGuaranteeListCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.buyerLabel];
    [self.bgView addSubview:self.salerLabel];
    [self.bgView addSubview:self.statusLabel];
    [self.bgView addSubview:self.amountLabel];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.timeLabel];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.buyerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(20));
        make.right.mas_equalTo(self.statusLabel.mas_left).offset(kRealWidth(-12));
    }];

    [self.salerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buyerLabel);
        make.top.mas_equalTo(self.buyerLabel.mas_bottom).offset(kRealWidth(8));
        make.right.mas_equalTo(self.amountLabel.mas_left).offset(-kRealWidth(12));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.buyerLabel.mas_centerY);
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.salerLabel.mas_centerY);
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.salerLabel.mas_bottom).offset(kRealWidth(17));
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(kRealWidth(7));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(20));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
    }];

    [self.amountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setModel:(PNGuaranteeListItemModel *)model {
    _model = model;

    if (self.model.originator.code.integerValue == 11) { ///我是卖方
        self.salerLabel.text = [NSString stringWithFormat:@"%@:%@", PNLocalizedString(@"X8wkuMw2", @"卖方"), self.model.userName ?: @""];
        self.buyerLabel.text = [NSString stringWithFormat:@"%@:%@", PNLocalizedString(@"EdX024QJ", @"买方"), self.model.traderName ?: @""];
    } else {
        ///我是买方
        self.buyerLabel.text = [NSString stringWithFormat:@"%@:%@", PNLocalizedString(@"X8wkuMw2", @"卖方"), self.model.traderName ?: @""];
        self.salerLabel.text = [NSString stringWithFormat:@"%@:%@", PNLocalizedString(@"EdX024QJ", @"买方"), self.model.userName ?: @""];
    }

    self.timeLabel.text = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.doubleValue / 1000]];
    self.statusLabel.text = self.model.status.message;

    SAMoneyModel *moneyModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%f", self.model.amt.doubleValue * 100] currency:self.model.cy];
    self.amountLabel.text = [moneyModel thousandSeparatorAmount];

    NSInteger status = self.model.status.code.integerValue;
    if (status == PNGuarateenStatus_UNCONFIRMED) { /// 待确认
        self.statusLabel.textColor = [UIColor hd_colorWithHexString:@"#FF9F0A"];
    } else if (status == PNGuarateenStatus_COMPLETED) { /// 已完成
        self.statusLabel.textColor = [UIColor hd_colorWithHexString:@"#32D74B"];
    } else if (status == PNGuarateenStatus_CANCELED) { /// 已取消
        self.statusLabel.textColor = [UIColor hd_colorWithHexString:@"#BABABA"];
    } else if (status == PNGuarateenStatus_REFUND_APPLY || status == PNGuarateenStatus_REFUND_APPEAL) { /// 买方申请退款 / 买方申诉
        self.statusLabel.textColor = [UIColor hd_colorWithHexString:@"#0A84FF"];
    } else if (status == PNGuarateenStatus_REFUND_REJECT || status == PNGuarateenStatus_APPEAL_REJECT) { /// 卖方拒绝退款 / 申诉被驳回
        self.statusLabel.textColor = [UIColor hd_colorWithHexString:@"#E9605B"];
    } else { /// 已退款 / 其他
        self.statusLabel.textColor = HDAppTheme.PayNowColor.c333333;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        _bgView = view;
    }
    return _bgView;
}
- (SALabel *)buyerLabel {
    if (!_buyerLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = [NSString stringWithFormat:@"%@:%@", PNLocalizedString(@"EdX024QJ", @"买方"), @""];
        _buyerLabel = label;
    }
    return _buyerLabel;
}

- (SALabel *)salerLabel {
    if (!_salerLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = [NSString stringWithFormat:@"%@:%@", PNLocalizedString(@"X8wkuMw2", @"卖方"), @""];
        _salerLabel = label;
    }
    return _salerLabel;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard11;
        _statusLabel = label;
    }
    return _statusLabel;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINBold:20];
        _amountLabel = label;
    }
    return _amountLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _lineView = view;
    }
    return _lineView;
}

- (SALabel *)timeLabel {
    if (!_timeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        _timeLabel = label;
    }
    return _timeLabel;
}

@end
