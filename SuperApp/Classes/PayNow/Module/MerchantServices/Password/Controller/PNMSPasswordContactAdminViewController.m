//
//  PNMSPasswordContactAdminViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPasswordContactAdminViewController.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNMSPwdDTO.h"
#import "PNMSRoleManagerInfoModel.h"


@interface PNMSPasswordContactAdminViewController ()
@property (nonatomic, strong) SALabel *topLabel;
@property (nonatomic, strong) PNOperationButton *button;
@property (nonatomic, strong) PNMSRoleManagerInfoModel *model;
@property (nonatomic, strong) PNMSPwdDTO *pwdDTO;
@end


@implementation PNMSPasswordContactAdminViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"change_pay_password", @"修改支付密码");
}

- (void)hd_bindViewModel {
    [self getManagerData];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.button];
}

- (void)updateViewConstraints {
    [self.topLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(16));
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
    }];

    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(20));
        make.top.mas_equalTo(self.topLabel.mas_bottom).offset(kRealWidth(36));
    }];
    [super updateViewConstraints];
}

#pragma mark
- (void)getManagerData {
    [self.view showloading];

    @HDWeakify(self);
    [self.pwdDTO getManagerInfo:^(PNMSRoleManagerInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        self.model = rspModel;

        NSString *hightStr = [NSString stringWithFormat:@"%@ %@", self.model.managerSurname, self.model.managerName];
        NSString *allStr = [NSString stringWithFormat:PNLocalizedString(@"pn_admin_send_sms_code_tips", @"请先联系商户管理员%@重置交易密码，再查看系统发送您手机的短信验证码"), hightStr];
        self.topLabel.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard20B
                                                                   highLightColor:HDAppTheme.PayNowColor.mainThemeColor];

        self.topLabel.hidden = NO;
        self.button.hidden = NO;

        [self.view setNeedsUpdateConstraints];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (SALabel *)topLabel {
    if (!_topLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard20;
        label.numberOfLines = 0;
        label.hidden = YES;
        _topLabel = label;
    }
    return _topLabel;
}

- (PNOperationButton *)button {
    if (!_button) {
        PNOperationButton *btn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [btn setTitle:PNLocalizedString(@"pn_received_sms_code", @"我已收到验证码") forState:UIControlStateNormal];
        btn.hidden = YES;
        _button = btn;

        [_button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesForgotPasswordVerifySMSCodeVC:@{
                @"type": @(1),
            }];
        }];
    }
    return _button;
}

- (PNMSPwdDTO *)pwdDTO {
    if (!_pwdDTO) {
        _pwdDTO = [[PNMSPwdDTO alloc] init];
    }
    return _pwdDTO;
}

@end
