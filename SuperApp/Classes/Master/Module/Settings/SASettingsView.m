//
//  SASettingsView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASettingsView.h"
#import "PNMultiLanguageManager.h" //支付语言
#import "SAApolloManager.h"
#import "SAAppSwitchManager.h"
#import "SAAppVersionViewModel.h"
#import "SAInfoView.h"
#import "SAMissingNotificationTipView.h"
#import "SARemoteNotifyViewModel.h"
#import "SASettingsViewModel.h"
#import "SAUserViewModel.h"
#import "SAVersionAlertManager.h"
#import "SAVersionAlertViewConfig.h"
#import "VipayUser.h"
#import <HDServiceKit/WNHelloWebSocketClient.h>
#import <KSInstantMessagingKit/KSCore.h>
#import "SASystemSettingsViewController.h"
#import "SASetPhoneViewController.h"


@interface SASettingsView ()
/// 我的信息
@property (nonatomic, strong) SAInfoView *myInfoView;
/// 密码
@property (nonatomic, strong) SAInfoView *passwordView;
/// 通知
@property (nonatomic, strong) SAInfoView *notificationView;
/// 通知提示
//@property (nonatomic, strong) SAMissingNotificationTipView *notificationTipView;
/// 缓存
@property (nonatomic, strong) SAInfoView *cacheView;
/// 政策
@property (nonatomic, strong) SAInfoView *policyView;
/// coolcash协议
@property (nonatomic, strong) SAInfoView *coolcashView;
/// coolcash oct协议
@property (nonatomic, strong) SAInfoView *coolcashOCTView;
/// 注销账号
@property (nonatomic, strong) SAInfoView *cancellationView;
/// app版本
@property (nonatomic, strong) SAInfoView *appVersionView;
/// 登出按钮
@property (nonatomic, strong) SAOperationButton *logoutBTN;
/// VM
@property (nonatomic, strong) SASettingsViewModel *viewModel;
/// 用户操作 VM
@property (nonatomic, strong) SAUserViewModel *userViewModel;
/// 通知 VM
@property (nonatomic, strong) SARemoteNotifyViewModel *remoteNotifyVM;
/// app 版本 VM
@property (nonatomic, strong) SAAppVersionViewModel *appVersionViewModel;

@property (nonatomic, strong) dispatch_group_t taskGroup; ///< 任务组

/// 语音通话测试
//@property (nonatomic, strong) SAInfoView *audioCallView;

@end


@implementation SASettingsView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.myInfoView];
    [self.scrollViewContainer addSubview:self.passwordView];
    [self.scrollViewContainer addSubview:self.notificationView];
    //    [self.scrollViewContainer addSubview:self.notificationTipView];
    [self.scrollViewContainer addSubview:self.cacheView];
    [self.scrollViewContainer addSubview:self.policyView];

    //根据后台配置控制显示注销栏，默认显示
    NSString *thirdPartLoginSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchAccountCancellation];
    if (!thirdPartLoginSwitch || ![thirdPartLoginSwitch isEqualToString:@"off"]) {
        [self.scrollViewContainer addSubview:self.cancellationView];
    }

    [self.scrollViewContainer addSubview:self.appVersionView];

    //        [self.scrollViewContainer addSubview:self.audioCallView];
    [self addSubview:self.logoutBTN];

    //    [self updateNotificationTipViewStatus];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_languageDidChanged {
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self.logoutBTN.mas_top).offset(-kRealWidth(30));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<UIView *> *visableViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView;
    for (UIView *view in visableViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViewContainer);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            if (view == visableViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
                if ([view isKindOfClass:SAInfoView.class]) {
                    SAInfoView *infoView = (SAInfoView *)view;
                    infoView.model.lineWidth = 0;
                    [infoView setNeedsUpdateContent];
                }
            }
        }];
        lastView = view;
    }

    [self.logoutBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedlogoutBTNHandler {
    @HDWeakify(self);
    [NAT showAlertWithMessage:SALocalizedString(@"confirm_to_logout", @"确定要退出吗？") confirmButtonTitle:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons")
        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            @HDStrongify(self);
            [self signout];
        }
        cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }];
}

