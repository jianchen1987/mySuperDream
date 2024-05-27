//
//  SACancellationApplicationAssetsAndEquityViewController.m
//  SuperApp
//
//  Created by Tia on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationAssetsAndEquityViewController.h"
#import "SACancellationApplicationAssetsAndEquityView.h"
#import "SACancellationApplicationAssetsAndEquityViewModel.h"
#import "SACancellationApplicationSuccessViewController.h"
#import "SACancellationApplicationVerifyIdentityViewController.h"


@interface SACancellationApplicationAssetsAndEquityViewController ()
/// 内容
@property (nonatomic, strong) SACancellationApplicationAssetsAndEquityView *contentView;
/// VM
@property (nonatomic, strong) SACancellationApplicationAssetsAndEquityViewModel *viewModel;

@end


@implementation SACancellationApplicationAssetsAndEquityViewController

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"ac_deactive_account", @"注销账号");
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 0;
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    [self.viewModel queryOrdeDetailInfo];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (SACancellationApplicationAssetsAndEquityView *)contentView {
    if (!_contentView) {
        _contentView = [[SACancellationApplicationAssetsAndEquityView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _contentView.nextBlock = ^{
            @HDStrongify(self);
            SACancellationApplicationSuccessViewController *vc = SACancellationApplicationSuccessViewController.new;
            [self.navigationController pushViewController:vc animated:YES];
            //            SACancellationApplicationVerifyIdentityViewController *vc = SACancellationApplicationVerifyIdentityViewController.new;
            //            vc.reasonModel = self.reasonModel;
            //            [self.navigationController pushViewController:vc animated:YES];
        };
        _contentView.cancelBlock = ^{
            @HDStrongify(self);
            BOOL result = NO;
            UIViewController *viewContr;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"SASettingsViewController")]) {
                    result = YES;
                    viewContr = vc;
                    break;
                }
            }
            if (result && viewContr) {
                [self.navigationController popToViewController:viewContr animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        };
        _contentView.backgroundColor = HDAppTheme.color.normalBackground;
    }

    return _contentView;
}

- (SACancellationApplicationAssetsAndEquityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SACancellationApplicationAssetsAndEquityViewModel alloc] initWithModel:self.reasonModel];
    }
    return _viewModel;
}

@end
