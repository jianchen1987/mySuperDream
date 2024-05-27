//
//  TNBargainCountModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainCountModel.h"


@implementation TNBargainCountModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"hasBargainedCount": @"isBargainedCount"};
}
@end
