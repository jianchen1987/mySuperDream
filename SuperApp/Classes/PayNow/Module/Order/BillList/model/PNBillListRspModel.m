//
//  PayHDBillListRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/12.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "PNBillListRspModel.h"
#import <YYModel/YYModel.h>


@implementation PNBillListRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": PNBillListModel.class};
}

@end
