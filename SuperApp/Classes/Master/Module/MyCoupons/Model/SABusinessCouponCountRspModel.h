//
//  SABusinessCouponCountRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/7/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SABusinessCouponCountModel : SAModel
@property (nonatomic, assign) NSUInteger total;        ///< 未读数
@property (nonatomic, copy) SAClientType businessLine; ///< 业务线
@property (nonatomic, copy) NSString *title;           /// < 标题
/// 优惠券类型 9-全部 15-现金券 34-运费券 37-支付券
@property (nonatomic, assign) SACouponListCouponType couponType;

@end


@interface SABusinessCouponCountRspModel : SARspModel
@property (nonatomic, strong) NSArray<SABusinessCouponCountModel *> *coupon; ///< 业务线未读数
@end

NS_ASSUME_NONNULL_END
