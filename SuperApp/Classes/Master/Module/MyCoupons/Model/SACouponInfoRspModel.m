//
//  SACouponInfoRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACouponInfoRspModel.h"


@implementation SACouponInfoRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cashCouponAmount": @"num"};
}
@end
