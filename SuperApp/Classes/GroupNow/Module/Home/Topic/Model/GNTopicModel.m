//
//  GNTopicModel.m
//  SuperApp
//
//  Created by wmz on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTopicModel.h"


@implementation GNTopicModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"stores": GNStoreCellModel.class,
        @"products": GNProductModel.class,
    };
}
@end
