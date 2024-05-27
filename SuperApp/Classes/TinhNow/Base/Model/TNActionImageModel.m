//
//  TNActionImageModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNActionImageModel.h"


@implementation TNActionImageModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"action": @"url", @"source": @"image"};
}
@end
