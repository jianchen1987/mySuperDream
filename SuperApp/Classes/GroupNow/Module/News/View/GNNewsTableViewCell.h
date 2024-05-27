//
//  GNNewsTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsCellModel.h"
#import "GNTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNNewsTableViewCell : GNTableViewCell

@property (nonatomic, strong) GNNewsCellModel *model;

@end

NS_ASSUME_NONNULL_END
