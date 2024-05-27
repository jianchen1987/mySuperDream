//
//  WMOrderSubmitFullGiftRspModel.m
//  SuperApp
//
//  Created by wmz on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitFullGiftRspModel.h"
#import "NSArray+HDKitCore.h"


@implementation WMOrderSubmitFullGiftRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"giftListResps": WMStoreFillGiftRuleModel.class,
        @"activityContentResps": WMStoreFillGiftRuleModel.class,
    };
}
- (NSString *)checkActivityResultStr {
    if (!_checkActivityResultStr) {
        NSDictionary *info = @{
            @"R0002": WMLocalizedString(@"wm_gift_fail_year", @"未满18岁，或未填写个人的生日信息"),
            @"R0003": WMLocalizedString(@"wm_gift_fail_num", @"已达到参与活动次数上限"),
            @"R0004": WMLocalizedString(@"wm_gift_fail_stock", @"赠品库存不足，可更换商家下单"),
            @"R0005": WMLocalizedString(@"wm_gift_fail_lowest", @"商品原价总价总计未达到活动最低要求")
        };
        NSMutableString *mar = [[NSMutableString alloc] initWithString:@""];
        if (self.checkActivityResults.count) {
            [mar appendFormat:@"%@\n%@：", WMLocalizedString(@"wm_fill_gift_fail_join", @"未达到参与资格"), WMLocalizedString(@"wm_gift_order_reason", @"原因")];
        }
        for (id code in self.checkActivityResults) {
            NSString *tag = @"";
            if ([code isKindOfClass:NSString.class]) {
                tag = code;
            } else if ([code isKindOfClass:NSDictionary.class]) {
                tag = code[@"name"] ?: @"";
            }
            NSString *infoStr = info[tag] ?: @"";
            if ([code isEqualToString:@"R0002"]) {
                [mar appendFormat:@"%@，%@\n", infoStr, WMLocalizedString(@"wm_gift_write", @"立即填写")];
            } else {
                [mar appendFormat:@"%@\n", infoStr];
            }
        }
        _checkActivityResultStr = mar;
    }
    return _checkActivityResultStr;
}

- (NSString *)fillName {
    if (!_fillName) {
        NSMutableString *fillName = NSMutableString.new;
        [fillName appendString:self.activityTitle.desc ?: @""];
        if (self.activityContentResps.count) {
            NSString *productName = [[self.activityContentResps mapObjectsUsingBlock:^id _Nonnull(WMStoreFillGiftRuleModel *_Nonnull obj1, NSUInteger idx) {
                NSString *labber = @"";
                labber = [NSString stringWithFormat:WMLocalizedString(@"wm_gift_buy_free", @"满%@赠%@%ld件"), [NSString stringWithFormat:@"$%@", obj1.amount], obj1.giftName, obj1.quantity];
                return labber;
            }] componentsJoinedByString:@"，"];
            [fillName appendString:@"，"];
            [fillName appendString:productName];
        }
        _fillName = fillName;
    }
    return _fillName;
}
@end
