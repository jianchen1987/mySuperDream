//
//  TNPaymentResultViewController.h
//  SuperApp
//
//  Created by seeu on 2020/8/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import "SAMoneyModel.h"
#import "TNModel.h"
#import "TNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNPaymentResultModel : TNModel
/// 页面名称
@property (nonatomic, copy) NSString *pageName;
/// 支付状态
@property (nonatomic, assign) SAPaymentState state;
/// 状态描述
@property (nonatomic, copy) NSString *stateDesc;
/// 支付金额
@property (nonatomic, strong) SAMoneyModel *amount;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
///< 商户号
@property (nonatomic, copy, nullable) NSString *merchantNo;
/// 按钮背景颜色
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
/// 支付类型，线上or线下
@property (nonatomic, assign) SAOrderPaymentType paymentType;
@end


@interface TNPaymentResultViewController : TNViewController
/// moedl
@property (nonatomic, strong) TNPaymentResultModel *model;

/// 返回首页回调
@property (nonatomic, copy) void (^backHomeClickedHander)(TNPaymentResultModel *model);
/// 查看订单
@property (nonatomic, copy) void (^orderDetailClickedHandler)(TNPaymentResultModel *model);

@end

NS_ASSUME_NONNULL_END
