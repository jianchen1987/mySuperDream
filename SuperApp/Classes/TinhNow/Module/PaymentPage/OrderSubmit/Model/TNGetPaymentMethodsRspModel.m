//
//  TNGetPaymentMethodsRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGetPaymentMethodsRspModel.h"
#import "TNPaymentMethodModel.h"


@implementation TNGetPaymentMethodsRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"paymentMethods": [TNPaymentMethodModel class]};
}
@end
