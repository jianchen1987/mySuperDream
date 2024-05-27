//
//  SAOrderListTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SAOrderModel *model;
/// 点击了确认收货
@property (nonatomic, copy) void (^clickedConfirmReceivingBlock)(SAOrderModel *orderModel);
/// 点击了门店标题
@property (nonatomic, copy) void (^clickedStoreTitleBlock)(SAOrderModel *orderModel);
/// 点击了评价
@property (nonatomic, copy) void (^clickedEvaluationOrderBlock)(SAOrderModel *orderModel);
/// 点击了退款详情
@property (nonatomic, copy) void (^clickedRefundDetailBlock)(SAOrderModel *orderModel);
/// 点击了立即支付
@property (nonatomic, copy) void (^clickedPayNowBlock)(SAOrderModel *orderModel);
/// 待支付倒计时时长结束
@property (nonatomic, copy) void (^payTimerCountDownEndedBlock)(SAOrderModel *orderModel);
/// 点击了再次购买
@property (nonatomic, copy) void (^clickedRebuyBlock)(SAOrderModel *orderModel);
/// 点击了转账付款
@property (nonatomic, copy) void (^clickedTransferBlock)(SAOrderModel *orderModel);
///< 再来一单 （电商诉求)
@property (nonatomic, copy) void (^clickedOneMoreBlock)(SAOrderModel *orderModel);
/// 点击了确认取餐
@property (nonatomic, copy) void (^clickedPickUpBlock)(SAOrderModel *orderModel);
@end

NS_ASSUME_NONNULL_END
