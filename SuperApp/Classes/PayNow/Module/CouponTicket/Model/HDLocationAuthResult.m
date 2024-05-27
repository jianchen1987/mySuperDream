//
//  HDLocationAuthResult.m
//  ViPay
//
//  Created by VanJay on 2019/6/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDLocationAuthResult.h"


@implementation HDLocationAuthResult
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude isSuccess:(BOOL)isSuccess {
    if (self = [super init]) {
        _latitude = latitude;
        _longitude = longitude;
        _isSuccess = isSuccess;
    }
    return self;
}
@end
