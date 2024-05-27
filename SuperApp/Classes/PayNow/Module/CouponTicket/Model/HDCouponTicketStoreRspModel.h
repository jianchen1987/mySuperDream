//
//  HDCouponTicketStoreRspModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "HDCouponTicketStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 优惠券门店详情 */
@interface HDCouponTicketStoreRspModel : SAModel

@property (nonatomic, copy) NSString *merchantLogo;                         ///< 商户logo链接
@property (nonatomic, copy) NSString *merchantName;                         ///< 商户名称
@property (nonatomic, copy) NSString *merchantNo;                           ///< 商户编号
@property (nonatomic, copy) NSArray<HDCouponTicketStoreModel *> *storeList; ///< 优惠券门店列表

@end

NS_ASSUME_NONNULL_END
