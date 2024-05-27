//
//  PNMSOperatorManagerView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOperatorManagerView.h"
#import "PNMSOperatorListCell.h"
#import "PNMSOperatorViewModel.h"
#import "PNTableView.h"


@interface PNMSOperatorManagerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) PNMSOperatorViewModel *viewModel;
@end


@implementation PNMSOperatorManagerView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSOperatorListCell *cell = [PNMSOperatorListCell cellWithTableView:tableView];
    cell.model = [self.viewModel.dataSource objectAtIndex:indexPath.row];

    @HDWeakify(self);
    cell.resetPasswordBlock = ^(PNMSOperatorInfoModel *model) {
        @HDStrongify(self);
        [self.viewModel resetPwdWithOperatorMobile:model.operatorMobile];
    };

    cell.unBindBlock = ^(PNMSOperatorInfoModel *model) {
        @HDStrongify(self);
        [self.viewModel unBindWithOperatorMobile:model.operatorMobile];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSOperatorInfoModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAddOrEditOperatorVC:@{
        @"operatorMobile": model.operatorMobile,
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
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel getNewData:NO];
        };
    }
    return _tableView;
}
@end
