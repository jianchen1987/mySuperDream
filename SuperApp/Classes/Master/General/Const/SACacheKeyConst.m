//
//  SACacheKeyConst.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACacheKeyConst.h"

NSString *const kCacheKeyUser = @"module.user.instance";
NSString *const kCacheKeyLastLoginedUserName = @"module.user.lastLoginName";
NSString *const kCacheKeyLastLoginedType = @"module.user.lastLoginType";
NSString *const kCacheKeyLastLoginedHeadURL = @"module.user.lastLoginHeadURL";
NSString *const kCacheKeyLastLoginedShowName = @"module.user.lastLoginedShowName";
NSString *const kCacheKeyHasCouponTipShowed = @"module.home.hasCouponTipShowed";
NSString *const kCacheKeyIsUserNewRegisted = @"module.user.isUserNewRegisted";
NSString *const kCacheKeyMineAdvertisementActivity = @"module.advertisement.mine.activity";
NSString *const kCacheKeyShouldHideGuidePage = @"module.app.shouldHideGuidePage.2.0";
NSString *const kCacheKeyMarketingTotalBonus = @"module.marketing.totalBonus";
NSString *const kCacheKeyUserChoosedCurrentAddress = @"com.superapp.user.address";
NSString *const kCacheKeyUserLastOrderSubmitChoosedCurrentAddress = @"com.superapp.user.submit.address";
NSString *const kCacheKeyMerchantKind = @"com.superapp.public.merchantKind";
NSString *const kCacheKeyMerchantBusinessCirlce = @"com.superapp.public.businessCirlce";
NSString *const kCacheKeyMerchantRecommendedList = @"com.superapp.recommended.store";
NSString *const kCacheKeyMerchantPickForYouList = @"com.superapp.pick.for.you.store";
NSString *const kCacheKeyHasShowedCashInAndMerchantGuide = @"com.superapp.hasShowedCashInAndMerchantGuide";
NSString *const kCacheKeyUserIgnoredAppVersion = @"com.superapp.public.userIgnoredAppVersion";
NSString *const kCacheKeyCheckHomeNotification = @"com.superapp.public.checkHomeNotification";
NSString *const kCacheKeyAppLaunchScreenAdvertisement = @"com.superapp.public.appLaunchScreenAdvertisement";
NSString *const kCacheKeyAppHomeDynamicFunctionList = @"com.superapp.public.appHomeDynamicFunctionList";
NSString *const kCacheKeyAppTabBarConfigList = @"com.superapp.public.appTabBarConfigListV2";
NSString *const kCacheKeyRemoteConfigCashIsInEnabled = @"com.superapp.public.remoteConfigCashIsInEnabled";
NSString *const kCacheKeyLocalShoppingCart = @"com.superapp.local.shoppingCart";
NSString *const kCacheKeyHomeAdvertisementCarousel = @"module.superapp.advertisement.home.activity";
NSString *const kCacheKeyHomeAdvertisementRecommended = @"module.superapp.advertisement.home.recommended";
NSString *const kCacheKeyLoginAdConfigs = @"module.superapp.public.loginAdConfigs";
/// 当前版本超A首页广告缓存key
NSString *const kCacheKeyMasterHomePageAdvertisement = @"module.superapp.advertisement.master.home.advertisement";
/// 当前版本外卖首页广告缓存key
NSString *const kCacheKeyYumNowHomePageAdvertisement = @"module.superapp.advertisement.yumNow.home.advertisement";
NSString *const kCacheKeyCheckStandLastTimeChoosedPaymentMethod = @"com.superapp.user.lastTime.choose.paymentMethod.v2";
/** 推送 token 记录 */
NSString *const kCacheKeyFCMRemoteNotifitionToken = @"com.superapp.fcmToken";
NSString *const kCacheKeyMasterNewHomePageWindow = @"module.superapp.advertisement.master.newHome.window";
NSString *const kCacheKeyWowNowMinePageConfig = @"module.superapp.page.wownow.mine.cmsConfig";
NSString *const kCacheKeyWowNowHomePageConfig = @"module.superapp.page.wownow.home.cmsConfig";

/** YumNow */
NSString *const kCacheKeyWMHomeAdvertisementCarousel = @"module.yumnow.advertisement.home.carousel";
NSString *const kCacheKeyWMHomeAdvertisementActivity = @"module.yumnow.advertisement.home.activity";
NSString *const kCacheKeyWMHomeAdvertisement = @"module.yumnow.advertisement.home.advertisement";
NSString *const kCacheKeyWMHomeInsterAdvertisement = @"module.yumnow.advertisement.home.inster.advertisement";
NSString *const kCacheKeyDeliveryAppHomeDynamicFunctionList = @"com.yumnow.public.appHomeDynamicFunctionList";
NSString *const kCacheKeyDeliveryAppTabBarConfigList = @"com.yumnow.public.appTabBarConfigList";
NSString *const kCacheKeyYumNowUserLastTimeChoosedPaymentMethod = @"com.yumnow.user.lastTime.choose.paymentMethodV2";
NSString *const kCacheKeyYumNowUserChoosedCurrentAddress = @"com.yumnow.user.address";
NSString *const kCacheKeyCheckStandSuccessPayedOrderNoList = @"kCacheKeyCheckStandSuccessPayedOrderNoList";
NSString *const kCacheKeyYumNowHomePageWindow = @"com.yumnow.home.page.window.V2";
NSString *const kCacheKeyMasterHomePageWindow = @"com.master.home.page.window.V2";
NSString *const kCacheKeyHomeNearbyStoreList = @"module.yumnow.home.nearby.storelist";
// NSString *const kCacheKeyYumNowLastLocateAddress = @"module.yumnow.home.last.locate";
NSString *const kCacheKeyUserHistory = @"module.yumnow.home.local.history";
NSString *const kCacheKeyHomeLayoutApollo = @"module.yumnow.public.homeLayoutApollo";
NSString *const kCacheKeyHomeNotice = @"com.yumnow.public.appkHomeNotice";
NSString *const kCacheKeyYumUserIgnoredAppVersion = @"com.yunnow.public.userIgnoredAppVersion";

