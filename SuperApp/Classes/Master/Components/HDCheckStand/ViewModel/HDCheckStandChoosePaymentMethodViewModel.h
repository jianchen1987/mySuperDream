//
//  HDCheckStandChoosePaymentMethodViewModel.h
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "HDCheckStandOrderSubmitParamsRspModel.h"
#import "HDCheckStandPaymentMethodCellModel.h"
#import "HDCreatePayOrderRspModel.h"
#import "HDPaymentMethodType.h"
#import "SAGoodsModel.h"
#import "SAMoneyModel.h"
#import "SAViewModel.h"
#import "SAWalletBalanceModel.h"
#import "SAQueryPaymentStateRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckStandChoosePaymentMethodViewModel : SAViewModel

///< 支付公告
@property (nonatomic, copy, readonly) NSString *paymentAnnoncement;
///< 可用的支付方式
@property (nonatomic, strong, readonly) NSArray<HDCheckStandPaymentMethodCellModel *> *availablePaymentMethods;

///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 门店号
@property (nonatomic, copy) NSString *storeNo;
///< 应付金额
@property (nonatomic, strong) SAMoneyModel *payableAmount;
///< 业务线
@property (nonatomic, copy) SAClientType businessLine;
///< 商品
@property (nonatomic, strong) NSArray<SAGoodsModel *> *goods;
///< 支持的支付方式
@property (nonatomic, strong) NSArray<HDSupportedPaymentMethod> *supportedPaymentMethod;
///< 上一次选中的支付方式
@property (nonatomic, strong) HDPaymentMethodType *lastChoosedMethod;
///< 聚合订单号
@property (nonatomic, copy, nullable) NSString *orderNo;
///< coolcash 支付订单号，不是中台支付订单号
@property (nonatomic, copy) NSString *outPayOrderNo;
///< 用户钱包状态
@property (nonatomic, strong) SAWalletBalanceModel *userWallet;
/// 是否为预选
@property (nonatomic) BOOL isPre;
/// 外卖自取为20的时候用到
@property (nonatomic, assign) NSInteger serviceType;

- (void)initialize;

- (void)submitPaymentParamsWithPaymentTools:(HDCheckStandPaymentTools)tools
                                    orderNo:(NSString *_Nonnull)orderNo
                              outPayOrderNo:(NSString *_Nonnull)outPayOrderNo
                                    success:(void (^)(HDCheckStandOrderSubmitParamsRspModel *_Nonnull rspModel))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock;

- (void)getQRCodePayDetailWithAggregateOrderNo:(NSString *_Nonnull)aggregateOrderNo
                                       success:(void (^)(HDCheckStandQRCodePayDetailRspModel *_Nonnull rspModel))successBlock
                                       failure:(CMNetworkFailureBlock)failureBlock;

/// 创建支付单
/// @param orderNo 聚合单号
/// @param trialId 营销试算id
/// @param payableAmount 应付金额
/// @param discountAmount 实付金额
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)createPayOrderWithOrderNo:(NSString *_Nonnull)orderNo
                          trialId:(NSString *_Nullable)trialId
                    payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                   discountAmount:(SAMoneyModel *_Nullable)discountAmount
                          success:(void (^)(HDCreatePayOrderRspModel *_Nonnull rspModel))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock;
/// 创建支付单
/// @param orderNo 聚合单号
/// @param trialId 营销试算id
/// @param payableAmount 应付金额
/// @param discountAmount 实付金额
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
/// @param isCashOnDelivery 是否为货到付款
- (void)createPayOrderWithOrderNo:(NSString *_Nonnull)orderNo
                          trialId:(NSString *_Nullable)trialId
                    payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                   discountAmount:(SAMoneyModel *_Nullable)discountAmount
                 isCashOnDelivery:(BOOL)isCashOnDelivery
                          success:(void (^)(HDCreatePayOrderRspModel *_Nonnull rspModel))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock;


/// 查询订单支付状态
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryOrderPaymentStateSuccess:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
