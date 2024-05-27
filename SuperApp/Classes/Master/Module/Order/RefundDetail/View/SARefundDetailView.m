//
//  SARefundDetailView.m
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARefundDetailView.h"
#import "SAInfoTableViewCell.h"
#import "SAOrderDetailRefundEventModel.h"
#import "SAOrderRefundDetailHeaderView.h"
#import "SAOrderRefundDetailProcessCell.h"
#import "SARefundDetailViewModel.h"
#import "SATableView.h"


@interface SARefundDetailView () <UITableViewDelegate, UITableViewDataSource>
/// 头部视图
@property (nonatomic, strong) SAOrderRefundDetailHeaderView *headerView;
/// VM
@property (nonatomic, strong) SARefundDetailViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
@end


@implementation SARefundDetailView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewBlock)(void) = ^(void) {
        @HDStrongify(self);
        [self.headerView updateUIWithOrderDetailRefundInfo:self.viewModel.orderRefundInfoModel];

        self.dataSource = self.viewModel.dataSource;
        [self.tableView successGetNewDataWithNoMoreData:true];
    };

    void (^failedGetNewDataBlock)(void) = ^(void) {
        @HDStrongify(self);
        BOOL isBusinessDataError = self.viewModel.isBusinessDataError;
        BOOL isNetworkError = self.viewModel.isNetworkError;
        if (isBusinessDataError || isNetworkError) {
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView failGetNewData];
        }
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        reloadTableViewBlock();
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"isBusinessDataError" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        failedGetNewDataBlock();
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"isNetworkError" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        failedGetNewDataBlock();
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

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAOrderDetailRefundEventModel.class]) {
        SAOrderRefundDetailProcessCell *cell = [SAOrderRefundDetailProcessCell cellWithTableView:tableView];
        SAOrderDetailRefundEventModel *trueModel = (SAOrderDetailRefundEventModel *)model;
        trueModel.isFirstCell = indexPath.row == 0;
        trueModel.isLastCell = indexPath.row == sectionModel.list.count - 1;
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        cell.model = trueModel;
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard2Bold;
    model.marginToBottom = kRealWidth(1);
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return kRealWidth(35);
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (SAOrderRefundDetailHeaderView *)headerView {
    return _headerView ?: ({ _headerView = SAOrderRefundDetailHeaderView.new; });
}
@end
