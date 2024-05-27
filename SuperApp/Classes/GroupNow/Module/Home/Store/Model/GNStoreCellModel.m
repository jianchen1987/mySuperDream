//
//  GNStoreCellModel.m
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreCellModel.h"


@implementation GNStoreCellModel
- (instancetype)init {
    if (self = [super init]) {
        self.cellClass = NSClassFromString(@"GNStoreViewCell");
        self.offset = kRealWidth(4);
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"productList": GNProductModel.class,
    };
}

@end
