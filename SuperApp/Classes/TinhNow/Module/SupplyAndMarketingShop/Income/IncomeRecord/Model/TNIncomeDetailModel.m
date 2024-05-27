//
//  TNIncomeDetailModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeDetailModel.h"


@implementation TNIncomeDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderShops": [TNIncomeOrderShopsModel class]};
}
@end
