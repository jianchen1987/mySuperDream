//
//  TNSellerOrderRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderRspModel.h"


@implementation TNSellerOrderRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content": [TNSellerOrderModel class]};
}
@end
