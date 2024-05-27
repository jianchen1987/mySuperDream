//
//  PNOutletViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNOutletViewController.h"
#import "PNNotifyView.h"
#import "PNOutletView.h"
#import "PNOutletViewModel.h"


@interface PNOutletViewController ()
@property (nonatomic, strong) PNOutletView *contentView;
@property (nonatomic, strong) PNOutletViewModel *viewModel;
@property (nonatomic, strong) PNNotifyView *notifyView;
@end


@implementation PNOutletViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"coolcash_agent_outlet", @"CoolCash网点");
}

- (void)hd_setupViews {
    [self.view addSubview:self.notifyView];
    [self.view addSubview:self.contentView];

    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeCoolcashWebsite];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
            make.height.equalTo(@([self.notifyView getViewHeight]));
        }];
    }

    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.notifyView.hidden) {
            make.top.equalTo(self.notifyView.mas_bottom);
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }
        make.right.left.bottom.equalTo(self.view);
    }];

    [self.notifyView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    [super updateViewConstraints];
}

#pragma mark
- (PNOutletView *)contentView {
    if (!_contentView) {
        _contentView = [[PNOutletView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNOutletViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNOutletViewModel alloc] init];
    }
    return _viewModel;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end
