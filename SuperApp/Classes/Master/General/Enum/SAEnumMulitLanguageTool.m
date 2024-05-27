//
//  SAEnumMulitLanguageTool.m
//  SuperApp
//
//  Created by seeu on 2020/9/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAEnumMulitLanguageTool.h"
#import "SAMultiLanguageManager.h"


@implementation SAEnumMulitLanguageTool
+ (NSString *)couponNameWithCouponType:(SACouponTicketType)type {
    NSString *couponName = nil;
    switch (type) {
        case SACouponTicketTypeDefault:
            couponName = @"";
            break;
        case SACouponTicketTypeDiscount:
            couponName = SALocalizedString(@"discount_coupons", @"折扣券");
            break;
        case SACouponTicketTypeMinus:
            couponName = SALocalizedString(@"KG8ZBMsK", @"满减券"); // 未上线，暂时不用管
            break;
            ;
        case SACouponTicketTypeReduction:
            couponName = SALocalizedString(@"cash_coupons", @"现金券");
            break;
        default:
            couponName = @"";
            break;
    }
    return couponName;
}
@end
