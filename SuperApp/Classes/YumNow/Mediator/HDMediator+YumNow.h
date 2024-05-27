//
//  HDMediator+YumNow.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+SuperApp.h"
#import <HDKitCore/HDKitCore.h>


@interface HDMediator (YumNow)

/// 导航到商户搜索界面
/// @param params 参数
- (void)navigaveToStoreSearchViewController:(NSDictionary *)params;

/// 导航到选择地址界面
/// @param params 参数
- (void)navigaveToChooseAddressViewController:(NSDictionary *)params;

/// 导航到商家列表
/// @param params 参数
- (void)navigaveToStoreListViewController:(NSDictionary *)params;

/// 导航到门店详情列表
/// @param params 参数
- (void)navigaveToStoreDetailViewController:(NSDictionary *)params;

/// 导航到购物车页面
/// @param params 参数
- (void)navigaveToShoppingCartViewController:(NSDictionary *)params;

/// 导航到新增或修改地址页面
/// @param params 参数
- (void)navigaveToAddOrModifyAddressViewController:(NSDictionary *)params;

/// 导航到选择地址地图页面
/// @param params 参数
- (void)navigaveToChooseAddressMapViewController:(NSDictionary *)params;

/// 导航到订单提交页面
/// @param params 参数
- (void)navigaveToOrderSubmitController:(NSDictionary *)params;

/// 导航到订单提交页面（使用聚合接口）
/// @param params 参数
- (void)navigaveToOrderSubmitV2Controller:(NSDictionary *)params;

/// 导航到订单提交选择地址页面
/// @param params 参数
- (void)navigaveToOrderSubmitChooseAddressController:(NSDictionary *)params;

/// 导航到订单提交选择优惠券页面
/// @param params 参数
- (void)navigaveToOrderSubmitChooseCouponController:(NSDictionary *)params;

/// 导航到订单详情
/// @param params 参数
- (void)navigaveToOrderDetailViewController:(NSDictionary *)params;

/// 导航到退款申请页面
/// @param params 参数
- (void)navigaveToOrderRefundApplyViewController:(NSDictionary *)params;

/// 导航到订单评价页面
/// @param params 参数
- (void)navigaveToOrderEvaluationViewController:(NSDictionary *)params;

/// 导航到消息详情页
/// @param params 参数
- (void)navigaveToMessageDetailController:(NSDictionary *)params;

/// 导航到门店评价和信息页面
/// @param params 参数
- (void)navigaveToStoreReviewsAndInfoController:(NSDictionary *)params;

/// 导航到门店商品详情
/// @param params 参数
- (void)navigaveToStoreProductDetailController:(NSDictionary *)params;

/// 导航到商品所有评价页面
/// @param params 参数
- (void)navigaveToStoreProductReviewListController:(NSDictionary *)params;

/// 导航到我的评价页面
/// @param params 参数
- (void)navigaveToMyReviewsViewController:(NSDictionary *)params;

/// 导航到提交订单写备注页面
/// @param params 参数
- (void)navigaveToOrderSubmitWriteNoteViewController:(NSDictionary *)params;

/// 导航到门店购物车包装费明细页面
/// @param params 参数
- (void)navigaveToProductPackingFeeViewController:(NSDictionary *)params;

/// 导航到订单退款详情页面
/// @param params 参数
- (void)navigaveToOrderRefundDetailViewController:(NSDictionary *)params;

/// 导航到门店内商品搜索页面
/// @param params 参数
- (void)navigaveToProductSearchViewController:(NSDictionary *)params;

/// 导航到货到付款下单结果页面
/// @param params 参数
- (void)navigaveToOrderResultViewController:(NSDictionary *)params;

/// 导航到支付结果页
/// @param params 参数
//- (void)navigationToPayResultViewController:(NSDictionary *)params;

/// 导航到全部分类界面
/// @param params 参数
- (void)navigaveToStoreSortViewController:(NSDictionary *)params;

/// 导航到食品反馈界面
- (void)navigaveToFeedBackViewController:(NSDictionary *)params;

/// 导航到食品反馈提交界面
- (void)navigaveToSubmitFeedBackViewController:(NSDictionary *)params;

///反馈历史记录界面
- (void)navigaveToFeedBackHistoryController:(NSDictionary *)params;

///食品反馈详情界面
- (void)navigaveToFeedBackDetailViewController:(NSDictionary *)params;

/// FAQ界面
- (void)navigaveToFAQViewController:(NSDictionary *)params;

///订单列表界面
- (void)navigaveToOrderListViewController:(NSDictionary *)params;

///专题页
- (void)navigaveToThemeViewController:(NSDictionary *)params;

///修改订单地址
- (void)navigaveToModifyOrderAddressViewController:(NSDictionary *)params;

///修改订单地址记录
- (void)navigaveToModifyOrderAddressHistoryViewController:(NSDictionary *)params;
@end
