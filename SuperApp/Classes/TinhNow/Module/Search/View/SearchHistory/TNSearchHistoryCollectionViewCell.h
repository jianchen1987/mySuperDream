//
//  TNSearchHistoryCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNSearchHistoryModel;


@interface TNSearchHistoryCollectionViewCell : TNCollectionViewCell
/// model
@property (nonatomic, strong) TNSearchHistoryModel *model;
@end

NS_ASSUME_NONNULL_END
