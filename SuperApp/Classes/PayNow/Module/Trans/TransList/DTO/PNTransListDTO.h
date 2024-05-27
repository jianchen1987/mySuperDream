//
//  PNTransListDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class HDPayeeInfoModel;
@class HDTransferOrderBuildRspModel;
@class HDUserBillDetailRspModel;
@class HDAnalysisQRCodeRspModel;
@class PNBillListRspModel;
@class PNQueryWithdrawCodeModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNTransListDTO : PNModel
/// 获取转账列表配置
- (void)getPayNowTransListConfig:(void (^_Nullable)(NSArray *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取最近转账联系人
- (void)getPayNowTransferUser:(void (^_Nullable)(NSArray *array))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 收藏/取消 最近联系人
- (void)userCollectAction:(NSInteger)flag
                  rivalNo:(NSString *)rivalNo
                  bizType:(PNTransferType)bizEntity
                  success:(void (^_Nullable)(void))successBlock
                  failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取对应的 收款人信息
- (void)getPayeeInfo:(NSDictionary *)paramsDict
             bizType:(PNTransferType)bizType
             success:(void (^_Nullable)(HDPayeeInfoModel *rspModel))successBlock
             failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取对应的 收款人信息 - 针对bakong二维码解析
- (void)getPayeeInfoFromBaKongQRCodeWithAccuontNo:(NSString *)accountNo
                                       merchantId:(NSString *)merchantId
                                     merchantType:(NSString *)merchantType
                                    terminalLabel:(NSString *)terminalLabel
                                          success:(void (^_Nullable)(HDPayeeInfoModel *rspModel))successBlock
                                          failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取对应的 收款人信息 - 针对Coolcash二维码解析
- (void)getPayeeInfoFromCoolcashQRCodeWithQRData:(NSString *)qrData success:(void (^_Nullable)(HDPayeeInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// coolcash出金确认
- (void)coolcashOutConfirmOrderWithFeeAmt:(NSString *)feeAmt
                                   payAmt:(NSString *)payAmt
                                  orderNo:(NSString *)orderNo
                                  purpose:(NSString *)purpose
                                  success:(void (^_Nullable)(HDTransferOrderBuildRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 转账下单
- (void)outConfirmOrderWithParams:(NSDictionary *)paramsDict
    shouldAlertErrorMsgExceptSpecCode:(BOOL)errorAlert
                              success:(void (^_Nullable)(HDTransferOrderBuildRspModel *rspModel))successBlock
                              failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取交易列表
- (void)getTransOrderListWithParams:(NSDictionary *)paramsDict success:(void (^_Nullable)(PNBillListRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取交易详情/订单详情
- (void)getTransOrderDetailWithtTadeNo:(NSString *)tradeNo
                             tradeType:(NSString *)tradeType
                               success:(void (^_Nullable)(HDUserBillDetailRspModel *rspModel))successBlock
                               failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 解析二维码V2
- (void)doAnalysisQRCode:(NSString *)qrCodeStr success:(void (^_Nullable)(HDAnalysisQRCodeRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 根据汇款交易单号，查询提码信息
- (void)queryWithdrawCodeWithTradeNo:(NSString *)tradeNo success:(void (^_Nullable)(PNQueryWithdrawCodeModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
