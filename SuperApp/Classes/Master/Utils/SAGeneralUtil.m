//
//  SAGeneralUtil.m
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAGeneralUtil.h"
#import "NSDate+SAExtension.h"
#import "SAChangeCountryViewProvider.h"
#import "SACountryModel.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/NSArray+HDKitCore.h>
#import <HDKitCore/UIImage+HDKitCore.h>
#import <HDServiceKit.h>
#import <UserNotifications/UserNotifications.h>


@implementation SAGeneralUtil
+ (NSString *)getRandomKey {
    return [NSString stringWithFormat:@"%02d%@%02d", arc4random() % 100, [self getCurrentDateStrByFormat:@"yyMMddHHmmss"], arc4random() % 100];
}

+ (NSString *)getCurrentDateStrByFormat:(NSString *)format {
    return [self getDateStrWithDate:NSDate.date format:format];
}

+ (NSString *)getDateStrWithDate:(NSDate *)date format:(NSString *)format {
    NSString *str = @"";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    str = [fmt stringFromDate:date];
    return str;
}

+ (NSString *)getDateStrWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getDateStrWithDate:date format:format];
}

+ (NSString *)getDateStrWithTimeInterval:(NSInteger)timeInterval dateFormat:(NSString *)format dateInTodayFormat:(NSString *)dateInTodayFormat {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL isDateInToday = [calendar isDateInToday:confromTimesp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (isDateInToday) {
        [formatter setDateFormat:dateInTodayFormat];
    } else {
        [formatter setDateFormat:format];
    }
    NSTimeZone *timeZone = NSTimeZone.localTimeZone;
    [formatter setTimeZone:timeZone];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSInteger)getDaysForMonth:(NSInteger)month inYear:(NSInteger)year {
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        return 31;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        return 30;
    } else if (month == 2) {
        if ([self isLeapYear:year]) {
            return 29;
        } else {
            return 28;
        }
    }
    return 0;
}

+ (NSString *)getRealRandomKeyWithRandomKey:(NSString *)randomKey {
    NSData *oriData = [randomKey dataUsingEncoding:NSUTF8StringEncoding];

    // 解密传输密钥，还原真正的key
    NSString *realKey = [[NSString alloc] initWithData:[oriData base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
    while (realKey.length < 16) {
        realKey = [realKey stringByAppendingString:@"0"];
    }
    NSString *realKey32 = [realKey substringWithRange:NSMakeRange(0, 16)];
    return realKey32;
}

static NSArray<NSString *> *_supportCountryCodes = nil;
+ (NSString *_Nullable)getCountryCodeFromFullAccountNo:(NSString *)fullAccountNo {
    if (_supportCountryCodes == nil) {
        _supportCountryCodes = [SAChangeCountryViewProvider.dataSource mapObjectsUsingBlock:^NSString *_Nonnull(SACountryModel *_Nonnull obj, NSUInteger idx) {
            return obj.countryCode;
        }];
    }
    for (NSString *countryCode in _supportCountryCodes) {
        if ([fullAccountNo hasPrefix:countryCode]) {
            return countryCode;
        }
    }
    return nil;
}

+ (NSString *_Nullable)getShortAccountNoFromFullAccountNo:(NSString *)fullAccountNo {
    NSString *countryCode = [self getCountryCodeFromFullAccountNo:fullAccountNo];
    if (countryCode && countryCode.length > 0) {
        return [fullAccountNo stringByReplacingCharactersInRange:NSMakeRange(0, countryCode.length) withString:@""];
    }
    return fullAccountNo;
}

+ (NSInteger)getDiffValueUntilNowForDate:(NSDate *)date {
    NSTimeInterval from = [date timeIntervalSince1970];
    NSTimeInterval to = [[NSDate new] timeIntervalSince1970];
    NSNumber *result = [NSNumber numberWithDouble:(to - from)];
    HDLog(@"间隔: %zd(s) %@", result.integerValue, result);
    return result.integerValue <= 0 ? 0 : result.integerValue;
}

+ (BOOL)isNotificationEnable {
    __block BOOL enabled = false;

    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *_Nonnull settings) {
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusAuthorized:
                enabled = true;
                break;
            default:
                break;
        }
        dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER); //获取通知设置的过程是异步的，这里需要等待

    return enabled;
}

