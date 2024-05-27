//
//  SACommonrefundInfoModel.h
//  SuperApp
//
//  Created by Tia on 2022/5/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACommonRefundOperateListModel : SAModel
/// 备注
@property (nonatomic, strong) NSString *remark;
/// 操作时间
@property (nonatomic, assign) NSInteger updateTime;
/// 操作类型 10-退款关闭 11-退款完成 12-改为线下退款 13-退款失败 14-重新发起 15-创建退款
@property (nonatomic, assign) SARefundOperationType operationType;

@end


@interface SACommonRefundOfflineRefundOrderDetailModel : SAModel
/// 收款账户
@property (nonatomic, copy) NSString *receiveAccount;
/// 收款人姓名
@property (nonatomic, copy) NSString *receiveName;
/// 付款渠道
@property (nonatomic, copy) NSString *paymentChannel;

@end


@interface SACommonRefundInfoModel : SAModel
/// 退款途径 1、原路退回 2、线下退款
@property (nonatomic, assign) NSInteger refundWay;
/// 付款方式
@property (nonatomic, copy) NSString *payChannel;
/// 退款时间
@property (nonatomic, assign) NSInteger finishTime;
/// 线下退款模型
@property (nonatomic, strong) SACommonRefundOfflineRefundOrderDetailModel *offlineRefundOrderDetail;
/// 退款金额模型
@property (nonatomic, strong) SAMoneyModel *refundAmount;
/// 是否显示钱款去向按钮:10:显示，11:不显示。
@property (nonatomic, assign) NSInteger guideShow;
@property (nonatomic, strong) NSArray *refundOrderOperateList;
/// 退款状态 :9-待退款,10-退款中,11-已退款,12-商家拒绝退款,13-退款已取消,99-初始状态,15-退款异常 （原退款撤销）17-退款关闭 只能用于退款异常状态,18-退款超过有效期
@property (nonatomic, assign) SARefundState refundOrderState;
/// 退款类型：10-全额退款,11-部分退款
@property (nonatomic, assign) NSInteger refundCategory;
/// 退款来源 NORMAL :10-业务正常退款 REPEAT :11-重复支付退款 TIME_OUT :12-超时支付退款 CHANNLE_UNILATERAL :13-渠道单方退款
@property (nonatomic, assign) SARefundSource refundSource;
/// 一级商户号
@property (nonatomic, strong) NSString *firstMerchantNo;
/// 支付单号
@property (nonatomic, copy) NSString *payOrderNo;
/// 商户名
@property (nonatomic, copy) NSString *merchantName;
/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
/// 商户号
@property (nonatomic, copy) NSString *merchantNo;
/// 退款单号
@property (nonatomic, copy) NSString *refundOrderNo;
/// 业务订单编号
@property (nonatomic, copy) NSString *businessOrderId;
/// 币种
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *androidUrl;
@property (nonatomic, copy) NSString *iosUrl;

/// 退款协商历史链接
@property (nonatomic, copy) NSString *negotiationHistoryUrl;

@end

NS_ASSUME_NONNULL_END
