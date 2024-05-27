//
//  SACommonRefundDetailView.m
//  SuperApp
//
//  Created by Tia on 2022/5/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonRefundDetailView.h"
#import "SACommonRefundDetailViewModel.h"
#import "SACommonRefundProgressDetailViewCell.h"
#import "SATableView.h"


@interface SACommonRefundDetailView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) SACommonRefundDetailViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;

@end


@implementation SACommonRefundDetailView

#pragma mark - SAViewProtocol
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = self.tableView.backgroundColor = [UIColor hd_colorWithHexString:@"F7F8F9"];
    [self addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewBlock)(void) = ^(void) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:true];
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        reloadTableViewBlock();
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"isLoading" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (isLoading) {
            [self showloading];
        } else {
            [self dismissLoading];
        }
    }];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.bottom.top.centerX.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SACommonRefundProgressDetailViewCell *cell = [SACommonRefundProgressDetailViewCell cellWithTableView:tableView];
    cell.orderNum = self.viewModel.aggregateOrderNo;
    cell.model = self.viewModel.dataSource[indexPath.row];
    return cell;
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    return _tableView;
}

@end
