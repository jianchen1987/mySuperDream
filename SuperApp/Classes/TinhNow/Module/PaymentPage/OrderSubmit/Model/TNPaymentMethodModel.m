//
//  TNPaymentMethodModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPaymentMethodModel.h"
#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import <NSString+HD_Size.h>


@implementation TNPaymentMethodModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc": @"description", @"name": @"nameLocales"};
}
//-(NSArray *)payIconsArr{
//    NSArray<NSString *> *icons = @[];
//    if ([self.method isEqualToString:TNPaymentMethodOnLine]) {
//        NSArray<NSString *> *supportChannelArray = [SACacheManager.shared objectForKey:kCacheKeyTinhNowPaymentToolsCache type:SACacheTypeCachePublic];
//        if (supportChannelArray.count) {
//            icons = [NSArray arrayWithArray:supportChannelArray];
//        } else {
//            NSString *supportChannelStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchPaymentChannelList];
//            icons = [NSJSONSerialization JSONObjectWithData:[supportChannelStr dataUsingEncoding:NSUTF8StringEncoding]
//                                                    options:NSJSONReadingMutableContainers
//                                                      error:nil];
//        }
//    }
//    return icons;
//}

- (NSString *)selectOnlineMethodTypeImageName {
    NSString *toolCode = self.selectedOnlineMethodType.toolCode;
    NSString *name;
    if ([toolCode isEqualToString:HDCheckStandPaymentToolsWechat]) {
        name = @"payment_method_wechat";
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsAlipay]) {
        name = @"";
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsCredit]) {
        name = @"payment_method_credit";
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsABAPay]) {
        name = @"payment_method_aba";
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsWing]) {
        name = @"payment_method_wing";
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsPrince]) {
        name = @"payment_method_prince";
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) {
        name = @"payment_method_balance";
    } else {
        name = @"";
    }
    return name;
}
@end
