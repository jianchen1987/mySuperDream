//
//  SAPaymentActivityTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2022/5/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SAPaymentActivityModel;


@interface SAPaymentActivityTableViewCell : SATableViewCell
///< model
@property (nonatomic, strong) SAPaymentActivityModel *model;
@end

NS_ASSUME_NONNULL_END
