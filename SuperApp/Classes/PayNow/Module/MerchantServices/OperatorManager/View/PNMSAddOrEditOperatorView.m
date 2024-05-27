//
//  PNMSAddOrEditOperatorView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSAddOrEditOperatorView.h"
#import "PNInfoSwitchView.h"
#import "PNInputItemView.h"
#import "PNMSOperatorViewModel.h"


@interface PNMSAddOrEditOperatorView () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNMSOperatorViewModel *viewModel;
/// 钱包账号
@property (nonatomic, strong) PNInputItemView *accountInputView;
/// 姓名
@property (nonatomic, strong) PNInputItemView *nameInputView;
/// 钱包余额查询权限
@property (nonatomic, strong) PNInfoSwitchView *walletPower;
/// 钱包提现权限
@property (nonatomic, strong) PNInfoSwitchView *withdrawPower;
/// 收款数据查询权限
@property (nonatomic, strong) PNInfoSwitchView *collectionPower;
/// 门店管理权限
@property (nonatomic, strong) PNInfoSwitchView *storePower;
/// 商家收款码查询权限
@property (nonatomic, strong) PNInfoSwitchView *receiveCodePower;

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) PNOperationButton *addBtn;
@end


@implementation PNMSAddOrEditOperatorView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!WJIsObjectNil(self.viewModel.operatorInfoModel)) {
            PNMSOperatorInfoModel *infoModel = self.viewModel.operatorInfoModel;
            self.accountInputView.model.value = infoModel.operatorMobile;
            [self.accountInputView update];

            self.nameInputView.model.value = infoModel.name;
            [self.nameInputView update];

            self.walletPower.model.switchValue = infoModel.walletPrower;
            [self.walletPower update];

            self.withdrawPower.model.switchValue = infoModel.withdraowPower;
            [self.withdrawPower update];

            self.collectionPower.model.switchValue = infoModel.collectionPower;
            [self.collectionPower update];

            self.storePower.model.switchValue = infoModel.storePower;
            [self.storePower update];

            self.receiveCodePower.model.switchValue = infoModel.receiverCodePower;
            [self.receiveCodePower update];

            [self ruleLimit];
        }
    }];

    if (WJIsStringNotEmpty(self.viewModel.operatorMobile)) {
        [self.viewModel getOperatorDetail];
    }
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.accountInputView];
    [self.scrollViewContainer addSubview:self.nameInputView];
    [self.scrollViewContainer addSubview:self.walletPower];
    [self.scrollViewContainer addSubview:self.withdrawPower];
    [self.scrollViewContainer addSubview:self.collectionPower];
    [self.scrollViewContainer addSubview:self.storePower];
    [self.scrollViewContainer addSubview:self.receiveCodePower];

    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.addBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self.bottomBgView.mas_top).offset(-kRealWidth(12));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.accountInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(12));
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(82)));
    }];

    [self.nameInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountInputView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(52)));
    }];

    [self.walletPower mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameInputView.mas_bottom).offset(kRealWidth(12));
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.withdrawPower mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.walletPower.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.collectionPower mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.withdrawPower.mas_bottom).offset(kRealWidth(12));
        ;
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.storePower mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionPower.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.receiveCodePower mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storePower.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(kRealWidth(64) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomBgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bottomBgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.bottomBgView.mas_top).offset(kRealWidth(12));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)ruleLimit {
    self.viewModel.operatorInfoModel.operatorMobile = self.accountInputView.model.value;
    if (WJIsStringNotEmpty(self.viewModel.operatorInfoModel.operatorMobile) && self.viewModel.isSuccess) {
        self.addBtn.enabled = YES;
    } else {
        self.addBtn.enabled = NO;
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
- (PNInputItemView *)accountInputView {
    if (!_accountInputView) {
        _accountInputView = [[PNInputItemView alloc] init];
        _accountInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.title = PNLocalizedString(@"pn_coolcash_wallet", @"CoolCash钱包账号");
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.bottomLineHeight = PixelOne;
        model.style = PNInputStypeRow_Two;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        model.leftLabelString = @"8550";
        model.valueAlignment = NSTextAlignmentLeft;
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.enabled = WJIsStringEmpty(self.viewModel.operatorMobile) ? YES : NO;

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
        _nameInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _nameInputView.textFiled;
        _nameInputView.textFiled.inputView = kb;
    }
    return _nameInputView;
}

- (PNInfoSwitchModel *)defaultSwitchModel:(NSString *)title subTitle:(NSString *)subTitle {
    PNInfoSwitchModel *model = [[PNInfoSwitchModel alloc] init];
    model.title = title;
    model.subTitle = subTitle;
    return model;
}

- (PNInfoSwitchView *)walletPower {
    if (!_walletPower) {
        PNInfoSwitchView *sv = [[PNInfoSwitchView alloc] init];
        PNInfoSwitchModel *model = [self defaultSwitchModel:PNLocalizedString(@"pn_Wallet_balance_permission", @"钱包余额查询权限")
                                                   subTitle:PNLocalizedString(@"pn_Open_to_check_wallet_balance", @"启用后可以查询钱包余额")];
        model.valueBlock = ^(BOOL switchValue) {
            self.viewModel.operatorInfoModel.walletPrower = switchValue;
        };
        sv.model = model;

        _walletPower = sv;
    }
    return _walletPower;
}

- (PNInfoSwitchView *)withdrawPower {
    if (!_withdrawPower) {
        PNInfoSwitchView *sv = [[PNInfoSwitchView alloc] init];
        PNInfoSwitchModel *model = [self defaultSwitchModel:PNLocalizedString(@"pn_Wallet_withdrawal_permission", @"钱包提现权限")
                                                   subTitle:PNLocalizedString(@"pn_Open_to_withdraw_from_wallet", @"启用后可以进行钱包提现")];
        model.bottomLineHeight = 0;
        model.valueBlock = ^(BOOL switchValue) {
            self.viewModel.operatorInfoModel.withdraowPower = switchValue;
        };
        sv.model = model;

        _withdrawPower = sv;
    }
    return _withdrawPower;
}

- (PNInfoSwitchView *)collectionPower {
    if (!_collectionPower) {
        PNInfoSwitchView *sv = [[PNInfoSwitchView alloc] init];
        PNInfoSwitchModel *model = [self defaultSwitchModel:PNLocalizedString(@"pn_Receiving_data_permission", @"收款数据查询权限")
                                                   subTitle:PNLocalizedString(@"pn_Open_to_check_merchant", @"启用后有今日收款和交易记录菜单权限，可以查询商户及门店所有收款数据")];
        model.valueBlock = ^(BOOL switchValue) {
            self.viewModel.operatorInfoModel.collectionPower = switchValue;
        };
        sv.model = model;

        _collectionPower = sv;
    }
    return _collectionPower;
}

- (PNInfoSwitchView *)storePower {
    if (!_storePower) {
        PNInfoSwitchView *sv = [[PNInfoSwitchView alloc] init];
        PNInfoSwitchModel *model = [self defaultSwitchModel:PNLocalizedString(@"pn_Store_management_permission", @"门店管理权限")
                                                   subTitle:PNLocalizedString(@"pn_Open_for_store_management", @"启用后有门店管理所有权限")];
        model.valueBlock = ^(BOOL switchValue) {
            self.viewModel.operatorInfoModel.storePower = switchValue;
        };
        sv.model = model;

        _storePower = sv;
    }
    return _storePower;
}

- (PNInfoSwitchView *)receiveCodePower {
    if (!_receiveCodePower) {
        PNInfoSwitchView *sv = [[PNInfoSwitchView alloc] init];
        PNInfoSwitchModel *model = [self defaultSwitchModel:PNLocalizedString(@"pn_Merchant_KHQR_permission", @"商家收款码查询权限")
                                                   subTitle:PNLocalizedString(@"pn_Open_merchant_KHQR_permission", @"启用后有商家收款码查询权限")];
        model.bottomLineHeight = 0;
        model.valueBlock = ^(BOOL switchValue) {
            self.viewModel.operatorInfoModel.receiverCodePower = switchValue;
        };
        sv.model = model;

        _receiveCodePower = sv;
    }
    return _receiveCodePower;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        _bottomBgView = view;
    }
    return _bottomBgView;
}

- (PNOperationButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_addBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成") forState:UIControlStateNormal];
        _addBtn.enabled = NO;
        @HDWeakify(self);
        [_addBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewModel saveOrUpdateOperatorInfo];
        }];
    }
    return _addBtn;
}
@end
