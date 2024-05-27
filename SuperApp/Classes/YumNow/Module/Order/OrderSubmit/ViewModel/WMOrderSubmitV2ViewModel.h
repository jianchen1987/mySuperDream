//
//  WMOrderSubmitV2ViewModel.h
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMCalculateProductPriceRspModel.h"
#import "WMOrderIncreaseDeliveryModel.h"
#import "WMOrderSubmitAggregationRspModel.h"
#import "WMOrderSubmitCalDeliveryFeeRspModel.h"
#import "WMOrderSubmitCouponModel.h"
#import "WMOrderSubmitFullGiftRspModel.h"
#import "WMOrderSubmitPayFeeTrialCalRspModel.h"
#import "WMOrderSubmitPromotionModel.h"
#import "WMOrderSubmitRspModel.h"
#import "WMPromoCodeRspModel.h"
#import "WMQueryOrderInfoRspModel.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMViewModel.h"

@class SAShoppingAddressModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitV2ViewModel : WMViewModel
#pragma mark - 入参
/// 所有商品
@property (nonatomic, copy) NSArray<WMShoppingCartStoreProduct *> *productList;
/// 门店信息
@property (nonatomic, strong) WMShoppingCartStoreItem *storeItem;
/// 从哪里进入的 0：门店 1：购物车
@property (nonatomic, assign) WMOrderSubmitFrom from;
/// 填充的促销码
@property (nonatomic, copy, nullable) NSString *promoCode;

#pragma mark - 埋点参数
@property (nonatomic, copy) NSString *funnel;           ///< 转化漏斗来源
@property (nonatomic, copy) NSString *bannerId;         ///< 广告id
@property (nonatomic, strong) NSNumber *bannerLocation; ///< 广告位置
@property (nonatomic, copy) NSString *bannerTitle;      ///< 广告名称

#pragma mark - 出参
/// 聚合查询返回
@property (nonatomic, strong, readonly) WMOrderSubmitAggregationRspModel *aggregationRspModel;
/// 需要检查是否可用的地址模型，如果不存在为 nil
@property (nonatomic, strong, nullable) SAShoppingAddressModel *addressModelToCheck;
/// 当前送餐地址（如果不为空，优先级高于 addressModelToCheck）
@property (nonatomic, strong) SAShoppingAddressModel *currentAddressModel;
/// 浮层地址 default nil
@property (nonatomic, strong, nullable) SAShoppingAddressModel *popAddressModel;
/// 有效地址
@property (nonatomic, strong, readonly) SAShoppingAddressModel *validAddressModel;
/// 用于查询活动的金额
@property (nonatomic, strong, readonly) SAMoneyModel *amountToQueryActivity;
/// 用于查询优惠券的金额
@property (nonatomic, strong, readonly) SAMoneyModel *amountToQueryCoupon;
/// 上次选择的门店是否在配送范围内
@property (nonatomic, assign, readonly) BOOL isLastChoosedAddressAvailable;
/// 活动列表，可能包含减配送费，满减活动
@property (nonatomic, copy, readonly) NSArray<WMOrderSubmitPromotionModel *> *promotionList;
/// 活动金额，除去减配送费活动的金额
@property (nonatomic, strong, readonly) SAMoneyModel *activityMoneyExceptDeliveryFeeReduction;
/// 活动减免的配送费金额
@property (nonatomic, strong, readonly) SAMoneyModel *deliveryFeeReductionMoney;
/// 优惠模型
@property (nonatomic, strong, nullable) WMOrderSubmitCouponModel *couponModel;
/// 可用优惠券数量
@property (nonatomic, assign, readonly) NSUInteger usableCouponCount;
/// 运费券优惠模型
@property (nonatomic, strong, nullable) WMOrderSubmitCouponModel *freightCouponModel;
/// 可用运费券数量
@property (nonatomic, assign, readonly) NSUInteger usableFreightCouponCount;
/// 满赠模型
@property (nonatomic, strong, nullable) WMOrderSubmitFullGiftRspModel *fullGiftRspModel;
/// 增加配送费模型
@property (nonatomic, strong, nullable) WMOrderIncreaseDeliveryModel *increaseDeliveryModel;
/// 选择的外卖送达时间
@property (nonatomic, strong) WMOrderSubscribeTimeModel *deliverySubscribeTimeModel;
/// 选择的到店自取时间
@property (nonatomic, strong) WMOrderSubscribeTimeModel *toStoreSubscribeTimeModel;

///< 支付扣减
@property (nonatomic, strong, nullable) SAMoneyModel *paymentDiscountAmount;

/// 标志，只要变化就刷新
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;
/// 优惠券数量刷新标志
@property (nonatomic, assign) BOOL refreshCoupon;

/// VM 内部选择了配送地址
@property (nonatomic, copy) void (^choosedAddressBlock)(SAShoppingAddressModel *addressModel);
/// 风控
@property (nonatomic, assign) BOOL userHasRisk;
/// 切换了地址的试算
@property (nonatomic, assign) BOOL changeAddress;
/// 切换了地址的试算失败
@property (nonatomic, assign) BOOL changeAddressFail;
/// 是否支持到店自取
@property (nonatomic, assign) BOOL pickUpStatus;

@property (nonatomic, assign) NSInteger serviceType;

@property (nonatomic, strong) NSArray *contactlist;

@property (nonatomic, strong) SAShoppingAddressModel *addressModel;


/// 获取初始化数据
- (void)getInitializedData;

/// 获取渲染页面所需所有数据
- (void)getRenderUIData;

/// 重新获取年龄后获取聚合数据
- (void)getNewAgeData;

///特殊区域
- (void)getSpecialAddress;

///选择浮层地址
- (void)selectPopAddress;

/// 判断需要检查的地址是否在门店可配送范围内
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)checkIsStoreCanDeliveryWithLastChooseAddressSuccess:(void (^)(BOOL canDelivery))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 订单下单（聚合下单）
/// @param userNote 用户备注
/// @param paymentMethod 付款方式
/// @param deliveryTimeModel 配送时间
/// @param toStoreMobile 到店自取的时间
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)submitOrderWithUserNote:(NSString *)userNote
                  paymentMethod:(SAOrderPaymentType)paymentMethod
              deliveryTimeModel:(WMOrderSubscribeTimeModel *)deliveryTimeModel
                  toStoreMobile:(NSString *)toStoreMobile
                        success:(void (^)(WMOrderSubmitRspModel *rspModel))successBlock
                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
