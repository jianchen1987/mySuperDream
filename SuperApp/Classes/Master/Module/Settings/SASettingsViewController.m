//
//  SASettingsViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASettingsViewController.h"
#import "SASettingsView.h"
#import "SASettingsViewModel.h"


@interface SASettingsViewController ()
/// 内容
@property (nonatomic, strong) SASettingsView *contentView;
/// VM
@property (nonatomic, strong) SASettingsViewModel *viewModel;
@end


@implementation SASettingsViewController
- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"settings", @"设置");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
    self.miniumGetNewDataDuration = 2;

    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)hd_getNewData {
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

#pragma mark - Notification
- (void)applicationBecomeActive {
    //    [self.contentView updateNotificationTipViewStatus];
}

#pragma mark - lazy load

- (SASettingsView *)contentView {
    return _contentView ?: ({ _contentView = [[SASettingsView alloc] initWithViewModel:self.viewModel]; });
}

- (SASettingsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SASettingsViewModel alloc] init];
    }
    return _viewModel;
}
@end