/** TonhNow */
NSString *const kCacheKeyTinhNowAppHomeDynamicFunctionList = @"com.tinhnow.public.appHomeDynamicFunctionList";
NSString *const kCacheKeyTinhNowAppTabBarConfigList = @"com.tinhnow.public.appTabBarConfigList";
NSString *const kCacheKeyTinhNowHomeRecommendGoodsData = @"module.tinhnow.home.recommend.productList";
NSString *const kCacheKeyTinhNowPaymentMethodLastChoosed = @"module.tinhnow.payment.paymentMethod.Choosed";
NSString *const kCacheKeyTinhNowHomeWindowsList = @"module.tinhnow.homepage.windows";
/** 电商首页活动卡片缓存 */
NSString *const kCacheKeyTinhNowHomeActivityCardData = @"module.tinhnow.homepage.activityCard";
/** 电商首页滚动文字缓存 */
NSString *const kCacheKeyTinhNowHomeScrollContentText = @"module.tinhnow.homepage.scrollContentText";
/** 记录上一次选择的物流公司缓存 */
NSString *const kCacheKeyTinhNowDeliveryCompanyLastChoosed = @"module.tinhnow.delivery.company.Choosed";
NSString *const kCacheKeyThirpartLoginSwitch = @"module.superapp.public.thirdPathLoginSwitch";

NSString *const kCacheKeyRemoteConfigs = @"module.superapp.public.remoteConfigs";
NSString *const kCacheKeyMarketingAlertConfigs = @"module.superapp.public.marketingAlertConfigs";
NSString *const kCacheKeyAlertLocalCache = @"module.superapp.public.alertLocalCache";

NSString *const kCacheKeyYumNowPaymentToolsCache = @"module.superapp.public.yumnow.paymentToolsCache";
NSString *const kCacheKeyTinhNowPaymentToolsCache = @"module.superapp.public.tinhnow.paymentToolsCache";
NSString *const kCacheKeyUserContactListCache = @"module.superapp.public.superapp.contactsCache";

NSString *const kCacheKeyStartupAdCache = @"module.superapp.public.superapp.startupAdCache";

NSString *const kCacheKeyAppleVoipToken = @"com.super.voipToken";

/** GroupBuy */
NSString *const kCacheKeyGroupBuyAppTabBarConfigList = @"com.groupbuy.public.appTabBarConfigList";
NSString *const kCacheKeyGroupBuySearchHistory = @"module.groupbuy.search.local.history";
NSString *const kCacheKeyGroupBuyHomePageWindow = @"module.groupbuy.homepage.windows";
NSString *const kCacheKeyGroupBuyAppHomeDynamicFunctionList = @"module.groupbuy.public.appHomeDynamicFunctionList";
NSString *const kCacheKeyGroupBuyLivingList = @"module.groupbuy.public.appHomeColumnList";
NSString *const kCacheKeyGroupBuyUserChoosedCurrentAddress = @"com.groupBuy.user.address";
NSString *const kCacheKeyGroupBuyUserLastTimeChoosedPaymentMethod = @"com.groupBuy.user.lastTime.choose.paymentMethod";
NSString *const kCacheKeyGroupBuyHomeLayoutApollo = @"module.groupBuy.public.homeLayoutApollo";

/** PayNow */

NSString *const kSaveUserTempInfo = @"module.payNow.saveUserTempInfo";
NSString *const kSaveDisclaimerAlertTips = @"module.payNow.saveDisclaimerAlertTips";

NSString *const KBlueAndGreenFlag = @"module.superapp.public.greenAndBlue.flag";
/** 首页3.0 用户选择的地址 */
NSString *const kCacheKeyWOWNOWHomeUserChoosedCurrentAddress = @"com.superapp.home.user.chooseAddress";
/** 搜索历史 */
NSString *const kCacheKeyAggregateSearchHistory = @"com.superapp.aggregateSearch.history";
/** 订单搜索历史 */
NSString *const kCacheKeyOrderSearchHistory = @"com.superapp.orderSearch.history";

NSString *const kCacheKeyHelloPlatformDeviceToken = @"module.superapp.user.helloPlatform.deviceToken";

NSString *const kCacheKeyEarnPointBannerCache = @"module.superapp.public.superapp.earnPointBanner";

NSString *const kCacheKeyShortIDTrace = @"module.superapp.public.shortID";
