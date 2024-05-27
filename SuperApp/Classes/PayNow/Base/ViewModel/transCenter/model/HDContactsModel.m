//
//  HDContactsModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/7.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDContactsModel.h"


@implementation HDContactsModel
- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [json enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull value, BOOL *_Nonnull stop) {
            if (!value || [value isEqual:[NSNull null]]) {
                [self setValue:@"" forKey:key];
            } else {
                [self setValue:value forKey:key];
            }
        }];
    }

    return self;
}
@end
