//
//  SACouponTicketModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACouponTicketModel.h"


@implementation SACouponTicketModel
+ (instancetype)modelWithOrderSubmitCouponModel:(WMOrderSubmitCouponModel *)model businessLine:(SAMarketingBusinessType)businessLine {
    SACouponTicketModel *item = SACouponTicketModel.new;
    item.couponTitle = model.title;
    item.thresholdAmount = model.thresholdMoney;
    item.couponDiscount = model.discountRatio.doubleValue;
    item.effectiveDate = model.effectiveDate;
    item.expireDate = model.expireDate;
    if ([model.usable isEqualToString:SABoolValueTrue]) {
        item.couponState = SACouponTicketStateUnused;
        item.couponUsageDescribe = model.desc;
    } else {
        item.couponState = SACouponTicketStateExpired;
        item.couponUsageDescribe = model.unavaliableReson ?: model.desc;
    }
    item.couponAmount = model.couponMoney;
    item.couponNo = model.couponCode;
    item.couponType = model.couponType;
    item.orderSubmitCouponModel = model;
    item.businessTypeList = @[@(businessLine.integerValue)];
    return item;
}
@end
