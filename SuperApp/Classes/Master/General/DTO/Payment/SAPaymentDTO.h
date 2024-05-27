//
//  SAPaymentDTO.h
//  SuperApp
//
//  Created by seeu on 2020/9/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAQueryPaymentStateRspModel;


@interface SAPaymentDTO : SAModel

- (void)queryOrderPaymentStateWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
