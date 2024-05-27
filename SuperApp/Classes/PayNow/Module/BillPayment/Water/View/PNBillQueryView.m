//
//  PNBillQueryView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillQueryView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNWaterBillModel.h"
#import "PNWaterViewModel.h"
#import "SACacheManager.h"

NSString *const kSelectCurrency = @"pn_bill_currency_select";


@interface PNBillQueryView () <HDUITextFieldDelegate, HDTextViewDelegate>
@property (nonatomic, strong) SAOperationButton *confirmButton;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) SALabel *payToTitleLabel;
@property (nonatomic, strong) UIView *payToBgView;
@property (nonatomic, strong) SALabel *payToLabel;

@property (nonatomic, strong) SALabel *numberTitleLabel;
@property (nonatomic, strong) UIView *numberBgView;
@property (nonatomic, strong) HDUITextField *numberTextField;

@property (nonatomic, strong) SALabel *currencyTitleLabel;
@property (nonatomic, strong) UIView *currencyBgView;
@property (nonatomic, strong) SALabel *currencyLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) HDUITextField *amountTextField;
@property (nonatomic, strong) HDUIButton *currencyButton;

@property (nonatomic, strong) SALabel *phoneTitleLabel;
@property (nonatomic, strong) UIView *phoneBgView;
@property (nonatomic, strong) HDUITextField *phoneTextField;

@property (nonatomic, strong) SALabel *noteTitleLabel;
@property (nonatomic, strong) UIView *noteBgView;
@property (nonatomic, strong) HDTextView *noteTextView;

@property (nonatomic, strong) PNWaterViewModel *viewModel;

@property (nonatomic, assign) CGFloat textViewHeight;
@end


