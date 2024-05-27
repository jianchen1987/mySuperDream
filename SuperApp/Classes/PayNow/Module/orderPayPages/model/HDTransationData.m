//
//  HDTransationData.m
//  customer
//
//  Created by 帅呆 on 2018/12/24.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDTransationData.h"


@implementation HDTransationData

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"payer": @[@"payer", @"payerMp"], @"timeStamp": @[@"timeStamp", @"date"]};
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"tradeNo", @"amt", @"cy", @"payer", @"timeStamp"];
}

@end