- (void)signout {
    [self showloading];

    //注销apns
    dispatch_group_enter(self.taskGroup);
    @HDWeakify(self);
    [self.remoteNotifyVM unregisterUserRemoteNotificationTokenWithChannel:SAPushChannelAPNS success:^{
        @HDStrongify(self);
        HDLog(@"apns注销成功！");
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        HDLog(@"apns注销失败！");
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    // 注销传声筒
    dispatch_group_enter(self.taskGroup);
    [self.remoteNotifyVM unregisterUserRemoteNotificationTokenWithChannel:SAPushChannelHello success:^{
        @HDStrongify(self);
        HDLog(@"传声筒注销成功！");
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        HDLog(@"传声筒注销失败！");
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    // 注销voip
    dispatch_group_enter(self.taskGroup);
    [self.remoteNotifyVM unregisterUserRemoteNotificationTokenWithChannel:SAPushChannelVOIP success:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    // 注销IM
    dispatch_group_enter(self.taskGroup);
    [KSInstMsgManager.share signoutWithCompletion:^(NSError *_Nonnull error) {
        @HDStrongify(self);
        HDLog(@"IM注销成功！");
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        //注销
        [self.userViewModel logoutSuccess:nil failure:nil];
        [self dismissLoading];
        HDLog(@"!!退出登录全部调用完成");
        [SAUser logout];
        [VipayUser.shareInstance logout];
        [[WNHelloClient sharedClient] signOutWithUserId:@""];
        [self.viewController.navigationController popToRootViewControllerAnimated:true];
    });
}

#pragma mark - public methods
//- (void)updateNotificationTipViewStatus {
//    self.notificationTipView.hidden = SAGeneralUtil.isNotificationEnable;
//    self.notificationView.model.valueText = SAGeneralUtil.isNotificationEnable ? SALocalizedString(@"enabled", @"已开启") : SALocalizedString(@"disabled", @"未开启");
//    [self.notificationView setNeedsUpdateContent];

//    [self setNeedsUpdateConstraints];
//}

#pragma mark - private methods
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.G3;
    model.keyText = key;
    model.enableTapRecognizer = true;
    return model;
}

- (SAInfoViewModel *)infoViewModelWithArrowImageAndKey:(NSString *)key {
    SAInfoViewModel *model = [self infoViewModelWithKey:key];
    model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
    return model;
}

- (void)checkAppVersion {
    [self showloading];
    @HDWeakify(self);
    [self.appVersionViewModel getAppVersionInfoSuccess:^(SAAppVersionInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        if (HDIsStringEmpty(rspModel.publicVersion)) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"app_version_latest", @"当前版本已是最新") type:HDTopToastTypeSuccess];
        } else {
            SAVersionAlertViewConfig *config = SAVersionAlertViewConfig.new;
            config.versionId = rspModel.versionId;
            config.updateInfo = rspModel.versionInfo;
            config.updateVersion = rspModel.publicVersion;
            config.updateModel = rspModel.updateModel;
            config.packageLink = rspModel.packageLink;
            config.ignoreCache = YES;
            if ([SAVersionAlertManager versionShouldAlert:config]) {
                SAVersionBaseAlertView *alertView = [SAVersionAlertManager alertViewWithConfig:config];
                alertView.didDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {

                };
                [alertView show];
            }
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark - lazy load
- (SAInfoView *)myInfoView {
    if (!_myInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"my_infomation", @"我的信息")];
        model.valueText = SALocalizedString(@"name_photo", @"姓名、照片");
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToMyInfomationController:nil];
        };
        view.model = model;
        _myInfoView = view;
    }
    return _myInfoView;
}

- (SAInfoView *)passwordView {
    if (!_passwordView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"password_setting", @"密码设置")];
        model.eventHandler = ^{
            NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewLoginPage];
            if (switchLine && [switchLine isEqualToString:@"on"]) {
                [SAWindowManager navigateToSetPhoneViewControllerWithText:SALocalizedString(@"login_new2_tip6", @"为了保证安全，设置密码之前需要绑定手机") bindSuccessBlock:^{
                    [HDMediator.sharedInstance navigaveToSettingPwdOptionViewController:nil];
                } cancelBindBlock:nil];
            } else {
                [HDMediator.sharedInstance navigaveToSettingPwdOptionViewController:nil];
            }
        };
        view.model = model;
        _passwordView = view;
    }
    return _passwordView;
}

- (SAInfoView *)notificationView {
    if (!_notificationView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"login_new2_Settings", @"系统设置")];
        //        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"message_notify", @"消息提醒")];
        //        model.valueText = SAGeneralUtil.isNotificationEnable ? SALocalizedString(@"enabled", @"已开启") : SALocalizedString(@"disabled", @"未开启");
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            //            [HDSystemCapabilityUtil openAppSystemSettingPage];
            [self.viewController.navigationController pushViewController:SASystemSettingsViewController.new animated:YES];
        };
        view.model = model;
        _notificationView = view;
    }
    return _notificationView;
}

