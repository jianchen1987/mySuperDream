//
//  PNWalletSettingViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWalletSettingViewController.h"
#import "PNInfoView.h"
#import "PNPinCodeDTO.h"
#import "SASettingPayPwdViewModel.h"

@interface PNWalletSettingViewController ()
/// 账户信息
@property (nonatomic, strong) PNInfoView *userInfoView;
/// 协议和条款
@property (nonatomic, strong) PNInfoView *termsInfoView;
/// 修改支付密码
@property (nonatomic, strong) PNInfoView *changePayPwdInfoView;
/// 交易记录
@property (nonatomic, strong) PNInfoView *transferBillInfoView;
/// 国际转账交易记录
@property (nonatomic, strong) PNInfoView *interTransferBillInfoView;
/// 限额说明
@property (nonatomic, strong) PNInfoView *walletLimitInfoView;
/// 限额说明
@property (nonatomic, strong) PNInfoView *contactUSInfoView;
/// 钱包明细
@property (nonatomic, strong) PNInfoView *walletOrderListInfoView;
/// 推广专员
@property (nonatomic, strong) PNInfoView *marketingInfoView;
///< 修改pinCode
@property (nonatomic, strong) PNInfoView *modifyPinCodeInfoView;
@property (nonatomic, strong) PNInfoView *setPinCodeInfoView;

@end


@implementation PNWalletSettingViewController

- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
}

- (void)hd_getNewData {
    
    // 先判断有没有设置pincode
    [self showloading];
    @HDWeakify(self);
    [PNPinCodeDTO checkPinCodeExistsCompletion:^(BOOL isExist) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.scrollViewContainer hd_removeAllSubviews];
        
        if (!WJIsArrayEmpty(VipayUser.shareInstance.functionModel.SETTING)) {
            PNWalletListConfigModel *settingModel = VipayUser.shareInstance.functionModel.SETTING.firstObject;
            settingModel.children = [settingModel.children sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(PNWalletListConfigModel  *_Nonnull obj1, PNWalletListConfigModel  *_Nonnull obj2) {
                if(obj1.sort > obj2.sort) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }];
            for (PNWalletListConfigModel *model in settingModel.children) {
                if (model.bizType == PNWalletListItemTypeACCOUNTINFORMATION) {
                    [self.scrollViewContainer addSubview:self.userInfoView];
                }

                if (model.bizType == PNWalletListItemTypeMODIFY_PAYMENT_PASSWORD) {
                    [self.scrollViewContainer addSubview:self.changePayPwdInfoView];
                }

                if (model.bizType == PNWalletListItemTypeWALLET_TRANSACTIONS) {
                    [self.scrollViewContainer addSubview:self.transferBillInfoView];
                }

                if (model.bizType == PNWalletListItemTypeINTERNATIONAL_TRANSFER_HISTORY) {
                    [self.scrollViewContainer addSubview:self.interTransferBillInfoView];
                }

                if (model.bizType == PNWalletListItemTypeTRADING_LIMIT) {
                    [self.scrollViewContainer addSubview:self.walletLimitInfoView];
                }

                if (model.bizType == PNWalletListItemTypeAGREEMENT_TERMS) {
                    [self.scrollViewContainer addSubview:self.termsInfoView];
                }

                if (model.bizType == PNWalletListItemTypeCONTACT_US) {
                    [self.scrollViewContainer addSubview:self.contactUSInfoView];
                }

                if (model.bizType == PNWalletListItemTypeWALLET_DETAILS) {
                    [self.scrollViewContainer addSubview:self.walletOrderListInfoView];
                }

                if (model.bizType == PNWalletListItemTypeMarketing) {
                    [self.scrollViewContainer addSubview:self.marketingInfoView];
                }
                
                if (model.bizType == PNWalletListItemTypePinCodeModify && isExist) {
                    [self.scrollViewContainer addSubview:self.modifyPinCodeInfoView];
                }
                
                if (model.bizType == PNWalletListItemTypePinCodeModify && !isExist) {
                    [self.scrollViewContainer addSubview:self.setPinCodeInfoView];
                }
                
            }
        }
        
        [self.view setNeedsUpdateConstraints];
        
    }];
    
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"settings", @"设置");
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

    NSArray<PNInfoView *> *visableInfoViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(PNInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    PNInfoView *lastInfoView;
    for (PNInfoView *infoView in visableInfoViews) {
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

#pragma mark - private methods
- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.G3;
    model.keyText = key;
    model.enableTapRecognizer = true;
    return model;
}

- (PNInfoViewModel *)infoViewModelWithArrowImageAndKey:(NSString *)key {
    PNInfoViewModel *model = [self infoViewModelWithKey:key];
    model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
    return model;
}

#pragma mark - Action
- (void)tapOnModityPinCode {
    
    void (^completionBlock)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess){
        [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletSettingViewController")];
    };
    
//    void (^completionBlock2)(BOOL) = ^(BOOL isSuccess) {
//        [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletSettingViewController")];
//    };
    
    void (^clickedRememberBlock)(void) = ^{
        // 校验旧密码修改密码
        [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{@"actionType" : @(SASettingPayPwdActionTypePinCodeVerify), @"completion" : completionBlock}];
    };
    
    void (^clickedForgetBlock)(void) = ^{
        /// 忘记密码  发送短信
        [HDMediator.sharedInstance navigaveToForgotPinCodeSendSMSViewController:@{@"completion" : completionBlock}];
    };
    
    [HDMediator.sharedInstance navigaveToWalletChangePayPwdAskingViewController:@{
        @"navTitle" : PNLocalizedString(@"modifyPinCode", @"修改Pin-code"),
        @"tipStr" : @"您是否记得当前的pin-code?",
        @"clickedRememberBlock" : clickedRememberBlock,
        @"clickedForgetBlock" : clickedForgetBlock
    }];
}

- (void)tapOnSettingPinCode {
    void (^completionBlock)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess){
        [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletSettingViewController")];
    };
    
    // 跳转设置pincode
    [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{@"actionType" : @(SASettingPayPwdActionTypePinCodeSetting), @"completion" : completionBlock}];
}


#pragma mark - lazy load
- (PNInfoView *)userInfoView {
    if (!_userInfoView) {
        PNInfoView *view = PNInfoView.new;
        view.model = [self infoViewModelWithArrowImageAndKey:(PNLocalizedString(@"ACCOUNT_INFO", @"账户信息"))];
        view.model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToPayNowAccountInfoVC:@{}];
        };
        _userInfoView = view;
    }
    return _userInfoView;
}

