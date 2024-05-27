//
//  TNDecimalTool.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNDecimalTool.h"


@implementation TNDecimalTool
+ (NSDecimalNumber *)toDecimalNumber:(NSString *)number {
    return [NSDecimalNumber decimalNumberWithString:number];
}
+ (NSDecimalNumber *)decimalDividingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2 {
    return [num1 decimalNumberByDividingBy:num2];
}
+ (NSDecimalNumber *)stringDecimalDividingBy:(NSString *)num1 num2:(NSString *)num2 {
    NSDecimalNumber *dec1 = [TNDecimalTool toDecimalNumber:num1];
    NSDecimalNumber *dec2 = [TNDecimalTool toDecimalNumber:num2];
    return [dec1 decimalNumberByDividingBy:dec2];
}
+ (NSDecimalNumber *)decimalMultiplyingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2 {
    return [num1 decimalNumberByMultiplyingBy:num2];
}
+ (NSDecimalNumber *)stringDecimalMultiplyingBy:(NSString *)num1 num2:(NSString *)num2 {
    NSDecimalNumber *dec1 = [TNDecimalTool toDecimalNumber:num1];
    NSDecimalNumber *dec2 = [TNDecimalTool toDecimalNumber:num2];
    return [dec1 decimalNumberByMultiplyingBy:dec2];
}
+ (NSDecimalNumber *)decimalSubtractingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2 {
    return [num1 decimalNumberBySubtracting:num2];
}
+ (NSDecimalNumber *)stringDecimalSubtractingBy:(NSString *)num1 num2:(NSString *)num2 {
    NSDecimalNumber *dec1 = [TNDecimalTool toDecimalNumber:num1];
    NSDecimalNumber *dec2 = [TNDecimalTool toDecimalNumber:num2];
    return [dec1 decimalNumberBySubtracting:dec2];
}
+ (NSDecimalNumber *)decimalAddingBy:(NSDecimalNumber *)num1 num2:(NSDecimalNumber *)num2 {
    return [num1 decimalNumberByAdding:num2];
}
+ (NSDecimalNumber *)stringDecimalAddingBy:(NSString *)num1 num2:(NSString *)num2 {
    NSDecimalNumber *dec1 = [TNDecimalTool toDecimalNumber:num1];
    NSDecimalNumber *dec2 = [TNDecimalTool toDecimalNumber:num2];
    return [dec1 decimalNumberByAdding:dec2];
}
+ (NSDecimalNumber *)decimslDisCountNumber:(NSString *)num1 num2:(NSString *)num2 {
    NSDecimalNumber *dec1 = [TNDecimalTool toDecimalNumber:num1];
    NSDecimalNumber *dec2 = [TNDecimalTool toDecimalNumber:num2];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:6 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO
                                                                              raiseOnDivideByZero:NO]; //向下取整
    NSDecimalNumber *resultDivid = [dec1 decimalNumberByDividingBy:dec2 withBehavior:handel];
    NSDecimalNumber *dec3 = [TNDecimalTool toDecimalNumber:@"1"];
    NSDecimalNumber *dec4 = [TNDecimalTool toDecimalNumber:@"100"];
    NSDecimalNumber *resultSub = [TNDecimalTool decimalSubtractingBy:dec3 num2:resultDivid];
    NSDecimalNumber *result = [TNDecimalTool decimalMultiplyingBy:resultSub num2:dec4];
    return result;
}

+ (NSDecimalNumber *)roundingNumber:(NSDecimalNumber *)number afterPoint:(NSInteger)position {
    NSDecimalNumberHandler *behivior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    NSDecimalNumber *result = [number decimalNumberByRoundingAccordingToBehavior:behivior];
    return result;
}

@end