@implementation PNBillQueryView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.confirmButton];

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollView addSubview:self.bgView];

    [self.bgView addSubview:self.payToTitleLabel];
    [self.bgView addSubview:self.payToBgView];
    [self.bgView addSubview:self.payToLabel];

    [self.bgView addSubview:self.numberTitleLabel];
    [self.bgView addSubview:self.numberBgView];
    [self.numberBgView addSubview:self.numberTextField];

    [self.bgView addSubview:self.currencyTitleLabel];
    [self.bgView addSubview:self.currencyBgView];
    [self.currencyBgView addSubview:self.currencyLabel];
    [self.currencyBgView addSubview:self.arrowImgView];
    [self.currencyBgView addSubview:self.currencyButton];

    if (self.viewModel.paymentCategoryType == PNPaymentCategorySchool || self.viewModel.paymentCategoryType == PNPaymentCategoryInsurance) {
        [self.currencyBgView addSubview:self.amountTextField];
    }

    if (self.viewModel.paymentCategoryType == PNPaymentCategorySchool || self.viewModel.paymentCategoryType == PNPaymentCategoryInsurance) {
        [self.bgView addSubview:self.phoneTitleLabel];
        [self.bgView addSubview:self.phoneBgView];
        [self.phoneBgView addSubview:self.phoneTextField];

        [self.bgView addSubview:self.noteTitleLabel];
        [self.bgView addSubview:self.noteBgView];
        [self.bgView addSubview:self.noteTextView];
    }

    /// 数据填充
    self.textViewHeight = 0;
    self.payToLabel.text = self.viewModel.payTo;
    [self.numberTextField setTextFieldText:self.viewModel.customerCode];
    NSString *currency = [SACacheManager.shared objectForKey:kSelectCurrency type:SACacheTypeCacheNotPublic];
    if (WJIsStringEmpty(currency)) {
        currency = PNCurrencyTypeUSD;
    }
    self.currencyLabel.text = currency;
    self.viewModel.currency = self.currencyLabel.text;

    [self.phoneTextField setTextFieldText:SAUser.shared.loginName];
    self.viewModel.customerPhone = self.phoneTextField.validInputText;

    [self ruleLimit];

    /// 设置title
    NSString *hightStr = @"*";
    NSString *norStr = @"";
    if (self.viewModel.paymentCategoryType == PNPaymentCategorySchool) {
        norStr = PNLocalizedString(@"student_id", @"学生ID");
    } else if (self.viewModel.paymentCategoryType == PNPaymentCategoryInsurance) {
        norStr = PNLocalizedString(@"policy_number", @"学生ID");
    } else {
        norStr = PNLocalizedString(@"customer_code", @"国际化");
    }
    NSString *all = [NSString stringWithFormat:@"%@%@", norStr, hightStr];
    self.numberTitleLabel.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:all highLightFont:HDAppTheme.PayNowFont.standard15B
                                                                       highLightColor:HDAppTheme.PayNowColor.cFD7127];

    [self.scrollViewContainer setFollowKeyBoardConfigEnable:YES margin:30 refView:nil];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.mas_equalTo(self.confirmButton.mas_top).offset(kRealWidth(-10));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.payToTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(20));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
    }];

    [self.payToBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.payToTitleLabel.mas_bottom).offset(kRealWidth(10));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
        if (WJIsStringEmpty(self.payToLabel.text)) {
            make.height.equalTo(@(kRealWidth(42)));
        }
    }];

    [self.payToLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payToBgView.mas_left).offset(kRealWidth(10));
        make.top.mas_equalTo(self.payToBgView.mas_top).offset(kRealWidth(10));
        make.right.mas_equalTo(self.payToBgView.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.payToBgView.mas_bottom).offset(kRealWidth(-10));
    }];

    [self.numberTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.payToBgView.mas_bottom).offset(kRealWidth(20));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
    }];

    [self.numberBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberTitleLabel.mas_bottom).offset(kRealWidth(10));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
        make.height.equalTo(@(kRealWidth(42)));
        if (self.viewModel.paymentCategoryType != PNPaymentCategorySchool && self.viewModel.paymentCategoryType != PNPaymentCategoryInsurance) {
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-20));
        }
    }];

    [self.numberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberBgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.numberBgView.mas_right).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.numberBgView.mas_centerY).offset(kRealWidth(-6));
    }];

    /// 账单 和 教育 才展示下面的
    if (self.viewModel.paymentCategoryType == PNPaymentCategorySchool || self.viewModel.paymentCategoryType == PNPaymentCategoryInsurance) {
        [self.currencyTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.top.mas_equalTo(self.numberBgView.mas_bottom).offset(kRealWidth(20));
            make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
        }];

        [self.currencyBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currencyTitleLabel.mas_bottom).offset(kRealWidth(10));
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
            make.height.equalTo(@(kRealWidth(42)));
            if (self.viewModel.paymentCategoryType != PNPaymentCategorySchool && self.viewModel.paymentCategoryType != PNPaymentCategoryInsurance) {
                make.bottom.equalTo(self.bgView.mas_bottom).offset(kRealWidth(-20));
            }
        }];

        [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(self.arrowImgView.image.size));
            make.centerY.mas_equalTo(self.currencyBgView.mas_centerY);
            make.left.mas_equalTo(self.currencyLabel.mas_right).offset(kRealWidth(15));
        }];

        self.currencyLabel.textAlignment = NSTextAlignmentCenter;
        [self.currencyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.currencyBgView.mas_left).offset(kRealWidth(10));
            make.centerY.mas_equalTo(self.currencyBgView.mas_centerY);
            make.width.equalTo(@(35));
        }];

        [self.amountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.arrowImgView.mas_right).offset(kRealWidth(15));
            make.right.mas_equalTo(self.currencyBgView.mas_right).offset(kRealWidth(-15));
            make.centerY.mas_equalTo(self.currencyBgView.mas_centerY).offset(kRealWidth(-6));
        }];

        [self.currencyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.currencyLabel.mas_left);
            make.right.mas_equalTo(self.arrowImgView.mas_right);
            make.top.mas_equalTo(self.currencyBgView.mas_top);
            make.bottom.mas_equalTo(self.currencyBgView.mas_bottom);
        }];

        [self.phoneTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.top.mas_equalTo(self.currencyBgView.mas_bottom).offset(kRealWidth(20));
            make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
        }];

        [self.phoneBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneTitleLabel.mas_bottom).offset(kRealWidth(10));
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
            make.height.equalTo(@(kRealWidth(42)));
        }];

        [self.phoneTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.phoneBgView.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.phoneBgView.mas_right).offset(kRealWidth(-15));
            make.centerY.mas_equalTo(self.phoneBgView.mas_centerY).offset(kRealWidth(-6));
        }];

        [self.noteTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.top.mas_equalTo(self.phoneBgView.mas_bottom).offset(kRealWidth(20));
            make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
        }];

        [self.noteBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.noteTitleLabel.mas_bottom).offset(kRealWidth(10));
            make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
            make.bottom.equalTo(self.bgView.mas_bottom).offset(kRealWidth(-20));
        }];

        [self.noteTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.noteBgView.mas_left).offset(kRealWidth(15));
            make.top.mas_equalTo(self.noteBgView.mas_top).offset(kRealWidth(5));
            make.right.mas_equalTo(self.noteBgView.mas_right).offset(kRealWidth(-15));
            make.height.mas_equalTo(self.textViewHeight > 0 ? self.textViewHeight : kRealWidth(30));
            make.bottom.mas_equalTo(self.noteBgView.mas_bottom).offset(kRealWidth(-5));
        }];
    }

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneXSeries ? -kiPhoneXSeriesSafeBottomHeight : kRealWidth(-20));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)showSelectCurrency {
    [self endEditing:YES];
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    HDActionSheetViewButton *maleBTN = [HDActionSheetViewButton buttonWithTitle:PNCurrencyTypeUSD type:HDActionSheetViewButtonTypeCustom
                                                                        handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                            [sheetView dismiss];
                                                                            [self updateData:PNCurrencyTypeUSD];
                                                                        }];
    HDActionSheetViewButton *femaleBTN = [HDActionSheetViewButton buttonWithTitle:PNCurrencyTypeKHR type:HDActionSheetViewButtonTypeCustom
                                                                          handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                                              [sheetView dismiss];
                                                                              [self updateData:PNCurrencyTypeKHR];
                                                                          }];
    [sheetView addButtons:@[maleBTN, femaleBTN]];
    [sheetView show];
}

