//
//  TNSellerOrderModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderModel.h"


@implementation TNSellerOrderProductsModel

@end


@implementation TNSellerOrderModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"supplierProductDTOList": [TNSellerOrderProductsModel class]};
}

@end
