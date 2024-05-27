//
//  PayOrderTableHeaderView.m
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOrderTableHeaderView.h"
#import "PNCommonUtils.h"


@interface PNOrderTableHeaderView ()

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) SALabel *typeLB;
@property (nonatomic, strong) SALabel *stateLB;
@property (nonatomic, strong) SALabel *amountLB;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *codeBgView;
@property (nonatomic, strong) SALabel *codeTitleLabel;
@property (nonatomic, strong) SALabel *codeValueLabel;
@property (nonatomic, strong) HDUIButton *codeCopyBtn;          //复制按钮
@property (nonatomic, strong) SALabel *tipsLabel;               //提示说明
@property (nonatomic, strong) SALabel *withdrawCodeStatusLabel; ///失效时间 已提现 等等
@end


@implementation PNOrderTableHeaderView

- (void)hd_setupViews {
    [self addSubview:self.headView];
    [self.headView addSubview:self.iconImg];
    [self.headView addSubview:self.typeLB];
    [self.headView addSubview:self.stateLB];
    [self.headView addSubview:self.amountLB];

    [self.headView addSubview:self.codeBgView];
    [self.codeBgView addSubview:self.codeTitleLabel];
    [self.codeBgView addSubview:self.codeValueLabel];
    [self.codeBgView addSubview:self.codeCopyBtn];
    [self.headView addSubview:self.withdrawCodeStatusLabel];
    [self.headView addSubview:self.tipsLabel];

    [self.headView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView);
        if (self.type == resultPage) {
            make.top.equalTo(self.headView).offset(kRealWidth(20));
            make.width.mas_equalTo(kRealWidth(63));
            make.height.mas_equalTo(kRealWidth(63));
        } else {
            make.top.equalTo(self.headView).offset(0);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }
    }];

    [self.typeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImg);
        make.top.equalTo(self.iconImg.mas_bottom).offset(kRealWidth(20));
    }];

    [self.stateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.typeLB);
        make.top.equalTo(self.typeLB.mas_bottom).offset(kRealWidth(10));
    }];

    UIView *lastView = self.amountLB;
    [self.amountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.stateLB);
        make.top.equalTo(self.stateLB.mas_bottom).offset(kRealWidth(10));
    }];

    if (!self.codeBgView.hidden) {
        [self.codeBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.amountLB.mas_bottom).offset(kRealWidth(10));
            make.centerX.mas_equalTo(self.headView.mas_centerX);
            make.height.mas_equalTo(50);
        }];

        [self.codeTitleLabel sizeToFit];
        [self.codeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.codeBgView.mas_left);
            make.width.mas_equalTo(@(self.codeTitleLabel.width + kRealWidth(20)));
            make.top.mas_equalTo(self.codeBgView.mas_top);
            make.bottom.mas_equalTo(self.codeBgView.mas_bottom);
        }];

        [self.codeValueLabel sizeToFit];
        [self.codeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.codeTitleLabel.mas_right).offset(kRealWidth(15));
            make.width.equalTo(@(self.codeValueLabel.width + kRealWidth(5)));
            if (!self.codeCopyBtn.hidden) {
                make.right.mas_equalTo(self.codeCopyBtn.mas_left);
            } else {
                make.right.mas_equalTo(self.codeBgView.mas_right).offset(kRealWidth(-5));
            }

            make.centerY.mas_equalTo(self.codeBgView.mas_centerY);
        }];

        if (!self.codeCopyBtn.hidden) {
            [self.codeCopyBtn sizeToFit];
            [self.codeCopyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.codeBgView.mas_top);
                make.bottom.mas_equalTo(self.codeBgView.mas_bottom);
                make.right.mas_equalTo(self.codeBgView.mas_right);
                make.width.equalTo(@(self.codeCopyBtn.width + kRealWidth(30)));
            }];
        }

        lastView = self.withdrawCodeStatusLabel;
        [self.withdrawCodeStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headView.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.headView.mas_right).offset(kRealWidth(-15));
            make.top.mas_equalTo(self.codeBgView.mas_bottom).offset(kRealWidth(10));
        }];

        if (!self.tipsLabel.hidden) {
            lastView = self.tipsLabel;
            [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.headView.mas_left).offset(kRealWidth(15));
                make.right.mas_equalTo(self.headView.mas_right).offset(kRealWidth(-15));
                make.top.mas_equalTo(self.withdrawCodeStatusLabel.mas_bottom).offset(kRealWidth(10));
            }];
        }
    }

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.headView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(lastView.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.headView.mas_bottom).offset(kRealWidth(-30));
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(PNOrderTableHeaderViewModel *)model {
    _model = model;
    self.iconImg.image = [UIImage imageNamed:model.iconImgName];
    self.typeLB.text = model.typeStr;
    self.stateLB.text = model.stateStr;
    self.amountLB.text = model.amountStr;

    if (WJIsStringNotEmpty(model.incomeFlag) && [model.incomeFlag isEqualToString:@"+"]) {
        self.amountLB.textColor = HDAppTheme.PayNowColor.mainThemeColor;
    } else {
        self.amountLB.textColor = HDAppTheme.PayNowColor.c333333;
    }

    NSString *codeValueStr = self.model.withdrawCode ?: @"          ";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:codeValueStr attributes:@{NSKernAttributeName: @(4)}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, codeValueStr.length)];
    self.codeValueLabel.attributedText = attStr;

    /// 针对提现码的处理
    if (self.model.transType == PNTransTypeToPhone && WJIsStringNotEmpty(self.model.withdrawCode)) {
        self.codeBgView.hidden = NO;
        self.withdrawCodeStatusLabel.hidden = NO;

        if (self.type == detailPage) {
            self.tipsLabel.hidden = YES;

            PNWithdrawCodeStatus withdrawCodeStatus = self.model.withdrawStatus;
            /// 未提现
            if (withdrawCodeStatus == PNWithdrawCodeStatusNoWithdraw || withdrawCodeStatus == PNWithdrawCodeStatusWithdrawIng) {
                self.withdrawCodeStatusLabel.text = [NSString stringWithFormat:@"(%@: %@%@)",
                                                                               PNLocalizedString(@"no_withdraw", @"未提现"),
                                                                               PNLocalizedString(@"faild_time", @"失效时间"),
                                                                               [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm"
                                                                                                        withDate:[NSDate dateWithTimeIntervalSince1970:model.withdrawOverdueTime.floatValue / 1000]]];

                self.withdrawCodeStatusLabel.textAlignment = NSTextAlignmentCenter;
                self.withdrawCodeStatusLabel.textColor = HDAppTheme.PayNowColor.cFD7127;

                self.codeBgView.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
                self.codeTitleLabel.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
                self.codeValueLabel.textColor = HDAppTheme.PayNowColor.cFD7127;

            } else if (withdrawCodeStatus == PNWithdrawCodeStatusWithdrawed || withdrawCodeStatus == PNWithdrawCodeStatusInvaild
                       || withdrawCodeStatus == PNWithdrawCodeStatusRefunded) { /// 已提现 已过期 已退款
                NSString *str = @"";
                if (withdrawCodeStatus == PNWithdrawCodeStatusWithdrawed) { /// 已提现
                    str = [NSString stringWithFormat:@"(%@)", PNLocalizedString(@"withdraw", @"已提现")];
                } else {
                    /// 已失效、已退款  都显示这个样式
                    str = [NSString stringWithFormat:@"(%@: %@)", PNLocalizedString(@"invalid_time", @"已失效"), PNLocalizedString(@"withdraw_code_expired", @"提现码过期")];
                }
                self.withdrawCodeStatusLabel.text = str;
                self.withdrawCodeStatusLabel.textAlignment = NSTextAlignmentCenter;
                self.withdrawCodeStatusLabel.textColor = HDAppTheme.PayNowColor.cC6C8CC;
                self.codeBgView.layer.borderColor = HDAppTheme.PayNowColor.cC6C8CC.CGColor;
                self.codeTitleLabel.backgroundColor = HDAppTheme.PayNowColor.cC6C8CC;
                self.codeValueLabel.textColor = HDAppTheme.PayNowColor.cC6C8CC;
                self.codeCopyBtn.hidden = YES;
            }
        } else {
            /// 结果页也要显示  提现码状态
            self.withdrawCodeStatusLabel.text = [NSString stringWithFormat:@"(%@%@)",
                                                                           PNLocalizedString(@"faild_time", @"失效时间"),
                                                                           [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm"
                                                                                                    withDate:[NSDate dateWithTimeIntervalSince1970:model.withdrawOverdueTime.floatValue / 1000]]];

            self.withdrawCodeStatusLabel.textAlignment = NSTextAlignmentCenter;
            self.withdrawCodeStatusLabel.textColor = HDAppTheme.PayNowColor.cFD7127;

            self.codeBgView.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
            self.codeTitleLabel.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
            self.codeValueLabel.textColor = HDAppTheme.PayNowColor.cFD7127;

            self.tipsLabel.hidden = NO;
        }
    } else {
        self.codeBgView.hidden = YES;
        self.withdrawCodeStatusLabel.hidden = YES;
        self.tipsLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)headView {
    if (!_headView) {
        _headView = UIView.new;
        _headView.backgroundColor = [UIColor clearColor];
    }
    return _headView;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = UIImageView.new;
    }
    return _iconImg;
}

