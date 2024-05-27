//
//  SAEnum.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 优惠券归属类型
typedef NSString *WMCouponTicketSceneType NS_STRING_ENUM;
FOUNDATION_EXPORT WMCouponTicketSceneType const WMCouponTicketSceneTypePlatform;
FOUNDATION_EXPORT WMCouponTicketSceneType const WMCouponTicketSceneTypeMerchant;
FOUNDATION_EXPORT WMCouponTicketSceneType const WMCouponTicketSceneTypePlatformAndMerchant;

/// 推荐来源
typedef NSString *WMMerchantRecommendType NS_STRING_ENUM;
FOUNDATION_EXPORT WMMerchantRecommendType const WMMerchantRecommendTypeMain;         ///< 首页推荐
FOUNDATION_EXPORT WMMerchantRecommendType const WMMerchantRecommendTypeDiscoverList; ///< 发现页列表推荐

/// 营业状态
typedef NSString *WMStoreStatus NS_EXTENSIBLE_STRING_ENUM;
FOUNDATION_EXPORT WMStoreStatus const WMStoreStatusOpening; ///< 营业
FOUNDATION_EXPORT WMStoreStatus const WMStoreStatusResting; ///< 休息
FOUNDATION_EXPORT WMStoreStatus const WMStoreStatusClosed;  ///< 停业

/// 购物车门店营业状态
typedef NSString *WMShopppingCartStoreStatus NS_EXTENSIBLE_STRING_ENUM;
FOUNDATION_EXPORT WMShopppingCartStoreStatus const WMShopppingCartStoreStatusOpening; ///< 营业
FOUNDATION_EXPORT WMShopppingCartStoreStatus const WMShopppingCartStoreStatusResting; ///< 休息
FOUNDATION_EXPORT WMShopppingCartStoreStatus const WMShopppingCartStoreStatusClosed;  ///< 停业

/// 搜索来源
typedef NSString *WMStoreSearchSourceType NS_STRING_ENUM;
FOUNDATION_EXPORT WMStoreSearchSourceType const WMStoreSearchSourceTypeNone;           ///< 不需要
FOUNDATION_EXPORT WMStoreSearchSourceType const WMStoreSearchSourceTypeClassification; ///< 分类
FOUNDATION_EXPORT WMStoreSearchSourceType const WMStoreSearchSourceTypeHome;           ///< 首页
FOUNDATION_EXPORT WMStoreSearchSourceType const WMStoreSearchSourceTypeDiscoverList;   ///< 发现页
FOUNDATION_EXPORT WMStoreSearchSourceType const WMStoreSearchSourceTypeDiscoverMap;    ///< 发现页

/// 详情页来源类型
typedef NSString *WMStoreDetailSourceType NS_STRING_ENUM;
FOUNDATION_EXPORT WMStoreDetailSourceType const WMStoreDetailSourceTypeRecommendHome;     ///< 首页推荐
FOUNDATION_EXPORT WMStoreDetailSourceType const WMStoreDetailSourceTypeSearchMain;        ///< 首页搜索
FOUNDATION_EXPORT WMStoreDetailSourceType const WMStoreDetailSourceTypeDiscoverList;      ///< 发现页列表
FOUNDATION_EXPORT WMStoreDetailSourceType const WMStoreDetailSourceTypeSearchDiscoverMap; ///< 发现页地图搜索
FOUNDATION_EXPORT WMStoreDetailSourceType const WMStoreDetailSourceTypeSearchPageNearBy;  ///< 附近
FOUNDATION_EXPORT WMStoreDetailSourceType const WMStoreDetailSourceTypeUnionShoppingCart; ///< 统一购物车
FOUNDATION_EXPORT WMStoreDetailSourceType const WMStoreDetailSourceTypeStoreFavourite;    ///< 门店收藏

/// 包装费策略
typedef NS_ENUM(NSUInteger, WMPackageFeeStrategy) {
    WMPackageFeeStrategyUnknown = 0,
    WMPackageFeeStrategyTotal = 10,  ///< 商品包装总价
    WMPackageFeeStrategyPackage = 11 ///< 商品包装单价
};

/// 商品上架状态
typedef NS_ENUM(NSUInteger, WMGoodsStatus) {
    WMGoodsStatusUnknown = 0,
    WMGoodsStatusOn = 10, ///< 上架
    WMGoodsStatusOff = 11 ///< 下架
};

/// 购物车是否有库存
typedef NS_ENUM(NSUInteger, WMShoppingCartGoodInventoryStatus) {
    WMShoppingCartGoodInventoryStatusNone = 0, ///< 无库存
    WMShoppingCartGoodInventoryStatusHave = 1  ///< 有库存
};