+ (NSString *)getTradeTypeNameByCode:(HDWalletTransType)code {
    static NSString *name = @"";
    switch (code) {
        case HDWalletTransTypeRefund:
            name = SALocalizedString(@"order_refund", @"退款");
            break;
        case HDWalletTransTypeCollect:
            name = SALocalizedString(@"gathering", @"收款");
            break;
        case HDWalletTransTypeConsume:
            name = SALocalizedString(@"consumption", @"消费");
            break;
        case HDWalletTransTypeExchange:
            name = SALocalizedString(@"convertible_currency", @"兑换币种");
            break;
        case HDWalletTransTypeRecharge:
            name = SALocalizedString(@"top_up", @"充值");
            break;
        case HDWalletTransTypeTransfer:
            name = SALocalizedString(@"transfer_accounts", @"转账");
            break;
        case HDWalletTransTypeWithdraw:
            name = SALocalizedString(@"withdrawal", @"提现");
            break;
        case HDWalletTransTypePinkPacket:
            name = SALocalizedString(@"red_packet", @"红包");
            break;
        case HDWalletTransTypeRemuneration:
            name = SALocalizedString(@"reward", @"酬劳");
            break;
        case HDWalletTransTypeDefault:
            name = SALocalizedString(@"all", @"所有");
            break;
        default:
            name = @"";
            break;
    }
    return name;
}

+ (NSString *)getWalletPaymethodDescWithPaymethod:(HDWalletPaymethod)paymethod {
    static NSString *desc = @"";
    switch (paymethod) {
        case HDWalletPaymethodBalance:
            desc = SALocalizedString(@"balance", @"余额");
            break;
        case HDWalletPaymethodAlipay:
            desc = SALocalizedString(@"pay_alipay", @"支付宝");
            break;
        case HDWalletPaymethodWechat:
            desc = SALocalizedString(@"pay_wechat", @"微信");
            break;
        case HDWalletPaymethodCreditCard:
            desc = SALocalizedString(@"credit_card", @"信用卡");
            break;
        case HDWalletPaymethodMonney:
            desc = SALocalizedString(@"wallet_cash", @"现金");
            break;
        default:
            break;
    }
    return desc;
}

+ (NSString *)getPaymentStatusDescWithEnum:(SAPaymentState)paymentStatus {
    static NSString *desc = @"";
    switch (paymentStatus) {
        case SAPaymentStateInit:
            desc = SALocalizedString(@"payOrderState_init", @"初始化");
            break;
        case SAPaymentStatePaying:
            desc = SALocalizedString(@"payOrderState_paying", @"支付中");
            break;
        case SAPaymentStatePayed:
            desc = SALocalizedString(@"payOrderState_payed", @"支付完成");
            break;
        case SAPaymentStatePayFail:
            desc = SALocalizedString(@"payOrderState_payFail", @"支付失败");
            break;
        case SAPaymentStateRefunding:
            desc = SALocalizedString(@"payOrderState_refunding", @"退款中");
            break;
        case SAPaymentStateRefunded:
            desc = SALocalizedString(@"payOrderState_refunded", @"退款完成");
            break;
        case SAPaymentStateClosed:
            desc = SALocalizedString(@"payOrderState_closed", @"关闭");
            break;
        default:
            break;
    }

    return desc;
}

+ (NSString *)getRefundStatusDescWithEnum:(SARefundState)refundStatus {
    static NSString *desc = @"";
    switch (refundStatus) {
        case SARefundStateWait:
            desc = SALocalizedString(@"refundOrderState_wait", @"待退款");
            break;
        case SARefundStateRefunding:
            desc = SALocalizedString(@"refundOrderState_refunding", @"退款中");
            break;
        case SARefundStateRefunded:
            desc = SALocalizedString(@"refundOrderState_refunded", @"已退款");
            break;
        case SARefundStateMerchantReject:
            desc = SALocalizedString(@"refundOrderState_reject", @"商家拒绝退款");
            break;
        case SARefundStateCancel:
            desc = SALocalizedString(@"refundOrderState_canceled", @"退款已取消");
            break;
        case SARefundStateInit:
            desc = SALocalizedString(@"refundOrderState_init", @"初始化");
            break;
        case SARefundStateRevoke:
            desc = SALocalizedString(@"refundOrderState_error", @"退款异常");
            break;
        case SARefundStateClose:
            desc = SALocalizedString(@"refundOrderState_closed", @"退款关闭");
            break;
        case SARefundStateExpired:
            desc = SALocalizedString(@"refundOrderState_expired", @"退款超过有效期");
            break;

        default:
            break;
    }
    return desc;
}

