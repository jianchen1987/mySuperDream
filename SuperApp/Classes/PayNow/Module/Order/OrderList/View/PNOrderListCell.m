//
//  OrderListTBCell.m
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOrderListCell.h"
#import "PNCommonUtils.h"


@implementation PNOrderListCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.timeLB];
    [self.contentView addSubview:self.amountLB];
    [self.contentView addSubview:self.stateLB];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kRealWidth(15));
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(30));
        make.width.mas_equalTo(kRealWidth(30));
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(kRealWidth(10));
        make.centerY.equalTo(self.iconImg);
        make.right.equalTo(self.amountLB.mas_left).offset(-kRealWidth(5));
    }];
    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(6));
        make.left.equalTo(self.iconImg.mas_right).offset(kRealWidth(10));
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
        make.left.equalTo(self.iconImg.mas_right).offset(kRealWidth(10));
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

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)collecTap:(PNOrderListModel *)model {
    !self.cellBlock ?: self.cellBlock(model);
}
#pragma mark - getters and setters
- (void)setModel:(PNOrderListModel *)model {
    _model = model;
    NSString *typeDesc = PNLocalizedString(@"PAGE_TEXT_TRADE", @"交易");
    switch (_model.tradeType) {
        case PNTransTypeRecharge: //充值
            self.iconImg.image = [UIImage imageNamed:@"pay_order_Remuneration"];
            self.nameLB.text = [NSString stringWithFormat:@"%@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType]];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeConsume: //消费
            self.iconImg.image = [UIImage imageNamed:@"pay_order_consume"];
            if (_model.subTradeType == PNTradeSubTradeTypePhoneTopUp || _model.subTradeType == PNTradeSubTradeTypeBroadandTV) {
                self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType], _model.merName];
            } else {
                self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType], _model.merName];
            }
            break;
        case PNTransTypeTransfer: //转账
            self.iconImg.image = [UIImage imageNamed:@"pay_order_trans"];
            self.nameLB.text = [NSString stringWithFormat:@"%@ - %@ %@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType], _model.realNameFirst, _model.realNameEnd];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeToPhone: //转账 - 到手机号
            self.iconImg.image = [UIImage imageNamed:@"pay_order_trans"];
            self.nameLB.text = [NSString stringWithFormat:@"%@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType]];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeExchange: //兑换
            self.iconImg.image = [UIImage imageNamed:@"pay_order_exc"];
            self.nameLB.text = [NSString stringWithFormat:@"%@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType]];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeWithdraw: //提现
            self.iconImg.image = [UIImage imageNamed:@"pay_order_outgold"];
            self.nameLB.text = [NSString stringWithFormat:@"%@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType]];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeCollect: //收款
            self.iconImg.image = [UIImage imageNamed:@"pay_order_Collection"];
            self.nameLB.text = [NSString stringWithFormat:@"%@ - %@ %@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType], _model.payerRealNameFirst, _model.payerRealNameEnd];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeRefund: //退款
        {
            self.iconImg.image = [UIImage imageNamed:@"pay_order_refund"];
            NSString *nameStr = @"";
            if ([_model.bizEntity.code isEqualToString:@"1050"]) {
                nameStr = _model.merName;
            } else {
                nameStr = _model.payeeUsrName;
            }
            self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType], nameStr];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
        } break;
        case PNTransTypePinkPacket: //红包
            self.iconImg.image = [UIImage imageNamed:@"pay_order_RedEnvelopes"];
            self.nameLB.text = [NSString stringWithFormat:@"%@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType]];
            break;
        case PNTransTypeRemuneration: //酬劳
            self.iconImg.image = [UIImage imageNamed:@"pay_order_Goldinput"];
            self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType], _model.payerUsrName];
            break;
        case PNTransTypeAdjust: //调账
            self.iconImg.image = [UIImage imageNamed:@"pay_order_Adjustment"];
            self.nameLB.text = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeBlocked: //冻结扣款
            self.iconImg.image = [UIImage imageNamed:@"pay_order_blocked"];
            self.nameLB.text = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        case PNTransTypeApartment: //缴费
            self.iconImg.image = [UIImage imageNamed:@"pay_order_apartment"];
            self.nameLB.text = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        default:
            self.iconImg.image = [UIImage imageNamed:@""];
            self.nameLB.text = @"--";
            break;
    }

    self.timeLB.text = [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:_model.createTime.floatValue / 1000.0]];

    //#ifdef DEBUG
    //    self.timeLB.text = [NSString stringWithFormat:@"%@ - [%@]", [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:_model.createTime.integerValue /
    //    1000.0]], _model.tradeNo];
    //#endif

    self.amountLB.text =
        [NSString stringWithFormat:@"%@%@", _model.incomeFlag, [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:_model.realAmt.stringValue] currencyCode:_model.currency]];

    if ([_model.incomeFlag isEqualToString:@"+"]) {
        self.amountLB.textColor = [UIColor hd_colorWithHexString:@"#FD7127"];
    } else {
        self.amountLB.textColor = HDAppTheme.PayNowColor.c343B4D;
    }

    if (_model.tradeType == PNTransTypeAdjust) {
        _stateLB.text = @"";
    } else {
        NSString *statusDesc = [PNCommonUtils getStatusByCode:_model.status];
        if (_model.status == PNOrderStatusProcessing) {
            _stateLB.text = PNLocalizedString(@"In_progress", @"订单处理中");
            _stateLB.textColor = [UIColor hd_colorWithHexString:@"#C6C8CC"];
        } else if (_model.tradeType == PNTransTypeRecharge && _model.subTradeType == PNTradeSubTradeTypeBankCashIn && (_model.status == PNOrderStatusFailure)) {
            _stateLB.textColor = [UIColor hd_colorWithHexString:@"#7A54CB"];
            _stateLB.text = PNLocalizedString(@"Order_closed", @"订单关闭");
        } else if (_model.tradeType == PNTransTypeRecharge && _model.subTradeType == PNTradeSubTradeTypeMerchantAgent && _model.status == PNOrderStatusRefund) {
            _stateLB.text = PNLocalizedString(@"refunded_success", @"退款成功");
            _stateLB.textColor = [UIColor hd_colorWithHexString:@"#3C6FF0"];
        } else if (_model.tradeType == PNTransTypeTransfer && _model.status == PNOrderStatusRefund) {
            //针对转账 + 退款成功 处理
            _stateLB.text = PNLocalizedString(@"ORDER_STATUS_REFUND", @"已退款");
        } else if (_model.tradeType == PNTransTypeBlocked) {
            _stateLB.text = statusDesc;
            _stateLB.textColor = HDAppTheme.PayNowColor.c343B4D;
        } else {
            _stateLB.text = [NSString stringWithFormat:@"%@%@%@", typeDesc, PNLocalizedString(@"Space", @""), statusDesc];
            _stateLB.textColor = HDAppTheme.PayNowColor.c343B4D;
        }
    }
    [self setNeedsUpdateConstraints];
}
- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = UIImageView.new;
    }
    return _iconImg;
}
- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:14];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        _nameLB = label;
    }
    return _nameLB;
}
- (SALabel *)timeLB {
    if (!_timeLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:12];
        label.textColor = [UIColor hd_colorWithHexString:@"#858994"];
        _timeLB = label;
    }
    return _timeLB;
}
- (SALabel *)amountLB {
    if (!_amountLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:17];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.textAlignment = NSTextAlignmentRight;
        _amountLB = label;
    }
    return _amountLB;
}
- (SALabel *)stateLB {
    if (!_stateLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:12];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.textAlignment = NSTextAlignmentRight;
        _stateLB = label;
    }
    return _stateLB;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = [UIColor hd_colorWithHexString:@"#ECECEC"];
    }
    return _lineView;
}
@end
