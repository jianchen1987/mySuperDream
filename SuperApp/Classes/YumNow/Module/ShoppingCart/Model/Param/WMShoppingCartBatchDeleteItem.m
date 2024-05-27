//
//  WMShoppingCartBatchDeleteItem.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/26.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartBatchDeleteItem.h"


@implementation WMShoppingCartBatchDeleteItem
- (NSInteger)deleteDelta {
    return 0;
}
- (NSString *)businessType {
    return @"10";
}
- (NSInteger)autoDetele {
    return 1;
}
@end
