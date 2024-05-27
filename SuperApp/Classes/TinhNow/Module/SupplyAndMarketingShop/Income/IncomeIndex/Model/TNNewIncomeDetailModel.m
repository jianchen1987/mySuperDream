//
//  TNNewIncomeDetailModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeDetailModel.h"


@implementation TNNewIncomeDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderShops": [TNIncomeOrderShopsModel class]};
}
@end
