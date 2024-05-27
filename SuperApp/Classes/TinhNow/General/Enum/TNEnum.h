//
//  TNEnum.h
//  SuperApp
//
//  Created by seeu on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef TNEnum_h
#define TNEnum_h

///商品类型
typedef NSString *TNGoodsType NS_STRING_ENUM;
FOUNDATION_EXPORT TNGoodsType const TNGoodsTypeGeneral;  ///< 普通商品
FOUNDATION_EXPORT TNGoodsType const TNGoodsTypeExchange; ///< 兑换商品
FOUNDATION_EXPORT TNGoodsType const TNGoodsTypeGift;     ///< 赠品
FOUNDATION_EXPORT TNGoodsType const TNGoodsTypeActivity; ///< 促销活动商品
FOUNDATION_EXPORT TNGoodsType const TNGoodsTypeOverseas; ///< 海外购商品

///订单类型
typedef NSString *TNOrderType NS_STRING_ENUM;
FOUNDATION_EXPORT TNOrderType const TNOrderTypeGeneral;     ///< 普通订单
FOUNDATION_EXPORT TNOrderType const TNOrderTypeExchange;    ///< 兑换订单
FOUNDATION_EXPORT TNOrderType const TNOrderTypeBargain;     ///< 砍价订单
FOUNDATION_EXPORT TNOrderType const TNOrderTypeGroupon;     ///< 拼团订单
FOUNDATION_EXPORT TNOrderType const TNOrderTypePanicBuying; ///< 抢购订单
FOUNDATION_EXPORT TNOrderType const TNOrderTypeSeckill;     ///<秒杀订单
FOUNDATION_EXPORT TNOrderType const TNOrderTypeOverseas;    ///< 海外购订单

///店铺类型
typedef NSString *TNStoreType NS_STRING_ENUM;
FOUNDATION_EXPORT TNStoreType const TNStoreTypeGeneral;          ///< 普通店铺
FOUNDATION_EXPORT TNStoreType const TNStoreTypeSelf;             ///< 商家经营店铺
FOUNDATION_EXPORT TNStoreType const TNStoreTypePlatfromSelf;     ///< 平台直营店铺
FOUNDATION_EXPORT TNStoreType const TNStoreTypeOverseasShopping; ///< 海外购店铺

///店铺标签 显示
typedef NSString *TNStoreTag NS_STRING_ENUM;
FOUNDATION_EXPORT TNStoreTag const TNStoreTagGlobal; ///< 海外购店铺

typedef NSString *TNGoodsListSortType NS_STRING_ENUM;
FOUNDATION_EXPORT TNGoodsListSortType const TNGoodsListSortTypeTopDesc;   ///< 置顶降序
FOUNDATION_EXPORT TNGoodsListSortType const TNGoodsListSortTypePriceAsc;  ///< 价格升序
FOUNDATION_EXPORT TNGoodsListSortType const TNGoodsListSortTypePriceDesc; ///< 价格降序
FOUNDATION_EXPORT TNGoodsListSortType const TNGoodsListSortTypeSalesDesc; ///< 销量降序
FOUNDATION_EXPORT TNGoodsListSortType const TNGoodsListSortTypeScoreDesc; ///< 评分降序
FOUNDATION_EXPORT TNGoodsListSortType const TNGoodsListSortTypeDateDesc;  ///< 日期降序
FOUNDATION_EXPORT TNGoodsListSortType const TNGoodsListSortTypeDefault;   ///<默认

typedef NSString *TNStoreState NS_STRING_ENUM;
FOUNDATION_EXPORT TNStoreState const TNStoreStateOpen;  ///< 营业中
FOUNDATION_EXPORT TNStoreState const TNStoreStateRest;  ///< 休息中
FOUNDATION_EXPORT TNStoreState const TNStoreStateClose; ///< 已停业

typedef NSString *TNPaymentMethod NS_STRING_ENUM;
FOUNDATION_EXPORT TNPaymentMethod const TNPaymentMethodOnLine;   ///线上支付
FOUNDATION_EXPORT TNPaymentMethod const TNPaymentMethodOffLine;  /// 线下支付
FOUNDATION_EXPORT TNPaymentMethod const TNPaymentMethodTransfer; ///< 转账付款

