//
//  TNOrderDetailsBizPartModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsBizPartModel.h"
#import "TNOrderDetailsGoodsInfoModel.h"


@implementation TNOrderDetailsBizPartModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id": @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items": [TNOrderDetailsGoodsInfoModel class]};
}

@end
