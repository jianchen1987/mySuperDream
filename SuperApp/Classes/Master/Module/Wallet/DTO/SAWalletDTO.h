//
//  SAWalletDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAWalletEnum.h"

@class SAWalletBalanceModel;
@class SAEnableWalletRspModel;
@class SAWalletChargeCreateRspModel;
@class SAMoneyModel;
@class SAWalletBillListRspModel;
@class SAWalletBillDetailRspModel;
@class SAVerifySMSCodeRspModel;
@class SAQueryAvaliableChannelRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface SAWalletDTO : SAModel

/// 查询余额
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryBalanceSuccess:(void (^_Nullable)(SAWalletBalanceModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 开通钱包
/// @param password 密码（明文）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)enableWalletWithPassword:(NSString *)password
                                     firstName:(NSString *)firstName
                                      lastName:(NSString *)lastName
                                        gender:(NSInteger)gender
                                       headUrl:(NSString *)headUrl
                                      birthday:(NSString *)birthday
                                       success:(void (^_Nullable)(SAEnableWalletRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 充值单创建
/// @param payAmt 充值金额
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)createChargeOrderWithPayAmt:(SAMoneyModel *)payAmt
                                          success:(void (^_Nullable)(SAWalletChargeCreateRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 钱包账单分页查询
/// @param pageSize 分页大小
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryWalletBillListWithPageSize:(NSUInteger)pageSize
                                              pageNum:(NSUInteger)pageNum
                                              success:(void (^_Nullable)(SAWalletBillListRspModel *rspModel))successBlock
                                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 钱包历史账单分页查询
/// @param pageSize 分页大小
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryWalletHistoryBillListWithPageSize:(NSUInteger)pageSize
                                                     pageNum:(NSUInteger)pageNum
                                                     success:(void (^_Nullable)(SAWalletBillListRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询钱包账单详情
/// @param tradeNo 交易订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryWalletBillDetailWithTradeNo:(NSString *)tradeNo
                                               success:(void (^_Nullable)(SAWalletBillDetailRspModel *rspModel))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 发送短信验证码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)sendSMSCodeSuccess:(void (^)(NSString *serialNum))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 校验短信验证码
/// @param smsCode 验证码
/// @param serialNum 短信序列号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)verifySMSCodeWithSmsCode:(NSString *)smsCode
                                     serialNum:(NSString *)serialNum
                                       success:(void (^)(SAVerifySMSCodeRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock)failureBlock;

/// 校验支付密码
/// @param password 原交易密码明文
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)verifyOriginalPayPwdWithPassword:(NSString *)password success:(void (^)(NSString *accessToken))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 修改支付密码
/// @param password 新交易密码明文
/// @param accessToken token
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)changePayPwdWithPassword:(NSString *)password accessToken:(NSString *)accessToken success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 查询可用的支付渠道
/// @param transType 业务类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryAvaliableChannelWithTransType:(HDWalletTransType)transType
                                clientType:(SAClientType)clientType
                                   success:(void (^)(NSArray<NSString *> *channels))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
