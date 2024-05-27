//
//  SAForgetPasswordOrBindPhoneViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAForgetPasswordOrBindPhoneViewController.h"
#import "SALoginViewModel.h"
#import "SAForgetPasswordOrBindPhoneView.h"


@interface SAForgetPasswordOrBindPhoneViewController ()
/// 内容
@property (nonatomic, strong) SAForgetPasswordOrBindPhoneView *contentView;
/// VM
@property (nonatomic, strong) SALoginViewModel *viewModel;

@end


@implementation SAForgetPasswordOrBindPhoneViewController

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeResetPassword]) {
        self.boldTitle = SALocalizedString(@"login_new_ForgetPassword", @"忘记密码");
    } else { //第三方登录绑定手机 SASendSMSTypeThirdRegister
        self.boldTitle = SALocalizedString(@"login_new_BindMobileNumber", @"绑定手机号");
    }
}

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [super hd_bindViewModel];
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

#pragma mark - lazy load

- (SAForgetPasswordOrBindPhoneView *)contentView {
    return _contentView ?: ({ _contentView = [[SAForgetPasswordOrBindPhoneView alloc] initWithViewModel:self.viewModel]; });
}

- (SALoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SALoginViewModel.new;
        _viewModel.accessToken = [self.parameters objectForKey:@"accessToken"];
        _viewModel.channel = [self.parameters objectForKey:@"channel"];
        _viewModel.thirdUserName = [self.parameters objectForKey:@"thirdUserName"];
        _viewModel.accountNo = [self.parameters objectForKey:@"accountNo"];
        _viewModel.countryCode = [self.parameters objectForKey:@"countryCode"];
        _viewModel.smsCodeType = [self.parameters objectForKey:@"smsCodeType"];
    }
    return _viewModel;
}
@end
