//
//  SAAppSwitchManager.m
//  SuperApp
//
//  Created by seeu on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import "SACommonConst.h"
#import <FirebaseRemoteConfig/FirebaseRemoteConfig.h>
#import <HDKitCore/HDKitCore.h>

SAAppSwitchName const SAAppSwitchThirdPartLogin = @"third_part_login";       ///< 三方登陆开关
SAAppSwitchName const SAAppSwitchPaymentChannelList = @"pay_method_list";    ///< 支付渠道列表
SAAppSwitchName const SAAppSwitchWechatLogin = @"wechat_login";              ///< 微信登陆开关
SAAppSwitchName const SAAppSwitchUploadContacts = @"upload_contacts_switch"; ///< 上传联系人开关
SAAppSwitchName const SAAppSwitchCmsBlackList = @"cms_black_list";           ///< cms黑名单
SAAppSwitchName const SAAppSwitchBackUpLines = @"product_backup_lines";
SAAppSwitchName const SAAppSwitchAutoSwitchLine = @"auto_switch_line"; ///< 自动切换线路
SAAppSwitchName const SAAppSwitchDataRecord = @"LKDataSwitch";
SAAppSwitchName const SAAppSwitchCMSPageMapping = @"cms_page_mapping";
SAAppSwitchName const SAAppSwitchTabBarMapping = @"iOS_tabbar_controller_mapping";          ///< tabbar 控制器映射
SAAppSwitchName const SAAppSwitchHelloPlatform = @"Hello_WebSocket_Switch";                 ///< 传声筒开关
SAAppSwitchName const SAAppSwitchWOWNOWPayAgainTip1 = @"wownow_pay_again_tip1";             //收银台中间提示文言1，如果已输入密码并确认付款，请耐心等待支付结果
SAAppSwitchName const SAAppSwitchWOWNOWPayAgainTip2 = @"wownow_pay_again_tip2";             //收银台中间提示文言2，如果误操作，还没有确认付款，请重新支付
SAAppSwitchName const SAAppSwitchWOWNOWPayAgainTip3 = @"wownow_pay_again_tip3";             //收银台中间提示文言3，该笔订单发生多次支付请求，限制重新支付
SAAppSwitchName const SAAppSwitchAccountCancellation = @"wownow_unregister_switch";         ///< 注销账号开关
SAAppSwitchName const SAAppSwitchThirdPartyBindPhone = @"thirdParty_Register_BindPhoneNum"; ///< 三方登陆是否绑定手机号
SAAppSwitchName const SAAppSwitchHttpDns = @"httpDNS_switch";                               /// HTTPDNS开关
SAAppSwitchName const SAAppSwitchCouponFilterOption = @"coupon_filter_option";              ///优惠券筛选
SAAppSwitchName const SAAppSwitchVoiceVerification = @"voiceVerification_switch";           ///语音验证码开关
SAAppSwitchName const SAAppSwitchVoiceVerificationSupportChineseMobilePhone = @"voiceVerificationSupportChineseMobilePhone_switch"; //是否支持86开头号码
SAAppSwitchName const SAAppSwitchStandardEventPoolSize = @"statistics_normal_max_size";
SAAppSwitchName const SAAppSwitchOtherEventPoolSize = @"statistics_other_max_size";
SAAppSwitchName const SAAppSwitchIMProvider = @"im_provider_switch";
SAAppSwitchName const SAAppSwitchDataPushInterval = @"LKDataPushInterval";
SAAppSwitchName const SAAppSwitchAppGuidePage = @"app_guide_page";
SAAppSwitchName const SAAppSwitchIMVoiceCall = @"im_voice_switch";
SAAppSwitchName const SAAppSwitchAppCallKitLocation = @"ios_callkit_location_switch";
SAAppSwitchName const SAAppSwitchPasteboardRead = @"ios_pasteboard_read";
SAAppSwitchName const SAAppSwitchOrderListFilterOption = @"orderList_filter_option"; ///< order筛选类型
SAAppSwitchName const SAAppSwitchIMFeedBackOption = @"im_feedBack_options";
SAAppSwitchName const SAAppSwitchABAPayLoadingTime = @"aba_pay_loadingTime"; ///< aba支付轮询时间
SAAppSwitchName const SAAppSwitchBizUrlMapping = @"bizLine_Url_Mapping";
SAAppSwitchName const SAAppSwitchYDOpenSwitch = @"YD_Open_Switch";
SAAppSwitchName const SAAppSwitchNewNetworkCryptModel = @"network_encrypt_update_switch";
SAAppSwitchName const SAAppSwitchNewLoginPage = @"switchToNewLoginPageV2";
SAAppSwitchName const SAAppSwitchNewLoginPageBindPhone = @"switchToNewLoginPageBindPhone";
SAAppSwitchName const SAAppSwitchOpenAppUpdateUserInfo = @"open_app_update_user_info"; ///< 刷新用户信息开关
SAAppSwitchName const SAAppSwitchNewWMPage = @"switchToNewWMHomePage";
SAAppSwitchName const SAAppSwitchLoginSkipSetPassword = @"login_skip_set_password";

