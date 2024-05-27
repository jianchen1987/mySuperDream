//
//  SACacheKeyConst.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 记录当前用户 */
FOUNDATION_EXPORT NSString *const kCacheKeyUser;
/** 记录上一次登录的用户 */
FOUNDATION_EXPORT NSString *const kCacheKeyLastLoginedUserName;
/** 记录上一次用户登录方式 */
FOUNDATION_EXPORT NSString *const kCacheKeyLastLoginedType;
/** 记录上一次用户登录的头像 */
FOUNDATION_EXPORT NSString *const kCacheKeyLastLoginedHeadURL;
/** 记录上一次用户登录的名称 */
FOUNDATION_EXPORT NSString *const kCacheKeyLastLoginedShowName;
/** 记录当前用户是否已经展示过优惠券入口提示 */
FOUNDATION_EXPORT NSString *const kCacheKeyHasCouponTipShowed;
/** 记录当前用户是否新注册用户 */
FOUNDATION_EXPORT NSString *const kCacheKeyIsUserNewRegisted;
/** 记录“我的”页面活动广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyMineAdvertisementActivity;
/** 记录引导页是否不该显示 */
FOUNDATION_EXPORT NSString *const kCacheKeyShouldHideGuidePage;
/** 记录用户分享裂变奖励总金额 */
FOUNDATION_EXPORT NSString *const kCacheKeyMarketingTotalBonus;
/** 记录用户当前地址 */
FOUNDATION_EXPORT NSString *const kCacheKeyUserChoosedCurrentAddress;
/** 记录用户上次下单选择的地址 */
FOUNDATION_EXPORT NSString *const kCacheKeyUserLastOrderSubmitChoosedCurrentAddress;
/** 记录商户品类 */
FOUNDATION_EXPORT NSString *const kCacheKeyMerchantKind;
/** 记录商户商圈 */
FOUNDATION_EXPORT NSString *const kCacheKeyMerchantBusinessCirlce;
/** 记录首页推荐商家缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyMerchantRecommendedList;
/** 记录首页推荐商家缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyMerchantPickForYouList;
/** 记录是否已经展示过入金和商家的指引 */
FOUNDATION_EXPORT NSString *const kCacheKeyHasShowedCashInAndMerchantGuide;
/** 记录用户忽略的版本更新号 */
FOUNDATION_EXPORT NSString *const kCacheKeyUserIgnoredAppVersion;
/** 记录检查首页小喇叭通知 */
FOUNDATION_EXPORT NSString *const kCacheKeyCheckHomeNotification;
/** 记录启动广告配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyAppLaunchScreenAdvertisement;
/** 记录超 A 首页金刚区配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyAppHomeDynamicFunctionList;
/** 记录超 A 底部导航栏配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyAppTabBarConfigList;
/** 记录 Cash In 打开状态 */
FOUNDATION_EXPORT NSString *const kCacheKeyRemoteConfigCashIsInEnabled;
/** 记录本地购物车 */
FOUNDATION_EXPORT NSString *const kCacheKeyLocalShoppingCart;
/** 记录超A首页轮播广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyHomeAdvertisementCarousel;
/** 记录超A首页推荐广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyHomeAdvertisementRecommended;
/** 记录登录推荐广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyLoginAdConfigs;
/** 收银台用户上次选择支付方式 */
FOUNDATION_EXPORT NSString *const kCacheKeyCheckStandLastTimeChoosedPaymentMethod;
/** 推送 token 记录 */
FOUNDATION_EXPORT NSString *const kCacheKeyFCMRemoteNotifitionToken;
/** 记录新版超A首页缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyMasterNewHomePageWindow;
/** 记录WOWNOW 我的页 cms配置*/
FOUNDATION_EXPORT NSString *const kCacheKeyWowNowMinePageConfig;

FOUNDATION_EXPORT NSString *const kCacheKeyWowNowHomePageConfig;

/** YumNow */
/** 记录外卖首页活动广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyWMHomeAdvertisementActivity;
/** 记录外卖首页轮播广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyWMHomeAdvertisementCarousel;
/** 记录外卖首页手动滑动广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyWMHomeAdvertisement;
/** 记录外卖首页插入广告 */
FOUNDATION_EXPORT NSString *const kCacheKeyWMHomeInsterAdvertisement;
/** 记录外卖首页金刚区配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyDeliveryAppHomeDynamicFunctionList;
/** 记录外卖底部导航栏配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyDeliveryAppTabBarConfigList;
/** 记录用户上次下单选择的付款方式 */
FOUNDATION_EXPORT NSString *const kCacheKeyYumNowUserLastTimeChoosedPaymentMethod;
/** 外卖选择地址 */
 FOUNDATION_EXPORT NSString *const kCacheKeyYumNowUserChoosedCurrentAddress;
