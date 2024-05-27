//
//  PNPacketAmountItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketAmountItemView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNCommonUtils.h"
#import "PNHandOutViewModel.h"
#import "PNInputItemView.h"


@interface PNPacketAmountItemView () <PNInputItemViewDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) PNInputItemView *quantifyInputView;
@property (nonatomic, strong) SALabel *rightLabel;
@property (nonatomic, strong) SALabel *usdLabel;
@property (nonatomic, strong) HDUIButton *changeBtn;
@end


@implementation PNPacketAmountItemView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.viewModel.model.splitType = PNPacketSplitType_Lucky;

    if (self.viewModel.model.packetType == PNPacketType_Password) {
        self.changeBtn.hidden = NO;
    } else {
        self.changeBtn.hidden = YES;
    }

    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"calculationRateFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self calculationRate];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"currentPacketType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (self.viewModel.model.packetType == PNPacketType_Password) {
            self.changeBtn.hidden = NO;
        } else {
            self.changeBtn.hidden = YES;
        }
        [self setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"hideKeyBoardFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self endEditing:YES];
        [self.quantifyInputView.textFiled resignFirstResponder];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"clearFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        self.viewModel.model.amt = @"";
        self.quantifyInputView.model.value = @"";
        [self.quantifyInputView update];

        self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
        self.viewModel.calculationRateFlag = !self.viewModel.calculationRateFlag;
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self addSubview:self.bgView];
    [self.bgView addSubview:self.quantifyInputView];
    [self.bgView addSubview:self.rightLabel];
    [self.bgView addSubview:self.usdLabel];
    [self addSubview:self.changeBtn];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        if (self.changeBtn.hidden) {
            make.bottom.equalTo(self);
        }
    }];

    [self.quantifyInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
        make.right.mas_equalTo(self.rightLabel.mas_left);
        make.height.mas_equalTo(@(kRealWidth(57)));
        if (self.usdLabel.hidden) {
            make.bottom.equalTo(self.bgView);
        } else {
            make.bottom.mas_equalTo(self.usdLabel.mas_top);
        }
    }];

    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.quantifyInputView.mas_centerY);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
    }];

    [self.rightLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    if (!self.usdLabel.hidden) {
        [self.usdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.quantifyInputView.mas_left);
            make.right.equalTo(self.rightLabel);
            make.top.mas_equalTo(self.quantifyInputView.mas_bottom);
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(20));
        }];
    }

    if (!self.changeBtn.hidden) {
        [self.changeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right);
            make.top.mas_equalTo(self.bgView.mas_bottom);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)setUsdStr:(NSString *)usdStr {
    _usdStr = usdStr;

    NSString *hightStr = usdStr;
    NSString *allStr = [NSString stringWithFormat:@"%@ %@", hightStr, PNCurrencyTypeUSD];
    NSMutableAttributedString *attStr = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14
                                                                    highLightColor:HDAppTheme.PayNowColor.c333333
                                                                           norFont:HDAppTheme.PayNowFont.standard14M
                                                                          norColor:HDAppTheme.PayNowColor.c333333];

    self.usdLabel.attributedText = attStr;

    [self setNeedsUpdateConstraints];
}

- (void)calculationRate {
    if (self.viewModel.model.amt.doubleValue > 0 && !WJIsObjectNil(self.viewModel.exchangeRateModel)) {
        if (self.viewModel.model.splitType == PNPacketSplitType_Lucky) {
            CGFloat usd = self.viewModel.model.amt.doubleValue / self.viewModel.exchangeRateModel.usdBuyKhr.doubleValue;
            if (usd < 0.01) {
                usd = 0.01;
            }
            self.usdStr = [NSString stringWithFormat:@"%0.2f", usd];
            self.usdLabel.hidden = NO;
        } else {
            if (self.viewModel.model.qty > 0) {
                CGFloat usd = self.viewModel.model.amt.doubleValue * self.viewModel.model.qty / self.viewModel.exchangeRateModel.usdBuyKhr.doubleValue;
                if (usd < 0.01) {
                    usd = 0.01;
                }
                self.usdStr = [NSString stringWithFormat:@"%0.2f", usd];
                self.usdLabel.hidden = NO;
            } else {
                self.usdLabel.hidden = YES;
            }
        }
    } else {
        self.usdLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view {
    self.viewModel.model.amt = textField.text;

    self.viewModel.calculationRateFlag = !self.viewModel.calculationRateFlag;

    self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (PNInputItemView *)quantifyInputView {
    if (!_quantifyInputView) {
        _quantifyInputView = [[PNInputItemView alloc] init];
        _quantifyInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.title = PNLocalizedString(@"pn_packet_total_amount", @"总金额");
        model.placeholder = PNLocalizedString(@"please_input_amout", @"请输入金额");
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueColor = HDAppTheme.PayNowColor.c333333;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(12), kRealWidth(20), kRealWidth(4));
        model.titleFont = HDAppTheme.PayNowFont.standard14M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.firstDigitCanNotEnterZero = YES;
        model.bottomLineHeight = 0;
        model.maxInputLength = 9;

        _quantifyInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];

        kb.inputSource = _quantifyInputView.textFiled;
        _quantifyInputView.textFiled.inputView = kb;
    }
    return _quantifyInputView;
}

- (SALabel *)rightLabel {
    if (!_rightLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = PNCurrencyTypeKHR;
        _rightLabel = label;
    }
    return _rightLabel;
}

- (SALabel *)usdLabel {
    if (!_usdLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = PNCurrencyTypeUSD;
        label.textAlignment = NSTextAlignmentRight;
        label.hidden = YES;
        _usdLabel = label;
    }
    return _usdLabel;
}

- (HDUIButton *)changeBtn {
    if (!_changeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_Identical_amount", @"改为平均金额") forState:UIControlStateNormal];
        [button setTitle:PNLocalizedString(@"pn_Random_amount", @"改为拼手气") forState:UIControlStateSelected];
        [button setTitleColor:[UIColor hd_colorWithHexString:@"#0085FF"] forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), 0, kRealWidth(4), 0);
        button.hidden = YES;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            btn.selected = !btn.selected;

            if (btn.selected) {
                self.viewModel.model.splitType = PNPacketSplitType_Average;
                self.quantifyInputView.model.title = PNLocalizedString(@"pn_packet_single_amount", @"单个金额");
            } else {
                self.viewModel.model.splitType = PNPacketSplitType_Lucky;
                self.quantifyInputView.model.title = PNLocalizedString(@"pn_packet_total_amount", @"总金额");
            }

            self.quantifyInputView.model.value = @"";
            [self.quantifyInputView update];
            self.viewModel.model.amt = @"";
            self.viewModel.calculationRateFlag = !self.viewModel.calculationRateFlag;
            self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
        }];

        _changeBtn = button;
    }
    return _changeBtn;
}

@end
