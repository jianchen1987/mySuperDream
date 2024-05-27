//
//  PNMSBillListRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBillListRspModel.h"


@implementation PNMSBillListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": PNMSBillListGroupModel.class};
}
@end
