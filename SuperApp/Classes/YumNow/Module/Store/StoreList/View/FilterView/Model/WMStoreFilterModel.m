//
//  WMStoreFilterModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterModel.h"


@implementation WMStoreFilterModel

- (NSString *)keyword {
    return HDIsStringEmpty(_keyword) ? @"" : _keyword;
}

@end
