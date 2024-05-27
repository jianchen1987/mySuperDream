//
//  HDUserRegisterRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/2.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDUserRegisterRspModel.h"


@implementation HDUserRegisterRspModel

- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }
    return NO;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"regStatus": @"register"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *registerStatus = dic[@"register"];
    //    if(!registerStatus){
    //        return NO;
    //    }
    _regStatus = registerStatus.boolValue;

    NSNumber *tradePwdStatus = dic[@"tradePwdExist"];
    //    if (!tradePwdStatus) {
    //        return NO;
    //    }
    _tradePwdExist = tradePwdStatus.boolValue;

    NSNumber *loginPwdStatus = dic[@"loginPwdExist"];
    //    if(!loginPwdStatus){
    //        return NO;
    //    }
    _loginPwdExist = loginPwdStatus.boolValue;

    return YES;
}

@end
