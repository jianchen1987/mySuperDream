//
//  PNMSOrderListCell.m
//  SuperApp
//
//  Created by xixi on 2022/6/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOrderListCell.h"
#import "PNCommonUtils.h"
#import "PNMSBillListModel.h"


@interface PNMSOrderListCell ()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) SALabel *nameLB;
@property (nonatomic, strong) SALabel *timeLB;
@property (nonatomic, strong) SALabel *amountLB;
@property (nonatomic, strong) SALabel *stateLB;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation PNMSOrderListCell

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

#pragma mark - getters and setters
- (void)setModel:(PNMSBillListModel *)model {
    _model = model;
    NSString *typeDesc = PNLocalizedString(@"PAGE_TEXT_TRADE", @"交易");
    switch (_model.tradeType) {
        case PNTransTypeRecharge: {
            //入金
            self.iconImg.image = [UIImage imageNamed:@"pay_order_Remuneration"];
            NSString *tradeType = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", tradeType, _model.payeeUsrName];

            /// 【额外处理】
            if (model.tradeType == PNTransTypeRecharge) {
                tradeType = PNLocalizedString(@"pn_Withdraw", @"提现");

                if ([model.subBizEntity.code isEqualToString:PNTransferTypeWitdraw]) {
                    self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", tradeType, _model.accountName];
                } else {
                    self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", tradeType, _model.payeeUsrName];
                }
            }

            typeDesc = tradeType;
        } break;
        case PNTransTypeCollect: //收款
        {
            self.iconImg.image = [UIImage imageNamed:@"pay_order_Collection"];
            NSString *tradeTypeStr = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            if (WJIsStringNotEmpty(_model.payerUsrName)) {
                tradeTypeStr = [tradeTypeStr stringByAppendingFormat:@"- %@", _model.payerUsrName];
            }
            self.nameLB.text = tradeTypeStr;
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        }
        case PNTransTypeRefund: //退款
            self.iconImg.image = [UIImage imageNamed:@"pay_order_refund"];
            self.nameLB.text = [NSString stringWithFormat:@"%@ - %@", [PNCommonUtils getTradeTypeNameByCode:_model.tradeType], _model.payeeUsrName];
            typeDesc = [PNCommonUtils getTradeTypeNameByCode:_model.tradeType];
            break;
        default:
            self.iconImg.image = [UIImage imageNamed:@""];
            self.nameLB.text = @"--";
            break;
    }

    self.timeLB.text = [PNCommonUtils getDateStrByFormat:@"dd/MM HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:_model.createTime.floatValue / 1000.0]];

    self.amountLB.text =
        [NSString stringWithFormat:@"%@%@", _model.incomeFlag, [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:_model.realAmt.stringValue] currencyCode:_model.currency]];

    if ([_model.incomeFlag isEqualToString:@"+"]) {
        self.amountLB.textColor = HDAppTheme.PayNowColor.mainThemeColor;
    } else {
        self.amountLB.textColor = HDAppTheme.PayNowColor.c333333;
    }

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
        _stateLB.textColor = HDAppTheme.PayNowColor.c333333;
    } else {
        _stateLB.text = [NSString stringWithFormat:@"%@%@%@", typeDesc, PNLocalizedString(@"Space", @""), statusDesc];
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
        label.textColor = HDAppTheme.PayNowColor.c333333;
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
        label.font = [HDAppTheme.PayNowFont fontDINBold:20];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.textAlignment = NSTextAlignmentRight;
        _amountLB = label;
    }
    return _amountLB;
}
- (SALabel *)stateLB {
    if (!_stateLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:12];
        label.textColor = HDAppTheme.PayNowColor.c333333;
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
