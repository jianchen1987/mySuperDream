//
//  HDGetPaymentCodeRsp.h
//  ViPay
//
//  Created by VanJay on 2019/8/6.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDGetPaymentCodeRsp : SAModel
@property (nonatomic, copy) NSString *payCode; ///< 付款码
@end

NS_ASSUME_NONNULL_END
