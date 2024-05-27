//
//  PNCommonUtils.m
//  National Wallet
//
//  Created by 陈剑 on 2018/4/25.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "PNCommonUtils.h"
#import "CommonCrypto/CommonDigest.h"
#import "HDCommonDefines.h"
#import "NSDate+Extension.h"
#import "NSString+HD_AES.h"
#import "NSString+HD_MD5.h"
#import "NSString+SA_Extension.h"
#import "PNMultiLanguageManager.h" //语言
#import "PNUtilMacro.h"
#import "UIView+HD_Extension.h"
#import "YYModel.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static NSString *_networkType = @"WIFI";


@implementation PNCommonUtils

+ (void)setNetworkType:(NSString *)type {
    if ([type isEqualToString:@"gsm"]) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus = info.currentRadioAccessTechnology;
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
            type = @"2g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
            type = @"3g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]) {
            type = @"3g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
            type = @"4g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
            type = @"4g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
            type = @"2g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]) {
            type = @"3g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]) {
            type = @"3g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
            type = @"3g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
            type = @"3g";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
            type = @"4g";
        }
        _networkType = type;
    } else {
        _networkType = type;
    }
}

+ (NSString *)getCurrentCarrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    if (carrier) {
        return carrier.carrierName;
    }
    return @"";
}

+ (NSString *)getCurrentNetworkType {
    return _networkType;
}

+ (NSString *)getyyyyMMddhhmmss:(NSDate *)date {
    NSString *str = @"";
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
    [formatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    str = [formatter1 stringFromDate:date];
    return str;
}

+ (NSString *)getDateStrByFormat:(NSString *)format withDate:(NSDate *)date {
    NSString *str = @"";
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:format];
    [formatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    str = [formatter1 stringFromDate:date];
    return str;
}

+ (NSString *)getCurrentDateStrByFormat:(NSString *)format {
    NSString *str = @"";
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:format];
    [formatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    str = [formatter1 stringFromDate:[NSDate date]];
    return str;
}

/// 比较两个时间的时间间隔【单位是 天】
+ (NSInteger)getDiffenrenceByDate1:(NSString *)startDateStr date2:(NSString *)endDateStr {
    NSString *formatStr = @"dd/MM/yyyy";
    NSDate *startDate = [startDateStr dateWithFormat:formatStr];
    NSDate *endDate = [endDateStr dateWithFormat:formatStr];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    NSInteger diffenDayInt = [comps day];
    HDLog(@"相差 %zd 天", diffenDayInt);
    return diffenDayInt;
}

+ (NSInteger)getDiffenrenceByDate:(NSString *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate toDate:now options:0];
    return [comps day];
}

+ (NSInteger)getDiffenrenceYearByDate:(NSDate *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:now options:0];
    return [comps year];
}

+ (NSInteger)getDiffenrenceYearByDate:(NSString *)date1Str date2:(NSString *)date2Str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    NSDate *date1 = [dateFormatter dateFromString:date1Str];
    NSDate *date2 = [dateFormatter dateFromString:date2Str];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
    return [comps year];
}

///针对年龄
+ (NSInteger)getDiffenrenceYearByDate_age:(NSString *)date1Str date2:(NSString *)date2Str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    NSDate *date1 = [dateFormatter dateFromString:date1Str];
    NSDate *date2 = [dateFormatter dateFromString:date2Str];
    NSInteger year1 = date1.year;
    NSInteger year2 = date2.year;
    NSInteger age = year2 - year1;
    return age;
}

+ (NSInteger)getDiffenrenceMinByDate:(NSDate *)date {
    NSTimeInterval from = [date timeIntervalSince1970];
    NSTimeInterval to = [[NSDate new] timeIntervalSince1970];
    NSNumber *result = [NSNumber numberWithDouble:(to - from)];
    HDLog(@"刷新间隔:%zd(s) %@", result.integerValue, result);
    return result.integerValue;
}

+ (NSString *)getRandomKey {
    return [NSString stringWithFormat:@"%02d%@%02d", arc4random() % 100, [self getCurrentDateStrByFormat:@"yyMMddHHmmss"], arc4random() % 100];
}

+ (NSString *)getCurrenceNameByCode:(NSString *)code {
    if (![code isEqual:[NSNull null]] && [code isEqualToString:PNCurrencyTypeUSD]) {
        return @"USD";
    } else if (![code isEqual:[NSNull null]] && [code isEqualToString:PNCurrencyTypeKHR]) {
        return @"KHR";
    } else {
        return @"USD";
    }
}

+ (NSString *)getCurrencySymbolByCode:(NSString *)code {
    if (![code isEqual:[NSNull null]] && [code isEqualToString:PNCurrencyTypeUSD]) {
        return @"$";
    } else if (![code isEqual:[NSNull null]] && [code isEqualToString:PNCurrencyTypeKHR]) {
        return @"៛";
    } else {
        return @"$";
    }
}

+ (NSInteger)getAmountDecimalsCountByCurrency:(NSString *)code {
    if (HDIsStringNotEmpty(code) && [code isEqualToString:PNCurrencyTypeKHR]) {
        return 0;
    } else if (HDIsStringNotEmpty(code) && [code isEqualToString:PNCurrencyTypeUSD]) {
        return 2;
    } else {
        return 2;
    }
}

