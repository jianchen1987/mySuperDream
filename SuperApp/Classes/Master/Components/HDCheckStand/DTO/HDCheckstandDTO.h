//
//  HDCheckstandDTO.h
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAModel.h"

@class HDTradeBuildOrderModel;
@class HDTradeCreatePaymentRspModel;
@class HDTradeConfirmPaymentRspModel;
@class HDTradeSubmitPaymentRspModel;
@class HDTradePreferentialModel;
@class HDQueryPaymentMethodRspModel;
@class HDTradeOrderStateRspModel;
@class HDOnlinePaymentToolsModel;
@class HDCheckStandOrderSubmitParamsRspModel;
@class HDCreatePayOrderRspModel;
@class HDQueryAnnoncementRspModel;
@class SAGoodsModel;
@class SAMoneyModel;
@class SAQueryPaymentAvailableActivityAnnouncementRspModel;
@class SAQueryPaymentAvailableActivityRspModel;
@class SAPaymentToolsActivityModel;
@class HDCheckStandQRCodePayDetailRspModel;

NS_ASSUME_NONNULL_BEGIN

/**
 收银台相关接口
 */
@interface HDCheckstandDTO : SAModel

/// 创建支付单
/// @param returnUrl 支付跳转url
/// @param orderNo 聚合订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)createPayOrderWithReturnUrl:(NSString *_Nonnull)returnUrl
                                          orderNo:(NSString *_Nonnull)orderNo
                                          trialId:(NSString *_Nullable)trialId
                                    payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                   discountAmount:(SAMoneyModel *_Nullable)discountAmount
                                          success:(void (^_Nullable)(HDCreatePayOrderRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 创建支付单
/// @param returnUrl 支付跳转url
/// @param orderNo 聚合订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
/// @param isCashOnDelivery 是否货到付款
- (CMNetworkRequest *)createPayOrderWithReturnUrl:(NSString *)returnUrl
                                          orderNo:(NSString *)orderNo
                                          trialId:(NSString *_Nullable)trialId
                                    payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                   discountAmount:(SAMoneyModel *_Nullable)discountAmount
                                 isCashOnDelivery:(BOOL)isCashOnDelivery
                                          success:(void (^)(HDCreatePayOrderRspModel *_Nonnull))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock;


/// 提交支付参数
/// @param payWay 支付方式
/// @param orderNo 聚合单号
/// @param tradeNo 交易订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)submitOrderParamsWithPaymentMethod:(HDCheckStandPaymentTools)payWay
                                                 orderNo:(NSString *_Nonnull)orderNo
                                                 tradeNo:(NSString *)tradeNo
                                                 success:(void (^_Nullable)(HDCheckStandOrderSubmitParamsRspModel *rspModel))successBlock
                                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 校验支付密码
/// @param payPwd 支付密码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)verifyPayPwd:(NSString *)payPwd
                           success:(void (^_Nullable)(NSString *token, NSString *index, NSString *pwdSecurityStr))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/**
 支付

 @param payPwd 支付密码
 @param tradeNo 订单号 (最大长度32)
 @param voucherNo 凭证号 (最大长度32)
 @param outBizNo 外部订单号
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (CMNetworkRequest *)tradeSubmitPaymentWithPayPwd:(NSString *)payPwd
                                           tradeNo:(NSString *)tradeNo
                                         voucherNo:(NSString *)voucherNo
                                          outBizNo:(NSString *)outBizNo
                                           success:(void (^)(HDTradeSubmitPaymentRspModel *rspModel))successBlock
                                           failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/**
 关闭订单

 @param tradeNo 交易订单号
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (CMNetworkRequest *)tradeClosePaymentWithTradeNo:(NSString *)tradeNo success:(void (^)(NSString *tradeNo))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询订单状态
/// @param tradeNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryOrderStatusWithTradeNo:(NSString *)tradeNo success:(void (^)(HDTradeOrderStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取支付渠道
/// @param tradeNo 交易订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryPaymentMethodListWithTradeNo:(NSString *)tradeNo
                                                success:(void (^_Nullable)(HDQueryPaymentMethodRspModel *rspModel))successBlock
                                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询公告
/// @param success 成功回调
/// @param failure 失败回调
- (CMNetworkRequest *)queryPaymentAnnouncementSuccess:(void (^_Nullable)(HDQueryAnnoncementRspModel *_Nullable announcement))success failure:(CMNetworkFailureBlock)failure;

/// 查询支付营销公告
/// @param merchantNo 商户号（二级商户）
/// @param storeNo 门店号
/// @param businessLine 业务线
/// @param goods 商品数据
/// @param payableAmount 应付金额
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryPaymentAvailableActivityAnnouncementWithMerchantNo:(NSString *_Nonnull)merchantNo
                                                        storeNo:(NSString *_Nonnull)storeNo
                                                   businessLine:(SAClientType)businessLine
                                                          goods:(NSArray<SAGoodsModel *> *_Nullable)goods
                                                  payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                                        success:(void (^)(SAQueryPaymentAvailableActivityAnnouncementRspModel *_Nonnull rspModel))successBlock
                                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询可用的支付营销活动
/// @param merchantNo 商户号
/// @param storeNo 门店号
/// @param businessLine 业务线
/// @param goods 商品数据
/// @param payableAmount 应付金额
/// @param aggregateOrderNo 聚合单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryPaymentAvailableActivityWithMerchantNo:(NSString *_Nonnull)merchantNo
                                            storeNo:(NSString *_Nonnull)storeNo
                                       businessLine:(SAClientType)businessLine
                                              goods:(NSArray<SAGoodsModel *> *_Nullable)goods
                                      payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                   aggregateOrderNo:(NSString *_Nullable)aggregateOrderNo
                                            success:(void (^)(NSArray<SAPaymentToolsActivityModel *> *_Nullable activitys))successBlock
                                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查当前商户可用的支付工具
/// @param merchantNo 商户号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryAvaliableOnlinePaymentToolsWithMerchantNo:(NSString *_Nonnull)merchantNo
                                               success:(void (^_Nullable)(NSArray<HDOnlinePaymentToolsModel *> *_Nullable paymentTools))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取QRCODE支付详情
/// @param aggregateOrderNo 交易订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getQRCodePayDetailWithAggregateOrderNo:(NSString *)aggregateOrderNo
                                                     success:(void (^_Nullable)(HDCheckStandQRCodePayDetailRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
