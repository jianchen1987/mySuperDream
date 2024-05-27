//
//  PNMSVoucherListView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherListView.h"
#import "PNMSVoucherInfoModel.h"
#import "PNMSVoucherListCell.h"
#import "PNMSVoucherRspModel.h"
#import "PNMSVoucherViewModel.h"
#import "PNTableView.h"


@interface PNMSVoucherListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) PNMSVoucherViewModel *viewModel;
@property (nonatomic, strong) PNOperationButton *uploadBtn;
@end


@implementation PNMSVoucherListView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.tableView];
    [self addSubview:self.uploadBtn];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.mas_equalTo(self.uploadBtn.mas_top).offset(-kRealWidth(16));
    }];

    [self.uploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(20));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(kRealWidth(16) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)getData:(BOOL)isShowLoading {
    [self.viewModel getNewData:isShowLoading success:^(PNMSVoucherRspModel *_Nonnull rspModel) {
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
    PNMSVoucherListCell *cell = [PNMSVoucherListCell cellWithTableView:tableView];
    cell.model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSVoucherInfoModel *infoModel = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesVoucherDetailVC:@{
        @"id": infoModel.voucherId,
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
        model.image = @"icon_store_no_data";
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.viewModel.currentPage = 1;
            [self getData:NO];
        };

        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.viewModel.currentPage += 1;
            [self getData:NO];
        };
    }
    return _tableView;
}

- (PNOperationButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_uploadBtn setTitle:PNLocalizedString(@"pn_upload_voucher_2", @"上传支付凭证") forState:UIControlStateNormal];
        [_uploadBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesUploadVoucherVC:@{}];
        }];
    }
    return _uploadBtn;
}

@end
