//
//  GNStoreDetailProductTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNProductModel.h"
#import "GNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreDetailProductTableViewCell : GNTableViewCell

@property (nonatomic, strong) GNProductModel *model;

@end

NS_ASSUME_NONNULL_END
