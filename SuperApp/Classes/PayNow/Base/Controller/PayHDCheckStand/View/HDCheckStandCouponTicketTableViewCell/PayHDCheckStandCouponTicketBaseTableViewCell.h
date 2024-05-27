//
//  PayHDCheckstandCouponTicketBaseTableViewCell.h
//  ViPay
//
//  Created by VanJay on 2019/6/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDBaseTableViewCell.h"
#import "PayHDTradePreferentialModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCheckstandCouponTicketBaseTableViewCell : HDBaseTableViewCell
@property (nonatomic, strong) PayHDTradePreferentialModel *model; ///< 模型
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
