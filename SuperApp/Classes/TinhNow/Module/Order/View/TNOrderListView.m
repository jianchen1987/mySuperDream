//
//  TNOrderListView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListView.h"
#import "HDAppTheme+TinhNow.h"
#import "HDCheckStandPresenter.h"
#import "HDCheckStandRepaymentAlertView.h"
#import "HDCheckStandViewController.h"
#import "SAChoosePaymentMethodPresenter.h"
#import "SAGoodsModel.h"
#import "SAOrderListTableViewCell+Skeleton.h"
#import "SATableView.h"
#import "TNOrderListFooterView.h"
#import "TNOrderListHeaderView.h"
#import "TNOrderListMoreProductCell.h"
#import "TNOrderListSingleProductCell.h"
#import "TNOrderListViewModel.h"


@interface TNOrderListView () <UITableViewDelegate, UITableViewDataSource, HDCheckStandViewControllerDelegate>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// viewModel
@property (strong, nonatomic) TNOrderListViewModel *viewModel;
@end


@implementation TNOrderListView
- (instancetype)initWithState:(TNOrderState)state {
    self.viewModel.state = state;
    return [super init];
}
- (void)hd_setupViews {
    [self addSubview:self.tableView];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:YES];

    @HDWeakify(self);
    self.viewModel.failedGetDataBlock = ^{
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (self.viewModel.currentPage == 1) {
            [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        }
    }];
}
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - 确认订单
- (void)handleConfirmOrderWithModel:(TNOrderModel *)orderModel {
    @HDWeakify(self);
    [self.viewModel confirmOrderWithOrderNo:orderModel.unifiedOrderNo completion:^{
        @HDStrongify(self);
        !self.reloadOrderCountCallBack ?: self.reloadOrderCountCallBack();
        [self.tableView getNewData];
    }];
}
#pragma mark - 取消订单
- (void)handleCancelOrderWithModel:(TNOrderModel *)orderModel {
    @HDWeakify(self);
    [self.viewModel cancelOrderWithOrderNo:orderModel.unifiedOrderNo completion:^{
        @HDStrongify(self);
        !self.reloadOrderCountCallBack ?: self.reloadOrderCountCallBack();
        [self.tableView getNewData];
    }];
}
#pragma mark - 评价
- (void)handleEvaluateOrderWithModel:(TNOrderModel *)orderModel {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"orderNo"] = orderModel.unifiedOrderNo;
    [HDMediator.sharedInstance navigaveToTinhNowPostReviewlViewController:params];
}
#pragma mark - 退款详情
- (void)handleJumpToRefundDetailWithModel:(TNOrderModel *)orderModel {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"orderNo"] = orderModel.unifiedOrderNo;
    [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:params];
}
#pragma mark - 支付
- (void)handleOrderPayWithModel:(TNOrderModel *)orderModel {
    @HDWeakify(self);
    [self.viewModel queryOrderPaymentStateWithOrderNo:orderModel.unifiedOrderNo completion:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (rspModel) {
            if (rspModel.actualPayAmount.cent.integerValue > 0) { // 实付金额>0元时才需要调起收银台  电商有改价0元单
                if (HDIsStringNotEmpty(orderModel.payChannelCode)) {
                    HDPaymentMethodType *paymentMethod = [HDPaymentMethodType onlineMethodWithPaymentTool:orderModel.payChannelCode];
                    //已经有支付方式  查询支付方式是否可用
                    [SAChoosePaymentMethodPresenter trialWithPayableAmount:orderModel.amount businessLine:SAClientTypeTinhNow supportedPaymentMethods:@[HDSupportedPaymentMethodOnline]
                                                                merchantNo:orderModel.storeInfo.merchantNo
                                                                   storeNo:orderModel.storeInfo.storeNo
                                                                     goods:@[]
                                                     selectedPaymentMethod:paymentMethod completion:^(BOOL available, NSString *_Nullable ruleNo, SAMoneyModel *_Nullable discountAmount) {
                                                         if (available) {
                                                             paymentMethod.ruleNo = ruleNo;
                                                             [self openCashRegisterWithModel:orderModel paymentMethod:paymentMethod];
                                                         } else {
                                                             [self openCashRegisterWithModel:orderModel paymentMethod:nil];
                                                         }
                                                     }];
                } else {
                    [self openCashRegisterWithModel:orderModel paymentMethod:nil];
                }
            } else {
                [HDTips showWithText:TNLocalizedString(@"tn_pay_state_tips", @"订单状态已变化，请刷新当前页面") inView:self hideAfterDelay:3];
            }
        } else {
            [self openCashRegisterWithModel:orderModel paymentMethod:nil];
        }
    }];
}
///打开收银台
- (void)openCashRegisterWithModel:(TNOrderModel *)orderModel paymentMethod:(HDPaymentMethodType *)paymentMethod {
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
    buildModel.orderNo = orderModel.unifiedOrderNo;
    //                                         buildModel.outPayOrderNo = orderModel.outPayOrderNo; // 不需要
    buildModel.storeNo = orderModel.storeInfo.storeNo;
    buildModel.merchantNo = orderModel.storeInfo.merchantNo;
    buildModel.payableAmount = orderModel.amount;
    buildModel.businessLine = SAClientTypeTinhNow;
    if (!HDIsObjectNil(paymentMethod)) {
        buildModel.selectedPaymentMethod = paymentMethod;
    }
    buildModel.goods = [orderModel.orderItems mapObjectsUsingBlock:^id _Nonnull(TNOrderProductItemModel *_Nonnull obj, NSUInteger idx) {
        SAGoodsModel *item = SAGoodsModel.new;
        item.goodsId = obj.productId;
        item.skuId = obj.skuId;
        item.quantity = obj.quantity;
        return item;
    }];

    buildModel.needCheckPaying = YES; //需要校验重新支付的时候改成YES

    [HDCheckStandPresenter payWithTradeBuildModel:buildModel preferedHeight:0 fromViewController:self.viewController delegate:self];
}
#pragma mark - 再次购买
- (void)handleRebuyWithModel:(TNOrderModel *)orderModel {
    [self.viewModel rebuymOrderWithOrderNo:orderModel.unifiedOrderNo completion:^(NSArray *_Nonnull skuIds) {
        [SAWindowManager openUrl:@"SuperApp://TinhNow/ShoppingCar" withParameters:@{@"skuIds": skuIds}];
    }];
}
#pragma mark - 附近购买
- (void)handleNearbyRoteWithModel:(TNOrderModel *)model {
    [self.viewModel nearBuyOrderWithOrderNo:model.unifiedOrderNo completion:^(NSString *_Nonnull route) {
        if (HDIsStringNotEmpty(route)) {
            [SAWindowManager openUrl:route withParameters:nil];
        }
    }];
}
#pragma mark - 转账付款
- (void)handleTransferWithModel:(TNOrderModel *)model {
    [[HDMediator sharedInstance] navigaveToTinhNowTransferViewController:@{@"orderNo": model.unifiedOrderNo}];
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:@{@"orderNo": controller.currentOrderNo, @"businessLine": controller.businessLine, @"merchantNo": controller.merchantNo}];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        // orderNo:聚合订单号,businessLine:业务线枚举
        [HDMediator.sharedInstance
            navigaveToCheckStandPayResultViewController:@{@"orderNo": controller.currentOrderNo, @"businessLine": controller.businessLine, @"merchantNo": controller.merchantNo}];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance
            navigaveToCheckStandPayResultViewController:@{@"orderNo": controller.currentOrderNo, @"businessLine": controller.businessLine, @"merchantNo": controller.merchantNo}];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": controller.currentOrderNo}];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionModel = self.viewModel.dataSource[section];
    if ([sectionModel isKindOfClass:TNOrderListSingleProductCellModel.class]) {
        TNOrderListSingleProductCellModel *cellModel = (TNOrderListSingleProductCellModel *)sectionModel;
        return cellModel.orderModel.orderItems.count;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealWidth(60);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TNOrderListHeaderView *headerView = [TNOrderListHeaderView headerWithTableView:tableView identifier:@"header"];
    id sectionModel = self.viewModel.dataSource[section];
    if ([sectionModel isKindOfClass:TNOrderListSingleProductCellModel.class]) {
        TNOrderListSingleProductCellModel *cellModel = (TNOrderListSingleProductCellModel *)sectionModel;
        headerView.orderModel = cellModel.orderModel;
    } else if ([sectionModel isKindOfClass:TNOrderListMoreProductCellModel.class]) {
        TNOrderListMoreProductCellModel *cellModel = (TNOrderListMoreProductCellModel *)sectionModel;
        headerView.orderModel = cellModel.orderModel;
    }
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TNOrderListFooterView *footerView = [TNOrderListFooterView headerWithTableView:tableView identifier:@"footer"];
    id sectionModel = self.viewModel.dataSource[section];
    if ([sectionModel isKindOfClass:TNOrderListSingleProductCellModel.class]) {
        TNOrderListSingleProductCellModel *cellModel = (TNOrderListSingleProductCellModel *)sectionModel;
        footerView.orderModel = cellModel.orderModel;
    } else if ([sectionModel isKindOfClass:TNOrderListMoreProductCellModel.class]) {
        TNOrderListMoreProductCellModel *cellModel = (TNOrderListMoreProductCellModel *)sectionModel;
        footerView.orderModel = cellModel.orderModel;
    }
    @HDWeakify(self);
    footerView.clickedPayNowBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        [self handleOrderPayWithModel:orderModel];
    };
    footerView.clickedRebuyBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        [self handleRebuyWithModel:orderModel];
    };
    footerView.clickedTransferBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        [self handleTransferWithModel:orderModel];
    };
    footerView.clickedOneMoreBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        [self handleNearbyRoteWithModel:orderModel];
    };
    footerView.clickedRefundDetailBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        [self handleJumpToRefundDetailWithModel:orderModel];
    };
    footerView.clickedEvaluationOrderBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        [self handleEvaluateOrderWithModel:orderModel];
    };
    footerView.clickedCancelBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        @HDWeakify(self);
        [NAT showAlertWithTitle:TNLocalizedString(@"tn_order_cancel_confirm_title", @"确认放弃购买？")
            message:TNLocalizedString(@"tn_order_cancel_confirm_content", @"商品数量有限，还有用户正在抢购哦~")
            confirmButtonTitle:TNLocalizedString(@"tn_order_cancel_confirm_btn", @"确认取消") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
                @HDStrongify(self);
                [self handleCancelOrderWithModel:orderModel];
            }
            cancelButtonTitle:TNLocalizedString(@"tn_order_cancel_continue_title", @"继续购买") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
    };
    footerView.clickedConfirmReceivingBlock = ^(TNOrderModel *_Nonnull orderModel) {
        @HDStrongify(self);
        [NAT showAlertWithMessage:TNLocalizedString(@"tn_order_confirm_title", @"请确认，你已经收到货") confirmButtonTitle:TNLocalizedString(@"tn_button_received", @"确定")
            confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
                [self handleConfirmOrderWithModel:orderModel];
            }
            cancelButtonTitle:TNLocalizedString(@"tn_button_NoYet_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
    };
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id sectionModel = self.viewModel.dataSource[indexPath.section];
    if ([sectionModel isKindOfClass:TNOrderListSingleProductCellModel.class]) {
        TNOrderListSingleProductCellModel *cellModel = (TNOrderListSingleProductCellModel *)sectionModel;
        TNOrderListSingleProductCell *cell = [TNOrderListSingleProductCell cellWithTableView:tableView];
        cell.model = cellModel.orderModel.orderItems[indexPath.row];
        cell.refundStatusDes = cellModel.orderModel.refundStatusDes;
        return cell;
    } else if ([sectionModel isKindOfClass:TNOrderListMoreProductCellModel.class]) {
        TNOrderListMoreProductCellModel *cellModel = (TNOrderListMoreProductCellModel *)sectionModel;
        TNOrderListMoreProductCell *cell = [TNOrderListMoreProductCell cellWithTableView:tableView];
        cell.productPicArr = cellModel.productPicArr;
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];

    id sectionModel = self.viewModel.dataSource[indexPath.section];
    NSString *orderNo;
    if ([sectionModel isKindOfClass:TNOrderListSingleProductCellModel.class]) {
        TNOrderListSingleProductCellModel *cellModel = (TNOrderListSingleProductCellModel *)sectionModel;
        orderNo = cellModel.orderModel.unifiedOrderNo;
    } else if ([sectionModel isKindOfClass:TNOrderListMoreProductCellModel.class]) {
        TNOrderListMoreProductCellModel *cellModel = (TNOrderListMoreProductCellModel *)sectionModel;
        orderNo = cellModel.orderModel.unifiedOrderNo;
    }
    [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": orderNo}];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}
#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 100;
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.viewModel.pageSize = 20;
            !self.reloadOrderCountCallBack ?: self.reloadOrderCountCallBack();
            [self.viewModel getNewData];
        };
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.viewModel.pageSize = 20;
            [self.viewModel loadMoreData];
        };
    }
    return _tableView;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [SAOrderListTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [SAOrderListTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}

/** @lazy viewModel */
- (TNOrderListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNOrderListViewModel alloc] init];
    }
    return _viewModel;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
- (void)listWillAppear {
    if ([SAUser hasSignedIn]) {
        if (!HDIsArrayEmpty(self.viewModel.dataSource)) {
            self.viewModel.pageSize = self.viewModel.currentPage * 20;
        } else {
            self.viewModel.pageSize = 20;
        }
        [self.viewModel getNewData];
    }
}
@end
