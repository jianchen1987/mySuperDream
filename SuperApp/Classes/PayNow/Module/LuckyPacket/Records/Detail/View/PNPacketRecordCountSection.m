//
//  PNPacketRecordCountSection.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordCountSection.h"
#import "SALabel.h"


@interface PNPacketRecordCountSection ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *valueLabel;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNPacketRecordCountSection

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.valueLabel];
    [self.bgView addSubview:self.line];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.bottom.mas_equalTo(self.contentView);
    }];

    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.top.bottom.equalTo(self.bgView);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.equalTo(@(PixelOne));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-1);
    }];
    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPacketDetailModel *)model {
    _model = model;

    /*
     未领取、已领完、已过期不同状态下文案显示

     部分领取：已领取1/4个红包，共KHR 400/4000
     已领完：4个红包共 KHR 4000
     已过期：已领取1/4个红包，共KHR 400/4000
     */

    NSString *str = @"";
    PNPacketReceiveStatus status = self.model.status;

    NSString *amtStr = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:self.model.amt currencyCode:PNCurrencyTypeKHR];
    NSString *receivedAmtStr = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:self.model.receivedAmt currencyCode:PNCurrencyTypeKHR];
    if (status == PNPacketReceiveStatus_RECEIVED) {
        str = [NSString stringWithFormat:PNLocalizedString(@"pn_packet_detail_count_Finished", @"已领完：%zd个红包共 KHR %@"), self.model.receivedQty, amtStr];
    } else if (status == PNPacketReceiveStatus_PARTIAL_REFUND) {
        str = [NSString
            stringWithFormat:PNLocalizedString(@"pn_packet_detail_count_part_refund", @"已领取%zd/%zd个红包，共KHR %@/%@ 已部分退款"), self.model.receivedQty, self.model.qty, receivedAmtStr, amtStr];
    } else if (status == PNPacketReceiveStatus_REFUNDED) {
        str =
            [NSString stringWithFormat:PNLocalizedString(@"pn_packet_detail_count_refund", @"已领取%zd/%zd个红包，共KHR %@/%@ 已退款"), self.model.receivedQty, self.model.qty, receivedAmtStr, amtStr];
    } else if (status == PNPacketReceiveStatus_PARTIAL_RECEIVE || status == PNPacketReceiveStatus_UNCLAIMED) {
        str = [NSString stringWithFormat:PNLocalizedString(@"pn_packet_detail_count_open", @"已领取%zd/%zd个红包，共KHR %@/%@"), self.model.receivedQty, self.model.qty, receivedAmtStr, amtStr];
    }
    self.valueLabel.text = str;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(8)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)valueLabel {
    if (!_valueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(16), 0, kRealWidth(16), 0);
        _valueLabel = label;
    }
    return _valueLabel;
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
