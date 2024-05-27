//
//  TNOrderDetailsGoodsInfoModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsGoodsInfoModel.h"


@implementation TNOrderDetailsGoodsInfoModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"productId": @"id"};
//}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"specificationValue": [NSString class]};
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
@end
