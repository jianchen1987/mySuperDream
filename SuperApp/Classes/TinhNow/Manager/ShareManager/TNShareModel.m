//
//  TNShareModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNShareModel.h"


@implementation TNShareModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = TNShareTypeDefault;
    }
    return self;
}
@end