/// 站内信是否已度
typedef NS_ENUM(NSUInteger, WMStationLetterReadStatus) {
    WMStationLetterReadStatusUnknown = 0,
    WMStationLetterReadStatusUnread = 10, ///< 未读
    WMStationLetterReadStatusRead = 11    ///< 已读
};

/// 站内信类别
// typedef NSString *WMStationLetterType NS_STRING_ENUM;
//
// FOUNDATION_EXPORT WMStationLetterType const WMStationLetterTypeCoupon;  ///< 优惠
// FOUNDATION_EXPORT WMStationLetterType const WMStationLetterTypeOrder;   ///< 订单
// FOUNDATION_EXPORT WMStationLetterType const WMStationLetterTypeSystem;  ///< 系统

/// 踩赞状态
typedef NS_ENUM(NSUInteger, WMReviewPraiseHateState) {
    WMReviewPraiseHateStateUnknown = 0,
    WMReviewPraiseHateStateLike = 10,  ///< 赞
    WMReviewPraiseHateStateUnlike = 11 ///< 踩
};

/// 评论是否匿名
typedef NS_ENUM(NSUInteger, WMReviewAnonymousState) {
    WMReviewAnonymousStateUnknown = 0,
    WMReviewAnonymousStateTrue = 10, ///< 匿名
    WMReviewAnonymousStateFalse = 11 ///< 不匿名
};

/// 优惠券类型
typedef NS_ENUM(NSUInteger, WMCouponType) {
    WMCouponTypeVoucher = 0,  ///现金券
    WMCouponTypeShipping = 1, ///运费券
};

/// 评论实体类型
typedef NSString *WMReviewEntityType NS_STRING_ENUM;

FOUNDATION_EXPORT WMReviewEntityType const WMReviewEntityTypeOrder; ///< 订单

/// 评论筛选类型
typedef NSString *WMReviewFilterType NS_STRING_ENUM;

FOUNDATION_EXPORT WMReviewFilterType const WMReviewFilterTypeAll;       ///< 所有
FOUNDATION_EXPORT WMReviewFilterType const WMReviewFilterTypeGood;      ///< 好评
FOUNDATION_EXPORT WMReviewFilterType const WMReviewFilterTypeMiddle;    ///< 中评
FOUNDATION_EXPORT WMReviewFilterType const WMReviewFilterTypeBad;       ///< 差评
FOUNDATION_EXPORT WMReviewFilterType const WMReviewFilterTypeWithImage; ///< 带图
FOUNDATION_EXPORT WMReviewFilterType const WMReviewFilterTypeLike;      ///< 点赞
FOUNDATION_EXPORT WMReviewFilterType const WMReviewFilterTypeUnlike;    ///< 点踩

/// 评论筛选条件：是否必须有内容
typedef NSString *WMReviewFilterConditionHasDetail NS_STRING_ENUM;

FOUNDATION_EXPORT WMReviewFilterConditionHasDetail const WMReviewFilterConditionHasDetailRequired; ///< 必须有评论
FOUNDATION_EXPORT WMReviewFilterConditionHasDetail const WMReviewFilterConditionHasDetailOrNone;   ///< 有无评论均可
FOUNDATION_EXPORT WMReviewFilterConditionHasDetail const WMReviewFilterConditionHasDetailNone;     ///< 无评论

/// 优惠活动优惠时间段类型
typedef NS_ENUM(NSUInteger, WMPreferentionTimeType) {
    WMPreferentionTimeTypeUnknown = 0,
    WMPreferentionTimeTypeAll = 10,     ///< 任意时间
    WMPreferentionTimeTypeInterval = 11 ///< 部分时间
};

/// 订单配送时间类型
typedef NSString *WMOrderDeliveryTimeType NS_STRING_ENUM;

FOUNDATION_EXPORT WMOrderDeliveryTimeType const WMOrderDeliveryTimeTypeRightNow;  ///< 立即送出
FOUNDATION_EXPORT WMOrderDeliveryTimeType const WMOrderDeliveryTimeTypeSubscribe; ///< 预约

/// 订单可用付款方式
typedef NSString *WMOrderAvailablePaymentType NS_STRING_ENUM;

FOUNDATION_EXPORT WMOrderAvailablePaymentType const WMOrderAvailablePaymentTypeOnline;  ///< 在线付款
FOUNDATION_EXPORT WMOrderAvailablePaymentType const WMOrderAvailablePaymentTypeOffline; ///< 线下付款