typedef NSString *TNOrderState NS_STRING_ENUM;
FOUNDATION_EXPORT TNOrderState const TNOrderStatePendingPayment;  ///< 等待付款
FOUNDATION_EXPORT TNOrderState const TNOrderStatePendingReview;   ///<  等待审核
FOUNDATION_EXPORT TNOrderState const TNOrderStatePendingShipment; ///<  等待发货
FOUNDATION_EXPORT TNOrderState const TNOrderStateShipped;         ///<  已发货
FOUNDATION_EXPORT TNOrderState const TNOrderStateReceived;        ///<  已收货
FOUNDATION_EXPORT TNOrderState const TNOrderStateCompleted;       ///<  已完成
FOUNDATION_EXPORT TNOrderState const TNOrderStateFailed;          ///<  已失败
FOUNDATION_EXPORT TNOrderState const TNOrderStateCanceled;        ///<  已取消
FOUNDATION_EXPORT TNOrderState const TNOrderStateDenied;          ///<  已拒绝

typedef NSString *TNMarketingType NS_STRING_ENUM;
FOUNDATION_EXPORT TNMarketingType const TNMarketingTypeFeeReduce;     ///< 减配送费
FOUNDATION_EXPORT TNMarketingType const TNMarketingTypeFullReduction; ///< 满减活动
FOUNDATION_EXPORT TNMarketingType const TNMarketingTypeTypeDiscount;  ///< 折扣活动

typedef NSString *TNCategoryType NS_STRING_ENUM;
FOUNDATION_EXPORT TNCategoryType const TNCategoryTypeGoods; ///<分类商品
FOUNDATION_EXPORT TNCategoryType const TNCategoryTypeBrand; ///< 分类品牌

typedef NSString *TNProductCategoryScene NS_STRING_ENUM;
FOUNDATION_EXPORT TNProductCategoryScene const TNProductCategorySceneAll;          ///<全部一级分类
FOUNDATION_EXPORT TNProductCategoryScene const TNProductCategorySceneBargainList;  ///< 砍价活动列表一级分类
FOUNDATION_EXPORT TNProductCategoryScene const TNProductCategorySceneGroupList;    ///< 拼团活动列表一级分类
FOUNDATION_EXPORT TNProductCategoryScene const TNProductCategorySceneGoodsSpecial; ///< 商品专题一级分类

typedef NSString *TNDeliveryCorpCode NS_STRING_ENUM;
FOUNDATION_EXPORT TNDeliveryCorpCode const TNDeliveryCorpCodeCE;     /// CE物流代码
FOUNDATION_EXPORT TNDeliveryCorpCode const TNDeliveryCorpCodeYumnow; ///外卖骑手

typedef NSString *TNPaymentWayCode NS_STRING_ENUM;
FOUNDATION_EXPORT TNPaymentWayCode const TNPaymentWayCodeBank;  ///<银行卡
FOUNDATION_EXPORT TNPaymentWayCode const TNPaymentWayCodeThird; ///< 第三方支付
FOUNDATION_EXPORT TNPaymentWayCode const TNPaymentWayCodeCash;  ///< 现金

/// 电商埋点前缀
typedef NSString *TNTrackEventPrefixName NS_STRING_ENUM;
FOUNDATION_EXPORT TNTrackEventPrefixName const TNTrackEventPrefixNameOverseas;    ///<【电商-海外购】
FOUNDATION_EXPORT TNTrackEventPrefixName const TNTrackEventPrefixNameFastConsume; ///< 【电商-快消品】
FOUNDATION_EXPORT TNTrackEventPrefixName const TNTrackEventPrefixNameOther;       ///< 【电商-其它】

typedef NSString *TNSalesType NS_STRING_ENUM;
FOUNDATION_EXPORT TNSalesType const TNSalesTypeSingle; /// 单买
FOUNDATION_EXPORT TNSalesType const TNSalesTypeBatch;  ///批量

// 店铺类型下标枚举值
typedef NS_ENUM(NSUInteger, TNStoreEnumType) {
    //普通或商家经营
    TNStoreEnumTypeGenneral = 0,
    //平台直营
    TNStoreEnumTypeSelf = 2,
    //海外购
    TNStoreEnumTypeOverseasShopping = 3
};

