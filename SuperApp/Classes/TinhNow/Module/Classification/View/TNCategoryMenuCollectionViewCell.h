//
//  TNCategoryMenuCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNCategoryModel;


@interface TNCategoryMenuCollectionViewCell : SACollectionViewCell
/// model
@property (nonatomic, strong) TNCategoryModel *model;
@end

NS_ASSUME_NONNULL_END
