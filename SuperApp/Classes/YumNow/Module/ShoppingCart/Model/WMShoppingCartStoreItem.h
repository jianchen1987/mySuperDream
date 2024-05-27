//
//  WMShoppingCartStoreItem.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCodingModel.h"
#import "WMCouponActivityContentModel.h"
#import "WMShoppingCartStoreProduct.h"

@class WMShoppingItemsPayFeeTrialCalRspModel;

NS_ASSUME_NONNULL_BEGIN

/// 单个门店购物车项
@interface WMShoppingCartStoreItem : WMCodingModel
/// 门店名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 门店名称-英文
@property (nonatomic, copy) NSString *storeNameEn;
/// 门店名称-柬文
@property (nonatomic, copy) NSString *storeNameKm;
/// 门店名称-中文
@property (nonatomic, copy) NSString *storeNameZh;
/// 税率
@property (nonatomic, strong) NSNumber *vatRate;
/// 门店最后操作时间
@property (nonatomic, copy) NSString *operatingTime;
/// 增值税
@property (nonatomic, copy) SAMoneyModel *valueAddedTax;
/// 门店起送价
@property (nonatomic, strong) SAMoneyModel *requiredPrice;
/// 打包费
@property (nonatomic, strong) SAMoneyModel *packingFee;
/// 该门店下所有商品的总价格（不包含打包费，税费）
@property (nonatomic, strong) SAMoneyModel *totalProductMoney;
/// 币种
@property (nonatomic, copy) SACurrencyType currency;
/// 门店id
@property (nonatomic, copy) NSString *storeId;
/// 门店状态
@property (nonatomic, copy) WMShopppingCartStoreStatus merchantStoreStatus;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 商户号
@property (nonatomic, copy) NSString *merchantNo;
/// 购物项列表
@property (nonatomic, copy) NSArray<WMShoppingCartStoreProduct *> *goodsList;
/// 门店购物车展示号
@property (nonatomic, copy) NSString *merchantDisplayNo;
/// 爆款限购数量
@property (nonatomic, assign) NSUInteger availableBestSaleCount;
/// 爆单状态 10正常 20爆单 30爆单停止接单
@property (nonatomic, assign) WMStoreFullOrderState fullOrderState;
/// 出餐慢状态 10正常 20出餐慢
@property (nonatomic, assign) WMStoreSlowMealState slowMealState;

#pragma mark - 绑定属性
/// 是否第一项
@property (nonatomic, assign) BOOL isFirstCell;
/// 是否最后一项
@property (nonatomic, assign) BOOL isLastCell;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
/// 商品试算返回数据
@property (nonatomic, strong, nullable) WMShoppingItemsPayFeeTrialCalRspModel *feeTrialCalRspModel;
///是否是删除选中
@property (nonatomic, assign) BOOL isDeleteSelected;
/// 实际起送价
@property (nonatomic, strong) SAMoneyModel *realRequiredPrice;
/// 是否弹起送价改变弹窗
@property (nonatomic, assign) BOOL needShowRequiredPriceChangeToast;
/// 门店优惠券活动
@property (nonatomic, strong, nullable) WMCouponActivityContentModel *couponActivtyModel;

@end

NS_ASSUME_NONNULL_END
