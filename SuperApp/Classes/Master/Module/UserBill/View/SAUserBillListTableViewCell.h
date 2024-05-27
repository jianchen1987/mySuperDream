//
//  SAUserBillListTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SAUserBillListModel;


@interface SAUserBillListTableViewCell : SATableViewCell

///< model
@property (nonatomic, strong) SAUserBillListModel *model;

@end

NS_ASSUME_NONNULL_END