- (SALabel *)typeLB {
    if (!_typeLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:17];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _typeLB = label;
    }
    return _typeLB;
}

- (SALabel *)stateLB {
    if (!_stateLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:15];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _stateLB = label;
    }
    return _stateLB;
}

- (SALabel *)amountLB {
    if (!_amountLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.PayNowFont fontDINBlack:32];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        _amountLB = label;
    }
    return _amountLB;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.PayNowColor.cECECEC;
    }
    return _lineView;
}

- (UIView *)codeBgView {
    if (!_codeBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.layer.cornerRadius = kRealWidth(5);
        view.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
        view.layer.borderWidth = PixelOne;
        view.layer.masksToBounds = YES;
        view.hidden = YES;
        _codeBgView = view;
    }
    return _codeBgView;
}

- (SALabel *)codeTitleLabel {
    if (!_codeTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        label.text = PNLocalizedString(@"pn_withdraw_code", @"提现码");
        label.textAlignment = NSTextAlignmentCenter;
        _codeTitleLabel = label;
    }
    return _codeTitleLabel;
}

- (SALabel *)codeValueLabel {
    if (!_codeValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFD7127;
        label.font = [HDAppTheme.PayNowFont fontSemibold:30];
        _codeValueLabel = label;
    }
    return _codeValueLabel;
}

- (HDUIButton *)codeCopyBtn {
    if (!_codeCopyBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_copy_withdraw_code"] forState:0];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            if (WJIsStringNotEmpty(self.model.withdrawCode)) {
                [UIPasteboard generalPasteboard].string = self.model.withdrawCode;
                [HDTips showWithText:PNLocalizedString(@"pn_copy_success", @"复制成功")];
            }
        }];

        _codeCopyBtn = button;
    }
    return _codeCopyBtn;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard13;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"trans_to_phone_tips2", @"说明：收款人可凭提现码、收款手机号前往CoolCash任意网点提现");
        label.hidden = YES;
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (SALabel *)withdrawCodeStatusLabel {
    if (!_withdrawCodeStatusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard13;
        label.text = @"";
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.hidden = YES;
        _withdrawCodeStatusLabel = label;
    }
    return _withdrawCodeStatusLabel;
}
@end
