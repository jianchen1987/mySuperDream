//
//  SASystemMessageTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASystemMessageModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASystemMessageTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SASystemMessageModel *model;
@end

NS_ASSUME_NONNULL_END
