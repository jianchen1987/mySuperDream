//
//  SAMineViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMineViewController.h"
#import "SAMineView.h"
#import "SAMineViewModel.h"
#import "SAMineHeaderView.h"


#define kHeadBgImageHeight kNavigationBarH + kRealWidth(55) + kRealWidth(15) * 2 - kRealWidth(7)

@interface SAMineViewController ()
/// VM
@property (nonatomic, strong) SAMineViewModel *viewModel;
/// 设置按钮
@property (nonatomic, strong) HDUIButton *settingsBTN;
/// 头部
@property (nonatomic, strong) SAMineHeaderView *headerView;
/// 头部背景
@property (nonatomic, strong) UIImageView *headerViewBgView;

@end


@implementation SAMineViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [dic setObject:CMSPageIdentifyMine forKey:@"pageLabel"];
    self = [super initWithRouteParameters:dic];
    if (self) {
    }
    return self;
}

- (void)updateViewConstraints {
    [self.headerViewBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeadBgImageHeight);
    }];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerViewBgView);
    }];

    [super updateViewConstraints];
}

- (void)hd_setupViews {
    [super hd_setupViews];

    self.miniumGetNewDataDuration = 10.0f;

    [self.view addSubview:self.headerViewBgView];
    [self.view addSubview:self.headerView];

    self.collectionView.contentInset = UIEdgeInsetsMake(kHeadBgImageHeight - UIApplication.sharedApplication.statusBarFrame.size.height - 44, 0, 0, 0);
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewAndTableHeaderView)(void) = ^void(void) {
        @HDStrongify(self);
        if (SAUser.hasSignedIn) {
            if (!HDIsObjectNil(self.viewModel.userInfoRspModel)) {
                [self.headerView updateInfoWithModel:self.viewModel.userInfoRspModel];
            } else {
                // 请求还没回来，先用缓存数据
                [self.headerView updateInfoWithNickName:SAUser.shared.nickName headUrl:SAUser.shared.headURL pointBalance:SAUser.shared.pointBalance];
            }
        } else {
            [self.headerView updateInfoWithModel:nil];
        }
    };

    reloadTableViewAndTableHeaderView();

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        reloadTableViewAndTableHeaderView();
    }];
    [self.KVOController hd_observe:self.viewModel keyPath:@"userInfoRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        SAGetUserInfoRspModel *userInfo = change[NSKeyValueChangeNewKey];
        @HDStrongify(self);
        [self.headerView updateInfoWithModel:userInfo];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"signinActivityEntranceUrl" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        NSString *url = change[NSKeyValueChangeNewKey];
        [self.headerView updateSigninEntrance:url];
    }];
}

- (void)hd_setupNavigation {
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.settingsBTN]];
}


- (void)hd_getNewData {
    // 触发消息更新
    [self.viewModel getNewData:^{

    }];
}

- (void)loginSuccessHandler {
    [super loginSuccessHandler];

    [self.viewModel getNewData:^{

    }];
    [self getNewData];
}

- (void)logoutHandler {
    [super logoutHandler];

    [self.headerView updateInfoWithModel:nil];
    [self getNewData];
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

#pragma mark - lazy load
- (SAMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAMineViewModel alloc] init];
    }
    return _viewModel;
}

- (HDUIButton *)settingsBTN {
    if (!_settingsBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"icon_settings"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToSettingsViewController:nil];
        }];
        _settingsBTN = button;
    }
    return _settingsBTN;
}

- (SAMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = SAMineHeaderView.new;
        _headerView.tapEventHandler = ^{
            if (SAUser.hasSignedIn) {
                [HDMediator.sharedInstance navigaveToMyInfomationController:nil];
            } else {
                [SAWindowManager switchWindowToLoginViewController];
            }
        };
    }
    return _headerView;
}

- (UIImageView *)headerViewBgView {
    if (!_headerViewBgView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBgImageHeight)];
        imageView.image = [UIImage imageNamed:@"mine_header_bg"];
        _headerViewBgView = imageView;
    }
    return _headerViewBgView;
}


@end
