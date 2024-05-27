//
//  TNProductSkuModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductSkuModel.h"


@implementation TNProductSkuModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.editCount = 0;
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"skuId": @[@"id", @"skuId"], @"skuSn": @"sn", @"stock": @[@"stock", @"availableStock"], @"bulkPrice": @[@"bulkPrice", @"tradePrice"]};
}
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
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"specificationValues": [TNProductSpecPropertieModel class]};
}
- (void)setSpecValueKey:(NSString *)specValueKey {
    _specValueKey = specValueKey;
    self.specValueKeyArray = [specValueKey componentsSeparatedByString:@","];
}
@end
