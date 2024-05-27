//
//  PNBillModifyAccountDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBillModifyAmountDTO : PNModel

/// 修改账单金额
- (void)billModifyAccountWithPaymentToken:(NSString *)paymentToken
                                   amount:(NSString *)amount
                                   billNo:(NSString *)billNo
                                 currency:(NSString *)currency
                                  success:(void (^)(PNRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
