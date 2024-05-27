//
//  SAWalletBillListView.m
//  SuperApp
//
//  Created by seeu on 2021/10/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAWalletBillListView.h"
#import "SATableView.h"
#import "SAWalletBillCell.h"
#import "SAWalletBillTableHeaderView.h"
#import "SAWalletbillListViewModel.h"


@interface SAWalletBillListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SAWalletBillListViewModel *viewModel; ///< viewmodel
@property (nonatomic, strong) SATableView *tableView;               ///<
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
@end


@implementation SAWalletBillListView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };

    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };
}

- (void)hd_languageDidChanged {
    [self.tableView getNewData];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - DATA
- (void)getNewData {
    @HDWeakify(self);
    [self.viewModel requestNewDataCompletion:^(NSError *_Nonnull error, BOOL hasMore, SARspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (!error) {
            self.dataSource = [self.viewModel.dataSource mutableCopy];
            [self.tableView successGetNewDataWithNoMoreData:!hasMore];
        } else {
            [self.tableView failGetNewData];
        }

        //根据需求去除 【T0027 - 用户编号不能为空】  错误提示
        if (self.viewModel.billType == SABillTypeHistory && !HDIsObjectNil(rspModel)) {
            HDLog(@"%@ - %@", rspModel.code, rspModel.msg);
            if (![rspModel.code isEqualToString:@"T0027"]) {
                [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
            }
        }
    }];
}

- (void)loadMoreData {
    @HDWeakify(self);
    [self.viewModel loadMoreDataCompletion:^(NSError *_Nonnull error, BOOL hasMore, SARspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (!error) {
            self.dataSource = [self.viewModel.dataSource mutableCopy];
            [self.tableView successLoadMoreDataWithNoMoreData:!hasMore];
        } else {
            [self.tableView failLoadMoreData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 容错
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;

    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    // 容错
    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAWalletBillModelDetail.class]) {
        SAWalletBillCell *cell = [SAWalletBillCell cellWithTableView:tableView];
        SAWalletBillModelDetail *trueModel = (SAWalletBillModelDetail *)model;
        trueModel.isLast = indexPath.row == sectionModel.list.count - 1;
        cell.model = trueModel;
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return nil;

    SAWalletBillTableHeaderView *headView = [SAWalletBillTableHeaderView headerWithTableView:tableView];
    SAWalletBillTableHeaderViewModel *model = sectionModel.commonHeaderModel;
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return 50;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HDTableViewSectionModel *sectioModel = self.dataSource[indexPath.section];
    id model = sectioModel.list[indexPath.row];
    if ([model isKindOfClass:SAWalletBillModelDetail.class]) {
        SAWalletBillModelDetail *trueModel = (SAWalletBillModelDetail *)model;
        [HDMediator.sharedInstance navigaveToWalletBillDetailViewController:@{@"tradeNo": trueModel.tradeNo}];
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
