//
//  SALoginWithLastTypeViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SALoginWithFastViewController.h"
#import "LKDataRecord.h"
#import "SALoginAreaCodeView.h"
#import "SALoginViewModel.h"
#import "SALoginByPasswordRightView.h"
#import "SALoginByThirdPartySubView.h"
#import "SALoginByThirdPartyOrView.h"


@interface SALoginWithFastViewController ()
/// VM
@property (nonatomic, strong) SALoginViewModel *viewModel;
/// 头部
@property (nonatomic, strong) UILabel *headerLabel;
/// 头像
@property (nonatomic, strong) UIImageView *avatarView;
/// 名称
@property (nonatomic, strong) UILabel *nameLabel;
/// 三方登录
@property (nonatomic, strong) SALoginByThirdPartySubView *thirdPartView;
/// 密码输入框
@property (nonatomic, strong) HDUITextField *passwordTF;
/// 登陆按钮
@property (nonatomic, strong) SAOperationButton *loginBTN;
/// rightView
@property (nonatomic, strong) SALoginByPasswordRightView *rightView;
/// 忘记密码按钮
@property (nonatomic, strong) UIButton *forgetBTN;

@property (nonatomic, strong) SALoginByThirdPartyOrView *orView;

@property (nonatomic, strong) SALoginByThirdPartySubView *accountView;

@end


@implementation SALoginWithFastViewController

- (void)hd_setupViews {
    [super hd_setupViews];

    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.thirdPartView];

    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.loginBTN];
    [self.view addSubview:self.forgetBTN];

    [self.view addSubview:self.orView];
    [self.view addSubview:self.accountView];


    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:SAUser.lastLoginUserHeadURL] placeholderImage:[UIImage imageNamed:@"neutral"]];
    self.nameLabel.text = SAUser.lastLoginUserShowName;


    self.passwordTF.hidden = YES;
    self.loginBTN.hidden = YES;
    self.forgetBTN.hidden = YES;
    self.rightView.hidden = YES;

    if (SAUser.lastLoginUserType == 4) { // apple
        [self.thirdPartView resetIcon:@"icon_login_apple_white" textColor:UIColor.whiteColor text:SALocalizedString(@"login_new2_Sign in with Apple", @"以Apple账户登录")
                      backgroundColor:UIColor.sa_C333];
    } else if (SAUser.lastLoginUserType == 3) { // FB
        [self.thirdPartView resetIcon:@"icon_login_facebook_white" textColor:UIColor.whiteColor text:SALocalizedString(@"login_new2_Sign in with Facebook", @"以Facebook账户登录")
                      backgroundColor:[UIColor hd_colorWithHexString:@"#3875EA"]];
    } else if (SAUser.lastLoginUserType == 2) { // wechat
        [self.thirdPartView resetIcon:@"icon_login_wechat_white" textColor:UIColor.whiteColor text:SALocalizedString(@"login_new2_Sign in with Wechat", @"以微信账户登录")
                      backgroundColor:[UIColor hd_colorWithHexString:@"#09BB07"]];
    } else if (SAUser.lastLoginUserType == 1) { //密码登录
        self.thirdPartView.hidden = YES;
        self.passwordTF.hidden = NO;
        self.loginBTN.hidden = NO;
        self.forgetBTN.hidden = NO;
        self.rightView.hidden = NO;

        //脱敏处理
        NSString *text = SAUser.lastLoginUserShowName;
        NSString *countryCode = @"";
        if (text.length > 3) {
            countryCode = [text substringToIndex:3];
        }
        if (text.length > 4) {
            text = [text substringFromIndex:text.length - 4];
        }

        text = [NSString stringWithFormat:@"%@****%@", countryCode, text];
        self.nameLabel.text = text;
    }

    [LKDataRecord.shared tracePVEvent:@"FastLoginPageView" parameters:nil SPM:nil];
}

