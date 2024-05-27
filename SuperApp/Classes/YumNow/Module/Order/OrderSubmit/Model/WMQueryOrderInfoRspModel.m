//
//  WMQueryOrderInfoRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMQueryOrderInfoRspModel.h"


@implementation WMOrderSubscribeTimeModel

@end


@implementation WMQueryOrderInfoRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"availableTime": WMOrderSubscribeTimeModel.class};
}
@end
