//
//  WMRefundDetailView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRefundDetailView.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "WMOrderRefundDetailHeaderView.h"
#import "WMOrderRefundDetailProcessCell.h"
#import "WMRefundDetailViewModel.h"


@interface WMRefundDetailView () <UITableViewDelegate, UITableViewDataSource>
/// 头部视图
@property (nonatomic, strong) WMOrderRefundDetailHeaderView *headerView;
/// VM
@property (nonatomic, strong) WMRefundDetailViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
@end


@implementation WMRefundDetailView
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
        WMBusinessStatus bizStatus = self.viewModel.detailModel.bizState;
        // 退款申请中隐藏整行
        if (bizStatus != WMBusinessStatusOrderCancelled) {
            self.headerView.hidden = true;
            self.headerView.height = CGFLOAT_MIN;
        } else {
            self.headerView.hidden = false;
            [self.headerView updateUIWithOrderDetailRefundInfo:self.viewModel.detailModel.refundInfo];
        }

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
    if ([model isKindOfClass:WMOrderDetailRefundEventModel.class]) {
        WMOrderRefundDetailProcessCell *cell = [WMOrderRefundDetailProcessCell cellWithTableView:tableView];
        WMOrderDetailRefundEventModel *trueModel = (WMOrderDetailRefundEventModel *)model;
        trueModel.isFirstCell = indexPath.row == 0;
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
    model.marginToBottom = kRealWidth(10);
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return 50;
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

- (WMOrderRefundDetailHeaderView *)headerView {
    return _headerView ?: ({ _headerView = WMOrderRefundDetailHeaderView.new; });
}
@end