// 退款状态
typedef NS_ENUM(NSUInteger, TNOrderRefundStatus) {
    //待审核
    TNOrderRefundStatusReview = 0,
    //待退款
    TNOrderRefundStatusWaitRefund = 1,
    //退款完成
    TNOrderRefundStatusCompleted = 2,
    //退款关闭
    TNOrderRefundStatusClosed = 3,
};

// 商品状态
typedef NS_ENUM(NSUInteger, TNStoreItemState) {
    //在售
    TNStoreItemStateOnSale = 10,
    //下架
    TNStoreItemStateOffSale = 11
};
/// 砍价商品状态
typedef NS_ENUM(NSUInteger, TNBargainGoodStatus) {
    ///进行中
    TNBargainGoodStatusOngoing = 1,
    ///助力成功
    TNBargainGoodStatusSuccess = 2,
    ///助力失败
    TNBargainGoodStatusFailure = 3
};
///商品类型  0 普通 1 拼团 2 助力
typedef NS_ENUM(NSUInteger, TNProductType) {
    TNProductTypeAll = -1, //全部默认
    TNProductTypeNomal = 0,
    TNProductTypeBargain = 2,
    TNProductTypeGroup = 1
};
/// 分享场景类型
typedef NS_ENUM(NSUInteger, TNShareType) {
    ///默认
    TNShareTypeDefault = -1,
    ///砍价列表页
    TNShareTypeBargainList = 1000,
    ///邀请砍价页  也即是砍价任务详情页
    TNShareTypeBargainInvite = 1002,
};

/// 砍价任务类型
typedef NS_ENUM(NSUInteger, TNBargainTaskType) {
    ///助力大挑战
    TNBargainTaskTypeBigChallenge = 0,
    ///普通砍价任务
    TNBargainTaskTypeNomal = 1,
    ///指定成单任务
    TNBargainTaskTypeSpecified = 2,
};

// 商品购买类型
typedef NS_ENUM(NSUInteger, TNProductBuyType) {
    ///立即购买
    TNProductBuyTypeBuyNow = 0,
    ///加入购物车
    TNProductBuyTypeAddCart = 1
};

// 商品销售区域类型
typedef NS_ENUM(NSUInteger, TNRegionType) {
    ///全国
    TNRegionTypeAllArea = 0,
    ///指定区域
    TNRegionTypeSpecifiedArea = 1,
    ///指定范围  一般是几公里内
    TNRegionTypeSpecifiedRange = 2
};

// 商品详情类型
typedef NS_ENUM(NSUInteger, TNProductDetailViewType) {
    ///普通商品详情
    TNProductDetailViewTypeNomal = 0,
    ///砍价商品详情
    TNProductDetailViewTypeBargain = 1,
    ///供销店商品详情  用来选品 或者已经加入微店的  详情
    TNProductDetailViewTypeSupplyAndMarketing = 2,
    ///微店商品详情  用户查看别人家微店商品的详情
    TNProductDetailViewTypeMicroShop = 3,
};

// 卖家当时的类型 1：普通卖家、2：兼职卖家
typedef NS_ENUM(NSUInteger, TNSellerIdentityType) {
    ///普通卖家
    TNSellerIdentityTypeNormal = 1,
    ///兼职卖家
    TNSellerIdentityTypePartTime = 2
};

/// 搜索范围
typedef NS_ENUM(NSUInteger, TNSearchScopeType) {
    ///全部商城
    TNSearchScopeTypeAllMall = 0,
    ///专题
    TNSearchScopeTypeSpecial = 1,
    ///店铺
    TNSearchScopeTypeStore = 2
};

/// 订单预约送达类型
typedef NS_ENUM(NSUInteger, TNOrderAppointmentType) {
    ///默认的
    TNOrderAppointmentTypeDefault = 0,
    ///立即送达
    TNOrderAppointmentTypeImmediately = 1,
    ///预约
    TNOrderAppointmentTypeReserve = 2
};

#endif /* TNEnum_h */

//* PENDING_PAYMENT：等待付款,
//* PENDING_REVIEW：等待审核,
//* PENDING_SHIPMENT：等待发货,
//* SHIPPED：已发货,
//* RECEIVED：已收货,
//* COMPLETED：已完成,
//* FAILED：已失败,
//* CANCELED：已取消,
//* DENIED：已拒绝
