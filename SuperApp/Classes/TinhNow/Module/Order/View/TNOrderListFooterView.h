//
//  TNOrderListFooterView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
#import "TNOrderListRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderListFooterView : SATableHeaderFooterView
@property (strong, nonatomic) TNOrderModel *orderModel;
/// 点击了确认收货
@property (nonatomic, copy) void (^clickedConfirmReceivingBlock)(TNOrderModel *orderModel);
/// 点击了评价
@property (nonatomic, copy) void (^clickedEvaluationOrderBlock)(TNOrderModel *orderModel);
/// 点击了退款详情
@property (nonatomic, copy) void (^clickedRefundDetailBlock)(TNOrderModel *orderModel);
/// 点击了立即支付
@property (nonatomic, copy) void (^clickedPayNowBlock)(TNOrderModel *orderModel);
/// 点击了再次购买
@property (nonatomic, copy) void (^clickedRebuyBlock)(TNOrderModel *orderModel);
/// 点击了转账付款
@property (nonatomic, copy) void (^clickedTransferBlock)(TNOrderModel *orderModel);
/// 再来一单 （电商诉求)
@property (nonatomic, copy) void (^clickedOneMoreBlock)(TNOrderModel *orderModel);
/// 取消订单
@property (nonatomic, copy) void (^clickedCancelBlock)(TNOrderModel *orderModel);
@end

NS_ASSUME_NONNULL_END