///外卖专题活动类型
typedef NSString *WMSpecialActiveType NS_STRING_ENUM;
FOUNDATION_EXPORT WMSpecialActiveType const WMSpecialActiveTypeImage;   ///< 图片专题
FOUNDATION_EXPORT WMSpecialActiveType const WMSpecialActiveTypeStore;   ///< 门店专题
FOUNDATION_EXPORT WMSpecialActiveType const WMSpecialActiveTypeProduct; ///< 商品专题
FOUNDATION_EXPORT WMSpecialActiveType const WMSpecialActiveTypeBrand;   ///< 品牌专题
FOUNDATION_EXPORT WMSpecialActiveType const WMSpecialActiveTypeEat;     ///< 按时吃饭
/// 门店可用付款方式
typedef NSString *WMStoreSupportedPaymentType NS_STRING_ENUM;

FOUNDATION_EXPORT WMStoreSupportedPaymentType const WMStoreSupportedPaymentTypeOnline;  ///< 在线付款
FOUNDATION_EXPORT WMStoreSupportedPaymentType const WMStoreSupportedPaymentTypeOffline; ///< 线下付款

typedef NSString *WMThemeType NS_STRING_ENUM;
///< 品牌主题
FOUNDATION_EXPORT WMThemeType const WMThemeTypeMerchant;
///< 门店主题
FOUNDATION_EXPORT WMThemeType const WMThemeTypeStore;
///< 商品主题
FOUNDATION_EXPORT WMThemeType const WMThemeTypeProduct;

typedef NSString *WMHomeAdviseType NS_STRING_ENUM;
///< 焦点广告
FOUNDATION_EXPORT WMHomeAdviseType const WMHomeFoucsAdviseType;
///< 轮播广告
FOUNDATION_EXPORT WMHomeAdviseType const WMHomeCarouselAdviseType;
///< 附近门店广告
FOUNDATION_EXPORT WMHomeAdviseType const WMHomeNearStoreAdviseType;
///< 顶部快捷选项
FOUNDATION_EXPORT WMHomeAdviseType const WMHomeTopShortcutOptions;

typedef NSString *WMHomeLayoutType NS_STRING_ENUM;
///< 焦点广告
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeFoucsAdvertise;
///< 轮播广告
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeCarouselAdvertise;
///< 门店穿插广告
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeNearStoreAdvertise;
///< 金刚区
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeKingKong;
///< 顶部快捷选项
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeTopShortcutOptions;
///< 按时吃饭
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeEatOnTime;
///< 商家主题
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeMerchantTheme;
///< 门店主题
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeStoreTheme;
///< 商品主题
FOUNDATION_EXPORT WMHomeLayoutType const WMHomeLayoutTypeProductTheme;

///首页通知频率
typedef NSString *WMHomeNoticeFrequencyType NS_STRING_ENUM;
///每天一次
FOUNDATION_EXPORT WMHomeNoticeFrequencyType const WMHomeNoticeFrequencyTypeDaily;
///用户每次下拉首页显示
FOUNDATION_EXPORT WMHomeNoticeFrequencyType const WMHomeNoticeFrequencyTypePullDown;
///用户每次进入首页显示
FOUNDATION_EXPORT WMHomeNoticeFrequencyType const WMHomeNoticeFrequencyTypeEnterHome;

///首页通知类型
typedef NSString *WMHomeNoticeType NS_STRING_ENUM;
///配送类
FOUNDATION_EXPORT WMHomeNoticeType const WMHomeNoticeTypeDelivery;
///营销类
FOUNDATION_EXPORT WMHomeNoticeType const WMHomeNoticeTypePromo;

///搜索类型
typedef NSString *WMSearchType NS_STRING_ENUM;
///搜索门店
FOUNDATION_EXPORT WMSearchType const WMSearchTypeStore;
///搜索商品
FOUNDATION_EXPORT WMSearchType const WMSearchTypeProduct;

typedef NSString *WMCallPhoneType NS_STRING_ENUM;
/// telegram
FOUNDATION_EXPORT WMCallPhoneType const WMCallPhoneTypeTelegram;
/// 打电话
FOUNDATION_EXPORT WMCallPhoneType const WMCallPhoneTypeCall;
/// 联系客服
FOUNDATION_EXPORT WMCallPhoneType const WMCallPhoneTypeServer;
/// 联系骑手
FOUNDATION_EXPORT WMCallPhoneType const WMCallPhoneTypeServerRider;
/// 联系门店
FOUNDATION_EXPORT WMCallPhoneType const WMCallPhoneTypeServerStore;
/// 在线沟通
FOUNDATION_EXPORT WMCallPhoneType const WMCallPhoneTypeOnline;

