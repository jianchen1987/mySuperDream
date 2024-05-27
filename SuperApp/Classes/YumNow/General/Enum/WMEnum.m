//
//  SAEnum.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMEnum.h"

WMCouponTicketSceneType const WMCouponTicketSceneTypePlatform = @"10";
WMCouponTicketSceneType const WMCouponTicketSceneTypeMerchant = @"11";
WMCouponTicketSceneType const WMCouponTicketSceneTypePlatformAndMerchant = @"12";

WMMerchantRecommendType const WMMerchantRecommendTypeMain = @"MainRecommend";              ///< 首页推荐
WMMerchantRecommendType const WMMerchantRecommendTypeDiscoverList = @"StoreListRecommend"; ///< 发现页列表推荐

WMStoreStatus const WMStoreStatusOpening = @"M001"; ///< 营业
WMStoreStatus const WMStoreStatusResting = @"M002"; ///< 休息
WMStoreStatus const WMStoreStatusClosed = @"M003";  ///< 停业

WMShopppingCartStoreStatus const WMShopppingCartStoreStatusOpening = @"OPEN";  ///< 营业
WMShopppingCartStoreStatus const WMShopppingCartStoreStatusResting = @"REST";  ///< 休息
WMShopppingCartStoreStatus const WMShopppingCartStoreStatusClosed = @"CLOSED"; ///< 停业

/// 搜索来源
WMStoreSearchSourceType const WMStoreSearchSourceTypeHome = @"MainSearch";                     ///< 首页
WMStoreSearchSourceType const WMStoreSearchSourceTypeClassification = @"ClassificationSearch"; ///< 分类页
WMStoreSearchSourceType const WMStoreSearchSourceTypeNone = @"none";
WMStoreSearchSourceType const WMStoreSearchSourceTypeDiscoverList = @"DiscoverListSearch"; ///< 发现页列表
WMStoreSearchSourceType const WMStoreSearchSourceTypeDiscoverMap = @"DiscoverMapSearch";   ///< 发现页地图

/// 详情页来源类型
WMStoreDetailSourceType const WMStoreDetailSourceTypeRecommendHome = @"MainRecommend";         ///< 首页推荐
WMStoreDetailSourceType const WMStoreDetailSourceTypeSearchMain = @"MainSearch";               ///< 首页搜索
WMStoreDetailSourceType const WMStoreDetailSourceTypeDiscoverList = @"DiscoverList";           ///< 发现页列表
WMStoreDetailSourceType const WMStoreDetailSourceTypeSearchDiscoverMap = @"DiscoverMapSearch"; ///< 发现页地图搜索
WMStoreDetailSourceType const WMStoreDetailSourceTypeSearchPageNearBy = @"NearBy";             ///< 附近
WMStoreDetailSourceType const WMStoreDetailSourceTypeUnionShoppingCart = @"UnionShoppingCart"; ///< 统一购物车
WMStoreDetailSourceType const WMStoreDetailSourceTypeStoreFavourite = @"StoreFavourite";       ///< 门店收藏

// WMStationLetterType const WMStationLetterTypeCoupon = @"Coupon";          ///< 优惠
// WMStationLetterType const WMStationLetterTypeOrder = @"Order";            ///< 订单
// WMStationLetterType const WMStationLetterTypeSystem = @"System Message";  ///< 系统

WMReviewEntityType const WMReviewEntityTypeOrder = @"order"; ///< 订单

WMReviewFilterType const WMReviewFilterTypeAll = @"";            ///< 所有
WMReviewFilterType const WMReviewFilterTypeGood = @"PRAISE";     ///< 好评
WMReviewFilterType const WMReviewFilterTypeMiddle = @"MIDDLE";   ///< 中评
WMReviewFilterType const WMReviewFilterTypeBad = @"CRITICAL";    ///< 差评
WMReviewFilterType const WMReviewFilterTypeWithImage = @"IMAGE"; ///< 带图
WMReviewFilterType const WMReviewFilterTypeLike = @"LIKE";       ///< 点赞
WMReviewFilterType const WMReviewFilterTypeUnlike = @"UNLIKE";   ///< 点踩

WMReviewFilterConditionHasDetail const WMReviewFilterConditionHasDetailRequired = @"10"; ///< 必须有评论
WMReviewFilterConditionHasDetail const WMReviewFilterConditionHasDetailOrNone = @"";     ///< 有无评论均可
WMReviewFilterConditionHasDetail const WMReviewFilterConditionHasDetailNone = @"11";     ///< 无评论

WMOrderDeliveryTimeType const WMOrderDeliveryTimeTypeRightNow = @"10";  ///< 立即送出
WMOrderDeliveryTimeType const WMOrderDeliveryTimeTypeSubscribe = @"20"; ///< 预约

WMOrderAvailablePaymentType const WMOrderAvailablePaymentTypeOnline = @"ONLINE_PAYMENT";    ///< 在线付款
WMOrderAvailablePaymentType const WMOrderAvailablePaymentTypeOffline = @"CASH_ON_DELIVERY"; ///< 线下付款

