//
//  GNEnum.m
//  SuperApp
//
//  Created by wmz on 2021/6/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNEnum.h"


@implementation GNEnum

/// 订单状态
GNOrderStatus const GNOrderStatusAll = @"";      ///< 全部
GNOrderStatus const GNOrderStatusUse = @"10";    ///< 待使用
GNOrderStatus const GNOrderStatusFinish = @"20"; ///< 已完成
GNOrderStatus const GNOrderStatusCancel = @"30"; ///< 已取消
GNOrderStatus const GNOrderStatusUnPay = @"40";  ///< 待付款
/// 核销状态
GNOrderStatus const GNVerificationStateUse = @"10";    ///< 待核销
GNOrderStatus const GNVerificationStateIng = @"20";    ///< 核销中
GNOrderStatus const GNVerificationStateFinish = @"30"; ///< 核销完成
GNOrderStatus const GNVerificationStateSome = @"40";   ///< 部分核销完成

/// 门店状态
GNStoreStatus const GNStoreStatusOpening = @"GS001"; ///< 已入场
GNStoreStatus const GNMStoreStatusClosed = @"GS002"; ///< 已离场
GNStoreStatus const GNStoreStatusReady = @"GS003";   ///< 准备中

/// 产品状态
GNProductStatus const GNProductStatusUp = @"GS001";   ///< 上架
GNProductStatus const GNProductStatusDown = @"GS002"; ///< 下架

/// 产品状态
GNProductType const GNProductTypeP1 = @"GP001"; ///<  常规：GP001
GNProductType const GNProductTypeP2 = @"GP002"; ///< 代金券：GP002

/// 券码核销状态
GNOrderCodeState const GNOrderCodeStateUse = @"10";    ///< 未使用
GNOrderCodeState const GNOrderCodeStateFinish = @"20"; ///< 已使用
GNOrderCodeState const GNOrderCodeStateCancel = @"30"; ///< 已取消
GNOrderCodeState const GNOrderCodeStateUnPay = @"40";  ///< 待付款
///
/// 订单取消原因
GNOrderCancelType const GNOrderCancelTypeUser = @"10";  ///< 客户终止订单
GNOrderCancelType const GNOrderCancelTypeTime = @"20";  ///< 过期自动取消
GNOrderCancelType const GNOrderCancelTypeUnPay = @"30"; ///< 超时未支付
///
/// 支付方式
GNPayMetnodType const GNPayMetnodTypeAll = @"GP001";    ///< 全部
GNPayMetnodType const GNPayMetnodTypeOnline = @"GP002"; ///< 线上支付
GNPayMetnodType const GNPayMetnodTypeCash = @"GP003";   ///< 到店付款

/// 门店营业状态
GNStoreBusnessType const GNStoreBusnessTypeOpen = @"GB001";   ///< 营业
GNStoreBusnessType const GNStoreBusnessTypeClosed = @"GB002"; ///< 停业

/// 门店状态 GNStoreStatus + GNStoreBusnessType
GNStoreCheckStatus const GNStoreCheckStatusOpen = @"GUM001";   ///< 营业
GNStoreCheckStatus const GNStoreCheckStatusClosed = @"GUM002"; ///< 停业

///退款状态
GNOrderRefundStatus const GNOrderRefundStatusWait = @"10";   ///< 待退款
GNOrderRefundStatus const GNOrderRefundStatusIng = @"20";    ///< 退款中
GNOrderRefundStatus const GNOrderRefundStatusFinidh = @"30"; ///< 已退款

/// 支付错误码
GNPayErrorType const GNPayErrorTypeChange = @"GO014";     ///< 商品商家等信息发生了改变
GNPayErrorType const GNPayErrorTypeProductUp = @"GPR002"; ///< 商品已下架
GNPayErrorType const GNPayErrorTypeSolded = @"GO018";     ///< 已售罄

/// 退款路径
GNRefundWayType const GNRefundWayOnline = @"1";  ///< 原路退回
GNRefundWayType const GNRefundWayOffline = @"2"; ///< 线下退款

///< 轮播广告
GNHomeLayoutType const GNHomeLayoutTypeCarouselAdvertise = @"GNCarouselAdvertise";
///< 金刚区
GNHomeLayoutType const GNHomeLayoutTypeKingKong = @"GNKingKong";

///< 商家
GNHomeColumnType const GNHomeColumnMerchant = @"GCT001";
///< 文章
GNHomeColumnType const GNHomeColumnAricle = @"GCT002";
///< 推荐
GNHomeColumnType const GNHomeColumnRecommend = @"GCT003";

///< 默认排序
GNHomeColumnType const GNHomeSortDefault = @"GUST001";
///< 销量排序
GNHomeColumnType const GNHomeSortSales = @"GUST002";
///< 评分排序
GNHomeColumnType const GNHomeSortScore = @"GUST003";
///< 距离排序
GNHomeColumnType const GNHomeSortDistance = @"GUST004";
///< 价格排序
GNHomeColumnType const GNHomeSortPrice = @"GUST005";
///< 置顶排序
GNHomeColumnType const GNHomeSortTop = @"GUST006";
///< 发布时间排序
GNHomeColumnType const GNHomeSortCreate = @"GUST007";

///文章绑定类型
typedef NSString *GNHomeArticleBindType NS_STRING_ENUM;
///< 商品
GNHomeArticleBindType const GNHomeArticleBindProduct = @"ABT001";
///< 门店
GNHomeArticleBindType const GNHomeArticleBindStore = @"ABT002";
///< 专题
GNHomeArticleBindType const GNHomeArticleBindTopic = @"ABT003";
///< 链接
GNHomeArticleBindType const GNHomeArticleBindURL = @"ABT004";
///< app内部其他链接
GNHomeArticleBindType const GNHomeArticleBindOther = @"ABT005";

@end
