//
//  PNCityModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCityModel.h"


@implementation PNCityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cities": [PNCityItemModel class]};
}
@end


@implementation PNCityItemModel

@end
