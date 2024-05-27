//
//  PNMarketingBindListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNMarketingBindListViewController.h"
#import "PNBindMarketingItemView.h"
#import "PNTableView.h"
#import "PNBindMarketingInfoCell.h"
#import "PNMarketingDTO.h"
#import "PNMarketingListItemModel.h"


@interface PNMarketingBindListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNBindMarketingItemView *sectionHeaderView;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray<PNMarketingListItemModel *> *dataSource;
@property (nonatomic, strong) PNMarketingDTO *marketingDTO;
@property (nonatomic, copy) NSString *promoterLoginName;
@end


@implementation PNMarketingBindListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.promoterLoginName = [parameters objectForKey:@"promoterLoginName"];
        self.pageNo = 1;
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"DaEmrCe1", @"绑定详情");
}

- (void)hd_setupViews {
    [self.view addSubview:self.sectionHeaderView];
    [self.view addSubview:self.tableView];

    [self.tableView.mj_header beginRefreshing];
}

- (void)updateViewConstraints {
    [self.sectionHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.sectionHeaderView.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    @HDWeakify(self);
    [self.marketingDTO queryPromoterFriendPage:self.pageNo promoterLoginName:self.promoterLoginName successBlock:^(NSArray<PNMarketingListItemModel *> *_Nonnull resultArray) {
        @HDStrongify(self);
        if (self.pageNo == 1) {
            [self.dataSource removeAllObjects];

            if (resultArray.count) {
                [self.dataSource addObjectsFromArray:resultArray];
                [self.tableView successGetNewDataWithNoMoreData:NO];
            } else {
                [self.dataSource addObjectsFromArray:resultArray];
                [self.tableView successGetNewDataWithNoMoreData:YES];
            }
        } else {
            if (resultArray.count > 0) {
                [self.dataSource addObjectsFromArray:resultArray];
                [self.tableView successLoadMoreDataWithNoMoreData:NO];
            } else {
                [self.tableView successLoadMoreDataWithNoMoreData:YES];
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.pageNo == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
    }];


    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBindMarketingInfoCell *cell = [PNBindMarketingInfoCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark
- (PNBindMarketingItemView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[PNBindMarketingItemView alloc] initWithType:PNBindMarketingItemView_Title];

        PNMarketingListItemModel *model = [[PNMarketingListItemModel alloc] init];
        model.friendLoginName = PNLocalizedString(@"98jChipT", @"好友手机号");
        model.friendName = PNLocalizedString(@"pn_full_name_2", @"姓名");
        model.tradeStr = PNLocalizedString(@"fIEqKQdK", @"是否交易");

        _sectionHeaderView.model = model;
    }
    return _sectionHeaderView;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder_2";
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.pageNo = 1;
            [self getData];
        };

        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.pageNo++;
            [self getData];
        };
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNMarketingDTO *)marketingDTO {
    if (!_marketingDTO) {
        _marketingDTO = [[PNMarketingDTO alloc] init];
    }
    return _marketingDTO;
}
@end