+ (NSString *)getRefundOperationDescWithEnum:(SARefundOperationType)operationType {
    static NSString *desc = @"";
    switch (operationType) {
        case SARefundOperationTypeClose:
            desc = SALocalizedString(@"refundOperationType_closed", @"退款关闭");
            break;
        case SARefundOperationTypeFinish:
            desc = SALocalizedString(@"refundOperationType_success", @"退款完成");
            break;
        case SARefundOperationTypeChangeToOfflineRefund:
            desc = SALocalizedString(@"refundOperationType_switch", @"改为线下退款");
            break;
        case SARefundOperationTypeFail:
            desc = SALocalizedString(@"refundOperationType_failed", @"退款失败");
            break;
        case SARefundOperationTypeAgain:
            desc = SALocalizedString(@"refundOperationType_relaunch", @"重新发起");
            break;
        case SARefundOperationTypeCreate:
            desc = SALocalizedString(@"refundOperationType_request", @"申请退款");
            break;
        case SARefundOperationTypeInitiate:
            desc = SALocalizedString(@"refundOperationType_accept", @"受理退款");
            break;
        default:
            break;
    }
    return desc;
}

+ (NSString *)getRefundSourceDescWithEnum:(SARefundSource)refundSource {
    static NSString *desc = @"";
    switch (refundSource) {
        case SARefundSourceNormal:
            desc = SALocalizedString(@"refundReason_normal", @"正常退款");
            break;
        case SARefundSourceRepeat:
            desc = SALocalizedString(@"refundReason_repeat", @"重复支付退款");
            break;
        case SARefundSourceTimeout:
            desc = SALocalizedString(@"refundReason_timeout", @"超时支付退款");
            break;
        case SARefundSourceChannel:
            desc = SALocalizedString(@"refundReason_channel", @"渠道单方退款");
            break;
        default:
            break;
    }
    return desc;
}

+ (NSString *)getDayStringWithDate:(NSDate *)date {
    NSString *str = @"";
    SADateWeekDayType type = date.sa_weekday;
    if ([type isEqualToString:SADateWeekDayTypeSunDay]) {
        str = SALocalizedString(@"sunday", @"Sun.");
    } else if ([type isEqualToString:SADateWeekDayTypeMonday]) {
        str = SALocalizedString(@"monday", @"Mon.");
    } else if ([type isEqualToString:SADateWeekDayTypeTuesDay]) {
        str = SALocalizedString(@"tuesday", @"Tues.");
    } else if ([type isEqualToString:SADateWeekDayTypeWednesday]) {
        str = SALocalizedString(@"wednesday", @"Wed.");
    } else if ([type isEqualToString:SADateWeekDayTypeThursday]) {
        str = SALocalizedString(@"thursday", @"Thur.");
    } else if ([type isEqualToString:SADateWeekDayTypeFriday]) {
        str = SALocalizedString(@"friday", @"Fri.");
    } else if ([type isEqualToString:SADateWeekDayTypeSaturday]) {
        str = SALocalizedString(@"saturday", @"Sat.");
    }
    return str;
}

+ (NSString *)getDayStringWithDateWeekdayIndex:(NSUInteger)weekdayIndex {
    if (weekdayIndex > 0 && weekdayIndex < 8) {
        NSArray *weeks = @[
            SALocalizedString(@"monday", @"Mon."),
            SALocalizedString(@"tuesday", @"Tues."),
            SALocalizedString(@"wednesday", @"Wed."),
            SALocalizedString(@"thursday", @"Thur."),
            SALocalizedString(@"friday", @"Fri."),
            SALocalizedString(@"saturday", @"Sat."),
            SALocalizedString(@"sunday", @"Sun.")
        ];
        return weeks[weekdayIndex - 1];
    }
    return @"";
}