+ (NSString *)getTradeTypeNameByCode:(PNTransType)code {
    NSString *name = @"";
    switch (code) {
        case PNTransTypeRefund:
            name = PNLocalizedString(@"TRANS_TYPE_REFUND", @"退款");
            break;
        case PNTransTypeCollect:
            name = PNLocalizedString(@"TRANS_TYPE_COLLECT", @"收款");
            break;
        case PNTransTypeConsume:
            name = PNLocalizedString(@"consumption", @"消费");
            break;
        case PNTransTypeExchange:
            name = PNLocalizedString(@"TRANS_TYPE_EXCHANGE", @"兑换币种");
            break;
        case PNTransTypeRecharge:
            name = PNLocalizedString(@"Deposit", @"入金");
            break;
        case PNTransTypeTransfer:
            name = PNLocalizedString(@"TRANS_TYPE_TRANSFER", @"转账");
            break;
        case PNTransTypeToPhone:
            //            name = PNLocalizedString(@"pn_transfer_phone_number2", @"转账到手机号");
            name = PNLocalizedString(@"TRANS_TYPE_TRANSFER", @"转账");
            break;
        case PNTransTypeWithdraw: //提现改出金
                                  //            name = PNLocalizedString(@"Cash_out", @"提现");
            name = PNLocalizedString(@"Cash_out", @"出金");
            break;
        case PNTransTypePinkPacket:
            name = PNLocalizedString(@"redpacket", @"红包");
            break;
        case PNTransTypeRemuneration:
            name = PNLocalizedString(@"TRANS_TYPE_Remuneration", @"酬劳");
            break;
        case PNTransTypeDefault:
            name = PNLocalizedString(@"TRANS_TYPE_ALL", @"所有");
            break;
        case PNTransTypeAdjust:
            name = PNLocalizedString(@"addjust", @"调账");
            break;
        case PNTransTypeBlocked:
            name = PNLocalizedString(@"blocked", @"冻结扣款");
            break;
        case PNTransTypeApartment:
            name = PNLocalizedString(@"pn_bill", @"缴费");
            break;
        default:
            name = @"";
            break;
    }
    return name;
}

+ (NSString *)getSubTradeTypeNameByCode:(PNTradeSubTradeType)code {
    NSString *name = @"";
    switch (code) {
        case PNTradeSubTradeTypePhoneTopUp:
            name = PNLocalizedString(@"SUBTRADE_TYPE_PHONE_TOU_UP", @"话费充值");
            break;
        case PNTradeSubTradeTypeCashBack:
            name = PNLocalizedString(@"SUBTRADE_TYPE_CASHBACK", @"立返");
            break;
        case PNTradeSubTradeTypeDefault:
            name = PNLocalizedString(@"TRANS_TYPE_ALL", @"所有");
            break;
        case PNTradeSubTradeTypeNewUserRights:
            name = PNLocalizedString(@"new_user_redpacket", @"新人专享");
            break;
        case PNTradeSubTradeTypeInviteReward:
            name = PNLocalizedString(@"invite_friend_reward", @"邀请好友奖励");
            break;
        default:
            name = @"";
            break;
    }
    return name;
}

+ (NSString *)getPapersNameByPapersCode:(PNPapersType)code {
    NSString *name = @"";
    switch (code) {
        case PNPapersTypeIDCard:
            name = PNLocalizedString(@"PAPER_TYPE_IDCARD", @"身份证");
            break;
        case PNPapersTypePassport:
            name = PNLocalizedString(@"PAPER_TYPE_PASSPORT", @"护照");
            break;
        case PNPapersTypeDrivingLince:
            name = PNLocalizedString(@"PAPER_TYPE_Driving_license", @"柬埔寨驾照");
            break;
        case PNPapersTypepolice:
            name = PNLocalizedString(@"PAPER_TYPE_Police", @"警察证/公务员证");
            break;
        default:
            name = @"";
            break;
    }
    return name;
}

+ (NSString *)getSexBySexCode:(PNSexType)code {
    NSString *name = @"";
    switch (code) {
        case PNSexTypeMen:
            name = PNLocalizedString(@"SEX_TYPE_MALE", @"男");
            break;
        case PNSexTypeWomen:
            name = PNLocalizedString(@"SEX_TYPE_FEMALE", @"女");
            break;
        default:
            name = @"";
            break;
    }
    return name;
}

+ (NSString *)getStatusByCode:(PNOrderStatus)code {
    NSString *name = @"";
    switch (code) {
        case PNOrderStatusSuccess:
            name = PNLocalizedString(@"ORDER_STATUS_SUCCESS", @"成功");
            break;
        case PNOrderStatusFailure:
            name = PNLocalizedString(@"ORDER_STATUS_FAILURE", @"失败");
            break;
        case PNOrderStatusProcessing:
            name = PNLocalizedString(@"ORDER_STATUS_PROCESS", @"处理中");
            break;
        case PNOrderStatusRefund:
            name = PNLocalizedString(@"ORDER_STATUS_REFUND", @"已退款");
            break;
        case PNOrderStatusDeducted:
            name = PNLocalizedString(@"Deducted", @"已扣款");
            break;
        default:
            break;
    }
    return name;
}

+ (NSString *)getAccountNameByCode:(NSString *)code {
    NSString *name = @"";
    if ([code isEqualToString:PNCurrencyTypeKHR]) {
        name = PNLocalizedString(@"ACCOUNT_TYPE_KHR", @"瑞尔账户");
    } else if ([code isEqualToString:PNCurrencyTypeUSD]) {
        name = PNLocalizedString(@"ACCOUNT_TYPE_USD", @"美元账户");
    } else {
        name = PNLocalizedString(@"ACCOUNT_TYPE_NONE", @"未知账户");
    }
    return name;
}

/// 脱敏处理
+ (NSString *)getSecretTextForPwd:(NSString *)pwd LoginName:(NSString *)loginName {
    return [[loginName stringByAppendingString:[pwd hd_MD5]] hd_MD5];
}

