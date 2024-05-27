//
//  PNMSBillListModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "BizEntityModel.h"
#import "PNEnum.h"
#import "PNModel.h"
#import "PayHDCouponModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBillListModel : SAModel

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *incomeFlag;
@property (nonatomic, copy) NSString *payeeUsrMp;   // 收款方账号
@property (nonatomic, copy) NSString *payeeUsrName; // 收款方昵称
@property (nonatomic, copy) NSString *payerUsrName;
@property (nonatomic, strong) NSNumber *realAmt;
@property (nonatomic, copy) NSString *realNameEnd;
@property (nonatomic, copy) NSString *realNameFirst;
@property (nonatomic, strong) NSNumber *serviceAmt;
@property (nonatomic, assign) PNOrderStatus status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tmFinished;
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, assign) PNTransType tradeType;

@property (nonatomic, copy) NSString *merName;
@property (nonatomic, copy) NSString *payerUsrMp;
@property (nonatomic, copy) NSString *payerRealNameFirst;
@property (nonatomic, copy) NSString *payerRealNameEnd;
@property (nonatomic, copy) NSString *channelCode;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *payeeAmt;
@property (nonatomic, copy) NSString *payeeCy;
@property (nonatomic, copy) NSString *exchangeRate;
@property (nonatomic, copy) NSString *displayStatus;
@property (nonatomic, copy) NSString *originTradeType;
@property (nonatomic, copy) NSString *originTradeNo;
@property (nonatomic, copy) NSString *productDesc;

@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *orderAmt;
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;

@property (nonatomic, strong) NSMutableArray<PayHDCouponModel *> *couponList;
@property (nonatomic, strong) BizEntityModel *bizEntity;
@property (nonatomic, strong) BizEntityModel *subBizEntity;

/// 当subBizEntity = 23 才会返回下面这三个字段
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *bankName;

@end

NS_ASSUME_NONNULL_END
