//
//  HDGetCouponsAfterUserActiveRspModel.h
//  ViPay
//
//  Created by seeu on 2019/6/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDBaseCodingObject.h"
#import "HDCouponTicketModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDGetCouponsAfterUserActiveRspModel : HDBaseCodingObject

@property (nonatomic, copy) NSArray<HDCouponTicketModel *> *receivedCouponList; ///<

@end

NS_ASSUME_NONNULL_END
