//
//  GNOrderProductTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderCellModel.h"
#import "GNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderProductTableViewCell : GNTableViewCell
@property (nonatomic, strong) GNOrderCellModel *model;
@end

NS_ASSUME_NONNULL_END
