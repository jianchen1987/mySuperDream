//
//  SAAppSwitchManager.h
//  SuperApp
//
//  Created by seeu on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SAAppSwitchName NS_STRING_ENUM;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchThirdPartLogin;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchPaymentChannelList;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchWechatLogin;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchUploadContacts;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchCmsBlackList;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchBackUpLines;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchAutoSwitchLine;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchDataRecord;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchCMSPageMapping;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchTabBarMapping;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchHelloPlatform; ///< 传声筒开关
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchWOWNOWPayAgainTip1;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchWOWNOWPayAgainTip2;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchWOWNOWPayAgainTip3;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchAccountCancellation;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchThirdPartyBindPhone; ///< 三方登陆是否需要绑定手机号
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchHttpDns;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchCouponFilterOption;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchVoiceVerification;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchVoiceVerificationSupportChineseMobilePhone;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchToNewLoginPage;
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchStandardEventPoolSize; ///< 标准事件池大小
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchOtherEventPoolSize;    ///< 其他事件池大小
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchIMProvider;            ///< im开关
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchDataPushInterval;      ///< 定时上送的间隔
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchAppGuidePage;          ///< app引导页
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchIMVoiceCall;           ///< 语音通话开关
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchAppCallKitLocation;    ///< 开启callkit定位判断 ，默认关闭
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchPasteboardRead;        ///< 打开粘贴板读取
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchOrderListFilterOption; ///< order筛选类型
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchIMFeedBackOption;      ///< im反馈选项
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchABAPayLoadingTime;     ///< aba支付轮询时间
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchBizUrlMapping;         ///< 网站业务线映射表
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchYDOpenSwitch;          ///< 易盾新老开关
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchNewNetworkCryptModel;  ///< 新版鉴权
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchNewLoginPage;          ///< 新版登录页面开关
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchNewLoginPageBindPhone; ///< 新版登录页面绑定手机开关
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchOpenAppUpdateUserInfo; ///< 刷新用户信息开关
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchNewWMPage;             ///< 新版外卖
FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchLoginSkipSetPassword;  ///< 登录注册跳过设置密码步骤

FOUNDATION_EXPORT SAAppSwitchName const SAAppSwitchAddressRegex; ///< 收货地址输入正则


@interface SAAppSwitchManager : NSObject

+ (SAAppSwitchManager *)shared;

// 只支持字符串的类型
- (NSString *_Nullable)switchForKey:(SAAppSwitchName)switchName;
@end

NS_ASSUME_NONNULL_END
