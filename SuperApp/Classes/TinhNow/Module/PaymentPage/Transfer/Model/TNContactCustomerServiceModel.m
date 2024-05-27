//
//  TNContactCustomerServiceModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNContactCustomerServiceModel.h"
#import "TNTransferRspModel.h"


@implementation TNContactCustomerServiceModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"Telegram": [TNTransferItemModel class], @"PhoneCall": [TNTransferItemModel class], @"Other": [TNTransferItemModel class]};
}
@end