SAAppSwitchName const SAAppSwitchAddressRegex = @"address_regex";

static SAAppSwitchManager *_appSwitchInstance;


@interface SAAppSwitchManager ()
/// 远程配置
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;
@end


@implementation SAAppSwitchManager

+ (SAAppSwitchManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appSwitchInstance = [[SAAppSwitchManager alloc] init];
    });
    return _appSwitchInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.remoteConfig = [FIRRemoteConfig remoteConfig];
        FIRRemoteConfigSettings *remoteConfigSettings = nil;
#if EnableDebug
        remoteConfigSettings = [[FIRRemoteConfigSettings alloc] init];
        remoteConfigSettings.minimumFetchInterval = 300.0f;
        remoteConfigSettings.fetchTimeout = 10.0f;
#else
        remoteConfigSettings = [[FIRRemoteConfigSettings alloc] init];
        remoteConfigSettings.minimumFetchInterval = 600.0f;
        remoteConfigSettings.fetchTimeout = 10.0f;
#endif

        self.remoteConfig.configSettings = remoteConfigSettings;

        [self setDefaultValues];
    }

    return self;
}

- (void)setDefaultValues {
#if EnableDebug
    [self.remoteConfig setDefaults:@{
        SAAppSwitchYDOpenSwitch: @"on",
        SAAppSwitchThirdPartLogin: @"on",
        SAAppSwitchPaymentChannelList: @"[\"ic_channel_wechat\",\"ic_channel_wallet\",\"ic_channel_aba\",\"ic_channel_visa\",\"ic_channel_master\",\"ic_channel_union\",\"ic_channel_wing\"]",
        SAAppSwitchWechatLogin: @"on",
        SAAppSwitchUploadContacts: @"on",
        SAAppSwitchCmsBlackList: @"[]",
        SAAppSwitchDataRecord: @"on",
        SAAppSwitchTabBarMapping: @"{\"SANewHomeViewController\":\"WNHomeViewController\",\"SAMessageCenterViewController\":\"SANewMessageCenterViewController\"}",
        SAAppSwitchWOWNOWPayAgainTip1:
            @"{\"en-US\": \"If you have entered the password and confirmed the payment, please wait patiently for the payment result and do not make repeated payments.  If you have paid twice, we "
            @"will refund you the same way within 3 days.\",\"km-KH\": \"ប្រសិនបើអ្នកបានបញ្ចូលពាក្យសម្ងាត់ និងបញ្ជាក់ការទូទាត់ សូមរង់ចាំដោយអត់ធ្មត់សម្រាប់លទ្ធផលការទូទាត់ ហើយកុំធ្វើការទូទាត់ម្តងទៀត។  ប្រសិនបើអ្នកបានទូទាត់ប្រាក់ពីរដង "
            @"ទឹកប្រាក់ប្រាក់នឹងបង្វិលសងតាមប្រព័ន្ធដដែល ក្នុងរយៈពេល 3 ថ្ងៃ។\",\"zh-CN\": \"如果你已输入密码并确认付款，请耐心等待支付结果，不要重复支付。如果你已重复支付，我们会在3天内原路退款给你\"}",
        SAAppSwitchWOWNOWPayAgainTip2: @"{\"en-US\": \"If you make a mistake and have not entered the password and confirmed the payment, please pay again.\",\"km-KH\": \"ប្រសិនបើអ្នកមានកំហុស "
                                       @"មិនបានបញ្ចូលពាក្យសម្ងាត់ និងបញ្ជាក់ការទូទាត់ទេ សូមទូទាត់ម្តងទៀត៕\",\"zh-CN\": \"如果误操作，还没有输入密码并确认付款，请重新支付\"}",
        SAAppSwitchWOWNOWPayAgainTip3: @"{\"en-US\": \"Multiple payment requests happen for this Order, Repayment is restricted.\",\"km-KH\": \"សំណើទូទាត់ប្រាក់បានកើតឡើងច្រើនដងសម្រាប់ការកម្ម៉ង់ "
                                       @"ការទូទាត់ប្រាក់ត្រូវបានរឹតបន្តឹង។\",\"zh-CN\": \"该笔订单发生多次支付请求，限制重新支付\"}",
        SAAppSwitchThirdPartyBindPhone: @"on",
        SAAppSwitchAccountCancellation: @"on",
        SAAppSwitchHttpDns: @"off",
        SAAppSwitchCouponFilterOption:
            @"{\"availableRange\":{\"title\":{\"en-US\":\"Available "
            @"Range\",\"km-KH\":\"រើសម្រាប់\",\"zh-CN\":\"可用范围\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"businessLine\":\"ALL\"},{"
            @"\"name\":{\"en-US\":\"Food "
            @"Delivery\",\"km-KH\":\"កម្ម៉ង់អាហារ​\",\"zh-CN\":\"外卖\"},\"isSelected\":0,\"businessLine\":\"YumNow\"},{\"name\":{\"en-US\":\"Online "
            @"Shopping\",\"km-KH\":\"ទំនិញអនឡាញ\",\"zh-CN\":\"电商​\"},\"isSelected\":0,\"businessLine\":\"TinhNow\"},{\"name\":{\"en-US\":\"Top-Up\",\"km-KH\":"
            @"\"បញ្ចូលលុយទូរស័ព្ទ\","
            @"\"zh-"
            @"CN\":"
            @"\"话费充值\"}"
            @",\"isSelected\":0,\"businessLine\":\"PhoneTopUp\"},{\"name\":{\"en-US\":\"Hotel\",\"km-KH\":\"សណ្ឋាគារ\",\"zh-CN\":\"酒店\"},\"isSelected\":0,\"businessLine\":\"HotelChannel\"},{"
            @"\"name\":{\"en-US\":\"Game\",\"km-KH\":\"ហ្គេម\",\"zh-CN\":\"游戏\"},\"isSelected\":0,\"businessLine\":\"GameChannel\"},{\"name\":{\"en-US\":\"Local Service\",\"km-KH\":\"Local "
            @"Service\",\"zh-CN\":\"团购\"},\"isSelected\":0,\"businessLine\":\"GroupBuy\"},{\"name\":{\"en-US\":\"Air"
            @"ticket\",\"km-KH\":\"សំបុត្រយន្តហោះ\",\"zh-CN\":\"机票\"},\"isSelected\":0,\"businessLine\":\"OTA\"},{\"name\":{\"en-US\":\"Travel\",\"km-KH\":\"ត្រាវែល\",\"zh-CN\":\"旅游\"},\"isSelected\":"
            @"0,\"businessLine\":\"Travel\"}]},\"couponType\":{\"title\":{\"en-US\":\"Coupon "
            @"Type\",\"km-KH\":\"ប្រភេទគូប៉ុង\",\"zh-CN\":\"券类别\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"sceneType\":9},{\"name\":{\"en-"
            @"US\":\"APP Coupon\",\"km-KH\":\"គូប៉ុងApp\",\"zh-CN\":\"平台券\"},\"isSelected\":0,\"sceneType\":10},{\"name\":{\"en-US\":\"Store "
            @"Coupon\",\"km-KH\":\"គូប៉ុងហាង\",\"zh-CN\":\"门店券\"},\"isSelected\":0,\"sceneType\":11}]},\"sort\":{\"title\":{\"en-US\":\"Sort\",\"km-KH\":\"តម្រៀប\",\"zh-CN\":\"排序\"},\"option\":[{"
            @"\"name\":{\"en-US\":\"Default\",\"km-KH\":\"លំនាំដើម\",\"zh-CN\":\"默认\"},\"isSelected\":1,\"orderBy\":10},{\"name\":{\"en-US\":\"New "
            @"Arrival\",\"km-KH\":\"មកដល់ថ្មី\",\"zh-CN\":\"新到\"},\"isSelected\":0,\"orderBy\":11},{\"name\":{\"en-US\":\"Expire "
            @"Soon\",\"km-KH\":\"ជិតផុតកំណត់​\",\"zh-CN\":\"快过期\"},\"isSelected\":0,\"orderBy\":12},{\"name\":{\"en-US\":\"Amount Large To "
            @"Small\",\"km-KH\":\"ទឹកប្រាក់​ធំទៅតូច\",\"zh-CN\":\"面额由大到小\"},\"isSelected\":0,\"orderBy\":13},{\"name\":{\"en-US\":\"Amount Small To "
            @"Large\",\"km-KH\":\"ទឹកប្រាក់​តូចទៅធំ\",\"zh-CN\":\"面额由小到大​\"},\"isSelected\":0,\"orderBy\":14}]}}",
        SAAppSwitchVoiceVerification: @"on",
        SAAppSwitchVoiceVerificationSupportChineseMobilePhone: @"off",
        SAAppSwitchOtherEventPoolSize: @(200),
        SAAppSwitchStandardEventPoolSize: @(200),
        SAAppSwitchIMProvider: @"on",
        SAAppSwitchDataPushInterval: @(15),
        SAAppSwitchAppGuidePage: @"on",
        SAAppSwitchIMVoiceCall: @"on",
        SAAppSwitchAppCallKitLocation: @"off",
        SAAppSwitchPasteboardRead: @"on",
        SAAppSwitchOrderListFilterOption:
            @"{\"businessLine\":{\"title\":{\"en-US\":\"Filter by "
            @"service\",\"km-KH\":\"តម្រងតាមសេវាកម្ម\",\"zh-CN\":\"按服务筛选\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"businessLine\":"
            @"\"SuperApp\"},{\"name\":{\"en-US\":\"Food "
            @"Delivery\",\"km-KH\":\"កម្ម៉ង់អាហារ​\",\"zh-CN\":\"外卖\"},\"isSelected\":0,\"businessLine\":\"YumNow\"},{\"name\":{\"en-US\":\"Online "
            @"Shopping\",\"km-KH\":\"ទំនិញអនឡាញ\",\"zh-CN\":\"电商​\"},\"isSelected\":0,\"businessLine\":\"TinhNow\"},{\"name\":{\"en-US\":\"Hotel\",\"km-KH\":"
            @"\"សណ្ឋាគារ\","
            @"\"zh-"
            @"CN\":"
            @"\"酒店\"}"
            @","
            @"\"isSelected\":0,\"businessLine\":\"HotelChannel\"},{\"name\":{\"en-US\":\"Air "
            @"ticket\",\"km-KH\":\"សំបុត្រយន្តហោះ\",\"zh-CN\":\"机票\"},\"isSelected\":0,\"businessLine\":\"OTA\"},{\"name\":{\"en-US\":\"Game\",\"km-KH\":\"ហ្គេម\",\"zh-CN\":\"游戏\"},\"isSelected\":0,"
            @"\"businessLine\":\"GameChannel\"},{\"name\":{\"en-US\":\"Local Service\",\"km-KH\":\"Local "
            @"Service\",\"zh-CN\":\"本地生活\"},\"isSelected\":0,\"businessLine\":\"GroupBuy\"},{\"name\":{\"en-US\":\"Top-Up\",\"km-KH\":\"បញ្ចូលលុយទូរស័ព្ទ\",\"zh-CN\":\"话费充值\"},\"isSelected\":0,"
            @"\"businessLine\":\"PhoneTopUp\"},{\"name\":{\"en-US\":\"Bill "
            @"payment\",\"km-KH\":\"ទូទាត់វិក្កយបត្រ\",\"zh-CN\":\"账单缴费\"},\"isSelected\":0,\"businessLine\":\"BillPayment\"},{\"name\":{\"en-US\":\"Member\",\"km-KH\":\"សមាជិក\",\"zh-CN\":\"会员\"},"
            @"\"isSelected\":0,\"businessLine\":\"MemberCentre\"},{\"name\":{\"en-US\":\"Travel\",\"km-KH\":\"ត្រាវែល\",\"zh-CN\":\"旅游\"},"
            @"\"isSelected\":0,\"businessLine\":\"Travel\"}]},\"timeRange\":{\"title\":{\"en-US\":\"Filter by "
            @"time\",\"km-KH\":\"តម្រងតាមពេលវេលា\",\"zh-CN\":\"按时间筛选\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"timeRange\":\"0\"},{"
            @"\"name\":{\"en-US\":\"1 month\",\"km-KH\":\"1 ខែចុងក្រោយ\",\"zh-CN\":\"近1个月\"},\"isSelected\":0,\"timeRange\":\"30\"},{\"name\":{\"en-US\":\"3 months\",\"km-KH\":\"3 "
            @"ខែចុងក្រោយ\",\"zh-CN\":\"近3个月\"},\"isSelected\":0,\"timeRange\":\"90\"}]}}",
        SAAppSwitchIMFeedBackOption: @"[{\"name\":{\"en-US\":\"Service "
                                     @"Quality\",\"km-KH\":\"គុណភាពសេវាកម្ម\",\"zh-CN\":\"服务质量\"},\"isSelected\":0,\"feedbackType\":\"service_quality\"},{\"name\":{\"en-US\":\"Harassment\",\"km-"
                                     @"KH\":\"ការបៀតបៀន\",\"zh-CN\":\"骚扰干扰\"},\"isSelected\":0,\"feedbackType\":\"disturbance\"},{\"name\":{\"en-US\":\"false "
                                     @"content\",\"km-KH\":\"ខ្លឹមសារមិនពិត\",\"zh-CN\":\"内容不实\"},\"isSelected\":0,\"feedbackType\":\"false_content\"},{\"name\":{\"en-US\":\"Low quality "
                                     @"goods\",\"km-KH\":\"ទំនិញគុណភាពទាប\",\"zh-CN\":\"劣质商品\"},\"isSelected\":0,\"feedbackType\":\"inferior_goods\"},{\"name\":{\"en-US\":\"Other\",\"km-KH\":"
                                     @"\"សេងទៀត\",\"zh-CN\":\"其他\"},\"isSelected\":0,\"feedbackType\":\"other\"}]",
        SAAppSwitchABAPayLoadingTime: @(10),
        SAAppSwitchNewLoginPage: @"on",
        SAAppSwitchNewLoginPageBindPhone: @"off",
        SAAppSwitchNewNetworkCryptModel: @"on",
        SAAppSwitchOpenAppUpdateUserInfo: @"on",
        SAAppSwitchNewWMPage: @"on",
        SAAppSwitchLoginSkipSetPassword: @"on",
    }];
#else
    [self.remoteConfig setDefaults:@{
        SAAppSwitchYDOpenSwitch: @"on",
        SAAppSwitchThirdPartLogin: @"off",
        SAAppSwitchPaymentChannelList: @"[\"ic_channel_wechat\",\"ic_channel_wallet\"]",
        SAAppSwitchWechatLogin: @"off",
        SAAppSwitchUploadContacts: @"off",
        SAAppSwitchCmsBlackList:
            @"[\"航空游戏_中_航空游戏3.0\",\"航空游戏_英_航空游戏3.0\",\"航空游戏_柬_航空游戏3.0\",\"航空会员_柬_积分乐园3.0\",\"航空会员_英_积分乐园3.0\",\"航空会员_中_积分乐园3.0\",\"航空游戏_中_"
            @"航空游戏\",\"航空游戏_英_航空游戏\",\"航空游戏_柬_航空游戏\",\"航空会员_会员3.0\",\"会员中心\",\"会员_中_会员\",\"会员_英_会员\",\"会员_柬_会员\",\"品牌_中_智小象AI\",\"品牌_英_"
            @"智小象AI\",\"品牌_柬_智小象AI\",\"品牌_中_智小象\",\"智小象AI\",\"品牌-中-智小象AI\",\"航空游戏_航空游戏3.0\",\"会员\",\"会员中心\"]",
        SAAppSwitchTabBarMapping: @"{\"SANewHomeViewController\":\"WNHomeViewController\",\"SAMessageCenterViewController\":\"SANewMessageCenterViewController\"}",
        SAAppSwitchWOWNOWPayAgainTip1:
            @"{\"en-US\": \"If you have entered the password and confirmed the payment, please wait patiently for the payment result and do not make repeated payments.  If you have paid twice, we "
            @"will refund you the same way within 3 days.\",\"km-KH\": \"ប្រសិនបើអ្នកបានបញ្ចូលពាក្យសម្ងាត់ និងបញ្ជាក់ការទូទាត់ សូមរង់ចាំដោយអត់ធ្មត់សម្រាប់លទ្ធផលការទូទាត់ ហើយកុំធ្វើការទូទាត់ម្តងទៀត។  ប្រសិនបើអ្នកបានទូទាត់ប្រាក់ពីរដង "
            @"ទឹកប្រាក់ប្រាក់នឹងបង្វិលសងតាមប្រព័ន្ធដដែល ក្នុងរយៈពេល 3 ថ្ងៃ។\",\"zh-CN\": \"如果你已输入密码并确认付款，请耐心等待支付结果，不要重复支付。如果你已重复支付，我们会在3天内原路退款给你\"}",
        SAAppSwitchWOWNOWPayAgainTip2: @"{\"en-US\": \"If you make a mistake and have not entered the password and confirmed the payment, please pay again.\",\"km-KH\": \"ប្រសិនបើអ្នកមានកំហុស "
                                       @"មិនបានបញ្ចូលពាក្យសម្ងាត់ និងបញ្ជាក់ការទូទាត់ទេ សូមទូទាត់ម្តងទៀត៕\",\"zh-CN\": \"如果误操作，还没有输入密码并确认付款，请重新支付\"}",
        SAAppSwitchWOWNOWPayAgainTip3: @"{\"en-US\": \"Multiple payment requests happen for this Order, Repayment is restricted.\",\"km-KH\": \"សំណើទូទាត់ប្រាក់បានកើតឡើងច្រើនដងសម្រាប់ការកម្ម៉ង់ "
                                       @"ការទូទាត់ប្រាក់ត្រូវបានរឹតបន្តឹង។\",\"zh-CN\": \"该笔订单发生多次支付请求，限制重新支付\"}",
        SAAppSwitchThirdPartyBindPhone: @"on",
        SAAppSwitchAccountCancellation: @"on",
        SAAppSwitchHttpDns: @"off",
        SAAppSwitchCouponFilterOption:
            @"{\"availableRange\":{\"title\":{\"en-US\":\"Available "
            @"Range\",\"km-KH\":\"រើសម្រាប់\",\"zh-CN\":\"可用范围\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"businessLine\":\"ALL\"},{"
            @"\"name\":{\"en-US\":\"Food "
            @"Delivery\",\"km-KH\":\"កម្ម៉ង់អាហារ​\",\"zh-CN\":\"外卖\"},\"isSelected\":0,\"businessLine\":\"YumNow\"},{\"name\":{\"en-US\":\"Online "
            @"Shopping\",\"km-KH\":\"ទំនិញអនឡាញ\",\"zh-CN\":\"电商​\"},\"isSelected\":0,\"businessLine\":\"TinhNow\"},{\"name\":{\"en-US\":\"Top-Up\",\"km-KH\":"
            @"\"បញ្ចូលលុយទូរស័ព្ទ\","
            @"\"zh-"
            @"CN\":"
            @"\"话费充值\"}"
            @",\"isSelected\":0,\"businessLine\":\"PhoneTopUp\"},{\"name\":{\"en-US\":\"Hotel\",\"km-KH\":\"សណ្ឋាគារ\",\"zh-CN\":\"酒店\"},\"isSelected\":0,\"businessLine\":\"HotelChannel\"},{"
            @"\"name\":{\"en-US\":\"Game\",\"km-KH\":\"ហ្គេម\",\"zh-CN\":\"游戏\"},\"isSelected\":0,\"businessLine\":\"GameChannel\"},{\"name\":{\"en-US\":\"Local Service\",\"km-KH\":\"Local "
            @"Service\",\"zh-CN\":\"团购\"},\"isSelected\":0,\"businessLine\":\"GroupBuy\"},{\"name\":{\"en-US\":\"Air "
            @"ticket\",\"km-KH\":\"សំបុត្រយន្តហោះ\",\"zh-CN\":\"机票\"},\"isSelected\":0,\"businessLine\":\"OTA\"},{\"name\":{\"en-US\":\"Travel\",\"km-KH\":\"ត្រាវែល\",\"zh-CN\":\"旅游\"},\"isSelected\":"
            @"0,\"businessLine\":\"Travel\"}]},\"couponType\":{\"title\":{\"en-US\":\"Coupon "
            @"Type\",\"km-KH\":\"ប្រភេទគូប៉ុង\",\"zh-CN\":\"券类别\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"sceneType\":9},{\"name\":{\"en-"
            @"US\":\"APP Coupon\",\"km-KH\":\"គូប៉ុងApp\",\"zh-CN\":\"平台券\"},\"isSelected\":0,\"sceneType\":10},{\"name\":{\"en-US\":\"Store "
            @"Coupon\",\"km-KH\":\"គូប៉ុងហាង\",\"zh-CN\":\"门店券\"},\"isSelected\":0,\"sceneType\":11}]},\"sort\":{\"title\":{\"en-US\":\"Sort\",\"km-KH\":\"តម្រៀប\",\"zh-CN\":\"排序\"},\"option\":[{"
            @"\"name\":{\"en-US\":\"Default\",\"km-KH\":\"លំនាំដើម\",\"zh-CN\":\"默认\"},\"isSelected\":1,\"orderBy\":10},{\"name\":{\"en-US\":\"New "
            @"Arrival\",\"km-KH\":\"មកដល់ថ្មី\",\"zh-CN\":\"新到\"},\"isSelected\":0,\"orderBy\":11},{\"name\":{\"en-US\":\"Expire "
            @"Soon\",\"km-KH\":\"ជិតផុតកំណត់​\",\"zh-CN\":\"快过期\"},\"isSelected\":0,\"orderBy\":12},{\"name\":{\"en-US\":\"Amount Large To "
            @"Small\",\"km-KH\":\"ទឹកប្រាក់​ធំទៅតូច\",\"zh-CN\":\"面额由大到小\"},\"isSelected\":0,\"orderBy\":13},{\"name\":{\"en-US\":\"Amount Small To "
            @"Large\",\"km-KH\":\"ទឹកប្រាក់​តូចទៅធំ\",\"zh-CN\":\"面额由小到大​\"},\"isSelected\":0,\"orderBy\":14}]}}",
        SAAppSwitchVoiceVerification: @"off",
        SAAppSwitchVoiceVerificationSupportChineseMobilePhone: @"off",
        SAAppSwitchOtherEventPoolSize: @(20),
        SAAppSwitchStandardEventPoolSize: @(20),
        SAAppSwitchIMProvider: @"on",
        SAAppSwitchDataPushInterval: @(15),
        SAAppSwitchAppGuidePage: @"on",
        SAAppSwitchDataRecord: @"on",
        SAAppSwitchIMVoiceCall: @"off",
        SAAppSwitchAppCallKitLocation: @"off",
        SAAppSwitchPasteboardRead: @"on",
        SAAppSwitchOrderListFilterOption:
            @"{\"businessLine\":{\"title\":{\"en-US\":\"Filter by "
            @"service\",\"km-KH\":\"តម្រងតាមសេវាកម្ម\",\"zh-CN\":\"按服务筛选\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"businessLine\":"
            @"\"SuperApp\"},{\"name\":{\"en-US\":\"Food "
            @"Delivery\",\"km-KH\":\"កម្ម៉ង់អាហារ​\",\"zh-CN\":\"外卖\"},\"isSelected\":0,\"businessLine\":\"YumNow\"},{\"name\":{\"en-US\":\"Online "
            @"Shopping\",\"km-KH\":\"ទំនិញអនឡាញ\",\"zh-CN\":\"电商​\"},\"isSelected\":0,\"businessLine\":\"TinhNow\"},{\"name\":{\"en-US\":\"Hotel\",\"km-KH\":"
            @"\"សណ្ឋាគារ\","
            @"\"zh-"
            @"CN\":"
            @"\"酒店\"}"
            @","
            @"\"isSelected\":0,\"businessLine\":\"HotelChannel\"},{\"name\":{\"en-US\":\"Air "
            @"ticket\",\"km-KH\":\"សំបុត្រយន្តហោះ\",\"zh-CN\":\"机票\"},\"isSelected\":0,\"businessLine\":\"OTA\"},{\"name\":{\"en-US\":\"Game\",\"km-KH\":\"ហ្គេម\",\"zh-CN\":\"游戏\"},\"isSelected\":0,"
            @"\"businessLine\":\"GameChannel\"},{\"name\":{\"en-US\":\"Local Service\",\"km-KH\":\"Local "
            @"Service\",\"zh-CN\":\"本地生活\"},\"isSelected\":0,\"businessLine\":\"GroupBuy\"},{\"name\":{\"en-US\":\"Top-Up\",\"km-KH\":\"បញ្ចូលលុយទូរស័ព្ទ\",\"zh-CN\":\"话费充值\"},\"isSelected\":0,"
            @"\"businessLine\":\"PhoneTopUp\"},{\"name\":{\"en-US\":\"Bill "
            @"payment\",\"km-KH\":\"ទូទាត់វិក្កយបត្រ\",\"zh-CN\":\"账单缴费\"},\"isSelected\":0,\"businessLine\":\"BillPayment\"},{\"name\":{\"en-US\":\"Member\",\"km-KH\":\"សមាជិក\",\"zh-CN\":\"会员\"},"
            @"\"isSelected\":0,\"businessLine\":\"MemberCentre\"},{\"name\":{\"en-US\":\"Travel\",\"km-KH\":\"ត្រាវែល\",\"zh-CN\":\"旅游\"},"
            @"\"isSelected\":0,\"businessLine\":\"Travel\"}]},\"timeRange\":{\"title\":{\"en-US\":\"Filter by "
            @"time\",\"km-KH\":\"តម្រងតាមពេលវេលា\",\"zh-CN\":\"按时间筛选\"},\"option\":[{\"name\":{\"en-US\":\"ALL\",\"km-KH\":\"ទាំងអស់\",\"zh-CN\":\"全部\"},\"isSelected\":1,\"timeRange\":\"0\"},{"
            @"\"name\":{\"en-US\":\"1 month\",\"km-KH\":\"1 ខែចុងក្រោយ\",\"zh-CN\":\"近1个月\"},\"isSelected\":0,\"timeRange\":\"30\"},{\"name\":{\"en-US\":\"3 months\",\"km-KH\":\"3 "
            @"ខែចុងក្រោយ\",\"zh-CN\":\"近3个月\"},\"isSelected\":0,\"timeRange\":\"90\"}]}}",
        SAAppSwitchIMFeedBackOption: @"[{\"name\":{\"en-US\":\"Service "
                                     @"Quality\",\"km-KH\":\"គុណភាពសេវាកម្ម\",\"zh-CN\":\"服务质量\"},\"isSelected\":0,\"feedbackType\":\"service_quality\"},{\"name\":{\"en-US\":\"Harassment\",\"km-"
                                     @"KH\":\"ការបៀតបៀន\",\"zh-CN\":\"骚扰干扰\"},\"isSelected\":0,\"feedbackType\":\"disturbance\"},{\"name\":{\"en-US\":\"false "
                                     @"content\",\"km-KH\":\"ខ្លឹមសារមិនពិត\",\"zh-CN\":\"内容不实\"},\"isSelected\":0,\"feedbackType\":\"false_content\"},{\"name\":{\"en-US\":\"Low quality "
                                     @"goods\",\"km-KH\":\"ទំនិញគុណភាពទាប\",\"zh-CN\":\"劣质商品\"},\"isSelected\":0,\"feedbackType\":\"inferior_goods\"},{\"name\":{\"en-US\":\"Other\",\"km-KH\":"
                                     @"\"សេងទៀត\",\"zh-CN\":\"其他\"},\"isSelected\":0,\"feedbackType\":\"other\"}]",
        SAAppSwitchABAPayLoadingTime: @(10),
        SAAppSwitchNewLoginPage: @"on",
        SAAppSwitchNewLoginPageBindPhone: @"off",
        SAAppSwitchOpenAppUpdateUserInfo: @"on",
        SAAppSwitchNewNetworkCryptModel: @"off",
        SAAppSwitchNewWMPage: @"off",
        SAAppSwitchLoginSkipSetPassword: @"on",
    }];
#endif
}

