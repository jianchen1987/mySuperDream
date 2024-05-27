//
//  WMStoreCartBottomDock.h
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;
@class WMStoreDetailPromotionModel;
@class WMShoppingItemsPayFeeTrialCalRspModel;
@class WMNextServiceTimeModel;


@interface WMStoreCartBottomDock : SAView
/// 点击了下单
@property (nonatomic, copy) void (^clickedOrdeNowBlock)(void);
/// 点击了门店购物车 Dock
@property (nonatomic, copy) void (^clickedStoreCartDockBlock)(void);

- (void)updateUIWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel;

// 设置下单按钮暂时不可点击，调用updateUIWithPayFeeTrialCalRspModel:后会根据实际试算设置状态
- (void)setOrderButtonUnClick;

/// 设置起送金额 和起送价是否因为特殊原因不一致
/// @param startPointPriceDiff 不一致的备注
- (void)setDeliveryStartPointPrice:(SAMoneyModel *_Nullable)startPointPrice startPointPriceDiff:(NSString *)startPointPriceDiff;

/// 根据门店状态和营业时间设置 UI
/// @param status 门店状态
/// @param businessHours 营业时间
- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status businessHours:(NSArray<NSArray<NSString *> *> *_Nullable)businessHours;

/// 根据门店状态和营业时间设置 UI  (下次服务时间)
- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status nextServiceTimeModel:(WMNextServiceTimeModel *)serviceTimeModel;

/// 根据门店状态和营业时间设置 UI  (下次营业时间)
- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status nextBuinessTimeModel:(NSString *)buinessTime;

/// 根据门店状态和暂停营业时间设置 UI  (暂停营业时间)
- (void)setOpeningTimeWithStoreStatus:(WMStoreStatus)status effectTimeTimeModel:(NSString *)effectTime;

/// 门店爆单
- (void)setFullOrderState:(WMStoreFullOrderState)state storeNo:(NSString *)storeNo;

/// 清空价格信息（未选商品）
- (void)emptyPriceInfo;

- (void)showPromotionInfo;
- (void)dismissPromotionInfo;
@end

NS_ASSUME_NONNULL_END
