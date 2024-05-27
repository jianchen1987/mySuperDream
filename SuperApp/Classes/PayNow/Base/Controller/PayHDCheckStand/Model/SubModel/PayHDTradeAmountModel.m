//
//  HDTradeAmountModel.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDTradeAmountModel.h"
#import "PNCommonUtils.h"


@implementation PayHDTradeAmountModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cent": @[@"amt", @"cent"], @"cy": @[@"cy", @"currency"]};
}

+ (instancetype)modelWithAmount:(NSString *)cent currency:(NSString *)cy {
    return [[self alloc] initWithAmount:cent currency:cy];
}

- (instancetype)initWithAmount:(NSString *)cent currency:(NSString *)cy {
    if (self = [super init]) {
        self.cent = cent;
        self.cy = cy;
    }
    return self;
}

- (void)setCy:(NSString *)cy {
    _cy = cy;

    _currencySymbol = [PNCommonUtils getCurrencySymbolByCode:cy];
}

- (NSString *)thousandSeparatorAmount {
    return [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:self.cent] currencyCode:self.cy];
}

- (NSString *)thousandSeparatorAmountNoCurrencySymbol {
    return [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[PNCommonUtils fenToyuan:self.cent] currencyCode:self.cy];
}
@end
