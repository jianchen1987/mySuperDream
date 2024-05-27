//
//  HDMediator+GroupOn.h
//  SuperApp
//
//  Created by wmz on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDMediator+SuperApp.h"
#import <HDKitCore/HDKitCore.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDMediator (GroupOn)
/// 跳转店铺列表
- (void)navigaveToGNStoreListViewController:(NSDictionary *)params;
/// 跳转店铺详情
- (void)navigaveToGNStoreDetailViewController:(NSDictionary *)params;
/// 跳转店铺搜索
- (void)navigaveToGNStoreSearchViewController:(NSDictionary *)params;
/// 跳转店铺地图
- (void)navigaveToGNStoreMapViewController:(NSDictionary *)params;
/// 跳转店铺商品
- (void)navigaveToGNStoreProductViewController:(NSDictionary *)params;
/// 跳转下单页
- (void)navigaveToGNOrderTakeViewController:(NSDictionary *)params;
/// 跳转下单结果
- (void)navigaveToGNOrderResultViewController:(NSDictionary *)params;
/// 跳转订单详情
- (void)navigaveToGNOrderDetailViewController:(NSDictionary *)params;
/// 跳转专题页
- (void)navigaveToGNTopicViewController:(NSDictionary *)params;
/// 跳转退款详情
- (void)navigaveToGNRefundDetailViewController:(NSDictionary *)params;
///跳转文章详情
- (void)navigaveToGNArticleDetailViewController:(NSDictionary *)params;
///跳转评论列表
- (void)navigaveToGNReViewListViewController:(NSDictionary *)params;
///跳转取消原因选择界面
- (void)navigaveToGNOrderCancelViewController:(NSDictionary *)params;
///跳转预约界面
- (void)navigaveToGNOrderReserveViewController:(NSDictionary *)params;
///跳转预约详情界面
- (void)navigaveToGNReserveDetailViewController:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
