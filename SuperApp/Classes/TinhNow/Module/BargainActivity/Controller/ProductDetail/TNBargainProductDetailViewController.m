//
//  TNBargainProductDetailViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNBargainProductDetailViewController.h"
#import "TNBargainProductDetailView.h"
#import "TNBargainProductDetailViewModel.h"


@interface TNBargainProductDetailViewController ()
/// 内容
@property (nonatomic, strong) TNBargainProductDetailView *contentView;
/// VM
@property (nonatomic, strong) TNBargainProductDetailViewModel *viewModel;
@end


@implementation TNBargainProductDetailViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.viewModel.originParameters = parameters;
    self.viewModel.taskId = [parameters objectForKey:@"taskId"];
    self.viewModel.activityId = [parameters objectForKey:@"activityId"];
    self.viewModel.bargainPrice = [parameters objectForKey:@"price"]; //砍价要显示原价

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.contentView.player vc_viewWillDisappear];
}
#pragma mark -

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.contentView.player vc_viewDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.contentView.player vc_viewDidDisappear];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}
#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.centerX.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (TNBargainProductDetailView *)contentView {
    if (!_contentView) {
        _contentView = [[TNBargainProductDetailView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (TNBargainProductDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNBargainProductDetailViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark
- (BOOL)allowContinuousBePushed {
    return YES;
}

@end
