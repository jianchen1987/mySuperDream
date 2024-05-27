//
//  GNFilterModel.m
//  SuperApp
//
//  Created by wmz on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNFilterModel.h"


@implementation GNFilterModel
- (instancetype)init {
    if (self = [super init]) {
        self.sortType = GNHomeSortDefault;
    }
    return self;
}
@end
