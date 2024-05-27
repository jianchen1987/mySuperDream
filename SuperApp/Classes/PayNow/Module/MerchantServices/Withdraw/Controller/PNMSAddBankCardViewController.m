//
//  PNMSAddBankCardViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSAddBankCardViewController.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNBankListModel.h"
#import "PNInfoView.h"
#import "PNInputItemView.h"
#import "PNMSBindBankSMSCodeViewController.h"
#import "PNMSWithdranBankInfoModel.h"
#import "PNMSWithdrawViewModel.h"
#import "PNOperationButton.h"


@interface PNMSAddBankCardViewController () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNInfoView *currencyInfoView;
@property (nonatomic, strong) PNInfoView *bankInfoView;
@property (nonatomic, strong) PNInputItemView *accountInputView;
@property (nonatomic, strong) PNInputItemView *accountNameInputView;
@property (nonatomic, strong) PNOperationButton *addBtn;
@property (nonatomic, strong) PNMSWithdrawViewModel *viewModel;
@end


@implementation PNMSAddBankCardViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        /// 借用一下 withdranBankInfoModel
        self.viewModel.withdranBankInfoModel = [[PNMSWithdranBankInfoModel alloc] init];
        self.viewModel.withdranBankInfoModel.currency = [parameters objectForKey:@"currency"];
    }
    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.currencyInfoView];
    [self.scrollViewContainer addSubview:self.bankInfoView];
    [self.scrollViewContainer addSubview:self.accountInputView];
    [self.scrollViewContainer addSubview:self.accountNameInputView];

    [self.view addSubview:self.addBtn];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

    [self.KVOController hd_observe:self.viewModel keyPath:@"rule" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        self.addBtn.enabled = self.viewModel.rule;

        if (self.viewModel.rule) {
            self.accountNameInputView.model.value = self.viewModel.withdranBankInfoModel.accountName;
            [self.accountNameInputView update];
        } else {
            self.accountNameInputView.model.value = @"";
            [self.accountNameInputView update];
        }
    }];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.addBtn.mas_top);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.currencyInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(12));
    }];

    [self.bankInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.currencyInfoView.mas_bottom).offset(kRealWidth(12));
    }];

    [self.accountInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.bankInfoView.mas_bottom);
        make.height.equalTo(@(80));
    }];

    [self.accountNameInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.accountInputView.mas_bottom);
        make.height.equalTo(@(80));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(kRealWidth(16) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)goToSelectBank {
    @HDWeakify(self);
    void (^callBack)(PNBankListModel *) = ^(PNBankListModel *tempModel) {
        @HDStrongify(self);
        self.viewModel.withdranBankInfoModel.participantCode = tempModel.participantCode;
        self.viewModel.withdranBankInfoModel.bankName = tempModel.bin;
        self.bankInfoView.model.valueText = tempModel.bin;
        [self.bankInfoView setNeedsUpdateContent];

        self.viewModel.rule = NO;
        [self.viewModel getAccountName];
    };

    [HDMediator.sharedInstance navigaveToPayNowBankList:@{
        @"navTitle": PNLocalizedString(@"View_support_bank", @"选择收款银行"),
        @"callBack": callBack,
    }];
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view {
    self.viewModel.rule = NO;
    self.viewModel.withdranBankInfoModel.accountNumber = self.accountInputView.model.value;
    [self.viewModel getAccountName];
}

#pragma mark
- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.keyFont = HDAppTheme.PayNowFont.standard14B;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.valueColor = HDAppTheme.PayNowColor.c666666;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.backgroundColor = [UIColor whiteColor];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    return model;
}

- (PNInfoView *)currencyInfoView {
    if (!_currencyInfoView) {
        PNInfoView *view = [[PNInfoView alloc] init];
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"select_currency", @"币种")];
        model.valueText = [self.parameters objectForKey:@"currency"];
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        view.model = model;

        _currencyInfoView = view;
    }
    return _currencyInfoView;
}

- (PNInfoView *)bankInfoView {
    if (!_bankInfoView) {
        PNInfoView *view = [[PNInfoView alloc] init];
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"bank", @"银行")];
        NSString *higStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, PNLocalizedString(@"bank", @"银行")];
        model.attrKey = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                           norFont:HDAppTheme.PayNowFont.standard14B
                                                          norColor:HDAppTheme.PayNowColor.c333333];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");

        model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
        model.enableTapRecognizer = YES;
        model.valueFont = HDAppTheme.PayNowFont.standard15M;
        view.model = model;

        model.eventHandler = ^{
            HDLog(@"要选择银行了");
            [self goToSelectBank];
        };

        _bankInfoView = view;
    }
    return _bankInfoView;
}

- (PNInputItemView *)accountInputView {
    if (!_accountInputView) {
        _accountInputView = [[PNInputItemView alloc] init];
        _accountInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.bottomLineHeight = 0;
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        NSString *higStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, PNLocalizedString(@"pn_receiver_account", @"收款账号")];
        model.attributedTitle = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard15M
                                                            highLightColor:HDAppTheme.PayNowColor.mainThemeColor];
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.bottomLineHeight = PixelOne;
        model.style = PNInputStypeRow_Two;
        model.valueAlignment = NSTextAlignmentLeft;

        _accountInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _accountInputView.textFiled;
        _accountInputView.textFiled.inputView = kb;
    }
    return _accountInputView;
}

- (PNInputItemView *)accountNameInputView {
    if (!_accountNameInputView) {
        _accountNameInputView = [[PNInputItemView alloc] init];
        _accountNameInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.bottomLineHeight = 0;
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        NSString *higStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, PNLocalizedString(@"pn_Receiver_name", @"收款人姓名")];
        model.attributedTitle = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard15M
                                                            highLightColor:HDAppTheme.PayNowColor.mainThemeColor];
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.bottomLineHeight = PixelOne;
        model.style = PNInputStypeRow_Two;
        model.valueAlignment = NSTextAlignmentLeft;
        model.enabled = NO;

        _accountNameInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _accountNameInputView.textFiled;
        _accountNameInputView.textFiled.inputView = kb;
    }
    return _accountNameInputView;
}

- (PNOperationButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_addBtn setTitle:PNLocalizedString(@"pn_Add_bank_card", @"添加银行卡") forState:UIControlStateNormal];
        _addBtn.enabled = NO;
        @HDWeakify(self);
        [_addBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            PNMSWithdranBankInfoModel *model = self.viewModel.withdranBankInfoModel;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:model.accountNumber forKey:@"accountNumber"];
            [dict setValue:model.accountName forKey:@"accountName"];
            [dict setValue:model.participantCode forKey:@"participantCode"];
            [dict setValue:model.currency forKey:@"currency"];

            void (^successHandler)(BOOL) = ^(BOOL isSuccess) {
                HDLog(@"12");
                [self.navigationController popViewControllerAnimated:YES];
            };

            PNMSBindBankSMSCodeViewController *vc = [[PNMSBindBankSMSCodeViewController alloc] initWithRouteParameters:@{
                @"completion": successHandler,
                @"params": dict,
            }];
            [SAWindowManager navigateToViewController:vc];
        }];
    }
    return _addBtn;
}

- (PNMSWithdrawViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNMSWithdrawViewModel alloc] init];
    }
    return _viewModel;
}
@end
