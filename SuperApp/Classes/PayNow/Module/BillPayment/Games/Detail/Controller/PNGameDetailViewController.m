//
//  PNGameDetailViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailViewController.h"
#import "PNGameDetailView.h"
#import "PNGameDetailViewModel.h"


@interface PNGameDetailViewController ()
///
@property (strong, nonatomic) PNGameDetailView *contentView;
///
@property (strong, nonatomic) PNGameDetailViewModel *viewModel;
@end


@implementation PNGameDetailViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.viewModel.categoryId = [parameters objectForKey:@"categoryId"];
    }
    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_get_items", @"Get Items");
}
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
/** @lazy viewModel */
- (PNGameDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNGameDetailViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy contentView */
- (PNGameDetailView *)contentView {
    if (!_contentView) {
        _contentView = [[PNGameDetailView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}
@end
