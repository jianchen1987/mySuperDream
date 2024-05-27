//
//  HDBillListRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/12.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDBillListRspModel.h"
#import <YYModel/YYModel.h>


@implementation HDBillListRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": HDBillListModel.class};
}

@end
