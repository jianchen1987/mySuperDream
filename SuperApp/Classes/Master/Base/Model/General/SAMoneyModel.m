//
//  SAMoneyModel.m
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "SAMoneyTools.h"


@implementation SAMoneyModel
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认美金
        self.cy = SACurrencyTypeUSD;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cent": @[@"cent"], @"cy": @[@"currency", @"cy"]};
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

- (void)setCy:(SACurrencyType)cy {
    _cy = cy;

    _currencySymbol = [SAMoneyTools getCurrencySymbolByCode:_cy];
}

- (NSString *)thousandSeparatorAmount {
    return [SAMoneyTools thousandSeparatorAmountYuan:[SAMoneyTools fenToyuan:self.cent] currencyCode:self.cy];
}

- (NSString *)centFace {
    double value = self.cent.doubleValue;
    // 测试要求优惠金额为负数时，也要下单成功
    //    if (value <= 0) return @"0";
    NSString *centFace = [NSString stringWithFormat:@"%.2f", value / 100.0];
    return centFace;
}

- (NSString *)thousandSeparatorAmountNoCurrencySymbol {
    return [SAMoneyTools thousandSeparatorNoCurrencySymbolWithAmountYuan:[SAMoneyTools fenToyuan:self.cent] currencyCode:self.cy];
}

- (NSString *)amount {
    NSString *fen = [self.cent substringWithRange:NSMakeRange(self.cent.length - 1, 1)];
    NSString *jiao = [self.cent substringWithRange:NSMakeRange(self.cent.length - 2, 1)];

    if (fen.integerValue > 0) {
        // 有小数
        return [NSString stringWithFormat:@"%.2f", self.cent.integerValue / 100.0];
    }
    if (jiao.integerValue > 0) {
        return [NSString stringWithFormat:@"%.1f", self.cent.integerValue / 100.0];
    } else {
        return [NSString stringWithFormat:@"%.0f", self.cent.integerValue / 100.0];
    }
}

/// 加上一个数
/// @param addend 被加数
- (SAMoneyModel *)plus:(SAMoneyModel *)addend {
    // 加了个寂寞
    if (!addend) {
        return self;
    }

    NSAssert([addend isKindOfClass:SAMoneyModel.class], @"只允许SAMoneyModel类型的相加");

    NSAssert([self.cy isEqualToString:addend.cy], @"不同币种不能相加");

    return [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", self.cent.integerValue + addend.cent.integerValue] currency:self.cy];
}

/// 减去一个数
/// @param minuend 被减数
- (SAMoneyModel *)minus:(SAMoneyModel *)minuend {
    // 减了个寂寞
    if (!minuend) {
        return self;
    }

    NSAssert([minuend isKindOfClass:SAMoneyModel.class], @"只允许SAMoneyModel类型的相减");

    NSAssert([self.cy isEqualToString:minuend.cy], @"不同币种不能相减");

    NSInteger value = self.cent.integerValue - minuend.cent.integerValue;

    // 金额没有负数，需要做负数的判断，请在业务侧实现，该方法不能用于普通数值相减
    return [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", value >= 0 ? value : 0] currency:self.cy];
}

- (BOOL)isZero {
    if(self.cent.integerValue > 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
