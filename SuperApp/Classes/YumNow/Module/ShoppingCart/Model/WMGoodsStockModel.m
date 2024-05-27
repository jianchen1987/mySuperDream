//
//  WMGoodsStockModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMGoodsStockModel.h"


@implementation WMGoodsStockModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"status": @"code"};
}
@end
