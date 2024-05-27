//
//  SASetPasswordViewController.m
//  SuperApp
//
//  Created by Tia on 2022/9/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASetPasswordViewController.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SALoginGuidePagesViewController.h"
#import "SAPasswordSettingOptionViewController.h"
#import "SASetPasswordView.h"
#import "SASetPasswordViewModel.h"


@interface SASetPasswordViewController ()
/// 内容
@property (nonatomic, strong) SASetPasswordView *contentView;
/// VM
@property (nonatomic, strong) SASetPasswordViewModel *viewModel;
/// skip
@property (nonatomic, strong) HDUIButton *skipBTN;

@end


@implementation SASetPasswordViewController

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"login_new_SetPassword", @"设置密码");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];

    self.hd_interactivePopDisabled = true;
    [self.skipBTN sizeToFit];

    //判断是否为设置密码页进入
    BOOL result = false;
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:SAPasswordSettingOptionViewController.class]) {
            result = true;
            break;
        }
    }

    if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
    } else if (result) {
        self.contentView.tipButton.hidden = true;
    } else {
        self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.skipBTN];
    }
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - private methods
- (void)clickOnSkipButton:(HDUIButton *)button {
    if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
        [LKDataRecord.shared traceClickEvent:@"SMSLoginPage_Set_Password_Page_Skip_click" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginBySMSViewController" area:@"" node:@""]];
    }

    if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
        [LKDataRecord.shared traceClickEvent:@"SMSRegisteredPage_Set_Password_Page_Skip_click" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginBySMSViewController" area:@"" node:@""]];
    }

    NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchAppGuidePage];
    BOOL result = false;
    if (switchLine && [switchLine isEqualToString:@"on"]) {
        result = true;
    }
    if (self.viewModel.isRealRegister && result) {
        [self.navigationController pushViewController:SALoginGuidePagesViewController.new animated:true];
    } else {
        [SAWindowManager switchWindowToMainTabBarControllerCompletion:nil];
    }
}

#pragma mark - lazy load
- (SASetPasswordView *)contentView {
    return _contentView ?: ({ _contentView = [[SASetPasswordView alloc] initWithViewModel:self.viewModel]; });
}

- (SASetPasswordViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SASetPasswordViewModel alloc] init];
        _viewModel.accountNo = [self.parameters objectForKey:@"accountNo"];
        _viewModel.countryCode = [self.parameters objectForKey:@"countryCode"];
        _viewModel.apiTicket = [self.parameters objectForKey:@"apiTicket"];
        _viewModel.smsCodeType = [self.parameters objectForKey:@"smsCodeType"];
        _viewModel.isRealRegister = [[self.parameters objectForKey:@"isRealRegister"] boolValue];
    }
    return _viewModel;
}

- (HDUIButton *)skipBTN {
    if (!_skipBTN) {
        _skipBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _skipBTN.titleLabel.font = HDAppTheme.font.sa_standard14M;
        [_skipBTN setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        [_skipBTN setTitle:SALocalizedString(@"login_new_skip", @"跳过") forState:UIControlStateNormal];
        [_skipBTN addTarget:self action:@selector(clickOnSkipButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBTN;
}

@end
