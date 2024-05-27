//
//  PNBillPaymentListDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillPaymentRspModel.h"
#import "PNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNBillPaymentListDTO : PNModel
/// 查询账单支付列表
- (void)queryBillPaymentListWithPageNum:(NSInteger)pageNum
                               pageSize:(NSInteger)pageSize
                                success:(void (^)(PNBillPaymentRspModel *rspModel))successBlock
                                failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
