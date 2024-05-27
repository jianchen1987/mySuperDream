//
//  OpenWalletVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOpenWalletVC.h"
#import "PNFlowView.h"
#import "PNIDVerifyViewController.h"
#import "PNNotificationMacro.h"
#import "PNOpenWalletInputVC.h"
#import "PNTypeView.h"
#import "SAMultiLanguageManager.h"
#import "SASettingPayPwdViewController.h"


@interface PNOpenWalletVC ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *tipLabel;
@property (nonatomic, strong) PNTypeView *typeView;
@property (nonatomic, strong) PNFlowView *flowView;
@property (nonatomic, strong) HDUIButton *agreeBtn;
@property (nonatomic, strong) HDUIButton *agreementBtn;
@property (nonatomic, strong) SAOperationButton *openBtn;
/// 服务由CoolCash提供支持
@property (nonatomic, strong) SALabel *coolCashLabel;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) PNWalletViewType viewType;

@property (nonatomic, assign) PNUserLevel accountLevel;

/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL needSetting, BOOL isSuccess);
@end


@implementation PNOpenWalletVC

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    self.successHandler = [self.parameters objectForKey:@"completion"];
    self.viewType = [[self.parameters objectForKey:@"viewType"] integerValue];
    self.accountLevel = [[self.parameters objectForKey:@"accountLevel"] integerValue];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F8F8F8"];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.bgView];
    [self.scrollViewContainer addSubview:self.titleLabel];
    [self.scrollViewContainer addSubview:self.tipLabel];
    [self.scrollViewContainer addSubview:self.typeView];
    [self.scrollViewContainer addSubview:self.flowView];

    [self.view addSubview:self.agreeBtn];
    [self.view addSubview:self.agreementBtn];
    [self.view addSubview:self.openBtn];
    [self.view addSubview:self.coolCashLabel];
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self.view.window endEditing:true];
    !self.successHandler ?: self.successHandler(false, false);
    [super hd_backItemClick:sender];
}

- (void)hd_setupNavigation {
    if (self.viewType == PNWalletViewType_Open) {
        self.boldTitle = PNLocalizedString(@"Open_Account", @"开通钱包");
    } else {
        self.boldTitle = PNLocalizedString(@"pn_activate_wallet", @"钱包激活");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.viewType == PNWalletViewType_Open) {
        if ([SAUser.shared.loginName hasPrefix:@"86"]) {
            [NAT showAlertWithTitle:nil message:PNLocalizedString(@"open_error_tips", @"根据NBC要求，仅允许855手机号开通钱包。") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                            handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                [alertView dismiss];
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
        }
    }
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return false;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.agreeBtn.mas_top).offset(-kRealWidth(15));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.mas_equalTo(self.flowView.mas_bottom);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollViewContainer);
        make.bottom.equalTo(self.typeView.mas_centerY);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(20));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
    }];

    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
    }];

    [self.typeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kRealWidth(20));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.height.equalTo(@(kRealWidth(120)));
    }];

    [self.flowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeView.mas_bottom).offset(kRealWidth(20));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.flowView.lastView.mas_bottom).offset(kRealWidth(15));
    }];

    [self.agreeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.openBtn.mas_top).offset(-kRealWidth(15));
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(15));
    }];

    [self.agreementBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeBtn.mas_right);
        make.centerY.mas_equalTo(self.agreeBtn.mas_centerY);
    }];
    [self.openBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coolCashLabel.mas_top).offset(-kRealWidth(10));
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(50));
    }];

    [self.coolCashLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
    }];
    [super updateViewConstraints];
}

