//
//  TNMicroShopDetailInfoModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopDetailInfoModel.h"
#import "TNSeller.h"


@implementation TNMicroShopDetailInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"supplierId": @"id"};
}

+ (instancetype)modelWithSellerModel:(TNSeller *)sellerModel {
    TNMicroShopDetailInfoModel *info = [[TNMicroShopDetailInfoModel alloc] init];
    info.supplierId = sellerModel.supplierId;
    info.supplierImage = sellerModel.supplierImage;
    info.nickName = sellerModel.nickName;
    info.sp = sellerModel.sp;
    info.isHonor = sellerModel.isHonor;
    return info;
}
@end
