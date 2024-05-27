//
//  SAVerificationCodeViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAVerificationCodeViewController.h"
#import "SAVerificationCodeView.h"
#import "SAVerificationCodeViewModel.h"


@interface SAVerificationCodeViewController ()
/// 内容
@property (nonatomic, strong) SAVerificationCodeView *contentView;
/// VM
@property (nonatomic, strong) SAVerificationCodeViewModel *viewModel;

@end


@implementation SAVerificationCodeViewController


- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"login_new_VerificationCode", @"验证码");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[NSNotificationCenter defaultCenter] addObserver:self.contentView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
#pragma clang diagnostic pop
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self.contentView name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - lazy load
- (SAVerificationCodeView *)contentView {
    return _contentView ?: ({ _contentView = [[SAVerificationCodeView alloc] initWithViewModel:self.viewModel]; });
}

- (SAVerificationCodeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SAVerificationCodeViewModel.new;
        _viewModel.accountNo = [self.parameters objectForKey:@"accountNo"];
        _viewModel.countryCode = [self.parameters objectForKey:@"countryCode"];
        _viewModel.smsCodeType = [self.parameters objectForKey:@"smsCodeType"];
        _viewModel.thirdToken = [self.parameters objectForKey:@"thirdToken"];
        _viewModel.channel = [self.parameters objectForKey:@"channel"];
        _viewModel.thirdUserName = [self.parameters objectForKey:@"thirdUserName"];
        _viewModel.isRealRegister = [[self.parameters objectForKey:@"isRealRegister"] boolValue];
        _viewModel.callBack = [self.parameters objectForKey:@"callBack"];
    }
    return _viewModel;
}

@end
