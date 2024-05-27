//
//  HDCouponTicketMerchantModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCouponTicketMerchantModel : SAModel
@property (nonatomic, copy) NSString *merchantLogo; ///< 商户 logo
@property (nonatomic, copy) NSString *merchantName; ///< 商户名称
@property (nonatomic, copy) NSString *merchantNo;   ///< 商户编号
@end

NS_ASSUME_NONNULL_END
