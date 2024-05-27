//
//  HDCouponTicketRspModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"
#import "HDCouponTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 用户优惠券列表 */
@interface HDCouponTicketRspModel : HDCommonPagingRspModel
@property (nonatomic, copy) NSArray<HDCouponTicketModel *> *list; ///< 优惠券列表
@end

NS_ASSUME_NONNULL_END
