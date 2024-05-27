//
//  SAApolloSwitchKeyConst.h
//  SuperApp
//
//  Created by Chaos on 2021/4/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *ApolloConfigKey NS_STRING_ENUM;

#pragma mark - 配置项
/** JSSDK网络请求白名单 */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyH5WhiteList;
/** Map相关  */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyMap;
/** 选择地区热门城市 */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyMapHotCity;
/** 客服热线 */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyCallCenter;

#pragma mark - 开关
/** 下单是否校验地址开关 */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyOrderSubmitNeedCheckAddress;
/** 外卖首页选择地址 地图是否只在点击确定时解析 */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyYumNowSelectAddressInMapForSearchStore;
/** 新增/编辑收货地址 地图是否只在点击确定时解析 */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyAppSelectAddressInMapForAddOrModify;
/** 外卖下单页 是否走聚合接口 -- Enable的时候走新的逻辑，Disable走老逻辑 */
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyYumNowOrderSubmit;
/** mine 隐藏菜单*/
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeySAMineMenus;
/** mine 是否使用cms*/
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeySAMineUseCMS;
/** 外卖是否默认使用优惠券*/
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyYumNowCouponSelectedSwitch;
/** 外卖是否默认使用运费券*/
FOUNDATION_EXPORT ApolloConfigKey const ApolloConfigKeyYumNowFreightSelectSwitch;
/** wownow 首页开启CMS 开关*/
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeySAWNHomeCMS;
/** 是否使用自建埋点的开关*/
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyLKDataRecord;
/** 柬埔寨手机号码格式*/
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyCambodiaPhoneFormatArray;
/** 历史账单入口*/
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyHistoryBillAlert;
/** 外卖首页布局配置*/
FOUNDATION_EXPORT ApolloConfigKey const kApolloConfigYumNowHomeLayout;
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeySigninEntrance;
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyGetMoreCoupons;
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyGetMorePayCoupons;
/** 支付H5容器白名单 */
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyPayNowWhiteList;
/** 获取积分后的跳转链接 */
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyWPointReceiveJumpLink;
/** 电商卖家收益页面版本回退开关 */
FOUNDATION_EXPORT ApolloConfigKey const kApolloSwitchKeyTinhnowSupplierIncomePageGoBack;

///
FOUNDATION_EXPORT ApolloConfigKey const kApolloCoolcashTelegram;
/** 评价攻略 */
FOUNDATION_EXPORT ApolloConfigKey const kApolloEvaluationStrategyFromYumNow;
FOUNDATION_EXPORT ApolloConfigKey const kApolloEvaluationStrategyFromTinhNow;

FOUNDATION_EXPORT ApolloConfigKey const kApolloConfigKeyMissionCompleteJumpLink;

FOUNDATION_EXPORT ApolloConfigKey const kApolloConfigKeyYumNowExchangeRate;

FOUNDATION_EXPORT ApolloConfigKey const kApolloConfigKeyDataRecordStandardPoolSize;
FOUNDATION_EXPORT ApolloConfigKey const kApolloConfigKeyDataRecordOtherPoolSize;
FOUNDATION_EXPORT ApolloConfigKey const kApolloConfigKeyDataRecordSwitch;
FOUNDATION_EXPORT ApolloConfigKey const kApolloConfigKeyDataRecordPushInterval;
NS_ASSUME_NONNULL_END
