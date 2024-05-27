//
//  WMManage.m
//  SuperApp
//
//  Created by wmz on 2021/8/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMManage.h"
#import "WMMultiLanguageManager.h"

static WMManage *postManage = nil;


@implementation WMManage

/// 单例
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        postManage = [[super allocWithZone:NULL] init];
        postManage.defaultPlateId = @"00000000000000000000000000000000";
    });
    return postManage;
}

- (void)changeLanguage {
    self.weekInfo = nil;
    self.giveCouponErrorInfo = nil;
}

- (NSString *)currentCompleteSource:(UIViewController<WMViewControllerProtocol> *)VC includeSelf:(BOOL)include {
    if ([VC conformsToProtocol:@protocol(WMViewControllerProtocol)] && [VC respondsToSelector:@selector(currentSourceType)]) {
        NSArray *viewControllers = [VC.navigationController viewControllers];
        NSInteger currentIndex = [viewControllers indexOfObject:VC];
        __block NSMutableArray *marr = NSMutableArray.new;
        if (currentIndex > 0) {
            [viewControllers enumerateObjectsUsingBlock:^(UIViewController<WMViewControllerProtocol> *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if ([obj conformsToProtocol:@protocol(WMViewControllerProtocol)] && [obj respondsToSelector:@selector(currentSourceType)] && (include ? (idx <= currentIndex) : (idx < currentIndex))) {
                    WMSourceType sourceType = [obj currentSourceType];
                    [marr addObject:sourceType];
                }
            }];
        }
        if (marr.count) {
            return [marr componentsJoinedByString:@" "];
        }
    }
    return WMSourceTypeNone;
}

- (NSString *)plateId {
    if (!_plateId) {
        _plateId = self.defaultPlateId;
    }
    return _plateId;
}

- (NSDictionary<NSString *, NSString *> *)weekInfo {
    if (!_weekInfo) {
        _weekInfo = @{
            @"MONDAY": WMLocalizedString(@"monday", @"MONDAY"),
            @"TUESDAY": WMLocalizedString(@"tuesday", @"TUESDAY"),
            @"WEDNESDAY": WMLocalizedString(@"wednesday", @"WEDNESDAY"),
            @"THURSDAY": WMLocalizedString(@"thursday", @"THURSDAY"),
            @"FRIDAY": WMLocalizedString(@"friday", @"FRIDAY"),
            @"SATURDAY": WMLocalizedString(@"saturday", @"SATURDAY"),
            @"SUNDAY": WMLocalizedString(@"sunday", @"SUNDAY"),
        };
    }
    return _weekInfo;
}

- (NSDictionary<WMGiveCouponError, NSString *> *)giveCouponErrorInfo {
    _giveCouponErrorInfo = @{
        WMGiveCouponErrorLogin: WMLocalizedString(@"wm_fail_user_notlog", @"领取失败，用户未登录"),
        WMGiveCouponErrorActivityChange: WMLocalizedString(@"wm_fail_event_change", @"领取失败，活动信息发生变更"),
        WMGiveCouponErrorGiveOver: WMLocalizedString(@"wm_fail_coupon_outof", @"领取失败，券已抢光"),
        WMGiveCouponErrorSendFail: WMLocalizedString(@"wm_fail_event_issuse", @"领取失败，发券失败"),
        WMGiveCouponErrorDayLimit: WMLocalizedString(@"wm_fail_coupon_limit_today", @"领取失败，达到今日领券上限"),
        WMGiveCouponErrorActivityLimit: WMLocalizedString(@"wm_fail_event_limit", @"领取失败，已达活动领取上限"),
        WMGiveCouponErrorActitityEnd: WMLocalizedString(@"wm_fail_event_ended", @"领取失败，活动已结束"),
        WMGiveCouponErrorCouponEnd: WMLocalizedString(@"wm_fail_coupon_expired", @"wm_fail_coupon_expired"),
        WMGiveCouponErrorCouponChange: WMLocalizedString(@"wm_fail_coupon_infochange", @"wm_fail_coupon_infochange"),
        WMGiveCouponErrorGiving: WMLocalizedString(@"wm_fail_coupon_giving", @"正在领券中"),
        WMGiveCouponErrorNotFound: WMLocalizedString(@"wm_fail_coupon_notfound", @"领取失败，找不到优惠券"),
        WMGiveCouponErrorActivityNotFound: WMLocalizedString(@"wm_fail_event_notfound", @"领取失败，找不到活动"),
        WMGiveCouponErrorUserNotFound: WMLocalizedString(@"wm_fail_user_notfound", @"领取失败，找不到用户"),
        WMGiveCouponErrorNotReceive: WMLocalizedString(@"wm_fail_eligible_receive", @"领取失败，未达到领用资格"),
        WMGiveCouponErrorReceiveCash: WMLocalizedString(@"wm_fail_system_error", @"领取失败，领用时发生异常"),
    };
    return _giveCouponErrorInfo;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [WMManage shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [WMManage shareInstance];
}

@end