- (void)openBtnTap {
    @HDWeakify(self);
    void (^openWalletCompletion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
        @HDStrongify(self);
        if (isSuccess) { //开通成功
            [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_settting_success", @"设置成功，请牢记支付密码。") type:HDTopToastTypeSuccess];
            SAUser.shared.tradePwdExist = true;
            [SAUser.shared save];
            NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:PNOpenWalletInputVC.class] || [vc isKindOfClass:PNOpenWalletVC.class] || [vc isKindOfClass:SASettingPayPwdViewController.class] ||
                    [vc isKindOfClass:PNIDVerifyViewController.class]) {
                    [marr removeObject:vc];
                }
            }
            self.navigationController.viewControllers = marr;

            [NSNotificationCenter.defaultCenter postNotificationName:kNOTIFICATIONSuccessOpenWallet object:nil];
        }
        !self.successHandler ?: self.successHandler(needSetting, isSuccess);
    };

    if (self.viewType == PNWalletViewType_Open) {
        if ([SAUser.shared.loginName hasPrefix:@"86"]) {
            [NAT showAlertWithTitle:nil message:PNLocalizedString(@"open_error_tips", @"根据NBC要求，仅允许855手机号开通钱包。") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                            handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                [alertView dismiss];
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
        }
        NSDictionary *dic = @{@"actionType": @(2), @"completion": openWalletCompletion};
        [HDMediator.sharedInstance navigaveToPayNowOpenWalletInputVC:dic];
    } else {
        [HDMediator.sharedInstance navigaveToPayNowIdVerifyVC:@{
            @"level": @(self.accountLevel),
            @"completion": openWalletCompletion,
        }];
    }
}

- (void)agreementBtnTap {
    [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName": @"CoolCash", @"navTitle": [NSString stringWithFormat:@"CoolCash%@", SALocalizedString(@"service_agreement", @"服务协议")]}];
}

#pragma mark - lazy load
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"pay_openWalletbg"];
    }
    return _bgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = SALabel.new;
        if (self.viewType == PNWalletViewType_Open) {
            _titleLabel.text = PNLocalizedString(@"open_title", @"开通后您将可享用钱包");
        } else {
            _titleLabel.text = PNLocalizedString(@"pn_after_activation_wallet", @"激活后您将可享用钱包");
        }

        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
            _titleLabel.font = [HDAppTheme.font forSize:15];
        } else {
            _titleLabel.font = [HDAppTheme.font boldForSize:25];
        }
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (SALabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = SALabel.new;
        _tipLabel.text = PNLocalizedString(@"open_tip", @"支付、转账、兑换等相关功能");
        _tipLabel.font = [HDAppTheme.font forSize:15];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (PNTypeView *)typeView {
    if (!_typeView) {
        _typeView = PNTypeView.new;
    }
    return _typeView;
}

- (PNFlowView *)flowView {
    if (!_flowView) {
        _flowView = [[PNFlowView alloc] initWithType:self.viewType];
    }
    return _flowView;
}

- (HDUIButton *)agreeBtn {
    if (!_agreeBtn) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"pay_Unchecked"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pay_checked"] forState:UIControlStateSelected];
        [btn setTitle:PNLocalizedString(@"agree", @"已阅读并同意") forState:0];
        [btn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        btn.titleLabel.font = HDAppTheme.PayNowFont.standard13;
        btn.spacingBetweenImageAndTitle = kRealWidth(5);
        btn.imagePosition = HDUIButtonImagePositionLeft;
        btn.adjustsButtonWhenHighlighted = NO;
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            btn.selected = !btn.isSelected;
            self.openBtn.enabled = btn.isSelected;
        }];
        _agreeBtn = btn;
    }
    return _agreeBtn;
}

- (HDUIButton *)agreementBtn {
    if (!_agreementBtn) {
        HDUIButton *btn = HDUIButton.new;
        [btn setTitle:PNLocalizedString(@"agreement", @"CoolCash服务协议") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(agreementBtnTap) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor hd_colorWithHexString:@"#FD7127"] forState:UIControlStateNormal];
        btn.titleLabel.font = [HDAppTheme.font forSize:13];
        _agreementBtn = btn;
    }
    return _agreementBtn;
}

- (SAOperationButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        if (self.viewType == PNWalletViewType_Open) {
            [_openBtn setTitle:PNLocalizedString(@"open", @"立即开通") forState:UIControlStateNormal];
        } else {
            [_openBtn setTitle:PNLocalizedString(@"pn_activate", @"立即激活") forState:UIControlStateNormal];
        }
        _openBtn.enabled = NO;
        [_openBtn addTarget:self action:@selector(openBtnTap) forControlEvents:UIControlEventTouchUpInside];

        _openBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(25)];
        };
    }
    return _openBtn;
}

- (SALabel *)coolCashLabel {
    if (!_coolCashLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.sa_C2;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = SALocalizedString(@"Powered_by_CoolCash", @"服务由CoolCash提供支持");
        _coolCashLabel = label;
    }
    return _coolCashLabel;
}
@end