- (void)hd_bindViewModel {
    [super hd_bindViewModel];

    [self.viewModel hd_bindView:self.view];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BeginIgnoreClangWarning(-Wundeclared - selector);

    [NSNotificationCenter.defaultCenter addObserver:self.viewModel selector:@selector(receiveWechatAuthLoginResp:) name:kNotificationWechatAuthLoginResponse object:nil];
    EndIgnoreClangWarning
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self.viewModel name:kNotificationWechatAuthLoginResponse object:nil];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (void)updateViewConstraints {
    CGFloat margin = 12;
    CGFloat height = 44;

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
    }];

    [self.avatarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 88));
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.headerLabel.mas_bottom).offset(2 * margin);
    }];


    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.height.mas_equalTo(30);
    }];

    if (!self.thirdPartView.hidden) {
        [self.thirdPartView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2 * margin);
        }];
    }

    if (SAUser.lastLoginUserType == 1) {
        [self.rightView sizeToFit];
        [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(margin);
            make.right.mas_equalTo(self.view).offset(-margin);
            make.height.mas_equalTo(55);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2 * margin);
        }];

        [self.loginBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTF.mas_bottom).offset(kRealWidth(32));
            make.centerX.mas_equalTo(self.view);
            make.width.equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
            make.height.mas_equalTo(margin * 4);
        }];

        [self.forgetBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.loginBTN.mas_bottom).offset(kRealWidth(8));
        }];
    }

    [self.orView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.equalTo(self.accountView.mas_top).offset(-18);
    }];

    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.mas_offset(-kiPhoneXSeriesSafeBottomHeight - 32);
    }];

    [super updateViewConstraints];
}

#pragma mark - private methods
- (void)_fixLoginBtnState {
    self.loginBTN.enabled = self.passwordTF.validInputText.length >= 6;
}

#pragma mark - event response
- (void)clickedLoginBTNHandler {
    [self.view endEditing:true];

    NSString *fullLastLoginName = SAUser.lastLoginFullAccount;
    if (HDIsStringNotEmpty(fullLastLoginName) && fullLastLoginName.length > 4) {
        BOOL hasPrefix86 = [fullLastLoginName hasPrefix:@"86"];

        NSString *phoneNumber = SAUser.lastLoginAccount;
        NSString *countryCode = hasPrefix86 ? @"86" : @"855";

        self.viewModel.countryCode = countryCode;
        self.viewModel.accountNo = phoneNumber;

        [self.viewModel loginWithplainPwd:self.passwordTF.validInputText];

        [LKDataRecord.shared traceClickEvent:@"FastLoginPageLoginClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithFastViewController" area:@"" node:@""]];
    }
}


#pragma mark - lazy load
- (SALoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SALoginViewModel.new;
    }
    return _viewModel;
}


- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = UILabel.new;
        label.text = SALocalizedString(@"login_new_WelcomeBack", @"欢迎回来");
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
}


- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithImage:[HDHelper placeholderImage]];
        _avatarView.layer.borderWidth = 2;
        _avatarView.layer.borderColor = [UIColor colorWithRed:233 / 255.0 green:234 / 255.0 blue:239 / 255.0 alpha:1.0].CGColor;
        _avatarView.layer.cornerRadius = 44;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = UILabel.new;
        label.text = @"JACK";
        label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
        label.textColor = HDAppTheme.color.sa_C333;
        label.textAlignment = NSTextAlignmentCenter;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALoginByThirdPartySubView *)thirdPartView {
    if (!_thirdPartView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new_SignInWithAPPLEID", @"APPLE ID 登录") iconName:@"icon_login_apple"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            if (SAUser.lastLoginUserType == 4) {
                [self.viewModel handleThirdParthLoginWithType:SALoginWithThirdPartyViewTypeApple];
            } else if (SAUser.lastLoginUserType == 3) {
                [self.viewModel handleThirdParthLoginWithType:SALoginWithThirdPartyViewTypeFacebook];
            } else if (SAUser.lastLoginUserType == 2) {
                [self.viewModel handleThirdParthLoginWithType:SALoginWithThirdPartyViewTypeWechat];
            }
            [LKDataRecord.shared traceClickEvent:@"FastLoginPageLoginClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithFastViewController" area:@"" node:@""]];
        };
        _thirdPartView = v;
    }
    return _thirdPartView;
}

