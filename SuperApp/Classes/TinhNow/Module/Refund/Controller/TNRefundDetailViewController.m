//
//  TNRefundDetailViewController.m
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundDetailViewController.h"
#import "SATableView.h"
#import "TNRefundDetailsViewModel.h"
#import "TNRefundDetailsItemCell.h"


@interface TNRefundDetailViewController () <UITableViewDelegate, UITableViewDataSource>
///
@property (nonatomic, strong) SATableView *tableView;
///
@property (nonatomic, strong) TNRefundDetailsViewModel *viewModel;
///
@property (nonatomic, copy) NSString *orderNo;

@end


@implementation TNRefundDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.orderNo = [parameters objectForKey:@"orderNo"];
        if (HDIsStringEmpty(self.orderNo)) {
            return nil;
        }
    }
    return self;
}


- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_apply_refund_detail", @"申请详情");
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}

- (void)hd_getNewData {
    [self.viewModel getData:self.orderNo];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNRefundDetailsItemCellModel.class]) {
        TNRefundDetailsItemCell *cell = [TNRefundDetailsItemCell cellWithTableView:tableView];
        cell.itemModel = ((TNRefundDetailsItemCellModel *)model).model;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == (self.viewModel.dataSource.count - 1)) {
        return 0;
    } else {
        return 10.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HDTableHeaderFootView *footView = [HDTableHeaderFootView headerWithTableView:tableView];
    footView.contentView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    return footView;
}

#pragma mark -
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.needShowNoDataView = YES;
        _tableView.needShowErrorView = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 5.0f;
    }
    return _tableView;
}

- (TNRefundDetailsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNRefundDetailsViewModel alloc] init];
    }
    return _viewModel;
}


#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return false;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