#pragma mark - private methods
- (void)fetchAndActivateRemoteConfigWithKey:(SAAppSwitchName)switchName {
    @HDWeakify(self);
    [self.remoteConfig fetchWithCompletionHandler:^(FIRRemoteConfigFetchStatus status, NSError *_Nullable error) {
        @HDStrongify(self);
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            [self activateConfigsWithSwitchName:switchName];
        }
    }];
}

- (void)activateConfigsWithSwitchName:(SAAppSwitchName)switchName {
    @HDWeakify(self);
    [self.remoteConfig activateWithCompletion:^(BOOL changed, NSError *_Nullable error) {
        @HDStrongify(self);
        if (!error) {
            FIRRemoteConfigValue *value = [self.remoteConfig configValueForKey:switchName];
            //            HDLog(@"获取到%@参数:%@,存入缓存", switchName, value.stringValue);
            [SACacheManager.shared setObject:value.stringValue forKey:switchName type:SACacheTypeCachePublic];
        }
    }];
}

#pragma mark - public methods
- (NSString *_Nullable)switchForKey:(SAAppSwitchName)switchName {
    NSString *value = [SACacheManager.shared objectForKey:switchName type:SACacheTypeCachePublic];
    if (HDIsStringEmpty(value)) {
        FIRRemoteConfigValue *remoteValue = [self.remoteConfig configValueForKey:switchName];
        value = remoteValue.stringValue;
        //        HDLog(@"缓存没有%@，用默认配置:%@", switchName, value);
    }
    [self fetchAndActivateRemoteConfigWithKey:switchName];
    return value;
}

@end