+ (NSString *)deSensitiveString:(NSString *)ori {
    if (ori.length <= 4 && ori.length > 1) {
        return [ori stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"***"];
    } else if (ori.length <= 1) {
        return [ori stringByAppendingString:@"***"];
    } else if (ori.length > 8 && ([ori hasPrefix:@"855"] || [ori hasPrefix:@"8550"])) {
        return [ori stringByReplacingCharactersInRange:NSMakeRange(6, (ori.length - 2) > 0 ? (ori.length - 8) : 2) withString:@"****"];
    } else {
        if (ori.length > 6) {
            return [ori stringByReplacingCharactersInRange:NSMakeRange(3, (ori.length - 7) > 0 ? (ori.length - 7) : 2) withString:@"****"];
        } else {
            return ori;
        }
    }
}

/// 针对姓名
+ (NSString *)deSensitiveWithName:(NSString *)name {
    NSString *result = @"";
    if (name.length >= 1) {
        result = [[name substringToIndex:1] stringByAppendingString:@"***"];
    }
    return result;
}

+ (NSString *)yuanTofen:(NSString *)yuan {
    if ([yuan isEqualToString:@""] || [yuan isEqual:[NSNull null]] || yuan.doubleValue <= 0) {
        return @"0";
    }

    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2.0f raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO
                                                                              raiseOnDivideByZero:YES];

    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:yuan];
    NSDecimalNumber *factoty = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *result = [amount decimalNumberByMultiplyingBy:factoty withBehavior:handle];

    return [NSString stringWithFormat:@"%@", result];
}

+ (NSString *)fenToyuan:(NSString *)fen {
    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2.0f raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO
                                                                              raiseOnDivideByZero:YES];

    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:fen];
    NSDecimalNumber *factoty = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *result = [amount decimalNumberByDividingBy:factoty withBehavior:handle];

    NSString *resultStr = [NSString stringWithFormat:@"%0.2f", result.doubleValue];

    // 如果小数点末尾是0需抹掉就解开注释
    /*
    if (resultStr.integerValue == resultStr.doubleValue) {
        resultStr = [NSString stringWithFormat:@"%zd", resultStr.integerValue];
    } else {
        // 判断小数位数
        if ([resultStr rangeOfString:@"."].location != NSNotFound) {
            NSArray<NSString *> *subStrArr = [resultStr componentsSeparatedByString:@"."];
            if (subStrArr.count >= 1) {
                NSString *pointStr = subStrArr[1];
                if (pointStr.length == 1) {
                    resultStr = [NSString stringWithFormat:@"%.1f", resultStr.doubleValue];
                } else {
                    // 最多两位
                    resultStr = [NSString stringWithFormat:@"%.2f", resultStr.doubleValue];
                }
            } else {
                resultStr = [NSString stringWithFormat:@"%zd", resultStr.integerValue];
            }
        }
    }
    */
    return resultStr;
}

+ (NSString *)thousandSeparatorAmount:(NSString *)amount currencyCode:(NSString *)code {
    NSNumberFormatter *format = [NSNumberFormatter new];
    format.numberStyle = NSNumberFormatterCurrencyStyle;
    format.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    format.currencySymbol = [PNCommonUtils getCurrencySymbolByCode:code];

    NSDecimalNumberHandler *hander = nil;
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:amount];
    if ([code isEqualToString:PNCurrencyTypeKHR]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 0;
    } else if ([code isEqualToString:PNCurrencyTypeUSD]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 2;
    } else if ([code isEqualToString:PNCurrencyTypeCNY]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 2;
    }
    return [format stringFromNumber:[result decimalNumberByRoundingAccordingToBehavior:hander]];
}

+ (NSString *)thousandSeparatorNoCurrencySymbolWithAmount:(NSString *)amount currencyCode:(NSString *)code {
    NSNumberFormatter *format = [NSNumberFormatter new];
    format.numberStyle = NSNumberFormatterCurrencyStyle;
    format.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    format.currencySymbol = @"";

    NSDecimalNumberHandler *hander = nil;
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:amount];
    if ([code.uppercaseString isEqualToString:PNCurrencyTypeKHR]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 0;
    } else if ([code.uppercaseString isEqualToString:PNCurrencyTypeUSD]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 2;
    } else if ([[code uppercaseString] isEqualToString:PNCurrencyTypeCNY]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 2;
    }
    return [format stringFromNumber:[result decimalNumberByRoundingAccordingToBehavior:hander]];
}

+ (BOOL)isLeapYear:(NSInteger)year {
    if (year % 4 == 0 && year % 100 != 0) {
        return YES;
    } else if (year % 400 == 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSInteger)getDayByMonth:(NSInteger)month Year:(NSInteger)year {
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        return 31;
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        return 30;
    } else if (month == 2) {
        if ([PNCommonUtils isLeapYear:year]) {
            return 29;
        } else {
            return 28;
        }
    }
    return 0;
}

+ (BOOL)isDate:(NSString *)date withFormat:(NSString *)format {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:format];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSDate *tmp = [fmt dateFromString:date];
    if (tmp) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSDate *)getNewDateByDay:(NSInteger)day Month:(NSInteger)month Year:(NSInteger)year fromDate:(NSDate *)from {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *comps = nil;

    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:from];

    NSDateComponents *adcomps = [[NSDateComponents alloc] init];

    [adcomps setYear:year];

    [adcomps setMonth:month];

    [adcomps setDay:day];
    return [calendar dateByAddingComponents:adcomps toDate:from options:0];
}
static NSMutableDictionary *allOperatorDictionArray;

