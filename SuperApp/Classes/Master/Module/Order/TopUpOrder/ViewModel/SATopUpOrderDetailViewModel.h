//
//  SATopUpOrderDetailViewModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandViewController.h"
#import "SAViewModel.h"

@class SATopUpOrderDetailRspModel;
@class SAQueryOrderDetailsRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface SATopUpOrderDetailViewModel : SAViewModel <HDCheckStandViewControllerDelegate>

/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// 账单号
@property (nonatomic, copy) NSString *orderNo;
/// 外部订单号
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 账单详情数据
@property (nonatomic, strong) SATopUpOrderDetailRspModel *model;
///< 中台订单数据
@property (nonatomic, strong) SAQueryOrderDetailsRspModel *orderInfo;

#pragma mark - 显示用的参数
/// 状态显示
@property (nonatomic, copy) NSString *status;
/// 是否显示支付按钮
@property (nonatomic, assign) BOOL isShowPayButton;
/// 充值图标
@property (nonatomic, copy) NSString *storeIcon;
/// 充值号码
@property (nonatomic, copy) NSString *account;
/// 充值金额
@property (nonatomic, copy) NSAttributedString *topUpMoney;
/// 支付金额
@property (nonatomic, copy) NSString *payMoney;
/// 下单时间
@property (nonatomic, strong) NSString *createTime;
/// 充值时间
@property (nonatomic, copy) NSString *orderTime;

/// 获取详情
- (void)getTopUpOrderDetail;

@end

NS_ASSUME_NONNULL_END
