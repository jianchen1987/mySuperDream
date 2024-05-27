//
//  SASearchRankItemTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchThematicModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchRankItemTableViewCell : SATableViewCell
/// 位置
@property (nonatomic, strong) NSIndexPath *indexPath;
/// 数据源
@property (nonatomic, strong) SASearchThematicListModel *model;

@end

NS_ASSUME_NONNULL_END
