//
//  PNMSStoreOperatorManagerView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorManagerView.h"
#import "PNMSStoreManagerViewModel.h"
#import "PNMSStoreOperatorRspModel.h"
#import "PNMSStoreOperatoreInfoCell.h"
#import "PNTableView.h"


@interface PNMSStoreOperatorManagerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@end


@implementation PNMSStoreOperatorManagerView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.viewModel.currentPage = 1;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self loadData];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

- (void)loadData {
    [self.viewModel getStoreOperatorList:^(PNMSStoreOperatorRspModel *_Nonnull rspModel) {
        if (self.viewModel.currentPage == 1) {
            [self.viewModel.dataSource removeAllObjects];
            self.viewModel.dataSource = [NSMutableArray arrayWithArray:rspModel.list];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self.viewModel.dataSource addObjectsFromArray:rspModel.list];
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSStoreOperatoreInfoCell *cell = [PNMSStoreOperatoreInfoCell cellWithTableView:tableView];
    cell.model = [self.viewModel.dataSource objectAtIndex:indexPath.row];

    @HDWeakify(self);
    cell.qrCodeBlock = ^(PNMSStoreOperatorInfoModel *model) {
        [HDMediator.sharedInstance navigaveToPayNowMerchantServicesReceiveCodeVC:@{
            @"storeNo": self.viewModel.storeNo,
            @"storeName": self.viewModel.storeName,
            @"operatorMobile": model.operatorMobile,
            @"operatorName": model.userName,
        }];
    };

    cell.unBindBlock = ^(PNMSStoreOperatorInfoModel *model) {
        @HDStrongify(self);
        @HDWeakify(self);
        [self.viewModel unBindStoreOperator:model.operatorMobile success:^{
            @HDStrongify(self);
            [self.viewModel.dataSource removeObject:model];
            [self.tableView successGetNewDataWithNoMoreData:NO];
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSStoreOperatorInfoModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    BOOL canEdit = YES;
    if (VipayUser.shareInstance.role == PNMSRoleType_STORE_MANAGER && model.role == PNMSRoleType_STORE_MANAGER) {
        canEdit = NO;
    }
    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesStoreOperatorAddOrEditVC:@{
        @"storeOperatorId": model.storeOperatorId,
        @"canEdit": @(canEdit),
    }];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.viewModel.currentPage = 1;
            [self loadData];
        };

        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.viewModel.currentPage += 1;
            [self loadData];
        };
    }
    return _tableView;
}

@end