/** 收银台支付成功的单 */
FOUNDATION_EXPORT NSString *const kCacheKeyCheckStandSuccessPayedOrderNoList;
/** 外卖首页window */
FOUNDATION_EXPORT NSString *const kCacheKeyYumNowHomePageWindow;
/** 超A首页window */
FOUNDATION_EXPORT NSString *const kCacheKeyMasterHomePageWindow;
/** 外卖首页附近门店 */
FOUNDATION_EXPORT NSString *const kCacheKeyHomeNearbyStoreList;
/** 记录外卖首页进入时定位的地址 */
// FOUNDATION_EXPORT NSString *const kCacheKeyYumNowLastLocateAddress;
/** 首页阿波罗布局配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyHomeLayoutApollo;
/** 首页通知 */
FOUNDATION_EXPORT NSString *const kCacheKeyHomeNotice;
/** 版本更新 */
FOUNDATION_EXPORT NSString *const kCacheKeyYumUserIgnoredAppVersion;


/** TonhNow */
/** 记录电商首页金刚区配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowAppHomeDynamicFunctionList;
/** 记录电商底部导航栏配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowAppTabBarConfigList;
/** 记录电商推荐列表数据 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowHomeRecommendGoodsData;
/** 记录上一次选择的支付方式 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowPaymentMethodLastChoosed;
/** 电商首页广告缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowHomeWindowsList;
/** 电商首页活动卡片缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowHomeActivityCardData;
/** 电商首页滚动文字缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowHomeScrollContentText;
/** 记录上一次选择的物流公司缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowDeliveryCompanyLastChoosed;

/** 远程配置 控制三方登陆显示与否 */
FOUNDATION_EXPORT NSString *const kCacheKeyThirpartLoginSwitch;
/** 自建远程配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyRemoteConfigs;
/** 弹窗配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyMarketingAlertConfigs;
/** 弹窗缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyAlertLocalCache;
/** 支付工具缓存 */
FOUNDATION_EXPORT NSString *const kCacheKeyYumNowPaymentToolsCache;
FOUNDATION_EXPORT NSString *const kCacheKeyTinhNowPaymentToolsCache;
/** 已上传的列表 */
FOUNDATION_EXPORT NSString *const kCacheKeyUserContactListCache;
/** 启动广告缓存数据 */
FOUNDATION_EXPORT NSString *const kCacheKeyStartupAdCache;

/** 历史记录 */
FOUNDATION_EXPORT NSString *const kCacheKeyUserHistory;
/** voip token*/
FOUNDATION_EXPORT NSString *const kCacheKeyAppleVoipToken;

/** GroupBuy */
/** 记录团购底部导航栏配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuyAppTabBarConfigList;
/** 搜索历史记录 */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuySearchHistory;
/** 团购首页window */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuyHomePageWindow;
/** 记录团购首页金刚区配置 */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuyAppHomeDynamicFunctionList;
/** 记录团购首页生活指南分类 */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuyLivingList;
/** 团购地址 */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuyUserChoosedCurrentAddress;
/** 记录用户上次下单选择的付款方式 */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuyUserLastTimeChoosedPaymentMethod;
/** 首页阿波罗 */
FOUNDATION_EXPORT NSString *const kCacheKeyGroupBuyHomeLayoutApollo;

/** PayNow */

FOUNDATION_EXPORT NSString *const kSaveUserTempInfo;
FOUNDATION_EXPORT NSString *const kSaveDisclaimerAlertTips;

/** 蓝绿标识 */
FOUNDATION_EXPORT NSString *const KBlueAndGreenFlag;
/** 首页3.0 用户选择的地址 */
FOUNDATION_EXPORT NSString *const kCacheKeyWOWNOWHomeUserChoosedCurrentAddress;
/** 聚合搜索历史 */
FOUNDATION_EXPORT NSString *const kCacheKeyAggregateSearchHistory;
/** 订单搜索历史 */
FOUNDATION_EXPORT NSString *const kCacheKeyOrderSearchHistory;
/** 传声筒DeviceToken */
FOUNDATION_EXPORT NSString *const kCacheKeyHelloPlatformDeviceToken;
/** 查询Banner类型为未达门槛和已达门槛的启用中banner */
FOUNDATION_EXPORT NSString *const kCacheKeyEarnPointBannerCache;
/** 用来存放关联短链的key */
FOUNDATION_EXPORT NSString *const kCacheKeyShortIDTrace;

NS_ASSUME_NONNULL_END
