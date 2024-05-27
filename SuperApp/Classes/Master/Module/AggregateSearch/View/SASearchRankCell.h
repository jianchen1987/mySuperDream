//
//  SASearchRankCell1.h
//  SuperApp
//
//  Created by Tia on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchThematicModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchRankCell : SATableViewCell
/// 数据源
@property (nonatomic, strong) NSArray<SASearchThematicModel *> *dataSource;

@end

NS_ASSUME_NONNULL_END
