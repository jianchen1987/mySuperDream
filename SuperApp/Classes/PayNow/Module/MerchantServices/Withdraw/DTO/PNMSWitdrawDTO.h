//
//  PNMSCaseInDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMSTransferCreateOrderRspModel;
@class PNMSWithdranBankInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSWitdrawDTO : PNModel
/// 转账入金下单【商户入金到自己的钱包】
- (void)transferMSCreateOrderWithParam:(NSDictionary *)paramDict
                               success:(void (^_Nullable)(PNMSTransferCreateOrderRspModel *rspModel))successBlock
                               failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 绑定银行卡 - 发送短信
- (void)bindBankCardSendSMSCodeWithParam:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 绑定添加银行卡
- (void)bindBankWithParam:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询商户提现银行卡列表
- (void)getBankCradListWithCurrency:(PNCurrencyType)currency success:(void (^)(NSArray<PNMSWithdranBankInfoModel *> *rspArray))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 删除商户提现银行卡
- (void)deleteBankCard:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// wownow APP 商户服务提现 交易前检查接口
- (void)withdrawPreCheck:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// APP 商户服务提现 下单接口
- (void)bankCardWithdrawMSCreateOrderWithParam:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 提现 支付密码校验
- (void)ms_withdrawAutoWithOrderNo:(NSString *)orderNo
                     cashVoucherNo:(NSString *)cashVoucherNo
                            payPwd:(NSString *)payPwd
                             index:(NSString *)index
                           funcCtl:(NSString *)funcCtl
                           success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
                           failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询银行卡信息
- (void)queryBankCardInfo:(NSDictionary *)paramDict success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询
- (void)getList:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
