//
//  TNGoodFavoritesModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNGoodFavoritesRspModel.h"
#import "TNGoodFavoritesModel.h"


@implementation TNGoodFavoritesRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNGoodFavoritesModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pages": @"totalPages"};
}
@end
