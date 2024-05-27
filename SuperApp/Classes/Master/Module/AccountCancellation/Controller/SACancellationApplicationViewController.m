//
//  SACancellationApplicationViewController.m
//  SuperApp
//
//  Created by Tia on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationViewController.h"
#import "SACancellationApplicationRemindViewController.h"
#import "SACancellationApplicationView.h"


@interface SACancellationApplicationViewController () <HDTextViewDelegate, UITextViewDelegate>
/// 内容
@property (nonatomic, strong) SACancellationApplicationView *contentView;

@end


@implementation SACancellationApplicationViewController

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"ac_logout_request", @"注销申请");
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
- (SACancellationApplicationView *)contentView {
    if (!_contentView) {
        _contentView = SACancellationApplicationView.new;
        @HDWeakify(self);
        _contentView.nextBlock = ^(SACancellationReasonModel *_Nonnull model) {
            @HDStrongify(self);
            SACancellationApplicationRemindViewController *vc = SACancellationApplicationRemindViewController.new;
            vc.reasonModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _contentView;
}

@end
