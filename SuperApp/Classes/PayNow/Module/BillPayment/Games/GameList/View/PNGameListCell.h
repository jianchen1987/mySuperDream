//
//  PNGamePaymentListCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
@class PNGameCategoryModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNGameListCell : PNTableViewCell
///
@property (strong, nonatomic) PNGameCategoryModel *model;
@end

NS_ASSUME_NONNULL_END
