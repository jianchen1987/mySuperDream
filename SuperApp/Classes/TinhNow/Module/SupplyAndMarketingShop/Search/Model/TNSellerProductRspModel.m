//
//  TNSellerProductRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerProductRspModel.h"
#import "TNCategoryModel.h"
#import "TNSellerProductModel.h"


@implementation TNSellerSearchAggsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categorys": [TNCategoryModel class]};
}
@end


@implementation TNSellerProductRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNSellerProductModel class]};
}
@end
