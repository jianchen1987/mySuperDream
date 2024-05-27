//
//  SACancellationApplicationRemindViewController.m
//  SuperApp
//
//  Created by Tia on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationRemindViewController.h"
#import "SACancellationApplicationAssetsAndEquityViewController.h"
#import "SACancellationApplicationRemindView.h"


@interface SACancellationApplicationRemindViewController ()

@property (nonatomic, strong) SACancellationApplicationRemindView *contentView;

@end


@implementation SACancellationApplicationRemindViewController

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"ac_deactive_account", @"注销账号");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (SACancellationApplicationRemindView *)contentView {
    if (!_contentView) {
        _contentView = SACancellationApplicationRemindView.new;
        @HDWeakify(self);
        _contentView.nextBlock = ^{
            @HDStrongify(self);
            SACancellationApplicationAssetsAndEquityViewController *vc = SACancellationApplicationAssetsAndEquityViewController.new;
            vc.reasonModel = self.reasonModel;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _contentView;
}

@end