+ (NSString *)getOperatorName:(NSString *)phoneNumber {
    if (!allOperatorDictionArray) {
        allOperatorDictionArray = [self loadOperatorData];
    }
    NSString *phoneString = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *operaString = @"";
    if ([phoneString rangeOfString:@"0"].location == 0 && phoneString.length >= 3) {
        operaString = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
    } else if (phoneString.length >= 2) {
        operaString = [NSString stringWithFormat:@"0%@", [phoneString substringWithRange:NSMakeRange(0, 2)]];
    }
    if ([allOperatorDictionArray.allKeys containsObject:operaString]) {
        return allOperatorDictionArray[operaString];
    };
    return @"";
}

+ (NSMutableDictionary *)loadOperatorData {
    NSMutableDictionary *allOperatorDictionArray = [NSMutableDictionary dictionary];
    NSArray *cellcard = @[
        @"011",
        @"012",
        @"014",
        @"017",
        @"061",
        @"076",
        @"077",
        @"085",
        @"089",
        @"092",
        @"099",
        @"095",
        @"078",
    ];
    [self addOperator:cellcard name:@"Cellcard" data:allOperatorDictionArray];
    NSArray *Smart = @[
        @"010",
        @"015",
        @"016",
        @"069",
        @"070",
        @"081",
        @"086",
        @"087",
        @"093",
        @"096",
        @"098",
    ];
    [self addOperator:Smart name:@"Smart" data:allOperatorDictionArray];

    NSArray *metfone = @[
        @"088",
        @"097",
        @"071",
        @"031",
        @"060",
        @"066",
        @"067",
        @"068",
        @"090",
        @"091",
    ];
    [self addOperator:metfone name:@"Metfone" data:allOperatorDictionArray];

    NSArray *qb = @[
        @"013",
        @"080",
        @"083",
        @"084",
    ];
    [self addOperator:qb name:@"Qb" data:allOperatorDictionArray];

    NSArray *Excell = @[@"018"];
    NSArray *Cootel = @[@"038"];
    [self addOperator:Excell name:@"Seatel" data:allOperatorDictionArray];
    [self addOperator:Cootel name:@"Cootel" data:allOperatorDictionArray];

    return allOperatorDictionArray;
}

+ (void)addOperator:(NSArray *)keys name:(NSString *)name data:(NSMutableDictionary *)allOperatorDictionArray {
    for (int i = 0; i < keys.count; i++) {
        [allOperatorDictionArray setValue:name forKey:keys[i]];
    }
}

+ (NSString *)dateSecondToDate:(NSInteger)interval dateFormat:(NSString *)format {
    return [self dateSecondToDate:interval dateFormat:format dateInTodayFormat:format];
}

+ (NSString *)dateSecondToDate:(NSInteger)interval dateFormat:(NSString *)format dateInTodayFormat:(NSString *)dateInTodayFormat {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];

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
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

/// 获取账户等级名称
/// @param level 账户等级
+ (NSString *)getAccountLevelNameByCode:(PNUserLevel)level {
    NSString *name = nil;
    switch (level) {
        case PNUserLevelUnknown:
            name = PNLocalizedString(@"bank_bill_email_hint_explain", @"");
            break;
        case PNUserLevelNormal:
            name = PNLocalizedString(@"USER_LEVEL_FIRST", @"经典");
            break;
        case PNUserLevelAdvanced:
            name = PNLocalizedString(@"USER_LEVEL_SECOUND", @"高级");
            break;
        case PNUserLevelHonour:
            name = PNLocalizedString(@"USER_LEVEL_THIRD", @"尊享");
            break;
        default:
            name = PNLocalizedString(@"bank_bill_email_hint_explain", @"");
            break;
    }

    return name;
}

/// 根据code 获取对应的 升级状态名字
+ (NSString *)getUpgradeStatusNameByCode:(PNAccountLevelUpgradeStatus)status {
    NSString *name = nil;
    switch (status) {
        case PNAccountLevelUpgradeStatus_GoToUpgrade:
            name = PNLocalizedString(@"Go_to_upgrade", @"去升级");
            break;
        case PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING:
            name = PNLocalizedString(@"Under_upgrade", @"审核中");
            break;
        case PNAccountLevelUpgradeStatus_SENIOR_UPGRADING:
            name = PNLocalizedString(@"Under_upgrade", @"审核中");
            break;
        case PNAccountLevelUpgradeStatus_INTERMEDIATE_FAILED:
            name = PNLocalizedString(@"Upgrade_fail", @"审核不通过");
            break;
        case PNAccountLevelUpgradeStatus_SENIOR_FAILED:
            name = PNLocalizedString(@"Upgrade_fail", @"审核不通过");
            break;
        case PNAccountLevelUpgradeStatus_INTERMEDIATE_SUCCESS:
            name = PNLocalizedString(@"Upgrade_succeed", @"审核成功");
            break;
        case PNAccountLevelUpgradeStatus_SENIOR_SUCCESS:
            name = PNLocalizedString(@"Upgrade_succeed", @"审核成功");
            break;
        case PNAccountLevelUpgradeStatus_APPROVALFAILED:
            name = PNLocalizedString(@"Upgrade_fail", @"审核不通过");
            break;
        case PNAccountLevelUpgradeStatus_APPROVALING:
            name = PNLocalizedString(@"Under_upgrade", @"审核中");
            break;
        default:
            name = PNLocalizedString(@"bank_bill_email_hint_explain", @"");
            break;
    }

    return name;
}

