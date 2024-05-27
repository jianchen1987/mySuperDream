//
//  WMSpecialActivesProductRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSpecialActivesProductRspModel.h"
#import "WMSpecialActivesProductModel.h"


@implementation WMSpecialActivesProductRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": WMSpecialActivesProductModel.class};
}
@end
