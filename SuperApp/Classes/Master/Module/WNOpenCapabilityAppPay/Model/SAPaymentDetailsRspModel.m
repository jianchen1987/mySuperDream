//
//  SAPaymentDetailsRspModel.m
//  SuperApp
//
//  Created by seeu on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAPaymentDetailsRspModel.h"


@implementation SAPaymentDetailsRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"bizOrderNo": @"businessOrderId"};
}
@end
