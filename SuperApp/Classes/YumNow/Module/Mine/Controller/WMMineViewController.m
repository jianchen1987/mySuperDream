//
//  WMMineViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMineViewController.h"
#import "SAInfoViewModel.h"
#import "SAMessageButton.h"
#import "WMMenuNavView.h"
#import "WMMineView.h"
#import "WMMineViewModel.h"
#import <HDUIKit/HDTableViewSectionModel.h>


@interface WMMineViewController ()
/// 列表
@property (nonatomic, strong) WMMineView *contentView;
/// VM
@property (nonatomic, strong) WMMineViewModel *viewModel;
/// 消息按钮
@property (nonatomic, strong) SAMessageButton *messageBTN;
/// nav
@property (nonatomic, strong) WMMenuNavView *menuView;
@end


@implementation WMMineViewController

- (void)hd_setupViews {
    self.hd_interactivePopDisabled = self.navigationController.viewControllers.count <= 1;

    [self.view addSubview:self.menuView];
    [self.view addSubview:self.contentView];
    self.clientType = SAClientTypeYumNow;
    self.miniumGetNewDataDuration = 5;

    // 监听消息更新的通知
    @HDWeakify(self);
    [NSNotificationCenter.defaultCenter addObserverForName:kNotificationNameReceivedNewMessage object:nil queue:nil usingBlock:^(NSNotification *_Nonnull note) {
        @HDStrongify(self);
        NSNumber *count = note.userInfo[@"count"];
        if (count.integerValue > 0) {
            [self.messageBTN showMessageCount:count.integerValue];
        } else {
            [self.messageBTN clearMessageCount];
        }
    }];
    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

- (void)hd_languageDidChanged {
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    // 触发消息更新
    [super hd_getNewData];

    if (SAUser.hasSignedIn) {
        self.viewModel.user = SAUser.shared;
        [self.contentView getNewData];
    }
}

- (void)updateViewConstraints {
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarH);
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.menuView.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - Notification
- (void)userLoginHandler {
    [self.contentView getNewData];
    // 触发当前界面的 viewWillAppear:
    [self beginAppearanceTransition:YES animated:NO];
}

- (void)userLogoutHandler {
    [self.viewModel clearDataSource];
    self.viewModel.refreshFlag = !self.viewModel.refreshFlag;
    [self.messageBTN showMessageCount:0];
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - lazy load
- (WMMineView *)contentView {
    return _contentView ?: ({ _contentView = [[WMMineView alloc] initWithViewModel:self.viewModel]; });
}

- (WMMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMMineViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

- (SAMessageButton *)messageBTN {
    if (!_messageBTN) {
        SAMessageButton *button = [SAMessageButton buttonWithType:UIButtonTypeCustom clientType:SAClientTypeYumNow];
        [button setImage:[UIImage imageNamed:@"master_home_message"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 0);
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{
                @"clientType": SAClientTypeYumNow,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖我的页"] : @"外卖我的页",
                @"associatedId" : self.viewModel.associatedId
            }];
        }];
        [button setDotColor:HexColor(0xFF4444)];
        _messageBTN = button;
    }
    return _messageBTN;
}

- (WMMenuNavView *)menuView {
    if (!_menuView) {
        _menuView = [[WMMenuNavView alloc] init];
        _menuView.bgColor = HDAppTheme.color.mainColor;
        _menuView.rightView = self.messageBTN;
        _menuView.rightImageInset = HDAppTheme.value.padding.right;
        @HDWeakify(self);
        _menuView.clickedRightViewBlock = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{
                @"clientType": SAClientTypeYumNow,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖我的页"] : @"外卖我的页",
                @"associatedId" : self.viewModel.associatedId
            }];
        };
        [_menuView updateConstraintsAfterSetInfo];
    }
    return _menuView;
}
@end