/// 根据升级状态获取 对应的 文案
+ (NSString *)getAccountUpgradeStatusNameByCode:(PNAccountLevelUpgradeStatus)status {
    NSString *name = nil;
    switch (status) {
        case PNAccountLevelUpgradeStatus_GoToUpgrade:
            name = PNLocalizedString(@"Go_to_upgrade", @"去升级");
            break;
        case PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING:
            name = PNLocalizedString(@"Upgrade_Gold_ing", @"高级账户升级中");
            break;
        case PNAccountLevelUpgradeStatus_INTERMEDIATE_FAILED:
            name = PNLocalizedString(@"Upgrade_Gold_fail", @"高级账户升级失败");
            break;
        case PNAccountLevelUpgradeStatus_INTERMEDIATE_SUCCESS:
            name = PNLocalizedString(@"Upgrade_Gold_succeed", @"高级账户升级成功");
            break;
        case PNAccountLevelUpgradeStatus_SENIOR_UPGRADING:
            name = PNLocalizedString(@"Upgrade_Platinum_ing", @"尊享账户升级中");
            break;
        case PNAccountLevelUpgradeStatus_SENIOR_FAILED:
            name = PNLocalizedString(@"Upgrade_Platinum_fail", @"尊享账户升级失败");
            break;
        case PNAccountLevelUpgradeStatus_SENIOR_SUCCESS:
            name = PNLocalizedString(@"Upgrade_Platinum_succeed", @"尊享账户升级成功");
            break;
        default:
            name = @"";
            break;
    }

    return name;
}
/// 获取账户等级icon
/// @param level 账户等级
+ (NSString *)getAccountLevelIconByCode:(PNUserLevel)level {
    NSString *name = [NSString stringWithFormat:@"pn_level_%zd", level];

    return name;
}

/// 根据code 获取对应的 证件类型名字
+ (NSString *)getCardTypeNameByCode:(PNPapersType)type {
    NSString *name = nil;
    switch (type) {
        case PNPapersTypeIDCard:
            name = PNLocalizedString(@"PAPER_TYPE_IDCARD", @"身份证");
            break;
        case PNPapersTypePassport:
            name = PNLocalizedString(@"PAPER_TYPE_PASSPORT", @"护照");
            break;
        case PNPapersTypeDrivingLince:
            name = PNLocalizedString(@"PAPER_TYPE_Driving_license", @"柬埔寨驾照");
            break;
        case PNPapersTypepolice:
            name = PNLocalizedString(@"PAPER_TYPE_Police", @"警察证/公务员证");
            break;
        default:
            name = PNLocalizedString(@"bank_bill_email_hint_explain", @"");
            break;
    }

    return name;
}

/// 根据code 获取对应的 性别名字
+ (NSString *)getGenderNameByCode:(PNSexType)type {
    NSString *name = nil;
    switch (type) {
        case PNSexTypeMen:
            name = PNLocalizedString(@"male", @"男");
            break;
        case PNSexTypeWomen:
            name = PNLocalizedString(@"female", @"女");
            break;
        default:
            name = PNLocalizedString(@"bank_bill_email_hint_explain", @"");
            break;
    }

    return name;
}

/// 根据账单类型返回对应的账单icon名字
+ (NSString *)getBillPaymentIconCategoryName:(PNPaymentCategory)type {
    NSString *iconName = @"";
    switch (type) {
        case PNPaymentCategoryWater:
            iconName = @"pn_utilities_water";
            break;
        case PNPaymentCategoryElectricity:
            iconName = @"pn_utilities_electricity";
            break;
        case PNPaymentCategorySolidWaste:
            iconName = @"pn_utilities_waste";
            break;
        default:
            break;
    }
    return iconName;
}

/// 根据账单类型返回对应的名字
+ (NSString *)getBillCategoryName:(PNPaymentCategory)type {
    NSString *name = @"";
    switch (type) {
        case PNPaymentCategoryWater:
            name = PNLocalizedString(@"water", @"水费");
            break;
        case PNPaymentCategoryElectricity:
            name = PNLocalizedString(@"electricity", @"电费");
            break;
        case PNPaymentCategorySolidWaste:
            name = PNLocalizedString(@"waste", @"垃圾费");
            break;
        case PNPaymentCategoryAnimalFeed:
            name = PNLocalizedString(@"waste", @"动物饲料");
            break;
        case PNPaymentCategoryTrading:
            name = PNLocalizedString(@"waste", @"贸易");
            break;
        case PNPaymentCategoryRaalEastate:
            name = PNLocalizedString(@"waste", @"房地产");
            break;
        case PNPaymentCategoryGovernment:
            name = PNLocalizedString(@"waste", @"政府账单");
            break;
        case PNPaymentCategoryInsurance:
            name = PNLocalizedString(@"waste", @"保险账单");
            break;
        case PNPaymentCategorySchool:
            name = PNLocalizedString(@"waste", @"教育账单");
            break;
        default:
            break;
    }
    return name;
}

