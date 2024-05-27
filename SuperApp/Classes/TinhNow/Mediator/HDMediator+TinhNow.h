//
//  HDMediator+TinhNow.h
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+SuperApp.h"
#import <HDKitCore/HDKitCore.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDMediator (TinhNow)
/// 导航到商品详情页
/// @param params 参数
- (void)navigaveTinhNowProductDetailViewController:(NSDictionary *)params;

/// 导航到门店详情
/// @param params 参数
- (void)navigaveToTinhNowStoreDetailsPage:(NSDictionary *)params;

/// 导航到订单评价页面
/// @param params 参数
- (void)navigaveToTinhNowPostReviewlViewController:(NSDictionary *)params;

/// 导航到电商门店详情页
/// @param params 参数
- (void)navigaveToTinhNowStoreInfoViewController:(NSDictionary *)params;

- (void)navigaveToTinhNowOrderSubmitViewController:(NSDictionary *)params;

/// 跳转到订单详情
/// @param params @{@"orderNo":@"123123"}
- (void)navigaveToTinhNowOrderDetailsViewController:(NSDictionary *)params;

/// 跳转商品评论详情
/// @param params @{};
- (void)navigaveToTinhNowProductReviewDetailsViewController:(NSDictionary *)params;

/// 跳转我的评论页
/// @param params 参数
- (void)navigaveToTinhNowMyReviewsPage:(NSDictionary *)params;

/// 跳转商品专题页
/// @param params 参数
- (void)navigaveToTinhNowspecialActivityViewController:(NSDictionary *)params;

/// 跳转我的砍价记录
/// @param params 参数
- (void)navigaveToTinhNowMyBargainRecordViewController:(NSDictionary *)params;

/// 运单详情
- (void)navigaveToExpressDetails:(NSDictionary *)params;

/// 跳转选择优惠券
/// @param params 参数
- (void)navigaveToTinhNowChooseCouponViewController:(NSDictionary *)params;

/// 跳转到 申请退款
- (void)navigaveToTinhNowApplyRefundViewController:(NSDictionary *)params;

/// 跳转到 退款详情
- (void)navigaveToTinhNowRefundDetailViewController:(NSDictionary *)params;

/// 跳转转账付款页面
- (void)navigaveToTinhNowTransferViewController:(NSDictionary *)params;

/// 砍价详情
- (void)navigaveToTinhNowBargainDetailViewController:(NSDictionary *)params;

/// 砍价商品详情
- (void)navigaveToTinhNowBargainProductDetailViewController:(NSDictionary *)params;

/// 电商优惠券列表
- (void)navigaveToTinhNowCouponListViewController:(NSDictionary *)params;

/// 电商物流跟踪页面
- (void)navigaveToTinhNowExpressTrackingViewController:(NSDictionary *)params;

/// 电商配送区域地图页面
- (void)navigaveToTinhNowDeliveryAreaMapViewController:(NSDictionary *)params;

/// 电商供销店
- (void)navigaveToTinhNowSupplyAndMarketingShop:(NSDictionary *)params;

/// 电商选品中心
- (void)navigaveToTinhNowProductCenterViewController:(NSDictionary *)params;

/// 电商卖家搜索页面
- (void)navigaveToTinhNowSellerSearchViewController:(NSDictionary *)params;

/// 预估收入记录
- (void)navigaveToTinhNowPreIncomeRecordViewController:(NSDictionary *)params;

///提现绑定
- (void)navigaveToTinhNowWithdrawBindViewController:(NSDictionary *)params;
///图片搜索
- (void)navigaveToTinhNowPictureSearchViewController:(NSDictionary *)params;

/// 导航到砍价商品详情页
- (void)navigaveTinhNowBargainProductDetailViewController:(NSDictionary *)params;
/// 导航到联系客服页面
- (void)navigaveTinhNowContactCustomerServiceViewController:(NSDictionary *)params;
/// 导航到TG群页面
- (void)navigaveTinhNowTelegramGroupViewController:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
