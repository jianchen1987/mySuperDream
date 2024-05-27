//
//  SAMessageCenterListTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SASystemMessageModel;


@interface SAMessageCenterListTableViewCell : SATableViewCell
@property (nonatomic, strong) SASystemMessageModel *model;
@end

NS_ASSUME_NONNULL_END
