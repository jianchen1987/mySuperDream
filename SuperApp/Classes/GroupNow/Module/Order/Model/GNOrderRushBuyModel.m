//
//  GNOrderRushBuyModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderRushBuyModel.h"


@implementation GNOrderRushBuyModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"codeId": @"code"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"type": GNMessageCode.class, @"productStatus": GNMessageCode.class};
}

- (NSDecimalNumber *)vat {
    if ([self.type.codeId isEqualToString:GNProductTypeP2]) {
        _vat = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        return _vat;
    }
    NSDecimalNumber *priceDe = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", [self.price doubleValue]]];
    _vat = [[priceDe decimalNumberByMultiplyingBy:[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", self.theVat]]
                                                      decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]]
        decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", self.customAmount]]
                        withBehavior:self.roundPlain];
    return _vat;
}

- (NSDecimalNumber *)allPrice {
    _allPrice = [self.subPrice decimalNumberByAdding:self.vat withBehavior:self.roundPlain];
    if (self.promoCodeRspModel) {
        _allPrice = [_allPrice decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.promoCodeRspModel.discountAmount.amount] withBehavior:self.roundPlain];
    }
    return _allPrice;
}

- (NSDecimalNumber *)subPrice {
    NSDecimalNumber *priceDe = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", [self.price doubleValue]]];
    _subPrice = [priceDe decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", self.customAmount]] withBehavior:self.roundPlain];
    return _subPrice;
}

- (NSDecimalNumber *)orginAllPrice {
    NSDecimalNumber *priceDe = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", [self.originalPrice doubleValue]]];
    _orginAllPrice = [priceDe decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", self.customAmount]] withBehavior:self.roundPlain];
    return _orginAllPrice;
}

- (NSDecimalNumberHandler *)roundPlain {
    if (!_roundPlain) {
        _roundPlain = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    }
    return _roundPlain;
}

@end