- (SAInfoView *)cacheView {
    if (!_cacheView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"clear_app_cache", @"清理APP缓存")];
        NSString *path = [CachesPath stringByAppendingPathComponent:@"com.hackemist.SDImageCache"];
        model.valueText = [HDFileUtil fileOrDirectorySizeDescWithFilePath:path];
        model.associatedObject = @{@"size": @([HDFileUtil fileOrDirectorySizeWithFilePath:path])};

        @HDWeakify(self);
        @HDWeakify(model);
        model.eventHandler = ^{
            @HDStrongify(model);
            if (((NSNumber *)[model.associatedObject valueForKey:@"size"]).intValue <= 0) {
                [NAT showToastWithTitle:nil content:SALocalizedString(@"nothing_to_delete", @"无需清除") type:HDTopToastTypeWarning];
                return;
            }
            [NAT showAlertWithMessage:SALocalizedString(@"confirm_delete", @"确认清除？")
                   confirmButtonTitle:SALocalizedStringFromTable(@"delete", @"删除", @"Buttons") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                       [alertView dismiss];
                       BOOL success = [HDFileUtil removeFileOrDirectory:path];
                       if (success) {
                           [NAT showToastWithTitle:nil content:SALocalizedString(@"delete_success", @"清除成功") type:HDTopToastTypeSuccess];
                       }
                       @HDStrongify(self);
                       self.cacheView.model.valueText = [HDFileUtil fileOrDirectorySizeDescWithFilePath:path];
                       [self.cacheView setNeedsUpdateContent];

                       [self setNeedsUpdateConstraints];
                   }
                    cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons")
                  cancelButtonHandler:nil];
        };
        view.model = model;
        _cacheView = view;
    }
    return _cacheView;
}

- (SAInfoView *)policyView {
    if (!_policyView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"service_agreement", @"服务协议")];
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/legal-policies"}];
        };
        view.model = model;
        _policyView = view;
    }
    return _policyView;
}

- (SAInfoView *)cancellationView {
    if (!_cancellationView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"ac_deactive_account", @"注销账号")];
        model.valueText = SALocalizedString(@"ac_tips1", @"注销后无法恢复，请谨慎操作");
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToCancellationApplication:nil];
        };
        view.model = model;
        _cancellationView = view;
    }
    return _cancellationView;
}

- (SAInfoView *)appVersionView {
    if (!_appVersionView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"app_version", @"APP版本")];
        model.valueText = [NSString stringWithFormat:@"V%@", HDDeviceInfo.appVersion];
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self checkAppVersion];
        };
        view.model = model;
        _appVersionView = view;
    }
    return _appVersionView;
}

//- (SAInfoView *)audioCallView {
//    if (!_audioCallView) {
//        SAInfoView *view = SAInfoView.new;
//        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:SALocalizedString(@"qZQ0QU8C", @"语音通话")];
//        model.eventHandler = ^{
//            [HDMediator.sharedInstance navigaveToCallAccountViewController:nil];
//        };
//        view.model = model;
//        _audioCallView = view;
//    }
//    return _audioCallView;
//}

//- (SAMissingNotificationTipView *)notificationTipView {
//    if (!_notificationTipView) {
//        _notificationTipView = SAMissingNotificationTipView.new;
//        SAMissingNotificationTipModel *model = SAMissingNotificationTipModel.new;
//        model.shouldFittingSize = true;
//        _notificationTipView.model = model;
//    }
//    return _notificationTipView;
//}

- (SAOperationButton *)logoutBTN {
    if (!_logoutBTN) {
        _logoutBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_logoutBTN addTarget:self action:@selector(clickedlogoutBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        [_logoutBTN setTitle:SALocalizedStringFromTable(@"logout", @"退出登录", @"Buttons") forState:UIControlStateNormal];
    }
    return _logoutBTN;
}

- (SAUserViewModel *)userViewModel {
    return _userViewModel ?: ({ _userViewModel = SAUserViewModel.new; });
}

- (SARemoteNotifyViewModel *)remoteNotifyVM {
    return _remoteNotifyVM ?: ({ _remoteNotifyVM = SARemoteNotifyViewModel.new; });
}
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (SAAppVersionViewModel *)appVersionViewModel {
    return _appVersionViewModel ?: ({ _appVersionViewModel = SAAppVersionViewModel.new; });
}

@end