typedef NSString *WMBusinessType NS_STRING_ENUM;
/// 扫码点餐
FOUNDATION_EXPORT WMBusinessType const WMBusinessTypeDigitelMenu;

///领取优惠券结果类型
typedef NSString *WMGiveCouponResult NS_STRING_ENUM;
/// 全部成功
FOUNDATION_EXPORT WMGiveCouponResult const WMGiveCouponResultAllSuccess;
/// 部分成功
FOUNDATION_EXPORT WMGiveCouponResult const WMGiveCouponResultPartSuccess;
/// 全部失败
FOUNDATION_EXPORT WMGiveCouponResult const WMGiveCouponResultAllFail;

///领取优惠券错误类型
typedef NSString *WMGiveCouponError NS_STRING_ENUM;
///用户未登录
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorLogin;
///活动信息发生变更
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorActivityChange;
///券已抢光
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorGiveOver;
///发券失败
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorSendFail;
///达到今日领券上限
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorDayLimit;
///达到活动领券上限
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorActivityLimit;
///活动已经结束
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorActitityEnd;
///优惠券已过期
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorCouponEnd;
///优惠券信息发生变更
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorCouponChange;
///正在领券中
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorGiving;
///找不到优惠券
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorNotFound;
///找不到活动
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorActivityNotFound;
///找不到用户
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorUserNotFound;
///未达到领用资格
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorNotReceive;
///领用时发生异常
FOUNDATION_EXPORT WMGiveCouponError const WMGiveCouponErrorReceiveCash;

///不可用券原因
typedef NSString *WMUnUseCouponReasonType NS_STRING_ENUM;
/// 未达到门槛
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponThreshold;
/// 账号有风险
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponAccountRisk;
/// 包含优惠商品，不可与优惠券叠加使用
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponStackVoucher;
/// 优惠券未到生效时间
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponEffective;
/// 该门店不能使用该优惠券
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponStore;
/// 不能与优惠码同享
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponStackProCode;
/// 不能与运费券同享
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponStackShipping;
/// 不能与门店优惠券同享
FOUNDATION_EXPORT WMUnUseCouponReasonType const WMUnUseCouponStackStoreCoupon;

/// 反馈进度
typedef NSString *WMOrderFeedBackHandleStatus NS_STRING_ENUM;
///待处理
FOUNDATION_EXPORT WMOrderFeedBackHandleStatus const WMOrderFeedBackHandleWait;
///处理中
FOUNDATION_EXPORT WMOrderFeedBackHandleStatus const WMOrderFeedBackHandlePending;
///已完成
FOUNDATION_EXPORT WMOrderFeedBackHandleStatus const WMOrderFeedBackHandleFinish;
///已驳回
FOUNDATION_EXPORT WMOrderFeedBackHandleStatus const WMOrderFeedBackHandleReject;

///期望处理方式进度
typedef NSString *WMOrderFeedBackStepShowType NS_STRING_ENUM;
///无
FOUNDATION_EXPORT WMOrderFeedBackStepShowType const WMOrderFeedBackStepNone;
///反馈进度
FOUNDATION_EXPORT WMOrderFeedBackStepShowType const WMOrderFeedBackStepProgress;
///反馈结果
FOUNDATION_EXPORT WMOrderFeedBackStepShowType const WMOrderFeedBackStepResult;

///期望处理方式
typedef NSString *WMOrderFeedBackPostShowType NS_STRING_ENUM;
///换货
FOUNDATION_EXPORT WMOrderFeedBackPostShowType const WMOrderFeedBackPostChange;
///退款
FOUNDATION_EXPORT WMOrderFeedBackPostShowType const WMOrderFeedBackPostRefuse;
///其他诉求
FOUNDATION_EXPORT WMOrderFeedBackPostShowType const WMOrderFeedBackPostOther;

/// 外卖来源类型
typedef NSString *WMSourceType NS_STRING_ENUM;
/// 首页
FOUNDATION_EXPORT WMSourceType const WMSourceTypeHome;
/// 分类
FOUNDATION_EXPORT WMSourceType const WMSourceTypeCategory;
///全部分类
FOUNDATION_EXPORT WMSourceType const WMSourceTypeAllCategory;
///品牌专题
FOUNDATION_EXPORT WMSourceType const WMSourceTypeTopicsBrands;
///商品专题
FOUNDATION_EXPORT WMSourceType const WMSourceTypeTopicsProduct;
///门店专题
FOUNDATION_EXPORT WMSourceType const WMSourceTypeTopicsStore;
///按时吃饭
FOUNDATION_EXPORT WMSourceType const WMSourceTypeTopicsEat;
///搜索
FOUNDATION_EXPORT WMSourceType const WMSourceTypeSearch;
///其他
FOUNDATION_EXPORT WMSourceType const WMSourceTypeOther;
///无
FOUNDATION_EXPORT WMSourceType const WMSourceTypeNone;
///门店详情
FOUNDATION_EXPORT WMSourceType const WMSourceTypeStoreDetail;