/// 获取缴费状态对应的文案
+ (NSString *)getBillPayStatusName:(PNBillPaytStatus)status {
    NSString *name = @"";

    switch (status) {
        case PNBillPaymentStatusInit:
            name = PNLocalizedString(@"bill_to_bo_paid", @"待缴费");
            break;
        case PNBillPaymentStatusProcessing:
            name = PNLocalizedString(@"bill_Paying", @"缴费处理中");
            break;
        case PNBillPaymentStatusConfirmIng:
            name = PNLocalizedString(@"bill_Paying_confirm", @"缴费确认中");
            break;
        case PNBillPaymentStatusConfirmSuccess:
            name = PNLocalizedString(@"bill_Paying_confirm", @"缴费确认中");
            break;
        case PNBillPaymentStatusSuccess:
            name = PNLocalizedString(@"bill_Paid", @"已缴费");
            break;
        case PNBillPaymentStatusFAIL:
            name = PNLocalizedString(@"bill_pay_fail", @"缴费失败");
            break;
        case PNBillPaymentStatusVerificationFail:
            name = PNLocalizedString(@"bill_pay_fail", @"缴费失败");
            break;
        case PNBillPaymentStatusClose:
            name = PNLocalizedString(@"closed", @"已关闭");
            break;
        default:
            break;
    }
    return name;
}

/// 获取缴费状态对应的icon - 支付结果页
+ (NSString *)getBillPayStatusResultIconName:(PNBillPaytStatus)status {
    NSString *name = @"pn_utilities_result_processing";

    switch (status) {
        case PNBillPaymentStatusProcessing:
            name = @"pn_utilities_result_processing";
            break;
        case PNBillPaymentStatusConfirmIng:
            name = @"pn_utilities_result_processing";
            break;
        case PNBillPaymentStatusSuccess:
            name = @"pn_utilities_result_success";
            break;
        default:
            break;
    }
    return name;
}

/// 获取账单详情页的状态icon
+ (NSString *)getBillOrderDetailsStattesIconName:(PNBillPaytStatus)status {
    NSString *name = @"";

    switch (status) {
        case PNBillPaymentStatusProcessing:
            name = @"pn_bill_orderDetails_paying";
            break;
        case PNBillPaymentStatusConfirmIng:
            name = @"pn_bill_orderDetails_paying";
            break;
        case PNBillPaymentStatusSuccess:
            name = @"pn_bill_orderDetails_success";
            break;
        case PNBillPaymentStatusClose:
            name = @"pn_bill_orderDetails_close";
            break;
        default:
            break;
    }
    return name;
}

/// 获取 手续费承担方的 文案
+ (NSString *)getChargeTypeName:(PNChargeType)type {
    NSString *name = @"";

    if (type == PNChargeTypeD) {
        name = PNLocalizedString(@"charge_from_customer", @"用户承担");
    } else if (type == PNChargeTypeC) {
        name = PNLocalizedString(@"charge_from_biller", @"商户承担");
    } else if (type == PNChargeTypeP) {
        name = PNLocalizedString(@"charge_from_customer_and_biller_", @"用户与商户按比例“%@”承担");
    }

    return name;
}

/*
 * [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName" : @"Disclaimer", @"navTitle" : PNLocalizedString(@"disclaimer", @"免责声明")}];
 */
/// 获取对应的连接
+ (NSString *)getURLWithName:(NSString *)typeName {
    NSString *urlStr = @"";
    if ([typeName isEqualToString:@"CoolCash"]) {
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
            urlStr = @"https://img.coolcashcam.com/CT%26C4CoolCashCPSKH.html";
        } else {
            urlStr = @"https://img.coolcashcam.com/CT%26C4CoolCashCPSEN.html";
        }
    } else if ([typeName isEqualToString:@"CoolCashOCT"]) {
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
            urlStr = @"https://img.coolcashcam.com/T%26C4OTCTransactionsKH.html";
        } else {
            urlStr = @"https://img.coolcashcam.com/T%26C4OTCTransactionsEN.html";
        }
    } else if ([typeName isEqualToString:@"Disclaimer"]) {
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
            urlStr = @"https://img.coolcashcam.com/statement_kh.html";
        } else {
            urlStr = @"https://img.coolcashcam.com/statement_en.html";
        }
    } else if ([typeName isEqualToString:@"MerchantServices"]) {
        urlStr = @"https://img.coolcashcam.com/T%26C4MerchantPaymentServiceAgreementKH.html";
    } else if ([typeName isEqualToString:@"InterTransfer"]) {
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
            urlStr = @"https://img.coolcashcam.com/T%26C4IRKH.html";
        } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
            urlStr = @"https://img.coolcashcam.com/T%26C4IRCN.html";
        } else {
            urlStr = @"https://img.coolcashcam.com/T%26C4IREN.html";
        }
    }
    return urlStr;
}

/// 根据type 获取对应的商户类型名称
+ (NSString *)getMerchantTypeName:(PNMerchantType)type {
    NSString *nameStr = @"";
    switch (type) {
        case PNMerchantTypeIndividual:
            nameStr = PNLocalizedString(@"ms_person_merchant", @"个人商户");
            break;
        case PNMerchantTypeBusiness:
            nameStr = PNLocalizedString(@"ms_business_merchant", @"企业商户");
        default:
            break;
    }
    return nameStr;
}

/// 获取商户状态名称
+ (NSString *)getMerchantStatusName:(PNMerchantStatus)type {
    NSString *nameStr = @"";

    switch (type) {
        case PNMerchantStatusFailed:
            nameStr = PNLocalizedString(@"pn_ms_rejected", @"审核拒绝");
            break;
        case PNMerchantStatusReviewing:
            nameStr = PNLocalizedString(@"pn_ms_approval_ing", @"审核中");
            break;
        case PNMerchantStatusEnable:
            nameStr = PNLocalizedString(@"ms_open_success", @"开通成功");
            break;
        default:
            break;
    }
    return nameStr;
}

