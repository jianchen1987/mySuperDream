//
//  SACommonOrderDetailsViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonOrderDetailsViewController.h"
#import "HDCheckStandPresenter.h"
#import "HDCheckStandViewController.h"
#import "NSDate+SAExtension.h"
#import "SAInfoTableViewCell.h"
#import "SAOrderDTO.h"
#import "SAOrderProductInfoTableViewCell.h"
#import "SAOrderStatusOperationTableViewCell.h"
#import "SATableView.h"


@interface SACommonOrderDetailsViewController () <UITableViewDelegate, UITableViewDataSource, HDCheckStandViewControllerDelegate>
///< tableview
@property (nonatomic, strong) SATableView *tableView;
///< dataSource
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
///< dto
@property (nonatomic, strong) SAOrderDTO *orderDTO;
///< model
@property (nonatomic, strong) SAQueryOrderDetailsRspModel *rspModel;
@end


@implementation SACommonOrderDetailsViewController

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = HDAppTheme.color.G5;
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"order_detail", @"订单详情");
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - DATA
- (void)hd_getNewData {
    @HDWeakify(self);
    [self.orderDTO queryOrderDetailsWithOrderNo:self.parameters[@"orderNo"] success:^(SAQueryOrderDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.rspModel = rspModel;
        [self generateDataWithRspModel:rspModel];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.tableView failGetNewData];
    }];
}

#pragma mark - private methods
- (void)generateDataWithRspModel:(SAQueryOrderDetailsRspModel *)rspModel {
    /** 状态 */
    HDTableViewSectionModel *orderStatusSection = HDTableViewSectionModel.new;
    SAOrderStatusOperationTableViewCellModel *statusModel = SAOrderStatusOperationTableViewCellModel.new;
    statusModel.aggregateOrderState = rspModel.aggregateOrderState;
    statusModel.aggregateOrderFinalState = rspModel.aggregateOrderFinalState;
    statusModel.expireTime = rspModel.expireTime;
    statusModel.createTime = rspModel.createTime;
    statusModel.operationList = [rspModel.operationList copy];
    orderStatusSection.list = @[statusModel];

    /** 商品信息 */
    HDTableViewSectionModel *productInfoSection = HDTableViewSectionModel.new;
    SAOrderProductInfoTableViewCellModel *productInfoModel = SAOrderProductInfoTableViewCellModel.new;
    productInfoModel.storeName = rspModel.storeName.desc;
    productInfoModel.storeLogo = rspModel.storeLogo;
    productInfoModel.storeNo = rspModel.storeNo;
    productInfoModel.firstMerchantNo = rspModel.firstMerchantNo;
    productInfoModel.secondMerchantNo = rspModel.merchantNo;
    SAGoodsModel *goods = SAGoodsModel.new;
    goods.imageUrl = rspModel.showUrl;
    goods.goodsName = rspModel.remark;
    //    goods.SPU = @"超大个";
    //    goods.quantity = 2;
    //    goods.goodsSellPrice = rspModel.actualPayAmount;
    //    goods.goodsOriPrice = rspModel.actualPayAmount;
    productInfoModel.productList = @[goods];
    productInfoSection.list = @[productInfoModel];

    /** 订单信息 */
    HDTableViewSectionModel *orderInfoSection = HDTableViewSectionModel.new;
    NSMutableArray<SAInfoViewModel *> *orderInfos = [[NSMutableArray alloc] initWithCapacity:3];
    SAInfoViewModel *infoModel = SAInfoViewModel.new;
    infoModel.keyText = SALocalizedString(@"orderDetails_orderNo", @"订单号");
    infoModel.valueText = rspModel.aggregateOrderNo;
    infoModel.rightButtonImage = [UIImage imageNamed:@"tn_orderNo_copy"];
    infoModel.eventHandler = ^{
        if (HDIsStringNotEmpty(rspModel.aggregateOrderNo)) {
            [UIPasteboard generalPasteboard].string = rspModel.aggregateOrderNo;
            [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
        }
    };
    infoModel.enableTapRecognizer = YES;
    [orderInfos addObject:infoModel];

    if (!HDIsObjectNil(rspModel.payDiscountAmount) && rspModel.payDiscountAmount.cent.integerValue > 0) {
        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"payment_coupon", @"支付优惠");
        infoModel.valueText = [NSString stringWithFormat:@"-%@", rspModel.payDiscountAmount.thousandSeparatorAmount];
        infoModel.valueColor = [UIColor hd_colorWithHexString:@"#F83E00"];
        [orderInfos addObject:infoModel];

        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"orderDetails_payAmount", @"支付金额");
        infoModel.valueText = rspModel.payActualPayAmount.thousandSeparatorAmount;
        [orderInfos addObject:infoModel];
    } else {
        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"orderDetails_payAmount", @"支付金额");
        infoModel.valueText = rspModel.actualPayAmount.thousandSeparatorAmount;
        [orderInfos addObject:infoModel];
    }

    infoModel = SAInfoViewModel.new;
    infoModel.keyText = SALocalizedString(@"orderDetails_createTime", @"下单时间");
    infoModel.valueText = [[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];
    [orderInfos addObject:infoModel];
    orderInfoSection.list = orderInfos;

    if (rspModel.payTime > 0) {
        infoModel = SAInfoViewModel.new;
        infoModel.keyText = SALocalizedString(@"orderDetails_payTime", @"支付时间");
        infoModel.valueText = [[NSDate dateWithTimeIntervalSince1970:rspModel.payTime.floatValue / 1000.0] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];
        [orderInfos addObject:infoModel];
        orderInfoSection.list = orderInfos;
    }

    self.dataSource = @[orderStatusSection, productInfoSection, orderInfoSection];
}

