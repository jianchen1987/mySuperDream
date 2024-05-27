//
//  PNInterTransferPayerInfoModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferPayerInfoModel.h"


@implementation PNPurposeRemittanceModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"purposeId": @"id"};
}
@end


@implementation PNSourceFundModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"sourceId": @"id"};
}
@end


@implementation PNInterTransferPayerInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"purposeRemittanceInfoList": [PNPurposeRemittanceModel class],
        @"sourceFundInfoList": [PNSourceFundModel class],
    };
}
@end
