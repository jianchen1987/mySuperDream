//
//  SASettingPayPwdViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASettingPayPwdViewController.h"
#import "SASettingPayPwdView.h"
#import "SASettingPayPwdViewModel.h"


@interface SASettingPayPwdViewController ()
/// 内容
@property (nonatomic, strong) SASettingPayPwdView *contentView;
/// VM
@property (nonatomic, strong) SASettingPayPwdViewModel *viewModel;
/// 类型
@property (nonatomic, assign) SASettingPayPwdActionType actionType;

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@end


@implementation SASettingPayPwdViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.actionType = [[self.parameters objectForKey:@"actionType"] integerValue];
    self.viewModel.successHandler = [self.parameters objectForKey:@"completion"];
    
    return self;
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self.view.window endEditing:true];
    if (self.actionType == SASettingPayPwdActionTypeSetFirst || self.actionType == SASettingPayPwdActionTypeChange || self.actionType == SASettingPayPwdActionTypePinCodeSetting || self.actionType == SASettingPayPwdActionTypePinCodeVerify) {
        !self.viewModel.successHandler ?: self.viewModel.successHandler(true, false);
    }
    [super hd_backItemClick:sender];
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_setupNavigation {
    if (self.actionType == SASettingPayPwdActionTypeConfirmID) {
        self.boldTitle = SALocalizedString(@"validation_pay_password", @"验证支付密码");
        
    } else if (self.actionType == SASettingPayPwdActionTypeSetFirst || self.actionType == SASettingPayPwdActionTypeWalletActivation) {
        self.boldTitle = SALocalizedString(@"setting_pay_password", @"设置支付密码");
        
    } else if (self.actionType == SASettingPayPwdActionTypeSetConfirm || self.actionType == SASettingPayPwdActionTypeChangeConfirm
               || self.actionType == SASettingPayPwdActionTypeWalletActivationConfirm) {
        self.boldTitle = SALocalizedString(@"input_pay_password_again", @"再次输入支付密码");
        
    } else if (self.actionType == SASettingPayPwdActionTypePinCodeSetting || self.actionType == SASettingPayPwdActionTypePinCodeSettingVerify) {
        self.boldTitle = SALocalizedString(@"setPinCode", @"设置Pin-code");
        
    } else if (self.actionType == SASettingPayPwdActionTypePinCodeVerify || self.actionType == SASettingPayPwdActionTypePinCodeNew || self.actionType == SASettingPayPwdActionTypePinCodeNewConfirm) {
        self.boldTitle = SALocalizedString(@"modifyPinCode", @"修改Pin-code");
        
    } else {
        self.boldTitle = SALocalizedString(@"change_pay_password", @"修改支付密码");
        
    }
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
}

- (BOOL)allowContinuousBePushed {
    return true;
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (SASettingPayPwdView *)contentView {
    return _contentView ?: ({ _contentView = [[SASettingPayPwdView alloc] initWithViewModel:self.viewModel]; });
}

- (SASettingPayPwdViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SASettingPayPwdViewModel alloc] init];
        _viewModel.actionType = self.actionType;
        _viewModel.successHandler = [self.parameters objectForKey:@"completion"];
        _viewModel.oldPayPassword = [self.parameters objectForKey:@"oldPayPassword"];
        _viewModel.accessToken = [self.parameters objectForKey:@"accessToken"];
        _viewModel.firstName = [self.parameters objectForKey:@"firstName"];
        _viewModel.lastName = [self.parameters objectForKey:@"lastName"];
        _viewModel.headUrl = [self.parameters objectForKey:@"headUrl"];
        _viewModel.gender = [[self.parameters objectForKey:@"sex"] integerValue];
        _viewModel.birthday = [self.parameters objectForKey:@"birthday"];
        _viewModel.serialNumber = [self.parameters objectForKey:@"serialNumber"];

        _viewModel.verifyParam = [self.parameters objectForKey:@"verifyParam"];
    }
    return _viewModel;
}
@end
