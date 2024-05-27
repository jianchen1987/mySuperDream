//
//  WMStoreGoodsProductPropertyOption.m
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreGoodsProductPropertyOption.h"
#import "SAMoneyModel.h"


@implementation WMStoreGoodsProductPropertyOption
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"optionId": @"id",
        @"additionalPriceCent" : @"additionalPrice.cent",
    };
}

- (NSString *)additionalPrice {
    if(!_additionalPrice && _additionalPriceCent >= 0) {
        return [NSString stringWithFormat:@"%.2f", _additionalPriceCent / 100.0];
    }
    return _additionalPrice;
}


@end