- (void)updateData:(NSString *)currency {
    self.currencyLabel.text = currency;
    self.viewModel.currency = currency;
}

#pragma mark
- (void)ruleLimit {
    if (WJIsStringNotEmpty(self.numberTextField.validInputText)) {
        if (self.viewModel.paymentCategoryType == PNPaymentCategorySchool || self.viewModel.paymentCategoryType == PNPaymentCategoryInsurance) {
            NSString *amountStr = self.amountTextField.validInputText;
            NSString *phoneStr = self.phoneTextField.validInputText;
            if (WJIsStringNotEmpty(amountStr) && amountStr.doubleValue > 0 && WJIsStringNotEmpty(phoneStr)) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        } else {
            self.confirmButton.enabled = YES;
        }
    } else {
        self.confirmButton.enabled = NO;
    }
}

- (void)queryData {
    [self.viewModel queryBillInfo:^(PNWaterBillModel *_Nonnull resultModel) {
        /// 能到这里点击跳转，说明 请求接口返回正常的数据
        NSDictionary *dict = [resultModel yy_modelToJSONObject];
        NSDictionary *params = @{
            @"billInfo": dict,
            @"paymentCategory": @(self.viewModel.paymentCategoryType),
            @"notes": self.viewModel.notes,
            @"customerPhone": self.viewModel.customerPhone,
        };
        [HDMediator.sharedInstance navigaveToPayNowSubmitWaterPaymentVC:params];
    }];
}

