//
//  PNUpgradeResultViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUpgradeResultViewController.h"
#import "NSDate+Extension.h"
#import "PNAccountViewModel.h"
#import "PNStepTipsView.h"


@interface PNUpgradeResultViewController ()
@property (nonatomic, strong) PNAccountViewModel *viewModel;

@property (nonatomic, strong) PNStepTipsView *stepView;
@property (nonatomic, assign) PNAccountLevelUpgradeStatus upgradeStatus;

@property (nonatomic, strong) UIImageView *centerIconImgView;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) SALabel *messageLabel;
@property (nonatomic, strong) SAOperationButton *confirmButton;

@end


@implementation PNUpgradeResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Account_authentication", @"账户认证");
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self setData];
    }];

    [self.viewModel getUserInfo];
}

- (void)setData {
    self.upgradeStatus = VipayUser.shareInstance.upgradeStatus;

    if (self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_FAILED || self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_UPGRADING
        || self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_SUCCESS) {
        self.stepView.hidden = YES;
    } else {
        self.stepView.upgradeStatus = self.upgradeStatus;
        self.stepView.hidden = NO;
    }

    self.statusLabel.text = VipayUser.shareInstance.upgradeMessage ?: @"";

    NSString *msg = VipayUser.shareInstance.upgradeDesc ?: @"";
    if (self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_FAILED || self.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_FAILED
        || self.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALFAILED) {
        self.messageLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"Reason_failure", @"失败原因"), msg];
    } else {
        self.messageLabel.text = msg;
    }

    NSString *imageName = @"";
    if (self.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING || self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_UPGRADING
        || self.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALING) {
        imageName = @"pn_certification_under";
    } else if (self.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_SUCCESS || self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_SUCCESS) {
        imageName = @"pn_certification_success";
    } else if (self.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_FAILED || self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_FAILED
               || self.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALFAILED) {
        imageName = @"pn_certification_faild";
    }
    self.centerIconImgView.image = [UIImage imageNamed:imageName];

    ///
    if (self.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING || self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_UPGRADING
        || self.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALING) {
        self.confirmButton.hidden = NO;
        [self.confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成") forState:0];
        [self.confirmButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_SUCCESS) {
        self.confirmButton.hidden = NO;
        [self.confirmButton setTitle:PNLocalizedString(@"btn_register_hint_known", @"我知道了") forState:0];
        [self.confirmButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_FAILED) {
        self.confirmButton.hidden = NO;
        [self.confirmButton setTitle:PNLocalizedString(@"Upgrade_again", @"再次升级") forState:0];
        [self.confirmButton addTarget:self action:@selector(goToUpgradAccount) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.upgradeStatus == PNAccountLevelUpgradeStatus_INTERMEDIATE_SUCCESS) {
        self.confirmButton.hidden = NO;
        [self.confirmButton setTitle:PNLocalizedString(@"Upgrade_Platinum_account", @"升级尊享账户") forState:0];
        [self.confirmButton addTarget:self action:@selector(goToUploadPhotoInHand) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.upgradeStatus == PNAccountLevelUpgradeStatus_APPROVALFAILED) {
        self.confirmButton.hidden = NO;
        [self.confirmButton setTitle:PNLocalizedString(@"Upgrade_again", @"再次升级") forState:0];
        [self.confirmButton addTarget:self action:@selector(goToUpgradAccount) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.upgradeStatus == PNAccountLevelUpgradeStatus_SENIOR_FAILED) {
        /// 有可能一次性升级的时候 被拒绝 【需要判断当前的等级 决定跳转哪个界面】
        //        if (VipayUser.shareInstance.accountLevel == PNUserLevelHonour) {
        //            self.confirmButton.hidden = YES;
        //        } else {
        self.confirmButton.hidden = NO;
        [self.confirmButton setTitle:PNLocalizedString(@"Upgrade_again", @"再次升级") forState:0];
        [self.confirmButton addTarget:self action:@selector(goToUpgradAccount) forControlEvents:UIControlEventTouchUpInside];
        //        }

        [SATalkingData trackEvent:@"升级尊享失败" label:@"尊享失败" parameters:@{
            @"name": VipayUser.shareInstance.loginName,
            @"level": @(VipayUser.shareInstance.accountLevel),
            @"upgradeStatus": @(VipayUser.shareInstance.upgradeStatus),
            @"date": [NSDate dateSecondToDate:[[NSDate date] timeIntervalSince1970] DateFormat:@"yyyy-MM-dd"],
        }];
    }

    [self setNeedsFocusUpdate];
}

/// 去上传手持照片
- (void)goToUploadPhotoInHand {
    [HDMediator.sharedInstance navigaveToPayNowUploadImageVC:@{
        @"viewType": @(1),
        @"upgradeLevel": @(YES),
        @"cardType": @(VipayUser.shareInstance.cardType),
    }];
}

/// 去升级账户
- (void)goToUpgradAccount {
    [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{
        @"needCall": @(YES),
    }];
}

- (void)pop {
    [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletController") animated:YES];
}

#pragma mark
- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.stepView];
    [self.scrollViewContainer addSubview:self.centerIconImgView];
    [self.scrollViewContainer addSubview:self.statusLabel];
    [self.scrollViewContainer addSubview:self.messageLabel];
    [self.view addSubview:self.confirmButton];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.confirmButton.mas_top).offset(kRealWidth(-15));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.scrollViewContainer);
    }];

    [self.centerIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.centerIconImgView.image.size);
        make.top.mas_equalTo(self.stepView.mas_bottom).offset(kRealWidth(30));
        make.centerX.mas_equalTo(self.scrollViewContainer.mas_centerX);
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.centerIconImgView.mas_bottom).offset(kRealWidth(15));
    }];

    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(15));
    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNAccountViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNAccountViewModel alloc] init];
    }
    return _viewModel;
}

- (PNStepTipsView *)stepView {
    if (!_stepView) {
        _stepView = [[PNStepTipsView alloc] init];
        _stepView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _stepView.upgradeStatus = self.upgradeStatus;
    }
    return _stepView;
}

- (UIImageView *)centerIconImgView {
    if (!_centerIconImgView) {
        _centerIconImgView = [[UIImageView alloc] init];
        _centerIconImgView.image = [UIImage imageNamed:@"pn_certification_under"];
    }
    return _centerIconImgView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[SALabel alloc] init];
        _statusLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _statusLabel.font = [HDAppTheme.PayNowFont fontSemibold:17];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (SALabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[SALabel alloc] init];
        _messageLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _messageLabel.font = HDAppTheme.PayNowFont.standard13;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _messageLabel;
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.hidden = YES;
        _confirmButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(20)];
        };
    }
    return _confirmButton;
}

@end