/// 获取商户状态名称 - 【跟上面的国际化的描述不一样】
+ (NSString *)getMerchantStatusName2:(PNMerchantStatus)type {
    NSString *nameStr = @"";

    switch (type) {
        case PNMerchantStatusEnable:
            nameStr = PNLocalizedString(@"7XCSMD52", @"启用");
            break;
        case PNMerchantStatusDisenable:
            nameStr = PNLocalizedString(@"pn_Suspended", @"停用");
            break;
        case PNMerchantStatusToBeActivated:
            nameStr = PNLocalizedString(@"9lYJWzkk", @"待激活");
            break;
        case PNMerchantStatusOff:
            nameStr = PNLocalizedString(@"MkxZ6a35", @"退网");
            break;
        default:
            break;
    }
    return nameStr;
}

/// 国际转账 根据状态获取对应的文案
+ (NSString *)getInterTransferOrderStatus:(PNInterTransferOrderStatus)status {
    NSString *nameStr = @"";

    switch (status) {
        case PNInterTransferOrderStatusInit:
            nameStr = PNLocalizedString(@"BQv4jaKx", @"初始");
            break;
        case PNInterTransferOrderStatusPayed:
            nameStr = PNLocalizedString(@"vFID0sZ0", @"支付完成");
            break;
        case PNInterTransferOrderStatusApplyed:
            nameStr = PNLocalizedString(@"j9vrnGxS", @"已提交申请，待确认");
            break;
        case PNInterTransferOrderStatusConfirmIng:
            nameStr = PNLocalizedString(@"grghSLEm", @"转账确认中");
            break;
        case PNInterTransferOrderStatusTransferIng:
            nameStr = PNLocalizedString(@"jS7pwDTg", @"转账处理中");
            break;
        case PNInterTransferOrderStatusCanWithdraw:
            nameStr = PNLocalizedString(@"twTKE3PI", @"待收款人提款");
            break;
        case PNInterTransferOrderStatusFinish:
            nameStr = PNLocalizedString(@"db6iZMXT", @"转账成功，资金已入账");
            break;
        case PNInterTransferOrderStatusRejuect:
            nameStr = PNLocalizedString(@"X3xjBXbU", @"转账失败");
            break;
        case PNInterTransferOrderStatusCancel:
            nameStr = PNLocalizedString(@"X3xjBXbU", @"转账失败");
            break;
        case PNInterTransferOrderStatusFaild:
            nameStr = PNLocalizedString(@"SAjZlyRo", @"入账失败");
            break;
        case PNInterTransferOrderStatusRevoke:
            nameStr = PNLocalizedString(@"1qxi9sok", @"转账已撤销");
            break;
        case PNInterTransferOrderStatusABNORMAL:
            nameStr = PNLocalizedString(@"pn_abnormal", @"异常");
            break;
        default:
            break;
    }
    return nameStr;
}

/// 获取公寓缴费状态名字
+ (NSString *)getApartmentStatusName:(PNApartmentPaymentStatus)status {
    NSString *nameStr = @"";
    switch (status) {
        case PNApartmentPaymentStatus_TO_PAID:
            nameStr = PNLocalizedString(@"bill_to_bo_paid", @"待缴费");
            break;
        case PNApartmentPaymentStatus_PAID:
            nameStr = PNLocalizedString(@"bill_Paid", @"已缴费");
            break;
        case PNApartmentPaymentStatus_USER_HAS_UPLOADED_VOUCHER:
            nameStr = PNLocalizedString(@"pn_Voucher_uploaded", @"已上传凭证");
            break;
        case PNApartmentPaymentStatus_USER_REJECT:
            nameStr = PNLocalizedString(@"pn_Refused_by_customer", @"已拒绝");
            break;
        case PNApartmentPaymentStatus_CLOSED:
            nameStr = PNLocalizedString(@"order_status_close", @"已关闭");
            break;
        default:
            break;
    }
    return nameStr;
}

/// 获取红包 状态
+ (NSString *)packetStatusName:(PNPacketMessageStatus)status {
    NSString *msg = @"";
    switch (status) {
        case PNPacketMessageStatus_UNCLAIMED:
            msg = PNLocalizedString(@"pn_Not_open", @"未领取");
            break;
        case PNPacketMessageStatus_PARTIAL_RECEIVE:
            msg = PNLocalizedString(@"pn_open", @"已领取");
            break;
        case PNPacketMessageStatus_EXPIRED:
            msg = PNLocalizedString(@"pn_Expired", @"已过期");
            break;
        case PNPacketMessageStatus_NO_WAITING:
            msg = PNLocalizedString(@"pn_None_left", @"已抢完");
            break;
        default:
            break;
    }

    return msg;
}

/// 获取红包领取 状态
+ (NSString *)packetReceiveStatusName:(PNPacketReceiveStatus)status {
    NSString *msg = @"";
    switch (status) {
        case PNPacketReceiveStatus_UNCLAIMED:
            msg = PNLocalizedString(@"pn_Not_open", @"未领取");
            break;
        case PNPacketReceiveStatus_PARTIAL_RECEIVE:
            msg = PNLocalizedString(@"pn_Partial_opened", @"部分领取");
            break;
        case PNPacketReceiveStatus_RECEIVED:
            msg = PNLocalizedString(@"pn_Opened", @"已领完");
            break;
        case PNPacketReceiveStatus_PARTIAL_REFUND:
            msg = PNLocalizedString(@"pn_Partial_refunded", @"部分退款");
            break;
        case PNPacketReceiveStatus_REFUNDED:
            msg = PNLocalizedString(@"pn_refunded", @"已退款");
            break;
        default:
            break;
    }

    return msg;
}

