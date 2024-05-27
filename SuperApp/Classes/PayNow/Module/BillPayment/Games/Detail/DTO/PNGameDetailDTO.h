//
//  PNGameDetailDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBalanceAndExchangeModel.h"
#import "PNGameDetailRspModel.h"
#import "PNGameFeeModel.h"
#import "PNGameSubmitOderRequestModel.h"
#import "PNGameSubmitOrderResponseModel.h"
#import "PNModel.h"
#import "TNGameBalanceAccountModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNGameDetailDTO : PNModel
/// 查询账单详情
- (void)queryGameItemDetailWithCategoryId:(NSString *)categoryId success:(void (^)(PNGameDetailRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询娱乐账号信息  通过billCode + userid+zoneid  如果没有userId zoneId 就不用拼接
/// - Parameters:
///   - billCode: billCode
///   - currency: currency
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)queryGameBalanceInquiryWithBillCode:(NSString *)billCode
                                   currency:(NSString *)currency
                                    success:(void (^)(TNGameBalanceAccountModel *rspModel))successBlock
                                    failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 请求娱乐缴费手续费和营销优惠
/// - Parameters:
///   - amt: 支付金额
///   - currency: 币种
///   - chargeType:手续费承担方（D=客户全部承担，C=商家全部承担，P=客户和商家按比例共同承担
///   - billCode:  通过billCode + userid+zoneid  如果没有userId zoneId 就不用拼接
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)queryGameFeeAndPromotionWithAmt:(NSString *)amt
                               currency:(NSString *)currency
                             chargeType:(NSString *)chargeType
                           supplierCode:(NSString *)supplierCode
                               billCode:(NSString *)billCode
                                success:(void (^)(PNGameFeeModel *feeModel))successBlock
                                failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取用户钱包余额  是否拉起中台收银台
/// - Parameters:
///   - totalAmount: 支付金额
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)queryUserBalanceAndExchangeWithTotalAmount:(NSString *)totalAmount success:(void (^)(PNBalanceAndExchangeModel *feeModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 中台下聚合单
/// - Parameters:
///   - submitModel: 下单模型
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)createGameAggregateOrderWithSubmitModel:(PNGameSubmitOderRequestModel *)submitModel
                                        success:(void (^)(PNGameSubmitOrderResponseModel *responseModel))successBlock
                                        failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 钱包下单
/// - Parameters:
///   - submitModel: 下单模型
///   - successBlock: 成功回调
///   - failureBlock: 失败回调
- (void)createGameWalletOrderWithSubmitModel:(PNGameSubmitOderRequestModel *)submitModel
                                     success:(void (^)(PNGameSubmitOrderResponseModel *responseModel))successBlock
                                     failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
