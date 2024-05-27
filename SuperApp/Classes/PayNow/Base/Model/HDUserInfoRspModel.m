//
//  HDUserInfoRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/6.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDUserInfoRspModel.h"


@implementation HDThirdPartAuthLoginInfoModel

@end


@implementation HDUserInfoRspModel

- (BOOL)parse {
    if ([super parse]) {
        [self parseAllObject];
        return YES;
    }
    return NO;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"authInfoList": [HDThirdPartAuthLoginInfoModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[@"loginPwdExist"] isKindOfClass:NSNumber.class]) {
        NSNumber *loginPwdExist = dic[@"loginPwdExist"];
        _loginPwdExist = loginPwdExist.boolValue;
    } else {
        _loginPwdExist = NO;
    }

    if ([dic[@"tradePwdExist"] isKindOfClass:NSNumber.class]) {
        NSNumber *tradePwdExist = dic[@"tradePwdExist"];
        _tradePwdExist = tradePwdExist.boolValue;
    } else {
        _tradePwdExist = NO;
    }

    return YES;
}

@end
