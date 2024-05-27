//
//  GNEnum.h
//  SuperApp
//
//  Created by wmz on 2021/6/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface GNEnum : NSObject

///继承BaseOrder页面来源
typedef enum : NSInteger {
    ///提交订单
    GNOrderFromSubmit = 1,
    ///团购订单列表
    GNOrderFromGNList = 2,
    ///订单详情
    GNOrderFromDetail = 3,
    ///订单结果
    GNOrderFromResult = 4,
} GNOrderFromType;

///获取接口状态
typedef enum : NSInteger {
    ///成功
    GNRequestTypeSuccess = 1,
    ///失败
    GNRequestTypeBad = 2,
    ///数据异常
    GNRequestTypeDataError = 3,
    ///没有数据
    GNRequestTypeDataNone = 4,
} GNRequestType;

/// 限购类型
typedef NS_ENUM(NSUInteger, GNHomePurchaseRestrictionsType) {
    ///限购
    GNHomePurchaseRestrictionsTypeCan = 1,
    ///不限购
    GNHomePurchaseRestrictionsTypeNot = 2,
};

/// 分享类型
typedef NS_ENUM(NSUInteger, GNShareViewType) {
    ///门店分享
    GNShareViewTypeStore = 1,
    ///商品分享
    GNShareViewTypeProduct = 2,
};

///订单状态类型
typedef NSString *GNOrderStatus NS_STRING_ENUM;
FOUNDATION_EXPORT GNOrderStatus const GNOrderStatusAll;    ///< 全部
FOUNDATION_EXPORT GNOrderStatus const GNOrderStatusUse;    ///< 待使用
FOUNDATION_EXPORT GNOrderStatus const GNOrderStatusFinish; ///< 已完成
FOUNDATION_EXPORT GNOrderStatus const GNOrderStatusCancel; ///< 已取消
FOUNDATION_EXPORT GNOrderStatus const GNOrderStatusUnPay;  ///< 待支付
/// 门店状态
typedef NSString *GNStoreStatus NS_STRING_ENUM;
FOUNDATION_EXPORT GNStoreStatus const GNStoreStatusOpening; ///< 已入场
FOUNDATION_EXPORT GNStoreStatus const GNMStoreStatusClosed; ///< 已离场
FOUNDATION_EXPORT GNStoreStatus const GNStoreStatusReady;   ///< 准备中

/// 门店营业状态
typedef NSString *GNStoreBusnessType NS_STRING_ENUM;
FOUNDATION_EXPORT GNStoreBusnessType const GNStoreBusnessTypeOpen;   ///< 营业
FOUNDATION_EXPORT GNStoreBusnessType const GNStoreBusnessTypeClosed; ///< 停业

/// 门店状态 GNStoreStatus + GNStoreBusnessType
typedef NSString *GNStoreCheckStatus NS_STRING_ENUM;
FOUNDATION_EXPORT GNStoreCheckStatus const GNStoreCheckStatusOpen;   ///< 营业
FOUNDATION_EXPORT GNStoreCheckStatus const GNStoreCheckStatusClosed; ///< 停业

/// 操作核销状态
typedef NSString *GNVerificationState NS_STRING_ENUM;
FOUNDATION_EXPORT GNVerificationState const GNVerificationStateUse;    ///< 待核销
FOUNDATION_EXPORT GNVerificationState const GNVerificationStateIng;    ///< 核销中
FOUNDATION_EXPORT GNVerificationState const GNVerificationStateFinish; ///< 核销完成
FOUNDATION_EXPORT GNVerificationState const GNVerificationStateSome;   ///< 部分核销完成

/// 券码核销状态
typedef NSString *GNOrderCodeState NS_STRING_ENUM;
FOUNDATION_EXPORT GNOrderCodeState const GNOrderCodeStateUse;    ///< 未使用
FOUNDATION_EXPORT GNOrderCodeState const GNOrderCodeStateFinish; ///< 已使用
FOUNDATION_EXPORT GNOrderCodeState const GNOrderCodeStateCancel; ///< 已取消
FOUNDATION_EXPORT GNOrderCodeState const GNOrderCodeStateUnPay;  ///< 待付款

/// 产品状态
typedef NSString *GNProductStatus NS_STRING_ENUM;
FOUNDATION_EXPORT GNProductStatus const GNProductStatusUp;   ///< 上架
FOUNDATION_EXPORT GNProductStatus const GNProductStatusDown; ///< 下架

/// 产品状态
typedef NSString *GNProductType NS_STRING_ENUM;
FOUNDATION_EXPORT GNProductType const GNProductTypeP1; ///< 常规：GP001
FOUNDATION_EXPORT GNProductType const GNProductTypeP2; ///< 代金券：GP002

