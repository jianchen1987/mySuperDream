//
// Created by ESJsonFormatForMac on 22/12/23.
//

#import "TNGameBalanceAccountModel.h"


@implementation TNGameBalanceAccountModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"balances": [TNGameBalancesModel class]};
}

@end


@implementation TNGameSupplierModel

@end


@implementation TNGameCustomerModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"ID": @"id"};
}

@end


@implementation TNGameBalancesModel

@end
