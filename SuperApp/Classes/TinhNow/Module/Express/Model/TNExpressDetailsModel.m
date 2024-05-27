//
//  TNExpressDetailsModel.m
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressDetailsModel.h"


@implementation TNExpressDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"events": [TNExpressEventInfoModel class]};
}
@end


@implementation TNExpressEventInfoModel

@end


@implementation TNExpressDetailsRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"expressOrder": [TNExpressDetailsModel class]};
}


@end
