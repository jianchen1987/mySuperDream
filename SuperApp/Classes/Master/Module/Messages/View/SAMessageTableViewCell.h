//
//  SAMessageTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2021/1/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageTableViewCell : SATableViewCell
@property (nonatomic, strong) SAMessageModel *model; ///< 数据模型
@end

NS_ASSUME_NONNULL_END
