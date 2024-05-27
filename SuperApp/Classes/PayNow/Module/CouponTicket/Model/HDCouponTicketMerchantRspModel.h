//
//  HDCouponTicketMerchantRspModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"
#import "HDCouponTicketMerchantModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 优惠券商户列表 */
@interface HDCouponTicketMerchantRspModel : HDCommonPagingRspModel
@property (nonatomic, copy) NSArray<HDCouponTicketMerchantModel *> *list; ///< 优惠券商户列表
@end

NS_ASSUME_NONNULL_END
