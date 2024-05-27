//
//  HDCouponTicketModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketModel.h"
#import "HDTradePreferentialModel.h"
#import "PNCommonUtils.h"
#import "PNUtilMacro.h"


@implementation HDCouponTicketModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.gradientLayerWidth = kRealWidth(107);
        self.numbersOfLineOfTitle = 0;
        self.numbersOfLineOfDate = 0;
    }
    return self;
}

- (NSString *)usableCurrencyDesc {
    NSString *desc = @"";
    if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSD) {
        desc = [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeUSD];
    } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeKHR) {
        desc = [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeKHR];
    } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSDAndKHR) {
        NSMutableString *string = [NSMutableString stringWithString:desc];
        [string appendFormat:@"%@", [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeUSD]];
        [string appendString:@"/"];
        [string appendFormat:@"%@", [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeKHR]];
        desc = [string mutableCopy];
    }
    return desc;
}

- (void)setCouponDiscount:(NSNumber *)couponDiscount {
    _couponDiscount = couponDiscount;

    if (couponDiscount.integerValue != couponDiscount.doubleValue) {
        // 判断小数位数
        NSString *stringValue = couponDiscount.stringValue;
        if ([stringValue rangeOfString:@"."].location != NSNotFound) {
            NSArray<NSString *> *subStrArr = [stringValue componentsSeparatedByString:@"."];
            if (subStrArr.count >= 1) {
                NSString *pointStr = subStrArr[1];
                if (pointStr.length == 1) {
                    _discountRadioStr = [NSString stringWithFormat:@"%.1f%%", couponDiscount.doubleValue];
                } else {
                    // 最多两位
                    _discountRadioStr = [NSString stringWithFormat:@"%.2f%%", couponDiscount.doubleValue];
                }
            } else {
                _discountRadioStr = [NSString stringWithFormat:@"%zd%%", couponDiscount.integerValue];
            }
        }
    } else {
        _discountRadioStr = [NSString stringWithFormat:@"%zd%%", couponDiscount.integerValue];
    }
}

- (void)setCouponState:(PNCouponTicketStatus)couponState {
    _couponState = couponState;

    switch (couponState) {
        case PNCouponTicketStatusIneffective:
            _couponStateDesc = @"未生效";
            break;

        case PNCouponTicketStatusUnUsed:
            _couponStateDesc = @"未使用";
            break;

        case PNCouponTicketStatusLocked:
            _couponStateDesc = @"已锁定";
            break;

        case PNCouponTicketStatusUsed:
            _couponStateDesc = @"已使用";
            break;

        case PNCouponTicketStatusOutDated:
            _couponStateDesc = @"已过期";
            break;

        default:
            break;
    }
}

- (void)setSceneType:(HDCouponTicketSceneType)sceneType {
    _sceneType = sceneType;

    switch (sceneType) {
        case HDCouponTicketSceneTypePlatform:
            _sceneTypeDesc = @"平台券";
            break;

        case HDCouponTicketSceneTypeMerchant:
            _sceneTypeDesc = @"商家券";
            break;

        case HDCouponTicketSceneTypePlatformAndMerchant:
            _sceneTypeDesc = @"平台+商家券";
            break;

        default:
            break;
    }
}

- (void)setCouponType:(PNTradePreferentialType)couponType {
    _couponType = couponType;

    switch (couponType) {
        case PNTradePreferentialTypeCashBack:
            _couponTypeDesc = @"返现";
            break;

        case PNTradePreferentialTypeMinus:
            _couponTypeDesc = @"立减";
            break;

        case PNTradePreferentialTypeDiscount:
            _couponTypeDesc = @"折扣";
            break;

        case PNTradePreferentialTypeDiscountTicket:
            _couponTypeDesc = @"折扣券";
            break;

        case PNTradePreferentialTypeFullReduction:
            _couponTypeDesc = @"满减券";
            break;

        default:
            break;
    }
}

+ (instancetype)modelWithTradePreferentialModel:(HDTradePreferentialModel *)model {
    return [[self alloc] initWithTradePreferentialModel:model];
}

- (instancetype)initWithTradePreferentialModel:(HDTradePreferentialModel *)model {
    if (self = [super init]) {
        // 1.15 修改，显示用 couponMoney， 计算用 couponAmt
        self.couponAmount = model.couponMoney;
        self.couponDiscount = model.discountRatio;
        // 收银台显示的券肯定是未使用的
        self.couponState = PNCouponTicketStatusUnUsed;
        self.couponTitle = model.title;
        self.couponType = model.type;
        self.sceneType = model.origin;
        self.effectiveDate = model.effectiveDate;
        self.expireDate = model.expireDate;
        self.thresholdAmount = model.thresholdMoney;
        self.numbersOfLineOfTitle = model.numbersOfLineOfTitle;
        self.numbersOfLineOfDate = model.numbersOfLineOfDate;
        self.gradientLayerWidth = model.gradientLayerWidth;
        self.isFixedHeight = model.isFixedHeight;
        self.currencyType = model.ableCurrencyType;
    }
    return self;
}
@end
