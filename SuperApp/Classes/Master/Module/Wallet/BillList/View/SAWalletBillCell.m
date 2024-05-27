//
//  SAWalletBillCell.m
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillCell.h"
#import "SAGeneralUtil.h"
#import "SAWalletBillModel.h"


@interface SAWalletBillCell ()
/// 图标
@property (nonatomic, strong) UIImageView *iconIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 金额
@property (nonatomic, strong) SALabel *amountLB;
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation SAWalletBillCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.amountLB];
    [self.contentView addSubview:self.bottomLine];

    [self.amountLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(SAWalletBillModelDetail *)model {
    _model = model;

    NSString *title = @"", *iconImageName = @"wallet_charge";

    // 以后会有差异
    switch (model.tradeType) {
        case HDWalletTransTypeCollect: { //收款
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_Collection";
            break;
        }
        case HDWalletTransTypeConsume: { //消费
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_consume";
            break;
        }
        case HDWalletTransTypeRecharge: { //充值
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_Remuneration";
            break;
        }
        case HDWalletTransTypeWithdraw: { //提现
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_outgold";
            break;
        }
        case HDWalletTransTypeExchange: { //兑换
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_exc";
            break;
        }
        case HDWalletTransTypeTransfer: { //转账
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_trans";
            break;
        }
        case HDWalletTransTypeRefund: { //退款
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_refund";
            break;
        }
        case HDWalletTransTypePinkPacket: { //红包
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_RedEnvelopes";
            break;
        }
        case HDWalletTransTypeRemuneration: { //酬劳
            title = [SAGeneralUtil getTradeTypeNameByCode:model.tradeType];
            iconImageName = @"pay_order_Goldinput";
            break;
        }
        default:
            break;
    }
    self.titleLB.text = title;

    self.iconIV.image = [UIImage imageNamed:iconImageName];
    self.descLB.text = [SAGeneralUtil getDateStrWithTimeInterval:model.finishTime.doubleValue / 1000.0 format:@"dd/MM/yyyy HH:mm"];
    self.amountLB.text = [NSString stringWithFormat:@"%@%@", model.incomeFlag, model.orderAmt.thousandSeparatorAmount];
    self.bottomLine.hidden = model.isLast;
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        //        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.width.mas_equalTo(30);
        make.height.equalTo(self.iconIV.mas_width).multipliedBy(1);
    }];

    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(10);
        make.centerY.equalTo(self.iconIV);
        //        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.right.lessThanOrEqualTo(self.amountLB.mas_left).offset(-5);
    }];

    [self.amountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.titleLB);
    }];

    [self.descLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(10);
        make.top.equalTo(self.titleLB.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
        make.right.lessThanOrEqualTo(self.amountLB.mas_left).offset(-5);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.height.mas_equalTo(PixelOne);
            make.left.equalTo(self.iconIV.mas_right);
            make.right.bottom.equalTo(self.contentView);
        }
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)amountLB {
    if (!_amountLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.C1;
        label.numberOfLines = 1;
        _amountLB = label;
    }
    return _amountLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
