//
//  SASelectableTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInfoTableViewCell.h"
#import "SASelectableTableViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASelectableTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SASelectableTableViewCellModel *model;
@end

NS_ASSUME_NONNULL_END