- (PNInfoView *)changePayPwdInfoView {
    if (!_changePayPwdInfoView) {
        PNInfoView *view = PNInfoView.new;
        view.model = [self infoViewModelWithArrowImageAndKey:(SALocalizedString(@"change_pay_password", @"修改支付密码"))];
        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            // 修改支付密码
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
            void (^clickedRememberBlock)(void) = ^{
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
                void (^completion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
                    [self.navigationController popToViewControllerClass:self.class];
                };
                params[@"completion"] = completion;
                // 校验旧密码修改密码
                params[@"actionType"] = @(5);
                [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:params];
                /// SASettingPayPwdViewController
            };
            params[@"clickedRememberBlock"] = clickedRememberBlock;
            void (^clickedForgetBlock)(void) = ^{
                //                [HDMediator.sharedInstance navigaveToWalletChangePayPwdInputSMSCodeViewController:nil];
                [HDMediator.sharedInstance navigaveToPayNowPasswordContactUSVC:@{}];
            };
            params[@"clickedForgetBlock"] = clickedForgetBlock;
            [HDMediator.sharedInstance navigaveToWalletChangePayPwdAskingViewController:params];
        };
        _changePayPwdInfoView = view;
    }
    return _changePayPwdInfoView;
}

- (PNInfoView *)transferBillInfoView {
    if (!_transferBillInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"pn_wallet_transactions", @"钱包交易记录")];
        model.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveToPayNowBillListVC:@{}];
        };
        view.model = model;
        _transferBillInfoView = view;
    }
    return _transferBillInfoView;
}

- (PNInfoView *)interTransferBillInfoView {
    if (!_interTransferBillInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"pn_International_transfer_record", @"国际转账记录   ")];
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToInternationalTransferRecordsListVC:@{}];
        };
        view.model = model;
        _interTransferBillInfoView = view;
    }
    return _interTransferBillInfoView;
}

- (PNInfoView *)walletLimitInfoView {
    if (!_walletLimitInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"2812hSh8", @"交易限额")];
        model.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveToPayNowWalletLimitVC:@{}];
        };
        view.model = model;
        _walletLimitInfoView = view;
    }
    return _walletLimitInfoView;
}

- (PNInfoView *)contactUSInfoView {
    if (!_contactUSInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"pn_contact_us", @"联系我们")];
        model.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveToPayNowContacUSVC:@{}];
        };
        view.model = model;
        _contactUSInfoView = view;
    }
    return _contactUSInfoView;
}

- (PNInfoView *)termsInfoView {
    if (!_termsInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"pn_terms", @"协议和条款")];
        model.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveToPayNowTermsVC:@{}];
        };
        view.model = model;
        _termsInfoView = view;
    }
    return _termsInfoView;
}

- (PNInfoView *)walletOrderListInfoView {
    if (!_walletOrderListInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"INCW7fTD", @"钱包明细")];
        model.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveToWalletOrderListVC:@{}];
        };
        view.model = model;
        _walletOrderListInfoView = view;
    }
    return _walletOrderListInfoView;
}

- (PNInfoView *)marketingInfoView {
    if (!_marketingInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"4zYx8Lji", @"推广专员")];
        model.eventHandler = ^{
            [[HDMediator sharedInstance] navigaveToPayNowMarketingHomeInfoVC:@{}];
        };
        view.model = model;
        _marketingInfoView = view;
    }
    return _marketingInfoView;
}

- (PNInfoView *)modifyPinCodeInfoView {
    if(!_modifyPinCodeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"modifyPinCode", @"修改Pin-code")];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self tapOnModityPinCode];
        };
        view.model = model;
        _modifyPinCodeInfoView = view;
    }
    return _modifyPinCodeInfoView;
}

- (PNInfoView *)setPinCodeInfoView {
    if(!_setPinCodeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"setPinCode", @"设置Pin-code")];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self tapOnSettingPinCode];
        };
        view.model = model;
        _setPinCodeInfoView = view;
    }
    return _setPinCodeInfoView;
}


@end
