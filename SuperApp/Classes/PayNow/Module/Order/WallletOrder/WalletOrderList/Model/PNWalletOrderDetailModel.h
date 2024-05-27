//
//  PNWalletOrderListModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletOrderDetailModel : PNModel
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) PNCurrencyType currency;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, strong) SAMoneyModel *orderAmt;
@property (nonatomic, strong) SAMoneyModel *balance;
@property (nonatomic, copy) NSString *orderSerialNo;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *tradeStatus;
@property (nonatomic, strong) SAMoneyModel *exchangeAmount;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *debitCreditFlag;
@end

NS_ASSUME_NONNULL_END
