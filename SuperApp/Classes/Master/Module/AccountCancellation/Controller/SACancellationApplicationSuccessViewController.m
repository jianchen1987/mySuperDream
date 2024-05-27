//
//  SACancellationApplicationSuccessViewController.m
//  SuperApp
//
//  Created by Tia on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationSuccessViewController.h"
#import "SARemoteNotifyViewModel.h"
#import "SAUserViewModel.h"
#import "VipayUser.h"
#import <KSInstantMessagingKit/KSCore.h>


@interface SACancellationApplicationSuccessViewController ()
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// 主标题
@property (nonatomic, strong) SALabel *tipsLB;
/// 副标题
@property (nonatomic, strong) SALabel *subTipsLB;
/// 返回按钮
@property (nonatomic, strong) SAOperationButton *backBtn;
/// 用户操作 VM
@property (nonatomic, strong) SAUserViewModel *userViewModel;
/// 通知 VM
@property (nonatomic, strong) SARemoteNotifyViewModel *remoteNotifyVM;

@property (nonatomic, strong) dispatch_group_t taskGroup; ///< 任务组

@end


@implementation SACancellationApplicationSuccessViewController

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"ac_deactive_account", @"注销账号");
    [self setHd_navLeftBarButtonItem:nil];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.normalBackground;

    self.hd_interactivePopDisabled = YES;

    [self.view addSubview:self.tipsLB];
    [self.view addSubview:self.subTipsLB];
    [self.view addSubview:self.logoIV];
    [self.view addSubview:self.backBtn];

    [self signout];
}

- (void)updateViewConstraints {
    CGFloat margin = kRealWidth(15);

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(40));
        make.centerX.equalTo(self.view);
    }];

    [self.tipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(20));
    }];

    [self.subTipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.equalTo(self.tipsLB.mas_bottom).offset(kRealWidth(20));
    }];

    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.subTipsLB.mas_bottom).offset(kRealWidth(120));
    }];

    [super updateViewConstraints];
}

#pragma mark - event response
- (void)clickedBackBtnHandler {
    [SAWindowManager switchWindowToLoginViewController];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}

#pragma mark - private methods
- (void)signout {
    @HDWeakify(self);
    //注销apns
    dispatch_group_enter(self.taskGroup);

    [self.remoteNotifyVM unregisterUserRemoteNotificationTokenWithChannel:SAPushChannelAPNS success:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    // 注销传声筒
    dispatch_group_enter(self.taskGroup);
    [self.remoteNotifyVM unregisterUserRemoteNotificationTokenWithChannel:SAPushChannelHello success:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    // 注销voip
    //    dispatch_group_enter(self.taskGroup);
    //    [self.remoteNotifyVM unregisterUserRemoteNotificationTokenWithChannel:SAPushChannelVOIP
    //        success:^{
    //            @HDStrongify(self);
    //            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    //        }
    //        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
    //            @HDStrongify(self);
    //            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    //        }];

    // 注销IM
    dispatch_group_enter(self.taskGroup);
    [KSInstMsgManager.share signoutWithCompletion:^(NSError *_Nonnull error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        //注销
        [self.userViewModel logoutSuccess:nil failure:nil];
        HDLog(@"!!退出登录全部调用完成");
        [SAUser logout];
        [VipayUser.shareInstance logout];
        [[WNHelloClient sharedClient] signOutWithUserId:@""];
    });
}

#pragma mark - lazy load
- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ac_icon_submit_success"]];
    }
    return _logoIV;
}

- (SALabel *)tipsLB {
    if (!_tipsLB) {
        SALabel *l = SALabel.new;
        l.text = SALocalizedString(@"ac_tips51", @"注销账号申请提交成功");
        l.font = [HDAppTheme.font boldForSize:16];
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = HDAppTheme.color.G1;
        l.numberOfLines = 0;
        _tipsLB = l;
    }
    return _tipsLB;
}

- (SALabel *)subTipsLB {
    if (!_subTipsLB) {
        SALabel *l = SALabel.new;
        l.hd_lineSpace = 5;
        l.numberOfLines = 0;
        l.font = HDAppTheme.font.standard4;
        l.textColor = [UIColor hd_colorWithHexString:@"#999999"];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = SALocalizedString(@"ac_tips52", @"WOWNOW已收到您注销账号申请，3个小时完成审核后即注销当前账号");
        _subTipsLB = l;
    }
    return _subTipsLB;
}

- (SAOperationButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(clickedBackBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:SALocalizedStringFromTable(@"return", @"返回", @"Buttons") forState:UIControlStateNormal];
        [_backBtn applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
    }
    return _backBtn;
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

@end
