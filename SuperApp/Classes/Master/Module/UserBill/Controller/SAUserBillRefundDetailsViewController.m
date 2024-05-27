//
//  SAUserBillPaymentDetailsViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillRefundDetailsViewController.h"
#import "NSDate+SAExtension.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "SAUserBillDTO.h"
#import "SAUserBillDetailsHeaderView.h"
#import "SAUserBillRefundReceiveInfoView.h"


@interface SAUserBillRefundDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

///< header view
@property (nonatomic, strong) SAUserBillDetailsHeaderView *headerView;
///< dto
@property (nonatomic, strong) SAUserBillDTO *billDTO;
///< tableview
@property (nonatomic, strong) SATableView *tableView;
///< dataSource
@property (nonatomic, strong) NSArray<SAInfoViewModel *> *dataSource;

@end


@implementation SAUserBillRefundDetailsViewController

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"userRefundBill_title", @"退款详情");
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - Data
- (void)hd_getNewData {
    @HDWeakify(self);
    NSString *refundTransactionNo = self.parameters[@"refundTransactionNo"];
    NSString *refundOrderNo = self.parameters[@"refundOrderNo"];

    [self.billDTO queryUserBillRefundDetailsWithRefundTransactionNo:refundTransactionNo refundOrderNo:refundOrderNo success:^(SAUserBillRefundDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSMutableArray<SAInfoViewModel *> *detailModels = [[NSMutableArray alloc] initWithCapacity:4];
        SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userRefundBill_refundState", @"退款状态");
        infoModel.valueText = [SAGeneralUtil getRefundStatusDescWithEnum:rspModel.refundOrderState];
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userRefundBill_refundMethod", @"退款方式");
        if (rspModel.refundWay.code == 1) {
            // 原路退回
            infoModel.valueText = rspModel.payChannel;
        } else if (rspModel.refundWay.code == 2) {
            // 线下退款
            infoModel.valueText = SALocalizedString(@"userRefundBill_refundOffline", @"线下转账");
            if (rspModel.offlineRefundOrderDetail) {
                infoModel.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
                @HDWeakify(self);
                infoModel.eventHandler = ^{
                    @HDStrongify(self);
                    [self showReceiveInfoWithModel:rspModel.offlineRefundOrderDetail];
                };
            }
        }

        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userRefundBill_refundTime", @"退款时间");
        infoModel.valueText = [[NSDate dateWithTimeIntervalSince1970:rspModel.finishTime.floatValue / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm:ss"];
        ;
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userRefundBill_refundOrderNo", @"退款单号");
        infoModel.valueText = rspModel.refundOrderNo;
        infoModel.rightButtonImage = [UIImage imageNamed:@"tn_orderNo_copy"];
        infoModel.eventHandler = ^{
            if (HDIsStringNotEmpty(rspModel.refundOrderNo)) {
                [UIPasteboard generalPasteboard].string = rspModel.refundOrderNo;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        };
        infoModel.enableTapRecognizer = YES;
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userRefundBill_refundSource", @"退款来源");
        infoModel.valueText = [SAGeneralUtil getRefundSourceDescWithEnum:rspModel.refundSource];
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userRefundBill_orignalOrderNo", @"原支付单");
        infoModel.valueText = SALocalizedString(@"userRefundBill_check", @"查看");
        infoModel.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
        infoModel.valueColor = HDAppTheme.color.C1;
        infoModel.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToBillPaymentDetails:@{@"payOrderNo": rspModel.payOrderNo}];
        };
        [detailModels addObject:infoModel];

        self.dataSource = detailModels;
        [self.headerView updateWithBusinessLine:rspModel.businessLine merchantName:rspModel.merchantName paymentAmount:[@"+" stringByAppendingString:rspModel.refundAmount.thousandSeparatorAmount]];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.tableView failGetNewData];
    }];
}

#pragma mark - private methods
- (void)showReceiveInfoWithModel:(SAUserBillRefundReceiveAccountModel *)model {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.contentHorizontalEdgeMargin = 0;
    config.title = SALocalizedString(@"refund_receiver_info_title", @"收款信息");
    config.buttonTitle = SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons");
    config.textAlignment = HDCustomViewActionViewTextAlignmentCenter;

    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
    SAUserBillRefundReceiveInfoView *view = [[SAUserBillRefundReceiveInfoView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    view.model = model;
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
    [actionView show];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = model;
        !trueModel.eventHandler ?: trueModel.eventHandler();
    }
}

//- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
//    return HDViewControllerNavigationBarStyleTransparent;
//}
#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
    }
    return _tableView;
}

- (SAUserBillDetailsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SAUserBillDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    }
    return _headerView;
}

- (SAUserBillDTO *)billDTO {
    if (!_billDTO) {
        _billDTO = SAUserBillDTO.new;
    }
    return _billDTO;
}

@end