+ (UIImage *)mergeImage:(UIImage *)aboveImage onBackgroundImageCenter:(UIImage *)bgImage {
    // 计算绘制点
    CGPoint point = CGPointMake((bgImage.size.width - aboveImage.size.width) * 0.5, (bgImage.size.height - aboveImage.size.height) * 0.5);

    // 合成
    UIImage *mergedImage = [bgImage hd_imageWithImageAbove:aboveImage atPoint:point];
    return mergedImage;
}

+ (NSString *)timeWithSeconds:(NSInteger)seconds {
    const NSInteger hour = floor(seconds / 3600);
    const NSInteger minute = floor(seconds / 60 % 60);
    const NSInteger second = floor(seconds % 60);

    const NSString *hourStr = [NSString stringWithFormat:@"%@%zd", hour < 10 ? @"0" : @"", hour];
    const NSString *minuteStr = [NSString stringWithFormat:@"%@%zd", minute < 10 ? @"0" : @"", minute];
    const NSString *secondStr = [NSString stringWithFormat:@"%@%zd", second < 10 ? @"0" : @"", second];

    if (hour > 0) {
        return [NSString stringWithFormat:@"%@:%@:%@", hourStr, minuteStr, secondStr];
    } else if (minute > 0) {
        return [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
    } else {
        return [NSString stringWithFormat:@"%zds", second];
    }
}

+ (NSString *)waitPayTimeWithSeconds:(NSInteger)seconds {
    const NSInteger hour = floor(seconds / 3600);
    const NSInteger minute = floor(seconds / 60 % 60);
    const NSInteger second = floor(seconds % 60);

    const NSString *hourStr = [NSString stringWithFormat:@"%@%zd", hour < 10 ? @"0" : @"", hour];
    const NSString *minuteStr = [NSString stringWithFormat:@"%@%zd", minute < 10 ? @"0" : @"", minute];
    const NSString *secondStr = [NSString stringWithFormat:@"%@%zd", second < 10 ? @"0" : @"", second];

    if (hour > 99) {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            return [NSString stringWithFormat:@"99+小时%@分钟%@秒", minuteStr, secondStr];
        }
        return [NSString stringWithFormat:@"99+h:%@m:%@s", minuteStr, secondStr];
    } else if (hour > 0) {
        return [NSString stringWithFormat:@"%@:%@:%@", hourStr, minuteStr, secondStr];
    } else if (minute > 0) {
        return [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
    } else {
        return [NSString stringWithFormat:@"00:%@", secondStr];
    }
}

/// 获取设备相关信息
+ (NSString *)getDeviceInfo {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:25];
    ///< 厂家
    //    [dic setValue:@"apple" forKey:@"brand"];
    ///< 型号
    [dic setValue:[HDDeviceInfo modelName] forKey:@"model"];
    ///< 厂家
    [dic setValue:[UIDevice currentDevice].name forKey:@"manufacturer"];
    ///< 系统版本
    [dic setValue:[HDDeviceInfo deviceVersion] forKey:@"osVersion"];
    ///< api版本
    //    [dic setValue:@"" forKey:@"apiLevel"];
    ///< 芯片架构
    //    [dic setValue:@"" forKey:@"abi"];
    ///< 芯片支撑架构
    //    [dic setValue:@"" forKey:@"supportedAbis"];
    ///< OPenGL ES版本
    //    [dic setValue:@"" forKey:@"glesVersion"];
    ///< 屏幕宽高
    [dic setValue:[HDDeviceInfo screenSize] forKey:@"WxH"];
    ///< 屏幕密度
    //    [dic setValue:[NSString stringWithFormat:@"%.1f", [UIScreen mainScreen].nativeScale] forKey:@"density"];
    ///< 屏幕密度DP
    //    [dic setValue:@"" forKey:@"densityDpi"];
    ///< 手机内存
    [dic setValue:[NSString stringWithFormat:@"%llu", [NSProcessInfo processInfo].physicalMemory] forKey:@"memory"];
    ///< cpu核数
    //    [dic setValue:@"" forKey:@"cpuCore"];
    ///< 语言
    [dic setValue:[HDDeviceInfo getDeviceLanguage] forKey:@"language"];
    ///< 国家地区
    [dic setValue:[NSLocale currentLocale].localeIdentifier forKey:@"region"];
    ///< app版本号
    [dic setValue:[HDDeviceInfo appVersion] forKey:@"appVersion"];
    ///< 渠道
    [dic setValue:@"AppStore" forKey:@"appChannel"];
    ///< 设备号
    [dic setValue:[HDDeviceInfo getUniqueId] forKey:@"deviceId"];

    if ([HDLocationUtils getCLAuthorizationStatus] == HDCLAuthorizationStatusAuthed && [[HDLocationManager shared] isCurrentCoordinate2DValid]) {
        ///< 经度
        [dic setValue:[NSString stringWithFormat:@"%f", [HDLocationManager shared].realCoordinate2D.latitude] forKey:@"latitude"];
        ///< 纬度
        [dic setValue:[NSString stringWithFormat:@"%f", [HDLocationManager shared].realCoordinate2D.longitude] forKey:@"longitude"];
    } else {
        ///< 经度
        [dic setValue:@"" forKey:@"latitude"];
        ///< 纬度
        [dic setValue:@"" forKey:@"longitude"];
    }
    ///< pos sp版本
    //    [dic setValue:@"" forKey:@"spVersion"];

    //    [dic setValue:@"" forKey:@"posVersion"];
    ///<  广告标识符
    [dic setValue:[HDDeviceInfo idfaString] forKey:@"IDFA"];
    ///<  设备标识符
    [dic setValue:[HDDeviceInfo idfvString] forKey:@"UUID"];
    ///< 磁盘总大小
    [dic setValue:[NSString stringWithFormat:@"%llu", [HDDeviceInfo deviceStorageSpace:YES]] forKey:@"totalDisk"];
    ///< 运营商
    [dic setValue:[HDDeviceInfo getCarrierName] forKey:@"networkBrand"];
    ///< 网络类型
    [dic setValue:[HDDeviceInfo getNetworkType] forKey:@"networkType"];
    ///< 电池状态
    [dic setValue:[NSString stringWithFormat:@"%ld", [UIDevice currentDevice].batteryState] forKey:@"batteryState"];
    ///< 电量
    [dic setValue:[NSString stringWithFormat:@"%.2f", [UIDevice currentDevice].batteryLevel] forKey:@"batteryLevel"];

    return [dic yy_modelToJSONString];
}

