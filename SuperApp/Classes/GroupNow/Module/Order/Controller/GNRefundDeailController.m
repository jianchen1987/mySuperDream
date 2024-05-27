//
//  GNRefundDeailController.m
//  SuperApp
//
//  Created by wmz on 2022/3/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNRefundDeailController.h"
#import "GNAlertUntils.h"
#import "GNRefundViewModel.h"


@interface GNRefundDeailController () <GNTableViewProtocol>
/// tableview
@property (nonatomic, strong) GNTableView *tableView;
/// viewModel
@property (nonatomic, strong) GNRefundViewModel *viewModel;
/// 客服BTN
@property (nonatomic, strong) HDUIButton *serverBTN;

@end


@implementation GNRefundDeailController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.orderNo = parameters[@"orderNo"];
        self.aggregateOrderNo = parameters[@"aggregateOrderNo"];
        self.cancelState = parameters[@"cancelState"];
        self.businessPhone = parameters[@"businessPhone"];
        if (parameters[@"cancelTime"]) {
            self.cancelTime = [parameters[@"cancelTime"] integerValue];
        }
    }
    return self;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.boldTitle = SALocalizedString(@"refund_detail", @"退款详情");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.serverBTN]];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self.view addSubview:self.tableView];
    @HDWeakify(self) self.tableView.tappedRefreshBtnHandler = self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self) self.view.backgroundColor = HDAppTheme.color.gn_whiteColor;
        self.tableView.delegate = self.tableView.provider;
        self.tableView.dataSource = self.tableView.provider;
        [self.tableView reloadData];
        [self hd_getNewData];
    };
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarH);
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(kRealWidth(-15));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self)[self.KVOController hd_observe:self.viewModel keyPath:@"refreshType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.view.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        self.tableView.GNdelegate = self;
        if (self.viewModel.refreshType == GNRequestTypeBad) {
            [self.tableView reloadFail];
        } else if (self.viewModel.refreshType == GNRequestTypeDataError) {
            [self.tableView reloadData:NO];
        } else {
            [self.tableView reloadData:NO];
        }
    }];
}

- (void)hd_getNewData {
    if (!self.cancelState && self.orderNo) {
        @HDWeakify(self)[self.viewModel getOrderDetailCompletion:^(BOOL error) {
            @HDStrongify(self)[self.viewModel queryOrderDetailInfo];
        }];
    } else {
        [self.viewModel queryOrderDetailInfo];
    }
}

///请求团购订单详情
- (void)requestGroupBuyOrderDetail {
    [self getOrderDetailCompletion:^(BOOL error){

    }];
}

/// 团购订单详情
- (void)getOrderDetailCompletion:(void (^)(BOOL error))completion {
    @HDWeakify(self)[self.viewModel.refundDetailDTO orderDetailRequestCustomerNo:SAUser.shared.operatorNo orderNo:self.orderNo success:^(GNOrderCellModel *_Nonnull rspModel) {
        @HDStrongify(self) if ([rspModel isKindOfClass:GNOrderCellModel.class]) {
            self.cancelState = rspModel.neCancelState;
            self.businessPhone = rspModel.merchantInfo.businessPhone;
        }
        !completion ?: completion(rspModel ? NO : YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(YES);
    }];
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.dataSource;
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _tableView.delegate = _tableView.provider;
        _tableView.dataSource = _tableView.provider;
        _tableView.needShowErrorView = YES;
        _tableView.needRefreshBTN = YES;
        _tableView.needRefreshHeader = YES;
    }
    return _tableView;
}

- (HDUIButton *)serverBTN {
    if (!_serverBTN) {
        _serverBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_serverBTN setImage:[UIImage imageNamed:@"gn_order_serve"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_serverBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [GNAlertUntils callAndServerString:self.viewModel.businessPhone];
        }];
    }
    return _serverBTN;
}

- (GNRefundViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = GNRefundViewModel.new;
        _viewModel.orderNo = self.aggregateOrderNo;
        _viewModel.buinessNo = self.orderNo;
        _viewModel.cancelState = self.cancelState;
        _viewModel.businessPhone = self.businessPhone;
        _viewModel.cancelTime = self.cancelTime;
    }
    return _viewModel;
}

@end
