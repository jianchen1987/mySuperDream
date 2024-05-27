//
//  WMStoreCateCacheModel.m
//  SuperApp
//
//  Created by wmz on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMStoreCateCacheModel.h"


@implementation WMStoreCateCacheModel

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = NSMutableArray.new;
    }
    return _dataSources;
}

@end
