//
//  PNWaterViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

@class PNWaterBillModel;
@class PNBillPayInfoModel;
@class PNCreateAggregateOrderRspModel;
@class SAQueryOrderInfoRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNWaterViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) PNWaterBillModel *billModel;

/// 这几个参数由上一个页面传递过来，用于查询
@property (nonatomic, copy) NSString *customerCode;
@property (nonatomic, assign) PNPaymentCategory paymentCategoryType;
@property (nonatomic, copy) NSString *billerCode;
@property (nonatomic, copy) NSString *payTo;
@property (nonatomic, copy) NSString *apiCredential;
@property (nonatomic, copy) NSString *currency;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *customerPhone;

/// 聚合单号
@property (nonatomic, copy) NSString *orderNo;
/// 钱包订单号  查询支付结果 有orderNo 查orderNo   有tradeNo  查tradeNo
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, strong) PNBillPayInfoModel *payInfoModel;

/// 查询账单编号查询账单
- (void)queryBillInfo:(void (^)(PNWaterBillModel *resultModel))successBlock;

/// 提交下单账单信息
- (void)submitBillOrder:(NSDictionary *)param success:(void (^)(PNCreateAggregateOrderRspModel *rspModel))successBlock;

/// 支付结果查询
- (void)queryPaymentResult:(BOOL)isShowLoading;
/** 查订单信息，中台 */
- (void)queryOrderInfoWithAggregationOrderNo:(NSString *_Nonnull)aggregationOrderNo completion:(void (^)(SAQueryOrderInfoRspModel *_Nullable rspModel))completion;

@end

NS_ASSUME_NONNULL_END
