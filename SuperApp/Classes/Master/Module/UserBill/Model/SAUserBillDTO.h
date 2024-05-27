//
//  SAUserBillDTO.h
//  SuperApp
//
//  Created by seeu on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "SAEnumModel.h"
#import "SAInternationalizationModel.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAUserBillListRspModel;
@class SAUserBillListModel;
@class SAUserBillPaymentDetailsRspModel;
@class SAUserBillRefundDetailsRspModel;
@class SAUserBillRefundRecordModel;
@class SAUserBillRefundReceiveAccountModel;
@class SAUserBillStatisticsRspModel;


@interface SAUserBillDTO : SAModel

- (void)queryUserBillListWithPageNum:(NSUInteger)pageNum
                            pageSize:(NSUInteger)pageSize
                           startTime:(NSTimeInterval)startTime
                             endTime:(NSTimeInterval)endTime
                             success:(void (^_Nullable)(SAUserBillListRspModel *list))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock;

- (void)queryUserBillPaymentDetailsWithPayTransactionNo:(NSString *_Nullable)payTransactionNo
                                             payOrderNo:(NSString *_Nullable)payOrderNo
                                                success:(void (^)(SAUserBillPaymentDetailsRspModel *_Nonnull))successBlock
                                                failure:(CMNetworkFailureBlock)failureBlock;

- (void)queryUserBillRefundDetailsWithRefundTransactionNo:(NSString *_Nullable)refundTransactionNo
                                            refundOrderNo:(NSString *_Nullable)refundOrderNo
                                                  success:(void (^)(SAUserBillRefundDetailsRspModel *_Nonnull))successBlock
                                                  failure:(CMNetworkFailureBlock)failureBlock;

- (void)getUserBillStatisticsWithStatTime:(NSTimeInterval)startTime
                                  endTime:(NSTimeInterval)endTime
                                  success:(void (^)(SAUserBillStatisticsRspModel *_Nonnull))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock;

@end


@interface SAUserBillListRspModel : SACommonPagingRspModel
@property (nonatomic, strong) NSArray<SAUserBillListModel *> *list;
@end
;


@interface SAUserBillListModel : SAModel
///< 支付流水号
@property (nonatomic, copy) NSString *payTransactionNo;
///< 退款流水号
@property (nonatomic, copy) NSString *refundTransactionNo;
///< 业务线
@property (nonatomic, copy) NSString *businessLine;
///< 创建时间
@property (nonatomic, strong) NSNumber *createTime;
///< 账单类型  EXPENSES :1-支出 INCOME :2-收入
@property (nonatomic, strong) SAEnumModel *billingType;
///< 账单行为 CONSUME :1、消费  AFTER_SALE_REFUND :2 退款(售后退款) REPEAT_PAY_REFUND :3 退款(重复支付) OVERTIME_PAYMENT_REFUND :4 退款(超时支付)
@property (nonatomic, strong) SAEnumModel *billingAction;
///< 消费来源
@property (nonatomic, copy) NSString *consumeSource;
///< 备注
@property (nonatomic, copy) NSString *remark;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 商户名
@property (nonatomic, copy) NSString *merchantName;
///< 金额
@property (nonatomic, strong) SAMoneyModel *amount;
///< 是否已经退款
@property (nonatomic, assign) BOOL existRefundOrder;

@end


@interface SAUserBillPaymentDetailsRspModel : SARspModel
///< 付款方式
@property (nonatomic, copy) NSString *payChannel;
///< 支付状态
@property (nonatomic, assign) SAPaymentState payState;
///< 创建时间
@property (nonatomic, strong) NSNumber *createTime;
///< 支付时间
@property (nonatomic, strong) NSNumber *finishTime;
///< 支付单号
@property (nonatomic, copy) NSString *payOrderNo;
///< 支付流水号
@property (nonatomic, copy) NSString *payTransactionNo;
///< 业务订单号
@property (nonatomic, copy) NSString *businessOrderId;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 商户名
@property (nonatomic, copy) NSString *merchantName;
///< 业务线
@property (nonatomic, copy) NSString *businessLine;
///< 实付金额
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
///< 商品名称
@property (nonatomic, strong) SAInternationalizationModel *shopName;
///< 退款记录集合
@property (nonatomic, strong) NSArray<SAUserBillRefundRecordModel *> *refundRecordList;
@end


@interface SAUserBillRefundDetailsRspModel : SARspModel
///< 退款途径 ONLINE_REFUND :1-原路退回 OFFLINE_REFUND :2-线下退款 CLOSE_REFUND :3-关闭退款
@property (nonatomic, strong) SAEnumModel *refundWay;
///< 付款方式
@property (nonatomic, copy) NSString *payChannel;
/* 退款状态 WAIT,PROCESSING,COMPLETE,REJECT,CANCEL,INITIALIZE,REVOKE,CLOSED,TIME_OUT
枚举备注: WAIT :9-待退款
 PROCESSING :10-退款中
 COMPLETE :11-已退款
 REJECT :12-商家拒绝退款
 CANCEL :13-退款已取消
 INITIALIZE :14-初始状态
 REVOKE :15-退款异常 （原退款撤销） 在线支付订单，系统通过原路返回进行退款，向CoolCash连续3次发起退款请求，都是收到退款失败结果，标记为异常 CLOSED :退款关闭 只能用于退款异常状态 TIME_OUT
:退款超过有效期
*/
@property (nonatomic, assign) SARefundState refundOrderState;

///< 退款时间
@property (nonatomic, strong) NSNumber *finishTime;
///< 支付单号
@property (nonatomic, copy) NSString *payOrderNo;
///< 退款单号
@property (nonatomic, copy) NSString *refundOrderNo;
///< 退款来源 NORMAL :10-业务正常退款 REPEAT :11-重复支付退款 TIME_OUT :12-超时支付退款 CHANNLE_UNILATERAL :13-渠道单方退款
@property (nonatomic, assign) SARefundSource refundSource;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 商户名
@property (nonatomic, copy) NSString *merchantName;
///< 业务线
@property (nonatomic, copy) NSString *businessLine;
///< 退款金额
@property (nonatomic, strong) SAMoneyModel *refundAmount;
///< 收款信息
@property (nonatomic, strong) SAUserBillRefundReceiveAccountModel *offlineRefundOrderDetail;

@end


@interface SAUserBillRefundRecordModel : SAModel

///< 退款单号
@property (nonatomic, copy) NSString *refundOrderNo;
///< 退款金额
@property (nonatomic, strong) SAMoneyModel *refundAmount;

@end


@interface SAUserBillRefundReceiveAccountModel : SAModel
///< 收款账号
@property (nonatomic, copy) NSString *receiveAccount;
///< 收款名称
@property (nonatomic, copy) NSString *receiveName;
///< 付款渠道
@property (nonatomic, copy) NSString *paymentChannel;
@end


@interface SAUserBillStatisticsRspModel : SAModel
///< 收入
@property (nonatomic, strong) SAMoneyModel *cashInAmt;
///< 支出
@property (nonatomic, strong) SAMoneyModel *cashOutAmt;
@end

NS_ASSUME_NONNULL_END
