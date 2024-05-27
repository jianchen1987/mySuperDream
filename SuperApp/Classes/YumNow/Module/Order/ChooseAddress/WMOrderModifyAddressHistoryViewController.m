//
//  WMOrderModifyAddressHistoryViewController.m
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderModifyAddressHistoryViewController.h"
#import "WMModifyAddressDTO.h"
#import "WMTableView.h"


@interface WMOrderModifyAddressHistoryViewController () <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) WMTableView *tableView;
///数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// modifyDTO
@property (nonatomic, strong) WMModifyAddressDTO *modifyDTO;

@end


@implementation WMOrderModifyAddressHistoryViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.parentOrderNo = parameters[@"orderNo"];
    return self;
}

- (void)hd_setupViews {
    self.boldTitle = WMLocalizedString(@"wm_modify_address_record", @"Modify address recor");
    [self.view addSubview:self.tableView];
    @HDWeakify(self)[self.tableView setRequestNewDataHandler:^{
        @HDStrongify(self)[self hd_getNewData];
    }];
}

- (void)hd_getNewData {
    if (!self.tableView.hd_hasData) {
        self.tableView.delegate = self.tableView.provider;
        self.tableView.dataSource = self.tableView.provider;
    }
    @HDWeakify(self)[self.modifyDTO getListOrderUpdateAddressWithOrderNo:self.parentOrderNo success:^(NSArray<WMModifyAddressListModel *> *_Nonnull rspModel) {
        @HDStrongify(self) self.dataSource = NSMutableArray.new;
        [rspModel enumerateObjectsUsingBlock:^(WMModifyAddressListModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            GNCellModel *model = [GNCellModel createClass:@"WMOrderModifyAddressHistoryTableViewCell"];
            model.businessData = obj;
            model.notCacheHeight = YES;
            [self.dataSource addObject:model];
        }];
        self.tableView.GNdelegate = self;
        [self.tableView reloadData:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.tableView.GNdelegate = self;
        [self.tableView reloadFail];
    }];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [super updateViewConstraints];
}

///取消
- (void)cancelAction:(NSString *)orderNo showloading:(BOOL)showloading {
    @HDWeakify(self) if (showloading) {
        [self.view showloading];
    }
    [self.modifyDTO cancelOrderUpdateAddressWithOrderNo:orderNo success:^{
        @HDStrongify(self)[self.view dismissLoading];
        [self hd_getNewData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self.view dismissLoading];
        [self hd_getNewData];
    }];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    ///倒计时结束
    if ([event.key isEqualToString:@"payCountDownEndAction"]) {
        WMModifyAddressListModel *model = event.info[@"model"];
        if ([model isKindOfClass:WMModifyAddressListModel.class]) {
            [self cancelAction:model.orderNo showloading:NO];
        }
    }
    ///取消
    else if ([event.key isEqualToString:@"cancelAction"]) {
        WMModifyAddressListModel *model = event.info[@"model"];
        if ([model isKindOfClass:WMModifyAddressListModel.class]) {
            [self cancelAction:model.orderNo showloading:YES];
        }
    }
    ///调起支付
    else if ([event.key isEqualToString:@"payAction"]) {
        WMModifyAddressListModel *model = event.info[@"model"];
        if ([model isKindOfClass:WMModifyAddressListModel.class]) {
            [self payActionWithOrderNo:model.aggregateNo merchantNo:model.merchantNo storeNo:model.storeNo payableAmount:model.payPrice];
        }
    }
}

- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return self.dataSource;
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.needRefreshHeader = YES;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kRealWidth(8) + kiPhoneXSeriesSafeBottomHeight, 0);
    }
    return _tableView;
}

- (WMModifyAddressDTO *)modifyDTO {
    if (!_modifyDTO) {
        _modifyDTO = WMModifyAddressDTO.new;
    }
    return _modifyDTO;
}

- (BOOL)allowContinuousBePushed {
    return YES;
}

@end