#pragma mark - private methods
+ (BOOL)isLeapYear:(NSInteger)year {
    if (year % 4 == 0 && year % 100 != 0) {
        return YES;
    } else if (year % 400 == 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)getAggregateOrderStateWithCode:(SAAggregateOrderState)code {
    static NSString *aggregateOrderState = @"";
    switch (code) {
        case SAAggregateOrderStateInit:
            aggregateOrderState = SALocalizedString(@"aggregateOrderState_init", @"初始化");
            break;
        case SAAggregateOrderStateComplete:
            aggregateOrderState = SALocalizedString(@"aggregateOrderState_completed", @"已完成");
            break;
        case SAAggregateOrderStatePaying:
            aggregateOrderState = SALocalizedString(@"aggregateOrderState_waitPay", @"待支付");
            break;
        case SAAggregateOrderStatePayed:
            aggregateOrderState = SALocalizedString(@"aggregateOrderState_payed", @"已支付");
            break;

        default:
            break;
    }
    return aggregateOrderState;
}
+ (NSString *)getAggregateOrderFinalStateWithCode:(SAAggregateOrderFinalState)code {
    static NSString *aggregateOrderFinalState = @"";
    switch (code) {
        case SAAggregateOrderFinalStateComplete:
            aggregateOrderFinalState = SALocalizedString(@"aggregateOrderState_completed", @"已完成");
            break;
        case SAAggregateOrderFinalStateCancel:
            aggregateOrderFinalState = SALocalizedString(@"aggregateOrderState_canceled", @"已取消");
            break;
        case SAAggregateOrderFinalStateClosed:
            aggregateOrderFinalState = SALocalizedString(@"aggregateOrderState_closed", @"已关闭");
            break;

        default:
            break;
    }
    return aggregateOrderFinalState;
}

@end
