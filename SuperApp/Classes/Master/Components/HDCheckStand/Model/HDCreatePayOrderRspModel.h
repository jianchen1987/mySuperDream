//
//  HDCreatePayOrderRspModel.h
//  SuperApp
//
//  Created by Chaos on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCreatePayOrderRspModel : SARspModel

/// 下单后返回的聚合订单号
@property (nonatomic, copy) NSString *orderNo;
/// 外部支付单号
@property (nonatomic, copy) NSString *outPayOrderNo;

@end

NS_ASSUME_NONNULL_END
