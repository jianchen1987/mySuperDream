//
//  PNApartmentOrderListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/5.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNApartmentOrderListViewController.h"
#import "PNTableView.h"
#import "PNApartmentListCell.h"
#import "PNApartmentDTO.h"
#import "UIViewController+NavigationController.h"


@interface PNApartmentOrderListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, copy) NSString *feesNo;
@property (nonatomic, strong) PNApartmentDTO *apartmentDTO;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation PNApartmentOrderListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.feesNo = [parameters objectForKey:@"feesNo"];
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_bindViewModel {
    [self getData];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_rent_bill_no", @"缴费订单");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.tableView];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(12));
    }];
    [super updateViewConstraints];
}

- (void)getData {
    [self showloading];

    @HDWeakify(self);
    [self.apartmentDTO getApartmentOrderListData:self.feesNo success:^(NSArray<PNApartmentListItemModel *> *_Nonnull rspArray) {
        @HDStrongify(self);
        [self dismissLoading];
        self.dataSource = [NSMutableArray arrayWithArray:rspArray];
        if (self.dataSource.count == 1) {
            void (^completion)(void) = ^(void) {
                [self remoteViewControllerWithSpecifiedClass:self.class];
            };

            PNApartmentListItemModel *model = self.dataSource.firstObject;
            [HDMediator.sharedInstance navigaveToPayNowApartmentRecordDetailVC:@{
                @"paymentId": model.paymentSlipNo,
                @"callBack": completion,
            }];

        } else {
            [self.tableView successGetNewDataWithNoMoreData:YES];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNApartmentListCell *cell = [PNApartmentListCell cellWithTableView:tableView];
    cell.cellType = PNApartmentListCellType_OrderList;
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNApartmentListItemModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [HDMediator.sharedInstance navigaveToPayNowApartmentRecordDetailVC:@{
        @"paymentId": model.paymentSlipNo,
        @"feesNo": self.feesNo,
    }];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder_2";
        _tableView.placeholderViewModel = model;
    }
    return _tableView;
}

- (PNApartmentDTO *)apartmentDTO {
    if (!_apartmentDTO) {
        _apartmentDTO = [[PNApartmentDTO alloc] init];
    }
    return _apartmentDTO;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
