//
//  TNStoreFavoritesModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreFavoritesModel.h"


@implementation TNStoreFavoritesModel
- (BOOL)isMicroShop {
    return !HDIsObjectNil(self.supplierFavoriteRespDto) && HDIsStringNotEmpty(self.supplierFavoriteRespDto.supplierId);
}
@end


@implementation TNMicroShopFavoritesModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"supplierId": @"id"};
}

@end
