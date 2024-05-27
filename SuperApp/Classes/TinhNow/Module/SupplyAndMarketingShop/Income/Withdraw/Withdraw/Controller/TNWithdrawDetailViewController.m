//
//  TNWithdrawDetailViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawDetailViewController.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "TNQuestionAndContactView.h"
#import "TNWithDrawAuditAmountCell.h"
#import "TNWithDrawDetailCertificateCell.h"
#import "TNWithDrawDetailTipsCell.h"
#import "TNWithdrawDetailViewModel.h"


@interface TNWithdrawDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) TNWithdrawDetailViewModel *viewModel; ///<
@property (nonatomic, strong) SATableView *tableView;
@property (strong, nonatomic) UIView *footerView; ///<  底部联系视图
@end


@implementation TNWithdrawDetailViewController
- (id)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.objId = parameters[@"id"];
    }
    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"N1Z0wzjw", @"提现详情");
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self.viewModel getDetailData];
    @HDWeakify(self);
    self.viewModel.withDrawDetailGetDataFaild = ^{
        @HDStrongify(self);
        [self.tableView failGetNewData];
    };
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel getDetailData];
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.footerView = [[UIView alloc] init];
    self.footerView.size = CGSizeMake(kScreenWidth, kRealWidth(130));
    self.tableView.tableFooterView = self.footerView;
    TNQuestionAndContactView *contactView = [[TNQuestionAndContactView alloc] init];
    [self.footerView addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.footerView.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
    }];
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
#pragma mark -delgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.dataArr[indexPath.row];
    if ([model isKindOfClass:TNWithDrawAuditAmountCellModel.class]) {
        TNWithDrawAuditAmountCell *cell = [TNWithDrawAuditAmountCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:TNWithDrawDetailTipsCellModel.class]) {
        TNWithDrawDetailTipsCell *cell = [TNWithDrawDetailTipsCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:TNWithDrawDetailCertificateCellModel.class]) {
        TNWithDrawDetailCertificateCell *cell = [TNWithDrawDetailCertificateCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}
/** @lazy viewModel */
- (TNWithdrawDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNWithdrawDetailViewModel alloc] init];
    }
    return _viewModel;
}
#pragma mark
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
