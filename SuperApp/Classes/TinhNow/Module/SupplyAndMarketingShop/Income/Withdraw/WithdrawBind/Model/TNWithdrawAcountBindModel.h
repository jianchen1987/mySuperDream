//
//  TNWithdrawAcountBindModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawAcountBindModel : TNModel
@property (nonatomic, strong) TNPaymentWayCode settlementType; //支付名称
@property (nonatomic, copy) NSString *paymentType;             ///<  支付方式名称
@property (nonatomic, strong) NSString *account;               ///< 银行账号
@property (nonatomic, strong) NSString *accountHolder;         ///<开户名
@end

NS_ASSUME_NONNULL_END
