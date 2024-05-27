//
//  WMStoreReviewsViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreReviewsViewController.h"
#import "WMStoreDetailRspModel.h"
#import "WMStoreReviewsView.h"
#import "WMStoreReviewsViewModel.h"
#import "WMZPageProtocol.h"


@interface WMStoreReviewsViewController () <WMZPageProtocol>

/// view
@property (nonatomic, strong) WMStoreReviewsView *reviewsView;
/// VM
@property (nonatomic, strong) WMStoreReviewsViewModel *viewModel;

@end


@implementation WMStoreReviewsViewController

- (void)hd_setupViews {
    [self.view addSubview:self.reviewsView];
}

- (void)hd_getNewData {
    [self.viewModel queryCountInfo];
    [self.viewModel queryStoreScore];
    [self.viewModel getNewData];
}

- (void)updateViewConstraints {
    [self.reviewsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (WMStoreReviewsView *)reviewsView {
    if (!_reviewsView) {
        _reviewsView = [[WMStoreReviewsView alloc] initWithViewModel:self.viewModel];
    }
    return _reviewsView;
}

#pragma mark - layout
- (WMStoreReviewsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMStoreReviewsViewModel alloc] init];
        WMStoreDetailRspModel *model = self.parameters[@"detailModel"];
        _viewModel.storeNo = model.storeNo;
    }
    return _viewModel;
}

- (UIScrollView *)getMyScrollView {
    return self.reviewsView.tableView;
}

@end
