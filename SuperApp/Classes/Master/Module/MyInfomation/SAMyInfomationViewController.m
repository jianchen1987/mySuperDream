//
//  SAMyInfomationViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMyInfomationViewController.h"
#import "SAMyInfomationView.h"
#import "SAMyInfomationViewModel.h"
#import "SAMyInfoView.h"
#import "SAAppSwitchManager.h"
#import "LKDataRecord.h"


@interface SAMyInfomationViewController ()
/// 内容
@property (nonatomic, strong) SAView *contentView;
/// VM
@property (nonatomic, strong) SAMyInfomationViewModel *viewModel;
/// 点击满赠填写年龄回调
@property (nonatomic, copy) void (^clickedAgeBlock)(void);
@end


@implementation SAMyInfomationViewController
- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"my_account", @"我的账号");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
    self.miniumGetNewDataDuration = 2;
}

- (void)hd_getNewData {
    [self.viewModel getNewData];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.clickedAgeBlock = parameters[@"clickedAgeBlock"];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.clickedAgeBlock) {
        self.clickedAgeBlock();
    }
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}


#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}


#pragma mark - lazy load

- (SAView *)contentView {
    NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewLoginPage];
    if (switchLine && [switchLine isEqualToString:@"on"]) {
        [LKDataRecord.shared tracePVEvent:@"MyInformationPageView" parameters:nil SPM:nil];
        return _contentView ?: ({ _contentView = [[SAMyInfoView alloc] initWithViewModel:self.viewModel]; });
    } else {
        return _contentView ?: ({ _contentView = [[SAMyInfomationView alloc] initWithViewModel:self.viewModel]; });
    }
}

- (SAMyInfomationViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAMyInfomationViewModel alloc] init];
    }
    return _viewModel;
}
@end
