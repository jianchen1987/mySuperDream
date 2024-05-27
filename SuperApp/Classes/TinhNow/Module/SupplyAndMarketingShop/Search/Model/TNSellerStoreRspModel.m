//
//  TNSellerStoreRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerStoreRspModel.h"
#import "TNSellerStoreModel.h"


@implementation TNSellerStoreRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNSellerStoreModel class]};
}
@end
