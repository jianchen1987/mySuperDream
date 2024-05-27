//
//  SACommonPagingRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"


@implementation SACommonPagingRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isFirstPage": @[@"isFirstPage", @"firstPage"], @"isLastPage": @[@"isLastPage", @"lastPage"]};
}
@end
