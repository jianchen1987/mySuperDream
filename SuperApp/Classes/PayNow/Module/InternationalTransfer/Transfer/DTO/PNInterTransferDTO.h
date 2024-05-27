//
//  PNInterTransferDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
@class PNInterTransferRateFeeModel;
@class PNInterTransferQuotaAndRateModel;
@class PNInterTransferPayerInfoModel;
@class PNInterTransferCreateOrderModel;
@class PNInterTransferConfirmInfoModel;
@class PNInterTransRecordModel;
@class PNInterTransferRiskListModel;
@class PNWalletHomeBannerModel;
@class PNNeedInputInviteCodeRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferDTO : PNModel
/// 查询汇率和手续费规则
- (void)queryRateFeeWithChannel:(PNInterTransferThunesChannel)channel success:(void (^)(PNInterTransferRateFeeModel *_Nonnull))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// 获取全部的风控限制
- (void)queryriskListWithChannel:(PNInterTransferThunesChannel)channel
                         success:(void (^)(NSArray<PNInterTransferRiskListModel *> *_Nonnull rspArray))successBlock
                         failure:(PNNetworkFailureBlock)failureBlock;

/// 查询手续费
- (void)queryFeeWithAmount:(NSString *)amount channel:(PNInterTransferThunesChannel)channel success:(void (^)(NSString *charge))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// 开通国际转账
- (void)openInterTransferAccount:(NSString *)beneficiaryId channel:(PNInterTransferThunesChannel)channel success:(void (^)(void))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// 查询额度和汇率
- (void)queryQuotaAndExchangeRateSuccess:(void (^_Nullable)(PNInterTransferQuotaAndRateModel *quotaModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询付款人信息
- (void)queryPayerInfoWithPayOutAmount:(NSString *)payOutAmount
                              currency:(NSString *)currency
                                msisdn:(NSString *)msisdn
                               channel:(PNInterTransferThunesChannel)channel
                               success:(void (^)(PNInterTransferPayerInfoModel *payerInfoModel))successBlock
                               failure:(PNNetworkFailureBlock)failureBlock;

/// 反洗钱校验
/// @param reciverName 收款人名字
/// @param idType 证件类型  12 身份证  13 护照
/// @param receiverID 收款人id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)amlAnalyzeVerificationWithReciverName:(NSString *)reciverName
                                       idType:(NSString *)idType
                                   receiverID:(NSString *)receiverID
                                      success:(void (^_Nullable)(void))successBlock
                                      failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 创建国际转账订单
/// @param createModel 下单模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)createOrderWithCreateModel:(PNInterTransferCreateOrderModel *)createModel
                           channel:(PNInterTransferThunesChannel)channel
                           success:(void (^_Nullable)(PNInterTransferConfirmInfoModel *confirmModel))successBlock
                           failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取支付结果
- (void)getPayResultWithOrderNo:(NSString *)orderNo success:(void (^)(PNInterTransRecordModel *confirmModel))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// 检查付款人是否可以使用国际转账功能
- (void)checkInterTransfer:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// Banner广告
- (void)getWalletHomeBanner:(void (^_Nullable)(NSArray<PNWalletHomeBannerModel *> *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 是否是首单需要输入邀请码
- (void)checkNeedInputInvitationCode:(void (^)(PNNeedInputInviteCodeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock;

/// 校验&绑定激活码
- (void)bindingInviteCode:(NSString *)inviteCode success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
