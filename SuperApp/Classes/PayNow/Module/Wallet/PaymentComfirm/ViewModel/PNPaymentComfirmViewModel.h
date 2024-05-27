//
//  PNPaymentComfirmViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentBuildModel.h"
#import "PNPaymentComfirmRspModel.h"
#import "PNViewModel.h"

@class PayHDTradeConfirmPaymentRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentComfirmViewModel : PNViewModel

/// 刷新
@property (nonatomic, assign) BOOL refreshFlag;

/// 根据tradeNo 获取的账户模型
@property (nonatomic, strong) PNPaymentComfirmRspModel *model;
/// 外部传入的模型【一般用于业务区分】
@property (nonatomic, strong) PNPaymentBuildModel *buildModel;

/// 获取当前页面数据
- (void)getData:(PNWalletBalanceType)type;

/// 确认支付
- (void)paymentComfirm:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock;

@end

NS_ASSUME_NONNULL_END
