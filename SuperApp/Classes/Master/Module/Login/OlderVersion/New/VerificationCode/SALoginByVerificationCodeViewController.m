//
//  SALoginByVerificationCodeViewController.m
//  SuperApp
//
//  Created by Tia on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByVerificationCodeViewController.h"
#import "SALoginByVerificationCodeView.h"
#import "SALoginByVerificationCodeViewModel.h"


@interface SALoginByVerificationCodeViewController ()
/// 内容
@property (nonatomic, strong) SALoginByVerificationCodeView *contentView;
/// VM
@property (nonatomic, strong) SALoginByVerificationCodeViewModel *viewModel;

@end


@implementation SALoginByVerificationCodeViewController

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
- (SALoginByVerificationCodeView *)contentView {
    return _contentView ?: ({ _contentView = [[SALoginByVerificationCodeView alloc] initWithViewModel:self.viewModel]; });
}

- (SALoginByVerificationCodeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SALoginByVerificationCodeViewModel.new;
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
