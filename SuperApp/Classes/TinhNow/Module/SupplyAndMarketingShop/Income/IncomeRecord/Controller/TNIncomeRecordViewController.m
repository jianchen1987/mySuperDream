//
//  TNIncomeRecordViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeRecordViewController.h"
#import "TNIncomeRecordView.h"
#import "TNIncomeViewModel.h"


@interface TNIncomeRecordViewController ()
@property (strong, nonatomic) TNIncomeViewModel *viewModel; ///<
@property (nonatomic, strong) TNIncomeRecordView *recordView;

@end


@implementation TNIncomeRecordViewController

- (void)hd_getNewData {
    [self.viewModel getIncomeData];
}

- (void)hd_setupViews {
    [self.view addSubview:self.recordView];
}
- (void)hd_bindViewModel {
    //请求收益列表数据
    [self.viewModel recordGetNewData];
}
- (void)updateViewConstraints {
    [self.recordView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (TNIncomeRecordView *)recordView {
    if (!_recordView) {
        _recordView = [[TNIncomeRecordView alloc] initWithViewModel:self.viewModel];
    }
    return _recordView;
}
/** @lazy viewModel */
- (TNIncomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNIncomeViewModel alloc] init];
    }
    return _viewModel;
}
#pragma mark
- (UIView *)listView {
    return self.view;
}

@end
