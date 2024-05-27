//
//  TNDeliveryAreaMapModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNDeliveryAreaMapModel.h"


@implementation TNCoordinateModel

@end


@implementation TNDeliveryAreaStoreInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"storeLatLonDTOList": [TNCoordinateModel class]};
}
@end


@implementation TNDeliveryAreaMapModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"storeInfoDTOList": [TNDeliveryAreaStoreInfoModel class]};
}
@end
