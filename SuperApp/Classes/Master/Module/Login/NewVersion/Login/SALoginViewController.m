//
//  SALoginViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/16.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SALoginViewController.h"
#import "SAAlertView.h"
#import "SAAppEnvManager.h"
#import "SAAppTheme.h"
#import "SAChangeAppEnvViewPresenter.h"
#import "SACommonConst.h"
#import "SALoginAdManager.h"
#import "SALoginBannerCollectionViewCell.h"
#import "SALoginWithPasswordViewController.h"
#import "SAStartupAdVideoView.h"
#import "SALoginByThirdPartySubView.h"
#import "SALoginByThirdPartyOrView.h"
#import "SAAppSwitchManager.h"
#import "SAPayHelper.h"
#import "SALoginByPasswordViewController.h"
#import "SALoginViewModel.h"
#import "SALoginWithFastViewController.h"
#import "LKDataRecord.h"
#import "SALabel.h"


@interface SALoginViewController ()

@property (nonatomic, strong) UIView *topBgView;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 切换环境按钮
@property (nonatomic, strong) HDUIButton *switchEnvBTN;
/// logo
@property (nonatomic, strong) UIImageView *logoView;
/// logo标题
@property (nonatomic, strong) UILabel *logoLabel;
/// 注册或登录文言
@property (nonatomic, strong) UILabel *textLabel;
/// 提示文言
@property (nonatomic, strong) SALabel *tipLabel;

@property (nonatomic, strong) SALoginByThirdPartySubView *fbView;
@property (nonatomic, strong) SALoginByThirdPartySubView *appleView;
@property (nonatomic, strong) SALoginByThirdPartySubView *wechatView;
@property (nonatomic, strong) SALoginByThirdPartySubView *smsView;

@property (nonatomic, strong) SALoginByThirdPartyOrView *orView;

@property (nonatomic, strong) SALoginByThirdPartySubView *accountView;
/// 协议
@property (nonatomic, strong) YYLabel *agreementLB;

@property (nonatomic, strong) SALoginViewModel *viewModel;

@end


@implementation SALoginViewController

- (void)hd_setupViews {
    [self.view addSubview:self.topBgView];
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.logoLabel];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.fbView];
    [self.view addSubview:self.appleView];
    [self.view addSubview:self.wechatView];
    [self.view addSubview:self.smsView];
    [self.view addSubview:self.orView];
    [self.view addSubview:self.accountView];
    [self.view addSubview:self.agreementLB];

    if (@available(iOS 13.0, *)) { //苹果登录iOS13之后才支持
        self.appleView.hidden = false;
    }

    NSString *wechatSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchWechatLogin];
    if (HDIsStringNotEmpty(wechatSwitch) && [wechatSwitch isEqualToString:@"on"]) {
        if ([SAPayHelper isSupportWechatPayAppNotInstalledHandler:nil appNotSupportApiHandler:nil]) {
            self.wechatView.hidden = false;
        }
    }

    NSString *thirdPartLoginSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchThirdPartLogin];
    if (thirdPartLoginSwitch && [thirdPartLoginSwitch isEqualToString:@"on"]) {
    } else {
        // 先隐藏
        self.appleView.hidden = true;
        self.fbView.hidden = true;
        self.wechatView.hidden = true;
    }

    //判断上一次登录成功的
    NSInteger lastLoginType = [SAUser lastLoginUserType];
    if (lastLoginType != 0) {
        SALoginWithFastViewController *vc = SALoginWithFastViewController.new;
        [self.navigationController pushViewController:vc animated:NO];
    }
    HDLog(@"上次成功登录方式 = %ld", lastLoginType);

    [LKDataRecord.shared tracePVEvent:@"Registration_LoginPageView" parameters:nil SPM:nil];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_setupNavigation {
#if EnableDebug
    self.hd_navigationItem.titleView = self.switchEnvBTN;
#endif
    self.hd_statusBarStyle = UIStatusBarStyleDefault;

    self.hd_navLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.closeBTN]];
}

