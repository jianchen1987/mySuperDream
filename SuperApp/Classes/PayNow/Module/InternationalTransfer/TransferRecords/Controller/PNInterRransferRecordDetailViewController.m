//
//  PNInterRransferRecordDetailViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterRransferRecordDetailViewController.h"
#import "PNInterTransferDetailViewModel.h"
#import "PNTableView.h"
#import "PNTransferSectionHeaderView.h"
#import "SAInfoTableViewCell.h"


@interface PNInterRransferRecordDetailViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表视图
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) PNInterTransferDetailViewModel *viewModel;
@end


@implementation PNInterRransferRecordDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.recordModel = [parameters objectForKey:@"recordModel"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"dtXJWLUv", @"转账详情");
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    [self.viewModel initDataArr];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark -tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[section];
    return sectionModel.list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        PNTransferSectionHeaderView *headerView = [PNTransferSectionHeaderView headerWithTableView:tableView];
        //        headerView.title = sectionModel.headerModel.title;
        [headerView setTitle:sectionModel.headerModel.title rightImage:sectionModel.headerModel.rightButtonImage];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        return 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        //        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        //        model.title = SALocalizedString(@"no_data", @"暂无数据");
        //        model.image = @"pn_no_data_placeholder";
        //        _tableView.placeholderViewModel = model;

        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kiPhoneXSeriesSafeBottomHeight + 20)];
    }
    return _tableView;
}
/** @lazy viewModel */
- (PNInterTransferDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNInterTransferDetailViewModel alloc] init];
    }
    return _viewModel;
}
@end