- (HDUITextField *)passwordTF {
    if (!_passwordTF) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:nil rightLabelString:nil];

        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.font sa_fontDINBold:18];
        config.textColor = HDAppTheme.color.sa_C333;
        config.maxInputLength = 20;
        config.secureTextEntry = YES;
        config.floatingText = @" ";
        config.characterSetString = kCharacterSetStringNumberAndLetterAndSpecialCharacters;
        config.rightLabelFont = HDAppTheme.font.standard3;
        config.rightLabelColor = HDAppTheme.color.C1;
        config.bottomLineSelectedColor = config.bottomLineNormalColor;
        config.textFieldTintColor = HDAppTheme.color.sa_C1;
        [textField setConfig:config];

        textField.inputTextField.attributedPlaceholder =
            [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_EnterPassword", @"输入密码")
                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14, NSForegroundColorAttributeName: HDAppTheme.color.sa_searchBarTextColor}];
        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = SALocalizedString(@"keyboard_brand_title", @"WOWNOW 安全键盘");
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapableCanSwitchToASCII theme:theme];

        kb.inputSource = textField.inputTextField;
        textField.inputTextField.inputView = kb;

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self _fixLoginBtnState];
        };
        CGSize rightViewSize = [self.rightView layoutImmediately];
        self.rightView.frame = CGRectMake(0, 0, rightViewSize.width, rightViewSize.height);
        [textField setCustomRightView:self.rightView];
        _passwordTF = textField;
    }
    return _passwordTF;
}

- (SALoginByPasswordRightView *)rightView {
    if (!_rightView) {
        _rightView = SALoginByPasswordRightView.new;
        @HDWeakify(self);
        _rightView.showPlainPwdButtonClickedHandler = ^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            self.passwordTF.inputTextField.secureTextEntry = !btn.isSelected;
        };
    }
    return _rightView;
}

- (SAOperationButton *)loginBTN {
    if (!_loginBTN) {
        _loginBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _loginBTN.titleLabel.font = HDAppTheme.font.sa_standard16H;
        [_loginBTN addTarget:self action:@selector(clickedLoginBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _loginBTN.enabled = false;
        [_loginBTN setTitle:SALocalizedString(@"login_new_SignIn", @"登录") forState:UIControlStateNormal];
    }
    return _loginBTN;
}

- (UIButton *)forgetBTN {
    if (!_forgetBTN) {
        @HDWeakify(self);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_ForgetPassword", @"忘记密码") attributes:@{
            NSFontAttributeName: HDAppTheme.font.sa_standard12M,
            NSForegroundColorAttributeName: HDAppTheme.color.sa_C333,
            NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]
        }];

        [button setAttributedTitle:string forState:UIControlStateNormal];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.view endEditing:YES];


            NSString *phoneNumber = @"";
            NSString *countryCode = @"855";

            NSString *fullLastLoginName = SAUser.lastLoginFullAccount;
            if (HDIsStringNotEmpty(fullLastLoginName) && fullLastLoginName.length > 4) {
                BOOL hasPrefix86 = [fullLastLoginName hasPrefix:@"86"];
                phoneNumber = SAUser.lastLoginAccount;
                countryCode = hasPrefix86 ? @"86" : @"855";
            }

            [HDMediator.sharedInstance navigaveToForgetPasswordOrBindPhoneViewController:@{@"countryCode": countryCode, @"smsCodeType": SASendSMSTypeResetPassword, @"accountNo": phoneNumber}];
        }];
        _forgetBTN = button;
    }
    return _forgetBTN;
}


- (SALoginByThirdPartyOrView *)orView {
    if (!_orView) {
        _orView = SALoginByThirdPartyOrView.new;
    }
    return _orView;
}

- (SALoginByThirdPartySubView *)accountView {
    if (!_accountView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new2_Switch account or register", @"切换账号或注册") iconName:nil];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            [self.navigationController popViewControllerAnimated:YES];

            [LKDataRecord.shared traceClickEvent:@"FastLoginPageSwitchAccountClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithFastViewController" area:@"" node:@""]];
        };
        _accountView = v;
    }
    return _accountView;
}


@end
