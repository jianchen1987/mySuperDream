//
//  SAGetUserCouponTicketRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "SACouponTicketModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAGetUserCouponTicketRspModel : SACommonPagingRspModel
/// y优惠券列表
@property (nonatomic, copy) NSArray<SACouponTicketModel *> *list;
@end

NS_ASSUME_NONNULL_END