WMSpecialActiveType const WMSpecialActiveTypeImage = @"picture";   ///< 图片专题
WMSpecialActiveType const WMSpecialActiveTypeStore = @"store";     ///< 门店专题
WMSpecialActiveType const WMSpecialActiveTypeProduct = @"product"; ///< 商品专题
WMSpecialActiveType const WMSpecialActiveTypeBrand = @"brand";     ///< 品牌专题
WMSpecialActiveType const WMSpecialActiveTypeEat = @"eatOnTime";   ///< 按时吃饭

///
WMStoreSupportedPaymentType const WMStoreSupportedPaymentTypeOnline = @"P0002";  ///< 在线付款
WMStoreSupportedPaymentType const WMStoreSupportedPaymentTypeOffline = @"P0003"; ///< 线下付款

///< 品牌主题
WMStoreStatus const WMThemeTypeMerchant = @"TT001";
///< 门店主题
WMStoreStatus const WMThemeTypeStore = @"TT002";
///< 商品主题
WMStoreStatus const WMThemeTypeProduct = @"TT003";

///< 焦点广告轮播
WMHomeAdviseType const WMHomeFoucsAdviseType = @"ADS001";
///< 活动精选
WMHomeAdviseType const WMHomeCarouselAdviseType = @"ADS002";
///< 附近门店广告
WMHomeAdviseType const WMHomeNearStoreAdviseType = @"ADS003";
///< 顶部快捷选项
WMHomeAdviseType const WMHomeTopShortcutOptions = @"ADS004";


///< 轮播广告(原来的焦点广告）
WMHomeLayoutType const WMHomeLayoutTypeFoucsAdvertise = @"WMFoucsAdvertise";
///< 活动精选（原来的轮播广告）
WMHomeLayoutType const WMHomeLayoutTypeCarouselAdvertise = @"WMCarouselAdvertise";
///< 门店穿插广告
WMHomeLayoutType const WMHomeLayoutTypeNearStoreAdvertise = @"WMNearStoreAdvertise";
///< 金刚区
WMHomeLayoutType const WMHomeLayoutTypeKingKong = @"WMKingKong";
///< 顶部快捷选项
WMHomeLayoutType const WMHomeLayoutTypeTopShortcutOptions = @"WMTopShortcutOptions";
///< 按时吃饭
WMHomeLayoutType const WMHomeLayoutTypeEatOnTime = @"WMEatOnTime";
///< 商家主题
WMHomeLayoutType const WMHomeLayoutTypeMerchantTheme = @"WMMerchantTheme";
///< 门店主题
WMHomeLayoutType const WMHomeLayoutTypeStoreTheme = @"WMStoreTheme";
///< 商品主题
WMHomeLayoutType const WMHomeLayoutTypeProductTheme = @"WMProductTheme";

///每天一次
WMHomeNoticeFrequencyType const WMHomeNoticeFrequencyTypeDaily = @"F001";
///用户每次下拉首页显示
WMHomeNoticeFrequencyType const WMHomeNoticeFrequencyTypePullDown = @"F002";
///用户每次进入首页显示
WMHomeNoticeFrequencyType const WMHomeNoticeFrequencyTypeEnterHome = @"F003";

///配送类
WMHomeNoticeType const WMHomeNoticeTypeDelivery = @"HNT001";
///营销类
WMHomeNoticeType const WMHomeNoticeTypePromo = @"HNT002";

///搜索门店
WMSearchType const WMSearchTypeStore = @"store";
///搜索商品
WMSearchType const WMSearchTypeProduct = @"product";

/// 外卖团购通用电话弹窗类型
/// telegram
WMCallPhoneType const WMCallPhoneTypeTelegram = @"WMCallPhoneTypeTelegram";
/// 打电话
WMCallPhoneType const WMCallPhoneTypeCall = @"WMCallPhoneTypeCall";
/// 联系客服
WMCallPhoneType const WMCallPhoneTypeServer = @"WMCallPhoneTypeServer";
/// 联系骑手
WMCallPhoneType const WMCallPhoneTypeServerRider = @"WMCallPhoneTypeServer";
/// 联系门店
WMCallPhoneType const WMCallPhoneTypeServerStore = @"WMCallPhoneTypeServerStore";
/// 在线沟通
WMCallPhoneType const WMCallPhoneTypeOnline = @"WMCallPhoneTypeOnline";

/// 外卖业务线
/// 扫码点餐
WMBusinessType const WMBusinessTypeDigitelMenu = @"1";

/// 全部成功
WMGiveCouponResult const WMGiveCouponResultAllSuccess = @"ALL_SUCCESS";
/// 部分成功
WMGiveCouponResult const WMGiveCouponResultPartSuccess = @"PART";
/// 全部失败
WMGiveCouponResult const WMGiveCouponResultAllFail = @"FAIL";

