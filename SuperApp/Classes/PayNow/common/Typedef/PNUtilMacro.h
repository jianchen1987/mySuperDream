//
//  PNUtilMacro.h
//  National Wallet
//
//  Created by 陈剑 on 2018/4/25.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "HDLog.h"
#import "PNCommonUtils.h"
#import <Foundation/Foundation.h>

#ifndef PNUtilMacro_h
#define PNUtilMacro_h

// 强弱引用
#define kWeakObj(type) __weak typeof(type) weak_##type = type
#define kStrongObj(type) __strong typeof(type) type = weak##type

//#ifdef DEBUG
//
//#define IS_DEBUG YES
////#define HDLog(...) [[HDLogger sharedInstance] printLogWithFile:__FILE__ line:__LINE__ func:__FUNCTION__ logItem:[HDLogItem logItemWithLevel:HDLogLevelDefault name:@"ViPay" logString:__VA_ARGS__]]
//
//#else
//
//#define IS_DEBUG NO
//#define HDLog(...) ;
//
//#endif

typedef void (^_Nullable NetworkSuccess)(id _Nullable rspObject);

typedef void (^_Nullable NetworkFailure)(NSError *_Nullable error);

// common define

#define COUNTDOWN_SEC 60

#define RSP_SUCCESS_CODE @"00000"

#define LANGUAGE_ENGLISH @"en-US"
#define LANGUAGE_CHINESE @"zh-CN"
#define LANGUAGE_KHR @"km-KH"

// 是否为空对象
#define WJIsObjectNil(__object) ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define WJIsStringEmpty(__string) ((__string.length == 0) || WJIsObjectNil(__string))

// 字符串不为空
#define WJIsStringNotEmpty(__string) (!WJIsStringEmpty(__string))

// 数组为空
#define WJIsArrayEmpty(__array) ((WJIsObjectNil(__array)) || (__array.count == 0))

// Block
typedef void (^VoidBlock)(void);
typedef void (^StringBlock)(NSString *__nullable string);

#define REGEX_NUMBER_ONLY @"^[0-9]{0,20}$"
#define REGEX_NUMBER_CHAR @"^[0-9a-zA-Z]{0,20}$"
#define REGEX_CHAR_ONLY @"^[a-zA-Z]{0,20}$"
#define REGEX_AMOUNT @"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,9}(([.]\\d{0,2})?)))?"
#define REGEX_AMOUNT_INT @"([0]|([1-9]\\d{0,9}))?"
#define REGEX_LOGIN_PWD @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"
#define REGEX_PHONE_NUM @"^[0-9]{8,11}$"
#define REGEX_ALL_PHONE_NUM @"^[0-9]{11,14}$"
#define REGEX_ID_NUMBER @"^[0-9]{9}$"
#define REGEX_NAME @"^[a-zA-Z\\s]{0,20}$"
#define REGEX_SMS_CODE @"^[0-9]{0,6}$"
#define REGEX_EMAIL_FORMAT @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,9}"

#define REGEX_ORDERLY @"(?:(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}|(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){5})\\d"

#define REGEX_REPEAT @"([\\d])\\1{5,}"

#define GOTO_RESULT_CODE                                                                                                                                                                          \
    @"R2000,R2001,R2002,R2003,R2004,R2005,R2006,R2007,R2008,R2009,R2010,R2011,R2012,R2016,R2017,R2018,R2019,R2020,C0015,T0003,T0004,T0005,T0006,T0007,T0017,T0019,T0029,T0011,T0012,T0013,T0014," \
    @"T0008,T0021,T1010,T1011,T1012,T1013,R2031,R2032,R2033,R2034,R2035"

#define registerProcotolNum @"1029933607356989440"
#define certProcotolNum @"1029933676802080768"

#define PN_Default_Photo_URL @"https://img.coolcashcam.com/kyc/id_tpl.jpg"

#define kIR_Help [PNCommonUtils urlWithTime:@"https://img.coolcashcam.com/ir/index.html#/ProblemSolving"]
#define kIR_Introduction [PNCommonUtils urlWithTime:@"https://img.coolcashcam.com/ir/index.html#/ProductIntroduction"]
#define kIR_Materials [PNCommonUtils urlWithTime:@"https://img.coolcashcam.com/ir/index.html#/materialsPDF"]
#define kAlipay_url_1 @"https://ur.alipay.com/5UsVNJ8RZJEouhD8LLKnwD"
#define kAlipay_url_2 @"https://ur.alipay.com/7sdI9LsOy1UgoIlIkWT0Jv"
#define kAlipay_url_3 @"https://ur.alipay.com/5yWGJh3ilttn2R4EIqEQnc"
#define kAlipay_url_4 @"https://ur.alipay.com/2OT42AwAcGIn4vDUAROG6x"

#define kWeChat_url_1 [PNCommonUtils urlWithTime:@"https://img.coolcashcam.com/ir/index.html#/WeChat"]

/// 红包规则
#define kPacket_rule [PNCommonUtils urlWithTime:@"https://img.coolcashcam.com/publishv/index.html#/red-packet/packet-rule"]

/// 抢红包
#define kPacket_share_tg @"https://img.coolcashcam.com/publishv/index.html#/red-packet/receive-packet"

/// 担保交易协议
#define kGuarateen_url [PNCommonUtils urlWithTime:@"https://img.coolcashcam.com/publishv/index.html#/secured-txn/protocol"]

#define kPNAllNotice @"pn_notice"

#endif /* PNUtilMacro_h */
