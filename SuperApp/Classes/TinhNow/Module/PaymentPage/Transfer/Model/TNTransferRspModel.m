//
//  TNTransferRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTransferRspModel.h"


@implementation TNTransferCredentialModel

@end


@implementation TNTransferItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name": @[@"name", @"key"]};
}
@end


@implementation TNTransferPayTypeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dataDictList": [TNTransferItemModel class]};
}
@end


@implementation TNTransferRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"payType": [TNTransferPayTypeModel class]};
}
@end