- (void)setInputStatus:(UITextField *)textField status:(NSInteger)status {
    if (textField == self.numberTextField.inputTextField) {
        self.numberBgView.layer.borderWidth = status;
        self.viewModel.customerCode = self.numberTextField.validInputText;
    } else if (textField == self.amountTextField.inputTextField) {
        self.currencyBgView.layer.borderWidth = status;
        self.viewModel.amount = self.amountTextField.validInputText;
    } else if (textField == self.phoneTextField.inputTextField) {
        self.phoneBgView.layer.borderWidth = status;
    }
}

#pragma mark
#pragma mark HDUITextField Delegate
- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldBeginEditing");
    return YES;
}

- (void)hd_textFieldDidBeginEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldDidBeginEditing");
    [self setInputStatus:textField status:1];
}

- (BOOL)hd_textFieldShouldEndEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldEndEditing");
    return YES;
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldDidEndEditing");
    [self setInputStatus:textField status:0];
    [self ruleLimit];
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    HDLog(@"hd_textFieldDidEndEditing reason");
}

- (BOOL)hd_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    HDLog(@"hd_textField shouldChangeCharactersInRange replacementString");
    return YES;
}

- (BOOL)hd_textFieldShouldClear:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldClear");
    return YES;
}

- (BOOL)hd_textFieldShouldReturn:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldReturn");
    return YES;
}

#pragma mark
#pragma mark HDTextView Delegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    self.textViewHeight = height;

    [self setNeedsUpdateConstraints];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.viewModel.notes = textView.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.noteBgView.layer.borderWidth = 1;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.noteBgView.layer.borderWidth = 0;
}

#pragma mark
- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_SUBMIT", @"提交") forState:0];
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [SACacheManager.shared setObject:self.viewModel.currency forKey:kSelectCurrency type:SACacheTypeCacheNotPublic];
            [self queryData];
        }];
    }
    return _confirmButton;
}

- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (UIView *)payToBgView {
    if (!_payToBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        _payToBgView = view;
    }
    return _payToBgView;
}

- (SALabel *)payToTitleLabel {
    if (!_payToTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        label.text = PNLocalizedString(@"pay_to", @"pay to");
        _payToTitleLabel = label;
    }
    return _payToTitleLabel;
}

- (SALabel *)payToLabel {
    if (!_payToLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.numberOfLines = 0;
        _payToLabel = label;
    }
    return _payToLabel;
}

- (SALabel *)numberTitleLabel {
    if (!_numberTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        NSString *hightStr = @"*";
        NSString *all = [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"customer_code", @"customer code"), hightStr];
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:all highLightFont:HDAppTheme.PayNowFont.standard15B highLightColor:HDAppTheme.PayNowColor.cFD7127];
        _numberTitleLabel = label;
    }
    return _numberTitleLabel;
}

- (UIView *)numberBgView {
    if (!_numberBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
        view.layer.cornerRadius = kRealWidth(4);
        _numberBgView = view;
    }
    return _numberBgView;
}

- (HDUITextField *)numberTextField {
    if (!_numberTextField) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:@"" leftLabelString:nil];
        textField.delegate = self;
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.placeholder = PNLocalizedString(@"please_enter", @"请输入");
        config.font = HDAppTheme.PayNowFont.standard15;
        config.textColor = HDAppTheme.PayNowColor.c343B4D;
        config.floatingText = @" ";
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [textField setConfig:config];

        _numberTextField = textField;
    }
    return _numberTextField;
}

- (SALabel *)currencyTitleLabel {
    if (!_currencyTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        NSString *hightStr = @"*";
        NSString *all = [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"select_currency", @"币种"), hightStr];
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:all highLightFont:HDAppTheme.PayNowFont.standard15B highLightColor:HDAppTheme.PayNowColor.cFD7127];
        _currencyTitleLabel = label;
    }
    return _currencyTitleLabel;
}

