//
//  TNGetShippingMethodsRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNShippingMethodModel;


@interface TNGetShippingMethodsRspModel : TNRspModel
/// 支付方式
@property (nonatomic, strong) NSArray<TNShippingMethodModel *> *shippingMethods;
@end

NS_ASSUME_NONNULL_END