- (void)updateViewConstraints {
    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.height.equalTo(self.topBgView.mas_width);
    }];

    [self.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneXSeries) {
            make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(40);
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }
        make.centerX.equalTo(self.view);
        //        make.size.mas_equalTo(CGSizeMake(150, 86));
    }];


    [self.logoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoView.mas_bottom).offset(12);
        make.height.mas_equalTo(22);
    }];

    CGFloat height = 44;
    CGFloat margin = 12;

    [self.agreementLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        if (iPhoneXSeries) {
            make.bottom.mas_offset(-kiPhoneXSeriesSafeBottomHeight - 32);
        } else {
            make.bottom.mas_offset(-kiPhoneXSeriesSafeBottomHeight - 10);
        }
    }];

    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        if (iPhoneXSeries) {
            make.bottom.equalTo(self.agreementLB.mas_top).offset(-margin * 2);
        } else {
            make.bottom.equalTo(self.agreementLB.mas_top).offset(-margin);
        }
    }];


    [self.orView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        if (iPhoneXSeries) {
            make.bottom.equalTo(self.accountView.mas_top).offset(-margin * 1.5);
        } else {
            make.bottom.equalTo(self.accountView.mas_top).offset(-margin);
        }
    }];


    [self.smsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        if (iPhoneXSeries) {
            make.bottom.equalTo(self.orView.mas_top).offset(-margin * 1.5);
        } else {
            make.bottom.equalTo(self.orView.mas_top).offset(-margin);
        }
    }];


    UIView *targetView = self.smsView;

    if (!self.wechatView.hidden) {
        [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
            make.bottom.equalTo(self.smsView.mas_top).offset(-8);
        }];
        targetView = self.wechatView;
    }

    if (!self.appleView.hidden) {
        [self.appleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
            make.bottom.equalTo(targetView.mas_top).offset(-8);
        }];
        targetView = self.appleView;
    }

    if (!self.fbView.hidden) {
        [self.fbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
            make.bottom.equalTo(targetView.mas_top).offset(-8);
        }];
        targetView = self.fbView;
    }
    if (!self.tipLabel.hidden) {
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
            if (iPhoneXSeries) {
                make.top.equalTo(self.textLabel.mas_bottom).offset(16);
                make.bottom.equalTo(self.fbView.mas_top).offset(-16);
            } else {
                make.top.equalTo(self.textLabel.mas_bottom).offset(margin);
                make.bottom.equalTo(self.fbView.mas_top).offset(-margin);
            }
        }];
        targetView = self.tipLabel;
    }

    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.bottom.equalTo(targetView.mas_top).offset(-margin);
        if (iPhoneXSeries) {
            make.height.mas_equalTo(36);
        }
    }];

    [super updateViewConstraints];
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


- (void)updateAgreementText {
    NSString *stringBlack1 = SALocalizedString(@"login_new2_User Agreement", @"《用户协议》");
    NSString *stringBlack2 = SALocalizedString(@"login_new2_Privacy Policy", @"《隐私政策》");
    NSString *stringGray = [NSString stringWithFormat:SALocalizedString(@"login_new2_tip9", @"创建/使用您的用户账号表示接受我们的 %@ 及 %@"), stringBlack1, stringBlack2];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:stringGray];

    text.yy_font = HDAppTheme.font.sa_standard12;
    text.yy_color = UIColor.sa_C666;

    [text yy_setTextHighlightRange:[stringGray rangeOfString:stringBlack1] color:UIColor.sa_C333 backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/legal-policies"}];
                         }];


    [text yy_setTextHighlightRange:[stringGray rangeOfString:stringBlack2] color:UIColor.sa_C333 backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/legal-policies"}];
                         }];

    [text addAttribute:NSFontAttributeName value:HDAppTheme.font.sa_standard12SB range:[stringGray rangeOfString:stringBlack1]];
    [text addAttribute:NSFontAttributeName value:HDAppTheme.font.sa_standard12SB range:[stringGray rangeOfString:stringBlack2]];

    [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[stringGray rangeOfString:stringBlack1]];
    [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[stringGray rangeOfString:stringBlack2]];

    self.agreementLB.attributedText = text;
    self.agreementLB.textAlignment = NSTextAlignmentCenter;
}


#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

#pragma mark - lazy load
- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = UIView.new;
        _topBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            // gradient
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = view.bounds;
            gl.startPoint = CGPointMake(0.5, 0);
            gl.endPoint = CGPointMake(0.5, 1);
            gl.colors = @[
                (__bridge id)[UIColor colorWithRed:252 / 255.0 green:32 / 255.0 blue:64 / 255.0 alpha:0.12].CGColor,
                (__bridge id)[UIColor colorWithRed:252 / 255.0 green:32 / 255.0 blue:64 / 255.0 alpha:0.0].CGColor
            ];
            gl.locations = @[@(0.0f), @(1.0f)];
            [view.layer addSublayer:gl];
        };
    }
    return _topBgView;
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_login_close"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.navigationController dismissAnimated:true completion:nil];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}

