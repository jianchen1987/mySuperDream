//
//  PayHDCheckstandInputPwdViewController.h
//  customer
//
//  Created by VanJay on 2019/5/17.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNPaymentReqModel.h"
#import "PayHDCheckstandBaseViewController.h"
#import "PayHDCheckstandPaymentDetailTitleModel.h"
#import "PayHDTradeBuildOrderRspModel.h"

@class PayHDTradeConfirmPaymentRspModel;

typedef enum : NSUInteger {
    BusinessActionType_Pay,
    BusinessActionType_CheckPayPassword,
    BusinessActionType_OpenPayment,
    BusinessActionType_GetPaymentCode,
    BusinessActionType_CheckMerchantServicePayPassword,
} BusinessActionType;

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCheckstandInputPwdViewController : PayHDCheckstandBaseViewController
- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters;
- (instancetype)initWithNumberOfCharacters:(NSUInteger)numberOfCharacters title:(NSString *)title tipStr:(NSString *)tipStr isVerifyPwd:(BOOL)isVerifyPwd;
@property (nonatomic, strong) PayHDTradeConfirmPaymentRspModel *model;  ///< 模型
@property (nonatomic, assign) PNTransType tradeType;                    ///< 交易类型
@property (nonatomic, strong) PayHDTradeBuildOrderRspModel *buildModel; ///< 下单模型
@property (nonatomic, assign) BusinessActionType actionType;
@property (nonatomic, strong) PNPaymentReqModel *businessModel;
@end

NS_ASSUME_NONNULL_END
