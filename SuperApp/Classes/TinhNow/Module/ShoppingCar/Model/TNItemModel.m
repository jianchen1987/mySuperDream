//
//  TNItemModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNItemModel.h"


@implementation TNItemSkuModel
- (void)setWeight:(NSNumber *)weight {
    _weight = weight;
    if (!HDIsObjectNil(weight)) {
        double freight = [weight doubleValue];
        if (freight > 0) {
            double roundFreight = freight / 1000;
            if (roundFreight < 0.01) {
                roundFreight = 0.01;
            }
            self.showWight = [NSString stringWithFormat:@"%.2fkg", roundFreight];
        }
    }
}
@end


@implementation TNItemModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.salesType = TNSalesTypeSingle; //默认是单买
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"skuList": [TNItemSkuModel class]};
}
@end
