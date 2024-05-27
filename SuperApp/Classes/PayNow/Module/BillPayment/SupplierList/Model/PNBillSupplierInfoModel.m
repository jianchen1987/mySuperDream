//
//  PNBillSupplierInfoModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillSupplierInfoModel.h"


@implementation PNBillSupplierInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"idStr": @"id"};
}

- (NSString *)payeeMerName_search {
    return self.payeeMerName.uppercaseString;
}
@end
