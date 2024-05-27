//
//  PNWaterBillModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWaterBillModel.h"


@implementation PNGamePasswordModel

@end


@implementation PNWaterBillModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"supplier": PNSupplierInfoModel.class, @"customer": PNCustomerInfoModel.class, @"balances": PNBalancesInfoModel.class};
}

@end
