//
//  SAMineTicketInfoTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACouponInfoRspModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMineTicketInfoTableViewCell : SATableViewCell
- (void)configCellWithModel:(SACouponInfoRspModel *)model;
@end

NS_ASSUME_NONNULL_END
