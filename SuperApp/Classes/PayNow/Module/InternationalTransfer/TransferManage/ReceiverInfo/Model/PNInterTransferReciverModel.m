//
//  PNInterTransferReciverModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferReciverModel.h"
#import "PNCommonUtils.h"


@implementation PNInterTransferReciverModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"reciverId": @"id"};
}

- (NSString *)showBirthDateStr {
    if (HDIsStringEmpty(self.birthDate)) {
        return @"";
    }

    NSString *dataStr = [PNCommonUtils dateSecondToDate:self.birthDate.integerValue / 1000 dateFormat:@"dd/MM/yyyy"];
    return dataStr;
}

@end
