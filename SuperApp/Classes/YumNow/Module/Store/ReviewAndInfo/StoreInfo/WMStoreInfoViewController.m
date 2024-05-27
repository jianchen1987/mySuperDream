//
//  WMStoreInfoViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreInfoViewController.h"
#import "WMStoreDetailRspModel.h"
#import "WMStoreInfoView.h"
#import "WMStoreInfoViewModel.h"


@interface WMStoreInfoViewController ()

@property (nonatomic, strong) WMStoreInfoView *infoView;
/// viewModel
@property (nonatomic, strong) WMStoreInfoViewModel *viewModel;

@end


@implementation WMStoreInfoViewController
- (void)hd_setupViews {
    [self.view addSubview:self.infoView];
}

- (void)hd_getNewData {
    [self.viewModel getStoreDetialinfo];
}

- (void)updateViewConstraints {
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (WMStoreInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[WMStoreInfoView alloc] initWithViewModel:self.viewModel];
    }
    return _infoView;
}

- (WMStoreInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMStoreInfoViewModel alloc] initWithImage:@"star_rating_level_1" font:HDAppTheme.font.standard4 textColor:HDAppTheme.color.G2 startColor:HDAppTheme.color.C1];
        WMStoreDetailRspModel *model = self.parameters[@"detailModel"];
        _viewModel.storeNo = model.storeNo;
    }
    return _viewModel;
}

@end
