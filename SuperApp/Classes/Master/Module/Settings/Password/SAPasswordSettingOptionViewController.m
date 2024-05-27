
//
//  SAPasswordSettingOptionViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPasswordSettingOptionViewController.h"
#import "SAAppSwitchManager.h"
#import "SAInfoView.h"
#import "SAWalletManager.h"


@interface SAPasswordSettingOptionViewController ()
/// 所有的属性
@property (nonatomic, strong) NSMutableArray *infoViewList;
/// 设置登录密码
@property (nonatomic, strong) SAInfoView *settingLoginPwdView;
/// 修改登录密码
@property (nonatomic, strong) SAInfoView *changeLoginPwdView;
/// 修改支付密码
@property (nonatomic, strong) SAInfoView *changePayPwdView;
@end


@implementation SAPasswordSettingOptionViewController

- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    self.miniumGetNewDataDuration = 1;
    [self.scrollView addSubview:self.scrollViewContainer];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"password_setting", @"密码设置");
}

- (void)hd_getNewData {
    [self.infoViewList removeAllObjects];
    [self.scrollViewContainer hd_removeAllSubviews];

    if (SAUser.shared.hasLoginPwd == SAUserLoginPwdStateNotSet) {
        [self.scrollViewContainer addSubview:self.settingLoginPwdView];
        [self.infoViewList addObject:self.settingLoginPwdView];
    }

    if (SAUser.shared.hasLoginPwd == SAUserLoginPwdStateSetted) {
        [self.scrollViewContainer addSubview:self.changeLoginPwdView];
        [self.infoViewList addObject:self.changeLoginPwdView];
    }

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private methods
CG_INLINE SAInfoViewModel *infoViewModelWithKey(NSString *key) {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.G2;
    model.keyText = key;
    model.lineWidth = PixelOne;
    model.enableTapRecognizer = true;
    model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
    return model;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<SAInfoView *> *visableInfoViews = [self.infoViewList hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    SAInfoView *lastInfoView;
    for (SAInfoView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.scrollViewContainer);
            }
            make.left.equalTo(self.scrollViewContainer);
            make.right.equalTo(self.scrollViewContainer);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateViewConstraints];
}

#pragma mark - lazy load
- (NSMutableArray *)infoViewList {
    if (!_infoViewList) {
        _infoViewList = [NSMutableArray arrayWithCapacity:5];
    }
    return _infoViewList;
}

- (SAInfoView *)settingLoginPwdView {
    if (!_settingLoginPwdView) {
        SAInfoView *view = SAInfoView.new;
        view.model = infoViewModelWithKey(SALocalizedString(@"setting_login_password", @"设置登录密码"));
        view.model.eventHandler = ^{
            // 设置登录密码
            [HDMediator.sharedInstance navigaveToSetPasswordViewController:nil];
        };
        _settingLoginPwdView = view;
    }
    return _settingLoginPwdView;
}

- (SAInfoView *)changeLoginPwdView {
    if (!_changeLoginPwdView) {
        SAInfoView *view = SAInfoView.new;
        view.model = infoViewModelWithKey(SALocalizedString(@"change_login_password", @"修改登录密码"));
        view.model.eventHandler = ^{
            // 修改支付密码
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
            void (^clickedRememberBlock)(void) = ^{
                [HDMediator.sharedInstance navigaveToChangeLoginPasswordViewController:nil];
            };
            params[@"clickedRememberBlock"] = clickedRememberBlock;
            void (^clickedForgetBlock)(void) = ^{
                NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewLoginPage];
                if (switchLine && [switchLine isEqualToString:@"on"]) {
                    if (HDIsStringNotEmpty(SAUser.shared.mobile)) {
                        [HDMediator.sharedInstance navigaveToVerificationCodeViewController:@{
                            @"accountNo": [SAGeneralUtil getShortAccountNoFromFullAccountNo:SAUser.shared.mobile],
                            @"countryCode": [SAGeneralUtil getCountryCodeFromFullAccountNo:SAUser.shared.mobile],
                            @"smsCodeType": SASendSMSTypeResetPassword,
                        }];
                    } else {
                        [HDMediator.sharedInstance navigaveToVerificationCodeViewController:@{
                            @"accountNo": [SAGeneralUtil getShortAccountNoFromFullAccountNo:SAUser.shared.loginName],
                            @"countryCode": [SAGeneralUtil getCountryCodeFromFullAccountNo:SAUser.shared.loginName],
                            @"smsCodeType": SASendSMSTypeResetPassword,
                        }];
                    }

                } else {
                    [HDMediator.sharedInstance navigaveToLoginByVerificationCodeViewController:@{
                        @"accountNo": [SAGeneralUtil getShortAccountNoFromFullAccountNo:SAUser.shared.loginName],
                        @"countryCode": [SAGeneralUtil getCountryCodeFromFullAccountNo:SAUser.shared.loginName],
                        @"smsCodeType": SASendSMSTypeResetPassword,
                    }];
                }
            };
            params[@"clickedForgetBlock"] = clickedForgetBlock;
            params[@"navTitle"] = SALocalizedString(@"change_login_password", @"修改登录密码");
            params[@"tipStr"] = SALocalizedString(@"remember_login_password", @"您是否记得当前的登录密码?");
            [HDMediator.sharedInstance navigaveToWalletChangePayPwdAskingViewController:params];
        };
        _changeLoginPwdView = view;
    }
    return _changeLoginPwdView;
}

@end
