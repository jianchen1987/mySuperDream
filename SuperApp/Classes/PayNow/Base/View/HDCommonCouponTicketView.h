//
//  HDCommonCouponTicketView.h
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDBaseTableViewCell.h"
#import "HDCouponTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 常规优惠 */
@interface HDCommonCouponTicketView : UIView
@property (nonatomic, strong) HDCouponTicketModel *model; ///< 模型
@end

NS_ASSUME_NONNULL_END
