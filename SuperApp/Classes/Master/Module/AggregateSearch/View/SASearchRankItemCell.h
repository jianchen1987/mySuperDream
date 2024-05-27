//
//  SASearchRankItemCell.h
//  SuperApp
//
//  Created by Tia on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "SASearchThematicModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchRankItemCell : SACollectionViewCell
/// 数据源
@property (nonatomic, strong) SASearchThematicModel *model;

@end

NS_ASSUME_NONNULL_END
