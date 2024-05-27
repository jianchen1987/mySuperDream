//
//  WMHomeLayoutModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMHomeLayoutModel.h"


@implementation WMHomeLayoutModel

- (instancetype)init {
    self = [super init];
    if(self) {
        self.willDisplayTime = 0;
    }
    return self;
}

- (WMHomeLayoutCongigModel *)layoutConfig {
    if (!_layoutConfig) {
        _layoutConfig = WMHomeLayoutCongigModel.new;
        _layoutConfig.outSets = UIEdgeInsetsMake(0, 0, kRealWidth(16), 0);
        _layoutConfig.inSets = UIEdgeInsetsMake(0, 0, 0, 0);
        _layoutConfig.contenInset = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
    }
    return _layoutConfig;
}

@end


@implementation WMHomeLayoutCongigModel

@end
