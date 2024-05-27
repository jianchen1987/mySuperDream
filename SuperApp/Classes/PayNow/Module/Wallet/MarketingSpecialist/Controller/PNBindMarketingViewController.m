//
//  PNBindMarketingViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNBindMarketingViewController.h"
#import "PNInputItemView.h"
#import "PNOperationButton.h"
#import "PNMarketingViewModel.h"
#import "PNCheckMarketingRspModel.h"


@interface PNBindMarketingViewController () <PNInputItemViewDelegate>
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) PNInputItemView *accountInputView;
@property (nonatomic, strong) PNInputItemView *nameInputView;
@property (nonatomic, strong) PNOperationButton *button;
@property (nonatomic, strong) PNMarketingViewModel *viewModel;
@property (nonatomic, strong) PNCheckMarketingRspModel *argModel;
@end


@implementation PNBindMarketingViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.argModel = [PNCheckMarketingRspModel yy_modelWithJSON:[parameters objectForKey:@"data"]];
        self.viewModel.promoterLoginName = self.argModel.promoterLoginName;
    }
    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self.scrollViewContainer addSubview:self.accountInputView];
    [self.scrollViewContainer addSubview:self.nameInputView];
    [self.scrollViewContainer addSubview:self.button];

    [self ruleLimit];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"SOimxbv0", @"绑定推广专员");
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.width.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(12));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
    }];

    [self.accountInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(12));
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(82)));
    }];

    [self.nameInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountInputView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(82)));
    }];

    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameInputView.mas_bottom).offset(kRealWidth(40));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(20));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        self.nameInputView.model.value = self.viewModel.accountName;
        [self.nameInputView update];

        [self ruleLimit];
    }];
}

#pragma mark
- (void)ruleLimit {
    self.viewModel.accountPhoneNumber = self.accountInputView.model.value;
    if (WJIsStringNotEmpty(self.viewModel.accountName) && self.viewModel.isSuccess) {
        self.button.enabled = YES;
    } else {
        self.button.enabled = NO;
    }
}

#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    HDLog(@"pn_textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)pn_textFieldShouldEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
    HDLog(@"pn_textFieldShouldEndEditing");
    return YES;
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    HDLog(@"pn_textFieldDidEndEditing");
    [self ruleLimit];
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(nonnull PNInputItemView *)view {
    HDLog(@"pn_textFieldDidEndEditing");
    self.viewModel.isSuccess = NO;

    [self ruleLimit];
    if (WJIsStringNotEmpty(self.accountInputView.model.value)) {
        [self.viewModel getCoolCashAccountName];
    }
}

#pragma mark
- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"bind_tips11", @"（若您的朋友是我司指定的推广，在您完成首笔国际转账业务时，您与您的朋友都将获取奖励）");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (PNInputItemView *)accountInputView {
    if (!_accountInputView) {
        _accountInputView = [[PNInputItemView alloc] init];
        _accountInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.title = PNLocalizedString(@"RWbJcOVJ", @"请填写您朋友的手机号");
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.bottomLineHeight = PixelOne;
        model.style = PNInputStypeRow_Two;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        model.leftLabelString = @"8550";
        model.valueAlignment = NSTextAlignmentLeft;
        model.valueFont = HDAppTheme.PayNowFont.standard14;

        _accountInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];

        kb.inputSource = _accountInputView.textFiled;
        _accountInputView.textFiled.inputView = kb;
    }
    return _accountInputView;
}

- (PNInputItemView *)nameInputView {
    if (!_nameInputView) {
        _nameInputView = [[PNInputItemView alloc] init];
        _nameInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.title = PNLocalizedString(@"pn_full_name_2", @"姓名");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        model.isUppercaseString = YES;
        model.canInputMoreSpace = NO;
        model.bottomLineHeight = 0;
        model.enabled = NO;
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueAlignment = NSTextAlignmentLeft;
        model.style = PNInputStypeRow_Two;

        _nameInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _nameInputView.textFiled;
        _nameInputView.textFiled.inputView = kb;
    }
    return _nameInputView;
}

- (PNOperationButton *)button {
    if (!_button) {
        _button = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_button setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewModel bindMarketing];
        }];
    }
    return _button;
}

- (PNMarketingViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNMarketingViewModel alloc] init];
    }
    return _viewModel;
}


@end
