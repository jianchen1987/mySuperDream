//
//  WMStoreActivityMdoel.h
//  SuperApp
//
//  Created by wmz on 2023/6/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMShareDeliveryFeeItems : WMRspModel
/// 活动id
@property (nonatomic, copy) NSString *activityNo;
/// 优惠后配送费
@property (nonatomic, strong) SAMoneyModel *deliveryFeeAfterDiscount;

@end

@interface WMShareStoreCouponItems : WMRspModel
/// 优惠券编号
@property (nonatomic, copy) NSString *couponNo;
/// 面值
@property (nonatomic, strong) SAMoneyModel *faceValue;

@end

@interface WMShareFullReductionItems : WMRspModel
/// 活动id
@property (nonatomic, copy) NSString *activityNo;
/// 满足金额
@property (nonatomic, strong) SAMoneyModel *thresholdAmt;
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;

@end

@interface WMShareProductDiscountItems : WMRspModel
/// 活动id
@property (nonatomic, copy) NSString *activityNo;
///活动名称-中
@property (nonatomic, copy) NSString *activityTitleZh;
///活动名称-英
@property (nonatomic, copy) NSString *activityTitleEn;
///活动名称-柬
@property (nonatomic, copy) NSString *activityTitleCb;

@end

@interface WMShareFirstItems : WMRspModel
/// 优惠券编号
@property (nonatomic, copy) NSString *couponNo;
///优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;

@end

@interface WMStoreActivityMdoel : WMRspModel
///减免配送费
@property (nonatomic, copy) NSArray<WMShareDeliveryFeeItems*> *deliveryFeeItems;
///门店优惠券
@property (nonatomic, copy) NSArray<WMShareStoreCouponItems*> *storeCouponItems;
///门店满减
@property (nonatomic, copy) NSArray<WMShareFullReductionItems*> *fullReductionItems;
///商品优惠
@property (nonatomic, copy) NSArray<WMShareProductDiscountItems*> *productDiscountItems;
///爆品
@property (nonatomic, copy) NSArray<WMShareProductDiscountItems*> *bestSaleItems;
///门店满减
@property (nonatomic, copy) NSArray<WMShareFirstItems*> *storeFirstItems;

@end

NS_ASSUME_NONNULL_END
