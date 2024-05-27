//
//  PNPaymentCodeDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class HDUserBussinessQueryRsp;

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentCodeDTO : PNModel

/// 查下用户业务
- (void)queryUserBussinessStatusWithType:(PNUserBussinessType)bussinessType success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 开通业务
- (void)openBussinessWithType:(PNUserBussinessType)bussinessType
                        index:(NSString *)index
                     password:(NSString *)password
                      success:(void (^)(PNRspModel *rspModel))successBlock
                      failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 用户关闭业务
- (void)closeBussinessWithType:(PNUserBussinessType)bussinessType success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 用户付款码支付结果查询
- (void)queryPaymentCodeResultWithContentQrCode:(NSString *)contentQrCode success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 免密支付 更新 【开启/停用】
- (void)updateCertifiledWithType:(PNUserBussinessType)bussinessType
                   operationType:(PNUserCertifiedTypes)operationType
                         success:(void (^)(PNRspModel *rspModel))successBlock
                         failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取收款码
- (void)genQRCodeByLoginName:(NSString *)loginName
                      Amount:(NSString *)amount
                    Currency:(NSString *)currency
                     success:(void (^)(PNRspModel *rspModel))successBlock
                     failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