///用户未登录
WMGiveCouponError const WMGiveCouponErrorLogin = @"510";
///活动信息发生变更
WMGiveCouponError const WMGiveCouponErrorActivityChange = @"511";
///券已抢光
WMGiveCouponError const WMGiveCouponErrorGiveOver = @"512";
///发券失败
WMGiveCouponError const WMGiveCouponErrorSendFail = @"513";
///达到今日领券上限
WMGiveCouponError const WMGiveCouponErrorDayLimit = @"514";
///达到活动领券上限
WMGiveCouponError const WMGiveCouponErrorActivityLimit = @"516";
///活动已经结束
WMGiveCouponError const WMGiveCouponErrorActitityEnd = @"517";
///优惠券已过期
WMGiveCouponError const WMGiveCouponErrorCouponEnd = @"518";
///优惠券信息发生变更
WMGiveCouponError const WMGiveCouponErrorCouponChange = @"519";
///正在领券中
WMGiveCouponError const WMGiveCouponErrorGiving = @"520";
///找不到优惠券
WMGiveCouponError const WMGiveCouponErrorNotFound = @"521";
///找不到活动
WMGiveCouponError const WMGiveCouponErrorActivityNotFound = @"522";
///找不到用户
WMGiveCouponError const WMGiveCouponErrorUserNotFound = @"523";
///未达到领用资格
WMGiveCouponError const WMGiveCouponErrorNotReceive = @"524";
///领用时发生异常
WMGiveCouponError const WMGiveCouponErrorReceiveCash = @"525";

/// 未达到门槛
WMUnUseCouponReasonType const WMUnUseCouponThreshold = @"MK4033";
/// 账号有风险
WMUnUseCouponReasonType const WMUnUseCouponAccountRisk = @"MK4037";
/// 包含优惠商品，不可与优惠券叠加使用
WMUnUseCouponReasonType const WMUnUseCouponStackVoucher = @"MK4038";
/// 优惠券未到生效时间
WMUnUseCouponReasonType const WMUnUseCouponEffective = @"MK4039";
/// 该门店不能使用该优惠券
WMUnUseCouponReasonType const WMUnUseCouponStore = @"MK4040";
/// 不能与优惠码同享
WMUnUseCouponReasonType const WMUnUseCouponStackProCode = @"MK4041";
/// 不能与运费券同享
WMUnUseCouponReasonType const WMUnUseCouponStackShipping = @"MK4042";
/// 不能与门店优惠券同享
WMUnUseCouponReasonType const WMUnUseCouponStackStoreCoupon = @"MK4043";

///待处理
WMOrderFeedBackHandleStatus const WMOrderFeedBackHandleWait = @"HS001";
///处理中
WMOrderFeedBackHandleStatus const WMOrderFeedBackHandlePending = @"HS002";
///已完成
WMOrderFeedBackHandleStatus const WMOrderFeedBackHandleFinish = @"HS003";
///已驳回
WMOrderFeedBackHandleStatus const WMOrderFeedBackHandleReject = @"HS004";

///售后反馈状态展示类型
typedef NSString *WMOrderFeedBackStepShowType NS_STRING_ENUM;
///无
WMOrderFeedBackStepShowType const WMOrderFeedBackStepNone = @"ST001";
///反馈进度
WMOrderFeedBackStepShowType const WMOrderFeedBackStepProgress = @"ST002";
///反馈结果
WMOrderFeedBackStepShowType const WMOrderFeedBackStepResult = @"ST003";

///期望处理方式
typedef NSString *WMOrderFeedBackPostShowType NS_STRING_ENUM;
///换货
WMOrderFeedBackPostShowType const WMOrderFeedBackPostChange = @"PST001";
///退款
WMOrderFeedBackPostShowType const WMOrderFeedBackPostRefuse = @"PST002";
///其他诉求
WMOrderFeedBackPostShowType const WMOrderFeedBackPostOther = @"PST003";

/// 外卖来源类型
typedef NSString *WMSourceType NS_STRING_ENUM;
///首页
WMSourceType const WMSourceTypeHome = @"Home";
///分类
WMSourceType const WMSourceTypeCategory = @"Category";
///全部分类
WMSourceType const WMSourceTypeAllCategory = @"All_Categories";
///品牌专题
WMSourceType const WMSourceTypeTopicsBrands = @"Brands_Topics";
///商品专题
WMSourceType const WMSourceTypeTopicsProduct = @"Product_Topics";
///门店专题
WMSourceType const WMSourceTypeTopicsStore = @"Store_Topics";
///按时吃饭
WMSourceType const WMSourceTypeTopicsEat = @"Eat_on_time";
///搜索
WMSourceType const WMSourceTypeSearch = @"Search";
///其他
WMSourceType const WMSourceTypeOther = @"Other";
///无
WMSourceType const WMSourceTypeNone = @"";
///门店详情
WMSourceType const WMSourceTypeStoreDetail = @"Store_Detail";
