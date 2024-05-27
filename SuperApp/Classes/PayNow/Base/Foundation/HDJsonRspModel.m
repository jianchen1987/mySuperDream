//
//  HDJsonRspModel.m
//  National Wallet
//
//  Created by 陈剑 on 2018/4/27.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "HDJsonRspModel.h"
#import "PNUtilMacro.h"


@implementation HDJsonRspModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"rspCode": @"rspCd",
//             @"rspMsg": @"rspInf",
//             @"rspType": @"rspType",
//             @"rspDateTime": @"responseTm",
//             @"v": @"v"};
//}
//
- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [json enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull value, BOOL *_Nonnull stop) {
            if (!value || [value isEqual:[NSNull null]] || value == NULL) {
                [self setValue:@"" forKey:key];
            } else {
                [self setValue:value forKey:key];
            }
        }];
    }

    return self;
}
//
- (BOOL)parse {
    //    if (!self.jsonBody || ![self.jsonBody count]) {
    //        return NO;
    //    }

    //    self.rspCd = [self.jsonBody objectForKey:@"rspCd"];
    //    self.rspInf = [self.jsonBody objectForKey:@"rspInf"];
    //    self.rspType = [self.jsonBody objectForKey:@"rspType"];
    //    self.rspDateTime = [self.jsonBody objectForKey:@"responseTm"];
    //    self.v = [self.jsonBody objectForKey:@"v"];
    //    HDLog(@"%@",self.rspInf);
    if (!self.rspCd || [self.rspCd isEqual:[NSNull null]]) {
        return NO;
    }

    return YES;
}
//
- (void)parseAllObject {
    if (self.data && ![self.data isEqual:[NSNull null]] && self.data != NULL) {
        NSArray *keys = [self.data allKeys];
        for (NSString *key in keys) {
            id obj = [self.data objectForKey:key];
            if ((obj && [obj isEqual:[NSNull null]]) || obj == NULL) {
                [self setValue:@"" forKey:key];
            } else {
                [self setValue:obj forKey:key];
            }
        }
    }
}
//
- (BOOL)isValid {
    return WJIsStringNotEmpty(self.rspCd) && [self.rspCd isEqualToString:RSP_SUCCESS_CODE];
}
//
//- (void)setNilValueForKey:(NSString *)key {
//    HDLog(@"param %@ is null", key);
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    HDLog(@"not find the key:%@", key);
//}

@end
