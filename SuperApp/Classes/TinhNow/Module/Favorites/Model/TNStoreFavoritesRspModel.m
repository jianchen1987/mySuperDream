//
//  TNStoreFavoritesRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreFavoritesRspModel.h"
#import "TNStoreFavoritesModel.h"


@implementation TNStoreFavoritesRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNStoreFavoritesModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pages": @"totalPages"};
}
@end
