//
//  WMWindowIconModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWindowItemModel.h"


@implementation SAWindowItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"bannerName": @[@"title", @"bannerName"]};
}

@end