- (HDUIButton *)switchEnvBTN {
    if (!_switchEnvBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColor.sa_C333 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SAAppEnvManager.sharedInstance.appEnvConfig.name forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [btn.window endEditing:true];
            [SAChangeAppEnvViewPresenter showChangeAppEnvViewViewWithChoosedItemHandler:^(SAAppEnvConfig *_Nullable model) {
                if (model) {
                    [btn setTitle:model.name forState:UIControlStateNormal];
                    [btn sizeToFit];
                }
            }];
        }];
        [button sizeToFit];
        _switchEnvBTN = button;
    }
    return _switchEnvBTN;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    }
    return _logoView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        UILabel *label = UILabel.new;
        label.font = HDAppTheme.font.sa_standard16;
        label.textColor = UIColor.sa_C1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = SALocalizedString(@"login_new2_Make Life Easy", @"让生活变得更简单");
        _logoLabel = label;
    }
    return _logoLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = UILabel.new;
        _textLabel.text = SALocalizedString(@"login_new2_Register or Sign In", @"注册或登录");
        _textLabel.textColor = UIColor.sa_C333;
        _textLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    }
    return _textLabel;
}

- (SALabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = SALabel.new;
        _tipLabel.numberOfLines = 0;

        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 5;

        NSString *sufText = SALocalizedString(@"login_new2_tip2-1", @"请允许 Facebook 上对大象APP的权限");
        NSString *fullText = [NSString stringWithFormat:SALocalizedString(@"login_new2_tip2", @"为了后续的验证和联系，我们需要存取您的Facebook电子邮件，%@，然后再尝试注册"), sufText];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]
            initWithString:fullText
                attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard12, NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: style}];

        [attStr addAttributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard12SB} range:[fullText rangeOfString:sufText]];
        _tipLabel.attributedText = attStr;
        _tipLabel.backgroundColor = UIColor.sa_C333;
        _tipLabel.hd_edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        _tipLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (SALoginByThirdPartySubView *)fbView {
    if (!_fbView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new2_Continue with Facebook", @"以Facebook账户继续")
                                                                                     iconName:@"icon_login_facebook"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            [self.viewModel handleThirdParthLoginWithType:SALoginWithThirdPartyViewTypeFacebook];

            [LKDataRecord.shared traceClickEvent:@"Registration_LoginPageFacebookButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginViewController" area:@"" node:@""]];
        };
        _fbView = v;
    }
    return _fbView;
}

- (SALoginByThirdPartySubView *)appleView {
    if (!_appleView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new2_Continue with Apple", @"以Apple账户继续") iconName:@"icon_login_apple"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            [self.viewModel handleThirdParthLoginWithType:SALoginWithThirdPartyViewTypeApple];

            [LKDataRecord.shared traceClickEvent:@"Registration_LoginPageAppleButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginViewController" area:@"" node:@""]];
        };
        _appleView = v;
        _appleView.hidden = true;
    }
    return _appleView;
}

- (SALoginByThirdPartySubView *)wechatView {
    if (!_wechatView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new2_Continue with Wechat", @"以微信账户继续") iconName:@"icon_login_wechat"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            [self.viewModel handleThirdParthLoginWithType:SALoginWithThirdPartyViewTypeWechat];

            [LKDataRecord.shared traceClickEvent:@"Registration_LoginPageWechatButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginViewController" area:@"" node:@""]];
        };
        _wechatView = v;
        _wechatView.hidden = true;
    }
    return _wechatView;
}

- (SALoginByThirdPartySubView *)smsView {
    if (!_smsView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new2_Continue with SMS", @"以手机短信继续") iconName:@"icon_login_msg_red"];
        v.clickBlock = ^{
            [HDMediator.sharedInstance navigaveToLoginWithSMSViewController:@{}];

            [LKDataRecord.shared traceClickEvent:@"Registration_LoginPageSmsButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginViewController" area:@"" node:@""]];
        };
        _smsView = v;
    }
    return _smsView;
}

- (SALoginByThirdPartyOrView *)orView {
    if (!_orView) {
        _orView = SALoginByThirdPartyOrView.new;
    }
    return _orView;
}

- (SALoginByThirdPartySubView *)accountView {
    if (!_accountView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new2_Account Password Sign in", @"账号密码登录") iconName:nil];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            SALoginWithPasswordViewController *vc = SALoginWithPasswordViewController.new;
            [self.navigationController pushViewController:vc animated:YES];

            [LKDataRecord.shared traceClickEvent:@"Registration_LoginPageAccountPasswordButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginViewController" area:@"" node:@""]];
        };
        _accountView = v;
    }
    return _accountView;
}

- (YYLabel *)agreementLB {
    if (!_agreementLB) {
        _agreementLB = [[YYLabel alloc] init];
        _agreementLB.preferredMaxLayoutWidth = SCREEN_WIDTH - 24; //自适应高度
        _agreementLB.numberOfLines = 0;
        [self updateAgreementText];
    }
    return _agreementLB;
}

- (SALoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SALoginViewModel.new;
        @HDWeakify(self);
        _viewModel.facebookLoginFailBlock = ^{
            @HDStrongify(self);
            self.tipLabel.hidden = NO;
            [self updateViewConstraints];
        };
    }
    return _viewModel;
}

@end
