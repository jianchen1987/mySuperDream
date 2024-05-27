//
//  PNWaterDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWaterDTO : PNModel

/// 查询账单编号查询账单
/// @param billCode Bill number 账单号  必填
/// @param customerCode Customer number 用户号  必填
/// @param categoryType 缴费类型
/// @Param currency 币种
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryBillWithBillCode:(NSString *)billCode
                 customerCode:(NSString *)customerCode
                 categoryType:(PNPaymentCategory)categoryType
                     currency:(PNCurrencyType)currency
                apiCredential:(NSString *)apiCredential
                   billAmount:(NSString *)billAmount
                customerPhone:(NSString *)customerPhone
                        notes:(NSString *)notes
                      success:(void (^)(PNRspModel *rspModel))successBlock
                      failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询最近交易账单列表
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryRecentBillList:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 聚合下单
/// @param param 入参
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)submitBillWithParam:(NSDictionary *)param success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 支付结果查询
/// @param orderNo 聚合订单号  和 tradeNo二选一
/// @param tradeNo 钱包订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryPaymentResultWithOrderNo:(NSString *_Nullable)orderNo
                              tradeNo:(NSString *_Nullable)tradeNo
                              success:(void (^)(PNRspModel *rspModel))successBlock
                              failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询账单详情 orderNo tradeNo 二选一
- (void)queryBillDetailWithOrderNo:(NSString *)orderNo tradeNo:(NSString *)tradeNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 关闭业务账单订单
- (void)closePaymentOrderWithOrderNo:(NSString *)orderNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询所有账单分类
- (void)getAllBillCategory:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 根据类型获取对应的供应商列表
- (void)getBillerSupplierListWithType:(PNPaymentCategory)paymentCategory success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
