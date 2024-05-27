//
//  TNHomeViewScrollLabelCell.h
//  SuperApp
//
//  Created by Chaos on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"

@class TNScrollContentRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNHomeViewScrollLabelCell : TNCollectionViewCell

/// 数据源
@property (nonatomic, strong) TNScrollContentRspModel *model;

@end

NS_ASSUME_NONNULL_END
