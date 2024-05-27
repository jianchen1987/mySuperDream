//
//  WMOrderDetailCouponModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailCouponModel : WMModel
/// 优惠券名称
@property (nonatomic, copy) NSString *couponName;
/// 优惠券面值
@property (nonatomic, strong) SAMoneyModel *couponAmt;
/// 优惠券创建时间
@property (nonatomic, copy) NSString *createTime;
/// 优惠券种类
@property (nonatomic, assign) SACouponTicketType couponType;
/// 优惠券ID
@property (nonatomic, copy) NSString *couponNo;
/// 过期日期
@property (nonatomic, copy) NSString *expireDate;
/// 平台优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;
/// 生效日期
@property (nonatomic, copy) NSString *effectiveDate;
@end

NS_ASSUME_NONNULL_END