///打开收银台
- (void)openCheckStand {
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
    buildModel.orderNo = self.rspModel.aggregateOrderNo;
    //    buildModel.outPayOrderNo = self.rspModel.payOrderNo;
    buildModel.payableAmount = self.rspModel.actualPayAmount;
    buildModel.merchantNo = self.rspModel.merchantNo;
    buildModel.businessLine = self.rspModel.businessLine;

    buildModel.needCheckPaying = YES;
    buildModel.payType = self.rspModel.payType;
    [HDCheckStandPresenter payWithTradeBuildModel:buildModel preferedHeight:0 fromViewController:self delegate:self];
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
    [self hd_getNewData];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
        // 跳转订单详情
        [vc.navigationController popViewControllerAnimated:NO];
    };

    params[@"orderClickBlock"] = orderDetailBlock;
    params[@"orderNo"] = controller.currentOrderNo;
    params[@"businessLine"] = controller.businessLine;
    params[@"outPayOrderNo"] = controller.outPayOrderNo;
    params[@"merchantNo"] = controller.merchantNo;
    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
    [self hd_getNewData];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
            // 跳转订单详情
            [vc.navigationController popViewControllerAnimated:NO];
        };

        params[@"orderClickBlock"] = orderDetailBlock;
        params[@"orderNo"] = controller.currentOrderNo;
        params[@"businessLine"] = controller.businessLine;
        params[@"outPayOrderNo"] = controller.outPayOrderNo;
        params[@"merchantNo"] = controller.merchantNo;
        [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
    }];
    [self hd_getNewData];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
    [self hd_getNewData];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
            // 跳转订单详情
            [vc.navigationController popViewControllerAnimated:NO];
        };

        params[@"orderClickBlock"] = orderDetailBlock;
        params[@"orderNo"] = controller.currentOrderNo;
        params[@"businessLine"] = controller.businessLine;
        params[@"outPayOrderNo"] = controller.outPayOrderNo;
        params[@"merchantNo"] = controller.merchantNo;
        [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
    }];
    [self hd_getNewData];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = model;
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:SAOrderProductInfoTableViewCellModel.class]) {
        SAOrderProductInfoTableViewCellModel *trueModel = model;
        SAOrderProductInfoTableViewCell *cell = [SAOrderProductInfoTableViewCell cellWithTableView:tableView];
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:SAOrderStatusOperationTableViewCellModel.class]) {
        SAOrderStatusOperationTableViewCellModel *trueModel = model;
        SAOrderStatusOperationTableViewCell *cell = [SAOrderStatusOperationTableViewCell cellWithTableView:tableView];
        cell.model = trueModel;
        @HDWeakify(self);
        cell.timerInvalidateHandler = ^(SAOrderStatusOperationTableViewCellModel *_Nonnull model) {
            @HDStrongify(self);
            // 倒计时结束，刷新一下订单
            [self hd_getNewData];
        };
        cell.payNowClickedHandler = ^(SAOrderStatusOperationTableViewCellModel *_Nonnull model) {
            @HDStrongify(self);
            // 支付按钮点击
            [self openCheckStand];
        };
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRealHeight(15);
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
    }
    return _tableView;
}

- (SAOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = SAOrderDTO.new;
    }
    return _orderDTO;
}

@end
