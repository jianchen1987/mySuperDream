//
//  TNCalcTotalPayFeeTrialRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCalcTotalPayFeeTrialRspModel.h"


@implementation TNInvalidSkuModel

@end


@implementation TNInvalidProductModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"invalidSkus": [TNInvalidSkuModel class]};
}

@end


@implementation TNImmediateDeliveryModel

@end


@implementation TNCalculateSkuPriceModel

@end


@implementation TNCalcTimeModel

@end


@implementation TNCalcDateModel
- (void)setDate:(NSString *)date {
    _date = date;
    if (HDIsStringNotEmpty(date)) {
        NSArray *arr = [date componentsSeparatedByString:@"/"];
        if (arr.count == 3) {
            self.showDate = [[arr subarrayWithRange:NSMakeRange(0, 2)] componentsJoinedByString:@"/"];
        } else {
            self.showDate = date;
        }
    }
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"deliveryTimeList": [TNCalcTimeModel class]};
}
@end


@implementation TNCalcPaymentFeeGoodsModel

@end


@implementation TNCalcTotalPayFeeTrialRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"deliveryTimeDTOList": [TNCalcDateModel class], @"cartItemDTOS": [TNCalculateSkuPriceModel class], @"invalidProducts": [TNInvalidProductModel class]};
}
@end
