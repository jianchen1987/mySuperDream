//
//  SAWriteDateReadableModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWriteDateReadableModel.h"


@implementation SAWriteDateReadableModel

+ (instancetype)modelWithStoreObj:(id)storeObj {
    return [[self alloc] initWithStoreObj:storeObj];
}

- (instancetype)initWithStoreObj:(id)storeObj {
    if (self = [super init]) {
        self.storeObj = storeObj;

        self.createTimeInterval = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (NSTimeInterval)timeIntervalSinceCreateTime {
    return [[NSDate date] timeIntervalSince1970] - self.createTimeInterval;
}
@end
