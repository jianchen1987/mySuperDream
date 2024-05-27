//
//  SAQueryAvaliableChannelRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/12/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAPaymentChannelModel : SAModel
@property (nonatomic, copy) NSString *message; ///<
@property (nonatomic, assign) NSUInteger code; ///<
@end


@interface SAQueryAvaliableChannelRspModel : SARspModel
@property (nonatomic, strong) NSArray<SAPaymentChannelModel *> *payWays; ///< 支付渠道
@end

NS_ASSUME_NONNULL_END
