//
//  TNCouponParamsModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCouponParamsModel.h"


@implementation TNCouponParamsModel
- (NSString *)userId {
    return SAUser.shared.operatorNo;
}
- (NSString *)businessType {
    return @"14";
}
- (NSString *)orderTime {
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%0.f", nowTime];
}
@end
