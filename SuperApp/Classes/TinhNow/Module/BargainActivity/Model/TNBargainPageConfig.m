//
//  TNBargainPageConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainPageConfig.h"


@implementation TNBargainPageConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPage = 1; //默认当前是第一页
    }
    return self;
}
- (NSMutableArray<TNBargainGoodModel *> *)goods {
    if (!_goods) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}
@end
