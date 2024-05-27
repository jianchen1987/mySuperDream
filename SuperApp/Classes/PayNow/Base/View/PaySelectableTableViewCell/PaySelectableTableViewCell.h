//
//  PaySelectableTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInfoTableViewCell.h"
#import "PaySelectableTableViewCellModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PaySelectableTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) PaySelectableTableViewCellModel *model;

@end

NS_ASSUME_NONNULL_END
