//
//  PNApartmentListRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentListRspModel.h"


@implementation PNApartmentListRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNApartmentListItemModel.class,
    };
}


@end


@implementation PNApartmentListItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"paymentId": @"id"};
}
@end
