//
//  SAPaymentActivityModel.m
//  SuperApp
//
//  Created by seeu on 2022/5/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPaymentToolsActivityModel.h"
#import "SAPaymentActivityModel.h"


@implementation SAPaymentToolsActivityModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rule": SAPaymentActivityModel.class};
}
@end