- (UIView *)currencyBgView {
    if (!_currencyBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
        view.layer.cornerRadius = kRealWidth(4);
        _currencyBgView = view;
    }
    return _currencyBgView;
}

- (SALabel *)currencyLabel {
    if (!_currencyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15;
        _currencyLabel = label;
    }
    return _currencyLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_arrow_down"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

- (HDUITextField *)amountTextField {
    if (!_amountTextField) {
        _amountTextField = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"please_input_amout", @"请输入金额") leftLabelString:@""];
        _amountTextField.delegate = self;

        HDUITextFieldConfig *config = [_amountTextField getCurrentConfig];
        config.placeholder = PNLocalizedString(@"please_input_money", @"请输入金额");
        config.font = HDAppTheme.PayNowFont.standard15;
        config.textColor = HDAppTheme.PayNowColor.c343B4D;
        config.floatingText = @" ";
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.textAlignment = NSTextAlignmentLeft;
        config.characterSetString = kCharacterSetStringAmount;
        config.maxDecimalsCount = 2;

        [_amountTextField setConfig:config];

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = _amountTextField.inputTextField;
        _amountTextField.inputTextField.inputView = kb;
    }
    return _amountTextField;
}

- (HDUIButton *)currencyButton {
    if (!_currencyButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self showSelectCurrency];
        }];
        _currencyButton = button;
    }
    return _currencyButton;
}

- (SALabel *)phoneTitleLabel {
    if (!_phoneTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        NSString *hightStr = @"*";
        NSString *all = [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"customer_phone", @"Customer Phone"), hightStr];
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:all highLightFont:HDAppTheme.PayNowFont.standard15B highLightColor:HDAppTheme.PayNowColor.cFD7127];
        _phoneTitleLabel = label;
    }
    return _phoneTitleLabel;
}

- (UIView *)phoneBgView {
    if (!_phoneBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
        view.layer.cornerRadius = kRealWidth(4);
        _phoneBgView = view;
    }
    return _phoneBgView;
}

- (HDUITextField *)phoneTextField {
    if (!_phoneTextField) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:@"" leftLabelString:nil];
        textField.delegate = self;
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.placeholder = PNLocalizedString(@"please_enter", @"请输入");
        config.font = HDAppTheme.PayNowFont.standard15;
        config.textColor = HDAppTheme.PayNowColor.c343B4D;
        config.floatingText = @" ";
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.characterSetString = kCharacterSetStringNumber;
        config.keyboardType = UIKeyboardTypeNumberPad;
        [textField setConfig:config];

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            self.viewModel.customerPhone = text;
            [self ruleLimit];
        };

        _phoneTextField = textField;
    }
    return _phoneTextField;
}

- (SALabel *)noteTitleLabel {
    if (!_noteTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        label.text = PNLocalizedString(@"notes", @"notes");
        _noteTitleLabel = label;
    }
    return _noteTitleLabel;
}

- (UIView *)noteBgView {
    if (!_noteBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
        view.layer.cornerRadius = kRealWidth(4);
        _noteBgView = view;
    }
    return _noteBgView;
}

- (HDTextView *)noteTextView {
    if (!_noteTextView) {
        HDTextView *view = HDTextView.new;
        view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        view.textColor = HDAppTheme.PayNowColor.c343B4D;
        view.maximumTextLength = 500;
        view.delegate = self;
        view.placeholder = PNLocalizedString(@"please_enter_notes", @"请填写备注");
        view.placeholderColor = HDAppTheme.color.G3;
        view.font = HDAppTheme.PayNowFont.standard15;
        view.bounces = false;
        view.showsVerticalScrollIndicator = false;
        view.scrollEnabled = NO;
        _noteTextView = view;
    }
    return _noteTextView;
}

@end