/// 订单取消原因
typedef NSString *GNOrderCancelType NS_STRING_ENUM;
FOUNDATION_EXPORT GNOrderCancelType const GNOrderCancelTypeUser;  ///< 客户终止订单
FOUNDATION_EXPORT GNOrderCancelType const GNOrderCancelTypeTime;  ///< 过期自动取消
FOUNDATION_EXPORT GNOrderCancelType const GNOrderCancelTypeUnPay; ///< 超时未支付

/// 支付方式
typedef NSString *GNPayMetnodType NS_STRING_ENUM;
FOUNDATION_EXPORT GNPayMetnodType const GNPayMetnodTypeAll;    ///< 全部
FOUNDATION_EXPORT GNPayMetnodType const GNPayMetnodTypeOnline; ///< 线上支付
FOUNDATION_EXPORT GNPayMetnodType const GNPayMetnodTypeCash;   ///< 到店付款

/// 支付错误码
typedef NSString *GNPayErrorType NS_STRING_ENUM;
FOUNDATION_EXPORT GNPayErrorType const GNPayErrorTypeChange;    ///< 商品商家等信息发生了改变
FOUNDATION_EXPORT GNPayErrorType const GNPayErrorTypeProductUp; ///< 商品已下架
FOUNDATION_EXPORT GNPayErrorType const GNPayErrorTypeSolded;    ///< 已售罄

///退款状态
typedef NSString *GNOrderRefundStatus NS_STRING_ENUM;
FOUNDATION_EXPORT GNOrderRefundStatus const GNOrderRefundStatusWait;   ///< 待退款
FOUNDATION_EXPORT GNOrderRefundStatus const GNOrderRefundStatusIng;    ///< 退款中
FOUNDATION_EXPORT GNOrderRefundStatus const GNOrderRefundStatusFinidh; ///< 已退款

typedef NSString *GNRefundWayType NS_STRING_ENUM;
FOUNDATION_EXPORT GNRefundWayType const GNRefundWayOnline;  ///< 原路退回
FOUNDATION_EXPORT GNRefundWayType const GNRefundWayOffline; ///< 线下退款

typedef NSString *GNHomeLayoutType NS_STRING_ENUM;
///< 轮播广告
FOUNDATION_EXPORT GNHomeLayoutType const GNHomeLayoutTypeCarouselAdvertise;
///< 金刚区
FOUNDATION_EXPORT GNHomeLayoutType const GNHomeLayoutTypeKingKong;

///栏目类型
typedef NSString *GNHomeColumnType NS_STRING_ENUM;
///< 商家
FOUNDATION_EXPORT GNHomeColumnType const GNHomeColumnMerchant;
///< 文章
FOUNDATION_EXPORT GNHomeColumnType const GNHomeColumnAricle;
///< 推荐
FOUNDATION_EXPORT GNHomeColumnType const GNHomeColumnRecommend;

///首页排序类型
typedef NSString *GNHomeSortType NS_STRING_ENUM;
///< 默认排序
FOUNDATION_EXPORT GNHomeColumnType const GNHomeSortDefault;
///< 销量排序
FOUNDATION_EXPORT GNHomeColumnType const GNHomeSortSales;
///< 评分排序
FOUNDATION_EXPORT GNHomeColumnType const GNHomeSortScore;
///< 距离排序
FOUNDATION_EXPORT GNHomeColumnType const GNHomeSortDistance;
///< 价格排序
FOUNDATION_EXPORT GNHomeColumnType const GNHomeSortPrice;
///< 置顶排序
FOUNDATION_EXPORT GNHomeColumnType const GNHomeSortTop;
///< 发布时间排序
FOUNDATION_EXPORT GNHomeColumnType const GNHomeSortCreate;

///文章绑定类型
typedef NSString *GNHomeArticleBindType NS_STRING_ENUM;
///< 商品
FOUNDATION_EXPORT GNHomeArticleBindType const GNHomeArticleBindProduct;
///< 门店
FOUNDATION_EXPORT GNHomeArticleBindType const GNHomeArticleBindStore;
///< 专题
FOUNDATION_EXPORT GNHomeArticleBindType const GNHomeArticleBindTopic;
///< 链接
FOUNDATION_EXPORT GNHomeArticleBindType const GNHomeArticleBindURL;
///< app内部其他链接
FOUNDATION_EXPORT GNHomeArticleBindType const GNHomeArticleBindOther;

@end

NS_ASSUME_NONNULL_END
