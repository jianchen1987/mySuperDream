//
//  TNWithDrawAuditAmountCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithDrawAuditAmountCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNWithDrawAuditAmountCell ()
@property (strong, nonatomic) UILabel *titleLabel;   ///< 标题
@property (strong, nonatomic) HDLabel *moneyLabel;   ///< 金额
@property (strong, nonatomic) HDLabel *remarkLabel;  ///< 备注
@property (strong, nonatomic) HDUIButton *statusBtn; ///<审核状态
@property (strong, nonatomic) UIView *lineView;      ///< 分割线
@end


@implementation TNWithDrawAuditAmountCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.statusBtn];
    [self.contentView addSubview:self.lineView];
}
- (void)setModel:(TNWithDrawAuditAmountCellModel *)model {
    _model = model;
    self.moneyLabel.text = model.amountMoney.thousandSeparatorAmount;
    if ([model.status isEqualToString:TNWithDrawApplyStatusPending]) {
        //审核中
        [self.statusBtn setTitle:TNLocalizedString(@"tn_tf_reviewing", @"审核中") forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = HDAppTheme.TinhNowColor.C1.CGColor;
    } else if ([model.status isEqualToString:TNWithDrawApplyStatusApproved]) {
        //审核通过
        [self.statusBtn setTitle:TNLocalizedString(@"hQSazy9v", @"审核通过") forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:HexColor(0x14B96D) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = HexColor(0x14B96D).CGColor;
    } else if ([model.status isEqualToString:TNWithDrawApplyStatusFailed]) {
        //审核不通过
        [self.statusBtn setTitle:TNLocalizedString(@"ImXEfCiN", @"审核不通过") forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:HexColor(0xFF2323) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = HexColor(0xFF2323).CGColor;
    }
    self.remarkLabel.hidden = HDIsStringEmpty(model.remark);
    self.remarkLabel.text = [NSString stringWithFormat:@"(%@)", model.remark];
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    if (!self.remarkLabel.isHidden) {
        [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moneyLabel.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    [self.statusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.remarkLabel.isHidden) {
            make.top.equalTo(self.remarkLabel.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.moneyLabel.mas_bottom).offset(kRealWidth(20));
        }
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(180), kRealWidth(25)));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBtn.mas_bottom).offset(kRealWidth(30));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = TNLocalizedString(@"Z5kClyL2", @"提现金额");
    }
    return _titleLabel;
}
/** @lazy moneyLabel */
- (HDLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[HDLabel alloc] init];
        _moneyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _moneyLabel.font = [HDAppTheme.TinhNowFont fontSemibold:35];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.numberOfLines = 2;
    }
    return _moneyLabel;
}
/** @lazy statusBtn */
- (HDUIButton *)statusBtn {
    if (!_statusBtn) {
        _statusBtn = [[HDUIButton alloc] init];
        _statusBtn.userInteractionEnabled = NO;
        _statusBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_statusBtn setTitleColor:HexColor(0xFF2323) forState:UIControlStateNormal];
        _statusBtn.layer.masksToBounds = YES;
        _statusBtn.layer.cornerRadius = 4;
        _statusBtn.layer.borderWidth = 0.5;
        _statusBtn.layer.borderColor = HexColor(0xFF2323).CGColor;
    }
    return _statusBtn;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xD6DBE8);
    }
    return _lineView;
}
/** @lazy moneyLabel */
- (HDLabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[HDLabel alloc] init];
        _remarkLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _remarkLabel.font = HDAppTheme.TinhNowFont.standard12;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
        _remarkLabel.numberOfLines = 2;
        //        _remarkLabel.text = TNLocalizedString(@"CVwrQ7RV", @"（兼职收益）");
    }
    return _remarkLabel;
}
@end


@implementation TNWithDrawAuditAmountCellModel

@end
