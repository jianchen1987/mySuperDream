//
//  SARspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/3/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"
#import <HDKitCore/HDCommonDefines.h>

SAResponseType const SAResponseTypeSuccess = @"00000";


@implementation SARspInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"code": @"rspCode", @"msg": @"rspInf"};
}
@end


@implementation SARspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"code": @"rspCd",
        @"msg": @"rspInf",
        //             @"type": @"rspType",
        @"time": @"responseTm",
        @"version": @"v"
    };
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    SARspModel *model = [SARspModel new];
    model.code = [dict objectForKey:@"rspCd"];
    model.data = [dict objectForKey:@"data"];
    model.msg = [dict objectForKey:@"rspInf"];
    model.version = [dict objectForKey:@"v"];
    model.time = [dict objectForKey:@"responseTm"];
    return model;
}

#pragma mark - getters
- (BOOL)isValid {
    return HDIsStringNotEmpty(self.code) && [self.code isEqualToString:SAResponseTypeSuccess];
}
@end