/// 门店商品活动限制
typedef NS_ENUM(NSUInteger, WMStoreGoodsPromotionLimitType) {
    ///< 无限制
    WMStoreGoodsPromotionLimitTypeNone = 10,
    ///< 常规
    WMStoreGoodsPromotionLimitTypeNormal = 11,
    ///< 爆款
    WMStoreGoodsPromotionLimitTypeHot = 12,
    ///< 特价商品（秒杀商品、爆款，不知道具体叫啥名。。）
    WMStoreGoodsPromotionLimitTypeBestSale = 13,
    ///< 按订单前几件商品限制
    WMStoreGoodsPromotionLimitTypeOrderProNum = 14,
    ///< 按每天每种商品限制
    WMStoreGoodsPromotionLimitTypeDayProNum = 15,
    ///< 按活动全部商品前几件限制
    WMStoreGoodsPromotionLimitTypeActivityTotalNum = 16,
};

/// 门店商品优惠模式
typedef NS_ENUM(NSUInteger, WMStoreGoodsPromotionMode) {
    WMStoreGoodsPromotionModeDiscount = 10, ///< 折扣
    WMStoreGoodsPromotionModeSale = 20,     ///< 减价
    WMStoreGoodsPromotionModeHot = 30,      ///< 爆品
};

/// 从哪个页面进入的下单页
typedef NS_ENUM(NSUInteger, WMOrderSubmitFrom) {
    WMOrderSubmitFromStore = 0,        ///< 门店页进入
    WMOrderSubmitFromShoppingCart = 1, ///< 购物车进入
};

/// 商品归属类型
typedef NS_ENUM(NSUInteger, WMGoodsCommodityType) {
    WMGoodsCommodityTypeNormal = 0, ///< 普通商品
    WMGoodsCommodityTypeGift = 10,  ///< 赠品
};

/// 爆单状态
typedef NS_ENUM(NSUInteger, WMStoreFullOrderState) {
    WMStoreFullOrderStateNormal = 10,      ///< 正常
    WMStoreFullOrderStateFull = 20,        ///< 爆单
    WMStoreFullOrderStateFullAndStop = 30, ///< 爆单停止接单
};

/// 出餐状态
typedef NS_ENUM(NSUInteger, WMStoreSlowMealState) {
    WMStoreSlowMealStateNormal = 10, ///< 正常
    WMStoreSlowMealStateSlow = 20,   ///< 出餐慢
};

///优惠券活动有效时长
typedef NS_ENUM(NSUInteger, WMStoreCouponEffectiveType) {
    WMStoreCouponEffectiveFixedDate = 10,      ///< 固定日期区间
    WMStoreCouponEffectiveFixedDuration = 11,  ///< 固定时长
    WMStoreCouponEffectiveFixedPerPetual = 12, ///< 永久有效
};

/// 修改地址订单状态
typedef NS_ENUM(NSUInteger, WMModifyOrderType) {
    WMModifyOrderSuccess = 10, ///< 修改成功
    WMModifyOrderIng = 11,     ///< 修改中
    WMModifyOrderCancel = 12,  ///< 修改取消
    WMModifyOrderUnKnown = 13, ///< 可修改
};

/// 订单详情修改地址状态
typedef NS_ENUM(NSUInteger, WMOrderUpdateAddressStatus) {
    WMOrderModifyCANNOT = 10,  ///< 无法修改
    WMOrderModifyING = 11,     ///< 修改中
    WMOrderModifySuccess = 12, ///< 修改成功
    WMOrderModifyCAN = 13,     ///< 可修改
};

/// 修改地址付款
typedef NS_ENUM(NSUInteger, WMModifyOrderPayType) {
    WMModifyOrderPayUn = 10,     ///< 未付款
    WMModifyOrderPayfinish = 20, ///< 已付款
};

/// 顶部提示类型
typedef NS_ENUM(NSUInteger, WMTopViewStyle) {
    WMTopViewStyleEvaluation = 0, ///<评价
    WMTopViewStyleEvaluationOnlyStore = 1, ///<仅商家评价
};
NS_ASSUME_NONNULL_END
