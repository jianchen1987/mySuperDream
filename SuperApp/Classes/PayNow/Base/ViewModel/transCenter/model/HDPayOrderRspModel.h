//
//  HDPayOrderRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/9.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"
#import "HDRemoteNotificationModel.h"
#import "PNEnum.h"
#import "PayHDCouponModel.h"
#import "PayHDTradeSubmitPaymentRspModel.h"

@class HDQrCodePaymentResultQueryRsp;


@interface HDPayOrderRspModel : HDJsonRspModel

@property (nonatomic, strong) NSNumber *amt;
@property (nonatomic, copy) NSString *cy;
@property (nonatomic, strong) NSNumber *orderAmt;
@property (nonatomic, copy) NSString *orderCy;
@property (nonatomic, strong) NSNumber *fee;
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, copy) NSString *payeeName;
@property (nonatomic, copy) NSString *payeeNo;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, assign) PNOrderStatus payOrderStatus; ///< 支付状态
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, assign) PNTransType tradeType;
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;
@property (nonatomic, assign) PNTradeSubTradeType subPayTradeType;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSNumber *exchangeRate;
@property (nonatomic, strong) NSNumber *payeeAmt;
@property (nonatomic, copy) NSString *payeeCy;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, strong) NSMutableArray<PayHDCouponModel *> *couponList;
@property (nonatomic, strong) SAMoneyModel *userFeeAmt; ///< 用户手续费
@property (nonatomic, copy) NSString *receiveBankName;  //收款银行
@property (nonatomic, copy) NSString *remark;           //备注
@property (copy, nonatomic) NSString *payeeStoreName;
@property (copy, nonatomic) NSString *payeeStoreLocation;
@property (nonatomic, copy) NSString *createTime; //时间
@property (nonatomic, copy) NSString *transactionHash;

+ (instancetype)modelFromTradeSubmitPaymentRspModel:(PayHDTradeSubmitPaymentRspModel *)model;
- (instancetype)initFromTradeSubmitPaymentRspModel:(PayHDTradeSubmitPaymentRspModel *)model;

+ (instancetype)modelFromPaymentCodeQueryRspModel:(HDQrCodePaymentResultQueryRsp *)model;
- (instancetype)initFromPaymentCodeQueryRspModel:(HDQrCodePaymentResultQueryRsp *)model;

+ (instancetype)modelFromRemoteNotificationModel:(HDRemoteNotificationModel *)model;
- (instancetype)initFromRemoteNotificationModel:(HDRemoteNotificationModel *)model;

@end
