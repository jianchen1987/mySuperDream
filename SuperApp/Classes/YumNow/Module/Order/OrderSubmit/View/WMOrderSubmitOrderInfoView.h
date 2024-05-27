//
//  WMOrderSubmitOrderInfoView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMShoppingCartStoreItem;
@class WMShoppingCartStoreProduct;
@class WMOrderSubmitCalDeliveryFeeRspModel;
@class WMOrderSubmitPromotionModel;
@class WMOrderSubmitCouponModel;
@class WMOrderSubmitPayFeeTrialCalRspModel;
@class SAMoneyModel;
@class WMCalculateProductPriceRspModel;
@class WMShoppingItemsPayFeeTrialCalRspModel;
@class WMPromoCodeRspModel;
@class WMOrderSubmitFullGiftRspModel;
#import "WMWriteNoteTagRspModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 订单信息
@interface WMOrderSubmitOrderInfoView : SAView
/// 点击备注回调
@property (nonatomic, copy) void (^clickedNoteBlock)(void);
/// 选择优惠券回调
@property (nonatomic, copy) void (^chooseCouponBlock)(WMOrderSubmitCouponModel *model);
/// 选择运费券回调
@property (nonatomic, copy) void (^chooseFreightCouponBlock)(WMOrderSubmitCouponModel *model);
/// 备注内容
@property (nonatomic, copy, readonly) NSString *noteText;
/// 备注内容 请求传入
@property (nonatomic, copy, readonly) NSString *requestNoteText;
/// 点击输入促销码回调
@property (nonatomic, copy) void (^clickedPromoCodeBlock)(void);
/// 点击清空促销码回调
@property (nonatomic, copy) void (^clickedClearPromoCodeBlock)(void);
/// 点击满赠填写年龄回调
@property (nonatomic, copy) void (^clickedAgeBlock)(void);

@property (nonatomic, strong) WMShoppingItemsPayFeeTrialCalRspModel *cartFeeModel;

@property (nonatomic, strong) WMShoppingCartStoreItem *storeModel;
/// 点击过找零提醒
@property (nonatomic, copy, readonly) NSString *changeReminderText;
/// 总减免
@property (nonatomic, assign) NSInteger totalDiscountMoney;
/// 备注标签数据
@property (nonatomic, strong) NSArray<WMWriteNoteTagRspModel *> *tagArray;

/// 更新慢必赔
- (void)configureWithSlowToPay:(SABoolValue)slowToPay;

/// 根据门店信息和商品信息更新界面
- (void)configureWithStoreItem:(WMShoppingCartStoreItem *)model productList:(NSArray<WMShoppingCartStoreProduct *> *)productList;
/// 根据商品信息更新界面
- (void)configureWithProductList:(NSArray<WMShoppingCartStoreProduct *> *)productList;

/// 更新商品核算金额更新界面
- (void)configureWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel productList:(NSArray<WMShoppingCartStoreProduct *> *)productList;

/// 根据购物车订单试算信息更新税费
- (void)configureWithShoppingItemsPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)model;

/// 根据配送费和配送费减免信信息更新界面
- (void)configureWithDeliveryFeeRspModel:(WMOrderSubmitCalDeliveryFeeRspModel *)model deliveryFeeReductionMoney:(SAMoneyModel *)deliveryFeeReductionMoney;

/// 根据活动信息更新界面
- (void)configureWithPromotionList:(NSArray<WMOrderSubmitPromotionModel *> *)promotionList
    activityMoneyExceptDeliveryFeeReduction:(SAMoneyModel *)activityMoneyExceptDeliveryFeeReduction
                    cartFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)cartFeeModel;

/// 根据优惠券信息更新界面
- (void)configureWithCouponModel:(WMOrderSubmitCouponModel *)model usableCouponCount:(NSUInteger)usableCouponCount shouldChangeDiscountView:(BOOL)change;

/// 根据优惠券优惠券信息更新界面
- (void)configureWithFreightCouponModel:(WMOrderSubmitCouponModel *)model usableCouponCount:(NSUInteger)usableFreightCouponCount shouldChangeDiscountView:(BOOL)change;

/// 根据输入备注信息更新界面
- (void)configureWithUserInputNote:(nullable NSString *)content changeRemind:(nullable NSString *)changeReminder;

/// 根据输入促销码和查询的促销码模型更新界面
- (void)configureWithUserInputPromoCode:(NSString *_Nullable)promoCode rspModel:(WMPromoCodeRspModel *_Nullable)promoCodeRspModel;

/// 根据满赠活动结果更新界面
- (void)configureWithFillGiftRspModel:(WMOrderSubmitFullGiftRspModel *_Nullable)fullGiftRspModel;

/// 隐藏配送费UI和运费券选择
- (void)configureWithHiddenDeliveryFeeViewAndFreightView;
@end

NS_ASSUME_NONNULL_END
