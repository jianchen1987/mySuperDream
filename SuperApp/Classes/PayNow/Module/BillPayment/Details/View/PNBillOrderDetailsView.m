//
//  PNBillOrderDetailsView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillOrderDetailsView.h"
#import "HDTableHeaderFootViewModel.h"
#import "HDTableViewSectionModel.h"
#import "PNBillOrderDetailsCell.h"
#import "PNBillOrderDetailsHeaderView.h"
#import "PNBillOrderDetialsSectionHeaderView.h"
#import "PNPaymentActionBarView.h"
#import "PNPaymentOrderDetailsViewModel.h"
#import "PNTableView.h"
#import "PNWaterBillModel.h"
#import "SAInfoViewModel.h"


@interface PNBillOrderDetailsView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNBillOrderDetailsHeaderView *headerView;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) PNPaymentOrderDetailsViewModel *viewModel;
@property (nonatomic, strong) PNPaymentActionBarView *actionBarView;
@end


@implementation PNBillOrderDetailsView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.viewModel queryBillDetail];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.headerView.model = self.viewModel.billModel;

        PNBalancesInfoModel *balancesInfoModel = self.viewModel.billModel.balances.firstObject;
        if (HDIsStringNotEmpty(self.viewModel.orderNo) && balancesInfoModel.billState == PNBillPaymentStatusProcessing) {
            self.actionBarView.hidden = NO;
        } else {
            self.actionBarView.hidden = YES;
        }

        [self.tableView successGetNewDataWithNoMoreData:NO];

        [self setNeedsUpdateConstraints];
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.tableView];
    [self addSubview:self.actionBarView];
}

- (void)updateConstraints {
    if (!self.actionBarView.hidden) {
        [self.actionBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneXSeries ? -kiPhoneXSeriesSafeBottomHeight : kRealWidth(-20));
            make.height.mas_equalTo(@(kRealWidth(64)));
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        if (!self.actionBarView.hidden) {
            make.bottom.equalTo(self.actionBarView.mas_top);
        } else {
            make.bottom.equalTo(self);
        }
    }];

    [super updateConstraints];
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.viewModel.dataSourceArray objectAtIndex:section];
    return sectionModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBillOrderDetailsCell *cell = [PNBillOrderDetailsCell cellWithTableView:tableView];
    HDTableViewSectionModel *sectionModel = [self.viewModel.dataSourceArray objectAtIndex:indexPath.section];
    cell.model = [sectionModel.list objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSourceArray[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    PNBillOrderDetialsSectionHeaderView *headView = [PNBillOrderDetialsSectionHeaderView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    headView.sectionTitleStr = model.title;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSourceArray[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;
    return 50;
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (PNBillOrderDetailsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PNBillOrderDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(65))];
    }
    return _headerView;
}

- (PNPaymentActionBarView *)actionBarView {
    if (!_actionBarView) {
        _actionBarView = [[PNPaymentActionBarView alloc] init];
        _actionBarView.hidden = YES;
        @HDWeakify(self);
        _actionBarView.clickCloseActionBlock = ^{
            @HDStrongify(self);
            [self.viewModel closePaymentOrder];
        };
    }
    return _actionBarView;
}
@end