/// 获取担保交易状态名称
+ (NSString *)getGuarateenStatusName:(PNGuarateenStatus)status {
    NSString *msg = @"";
    switch (status) {
        case PNGuarateenStatus_ALL:
            msg = PNLocalizedString(@"TRANS_TYPE_ALL", @"所有");
            break;
        case PNGuarateenStatus_UNCONFIRMED:
            msg = PNLocalizedString(@"QeZR98d0", @"待确认");
            break;
        case PNGuarateenStatus_UNPAID:
            msg = PNLocalizedString(@"WyIjQGbH", @"待付款");
            break;
        case PNGuarateenStatus_PENDING:
            msg = PNLocalizedString(@"ePHz7Mzn", @"待完成");
            break;
        case PNGuarateenStatus_COMPLETED:
            msg = PNLocalizedString(@"6qOkNbwk", @"已完成");
            break;
        case PNGuarateenStatus_CANCELED:
            msg = PNLocalizedString(@"INow7LMn", @"已取消");
            break;
        case PNGuarateenStatus_REFUND_APPLY:
            msg = PNLocalizedString(@"dqe12rcV", @"买方申请退款");
            break;
        case PNGuarateenStatus_REFUND_REJECT:
            msg = PNLocalizedString(@"XmiY47Lw", @"卖方拒绝退款");
            break;
        case PNGuarateenStatus_REFUND_APPEAL:
            msg = PNLocalizedString(@"ncB3SsuB", @"买方申述");
            break;
        case PNGuarateenStatus_APPEAL_REJECT:
            msg = PNLocalizedString(@"Gg7akkBp", @"申述驳回");
            break;
        case PNGuarateenStatus_REFUNDED:
            msg = PNLocalizedString(@"pn_refunded", @"已退款");
            break;
        case PNGuarateenStatus_REJECT:
            msg = PNLocalizedString(@"kkJWMbb2", @"已拒绝");
            break;
        default:
            break;
    }

    return msg;
}

///为url后面拼接上时间搓
+ (NSString *)urlWithTime:(NSString *)url {
    return [NSString stringWithFormat:@"%@?v=%ld", url, (long)[[NSDate date] timeIntervalSince1970]];
}

#pragma mark 获取纯数字
+ (int)getnum:(NSString *)str {
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int remainSecond = [[str stringByTrimmingCharactersInSet:nonDigits] intValue];
    return remainSecond;
}

/// 商户服务 基本信息 的商户状态
+ (NSString *)getMerchantInfoStatus:(NSInteger)status {
    /**
     10, "启用"),
     11, "停用"),
     12, "待激活"),
     13, "终止合作"
     */
    NSString *str = @"";
    switch (status) {
        case 10:
            str = PNLocalizedString(@"7XCSMD52", @"启用");
            break;
        case 11:
            str = PNLocalizedString(@"pn_Suspended", @"停用");
            break;
        case 12:
            str = PNLocalizedString(@"9lYJWzkk", @"待激活");
            break;
        case 13:
            str = PNLocalizedString(@"POStv3XK", @"终止合作");
            break;

        default:
            break;
    }

    return str;
}

/// 根据类型获取公告
+ (NSString *)getNotifiView:(PNWalletListItemType)type {
    NSString *value = @"";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [def objectForKey:kPNAllNotice];
    NSString *key = [NSString stringWithFormat:@"%zd", type];
    if ([dict.allKeys containsObject:key]) {
        NSDictionary *itemDict = [dict objectForKey:key];
        value = [itemDict objectForKey:@"noticeText"];
    }

    HDLog(@"通知查询： %@ - %@", key, value);
    return value;
}

/// 返回钱包明细筛选的枚举名称
+ (NSString *)getWalletOrderListFilterTypeName:(PNWalletListFilterType)type {
    NSString *str = @"";
    if ([type isEqualToString:PNWalletListFilterType_All]) {
        str = PNLocalizedString(@"TRANS_TYPE_ALL", @"所有");
    } else if ([type isEqualToString:PNWalletListFilterType_Consumption]) {
        str = PNLocalizedString(@"consumption", @"消费");
    } else if ([type isEqualToString:PNWalletListFilterType_Recharge]) {
        str = PNLocalizedString(@"AkFAEFeW", @"充值");
    } else if ([type isEqualToString:PNWalletListFilterType_Withdrawal]) {
        str = PNLocalizedString(@"pn_Withdraw", @"提现");
    } else if ([type isEqualToString:PNWalletListFilterType_Transfer]) {
        str = PNLocalizedString(@"TRANS_TYPE_TRANSFER", @"转账");
    } else if ([type isEqualToString:PNWalletListFilterType_Exchange]) {
        str = PNLocalizedString(@"mMoic5PX", @"汇兑");
    } else if ([type isEqualToString:PNWalletListFilterType_Settlement]) {
        str = PNLocalizedString(@"fjECY0JS", @"结算");
    } else if ([type isEqualToString:PNWalletListFilterType_Entry_Adjustment]) {
        str = PNLocalizedString(@"3YEl63zX", @"分录调帐");
    } else if ([type isEqualToString:PNWalletListFilterType_Self_Adjustment]) {
        str = PNLocalizedString(@"SFLSCZk7", @"自主调帐");
    } else if ([type isEqualToString:PNWalletListFilterType_Refund]) {
        str = PNLocalizedString(@"TRANS_TYPE_REFUND", @"退款");
    } else if ([type isEqualToString:PNWalletListFilterType_Marketing]) {
        str = PNLocalizedString(@"mttjUMbV", @"营销");
    } else if ([type isEqualToString:PNWalletListFilterType_Credit]) {
        str = PNLocalizedString(@"wbxdUAaR", @"贷款");
    }
    return str;
}
@end
