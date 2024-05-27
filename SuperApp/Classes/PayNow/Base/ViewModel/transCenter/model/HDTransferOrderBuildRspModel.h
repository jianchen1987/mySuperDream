//
//  HDTransferOrderBuildRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/8.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDTransferOrderBuildRspModel : HDJsonRspModel

@property (nonatomic, assign) PNTransType tradeType;
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, copy) NSString *payeeNo;
@property (nonatomic, copy) NSString *payeeName;
@property (nonatomic, copy) NSString *cy;
@property (nonatomic, copy) NSString *amt;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *payeeCy;
@property (nonatomic, copy) NSString *payeeAmt;

//出金二维码
@property (nonatomic, strong) NSString *orderAmt;
@property (nonatomic, strong) NSString *feeAmt;
@property (nonatomic, strong) NSString *payAmt;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *bizType;
@property (nonatomic, copy) NSString *merName;
@property (nonatomic, copy) NSString *logoUrl;
@end

NS_ASSUME_NONNULL_END
