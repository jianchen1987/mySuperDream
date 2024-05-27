//
//  PNPaymentCodeViewModel.h
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "PNViewModel.h"

@class HDUserBussinessQueryRsp;
@class HDUserBussinessCreateRsp;
@class HDQrCodePaymentResultQueryRsp;
@class HDGetPaymentCodeRsp;
@class HDGenQRCodeRspModel;
@class PNWalletLimitModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentCodeViewModel : PNViewModel

/**
 用户业务查询

 @param bussinessType 业务类型
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
- (void)queryUserBussinessStatusWithType:(PNUserBussinessType)bussinessType success:(void (^)(HDUserBussinessQueryRsp *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/**
 用户开通业务

 @param bussinessType 业务类型
 @param index 加密因子
 @param password 密码
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
- (void)openBussinessWithType:(PNUserBussinessType)bussinessType
                        index:(NSString *)index
                     password:(NSString *)password
                      success:(void (^)(HDUserBussinessCreateRsp *rspModel))successBlock
                      failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/**
 用户关闭业务

 @param bussinessType 业务类型
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
- (void)closeBussinessWithType:(PNUserBussinessType)bussinessType success:(void (^)(void))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/**
 在线付款码支付结果查询接口

 @param contentQrCode 扫码内容
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
- (void)queryPaymentCodeResultWithContentQrCode:(NSString *)contentQrCode success:(void (^)(HDQrCodePaymentResultQueryRsp *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 免密支付 更新
/// @param bussinessType 12 付款码
/// @param operationType 10-开启 11-关闭
- (void)updateCertifiledWithType:(PNUserBussinessType)bussinessType
                   operationType:(PNUserCertifiedTypes)operationType
                         success:(void (^)(void))successBlock
                         failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取收款码
- (void)genQRCodeByLoginName:(NSString *)loginName Amount:(NSString *)amount Currency:(NSString *)currency success:(void (^)(HDGenQRCodeRspModel *rspModel))successBlock;

- (void)getLimitList:(void (^_Nullable)(NSArray<PNWalletLimitModel *> *list))successBlock;
@end

NS_ASSUME_NONNULL_END
