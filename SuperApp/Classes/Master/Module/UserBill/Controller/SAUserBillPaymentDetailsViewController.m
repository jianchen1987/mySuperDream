//
//  SAUserBillPaymentDetailsViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillPaymentDetailsViewController.h"
#import "NSDate+SAExtension.h"
#import "SAGeneralUtil.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "SAUserBillDTO.h"
#import "SAUserBillDetailsHeaderView.h"


@interface SAUserBillPaymentDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

///< header view
@property (nonatomic, strong) SAUserBillDetailsHeaderView *headerView;
///< dto
@property (nonatomic, strong) SAUserBillDTO *billDTO;
///< tableview
@property (nonatomic, strong) SATableView *tableView;
///< dataSource
@property (nonatomic, strong) NSArray<SAInfoViewModel *> *dataSource;

@end


@implementation SAUserBillPaymentDetailsViewController

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"userPaymentBill_title", @"支付详情");
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

    NSString *payTransactionNo = self.parameters[@"payTransactionNo"];
    NSString *payOrderNo = self.parameters[@"payOrderNo"];

    [self.billDTO queryUserBillPaymentDetailsWithPayTransactionNo:payTransactionNo payOrderNo:payOrderNo success:^(SAUserBillPaymentDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSMutableArray<SAInfoViewModel *> *detailModels = [[NSMutableArray alloc] initWithCapacity:4];
        __block SAInfoViewModel *infoModel = nil;

        if (rspModel.refundRecordList.count) {
            [rspModel.refundRecordList enumerateObjectsUsingBlock:^(SAUserBillRefundRecordModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                infoModel = [[SAInfoViewModel alloc] init];
                if (idx == 0) {
                    infoModel.keyText = SALocalizedString(@"userPaymentBill_refundRecord", @"退款记录");
                }

                infoModel.valueText = [NSString stringWithFormat:@"%@ %@", SALocalizedString(@"userBillList_refunded", @"已退款"), obj.refundAmount.thousandSeparatorAmount];
                infoModel.valueColor = HDAppTheme.color.C1;
                infoModel.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
                infoModel.eventHandler = ^{
                    [HDMediator.sharedInstance navigaveToBillRefundDetails:@{@"refundOrderNo": obj.refundOrderNo}];
                };
                [detailModels addObject:infoModel];
            }];
        }

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userPaymentBill_paymentMethod", @"付款方式");
        infoModel.valueText = rspModel.payChannel;
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userPaymentBill_paymentState", @"支付状态");
        infoModel.valueText = [SAGeneralUtil getPaymentStatusDescWithEnum:rspModel.payState];
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userPaymentBill_product", @"商品说明");
        infoModel.valueText = rspModel.shopName.desc;
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userPaymentBill_createTime", @"创建时间");
        infoModel.valueText = [[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm:ss"];
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userPaymentBill_paymentTime", @"支付时间");
        infoModel.valueText = [[NSDate dateWithTimeIntervalSince1970:rspModel.finishTime.floatValue / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm:ss"];
        ;
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userPaymentBill_paymentOrderNo", @"支付单号");
        infoModel.valueText = rspModel.payOrderNo;
        infoModel.rightButtonImage = [UIImage imageNamed:@"tn_orderNo_copy"];
        infoModel.eventHandler = ^{
            if (HDIsStringNotEmpty(rspModel.payOrderNo)) {
                [UIPasteboard generalPasteboard].string = rspModel.payOrderNo;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        };
        infoModel.enableTapRecognizer = YES;
        [detailModels addObject:infoModel];

        infoModel = [[SAInfoViewModel alloc] init];
        infoModel.keyText = SALocalizedString(@"userPaymentBill_merchantOrderNo", @"商户单号");
        infoModel.rightButtonImage = [UIImage imageNamed:@"tn_orderNo_copy"];
        infoModel.valueText = rspModel.businessOrderId;
        infoModel.eventHandler = ^{
            if (HDIsStringNotEmpty(rspModel.businessOrderId)) {
                [UIPasteboard generalPasteboard].string = rspModel.businessOrderId;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        };
        infoModel.enableTapRecognizer = YES;
        [detailModels addObject:infoModel];

        self.dataSource = detailModels;
        [self.headerView updateWithBusinessLine:rspModel.businessLine merchantName:rspModel.merchantName paymentAmount:[@"-" stringByAppendingString:rspModel.actualPayAmount.thousandSeparatorAmount]];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.tableView failGetNewData];
    }];
}

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
        _headerView = [[SAUserBillDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
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
