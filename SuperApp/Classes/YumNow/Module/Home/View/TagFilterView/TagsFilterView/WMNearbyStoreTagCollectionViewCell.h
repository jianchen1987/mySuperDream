//
//  WMNearbyStoreTagCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class WMNearbyStoreTagsModel;


@interface WMNearbyStoreTagCollectionViewCell : SACollectionViewCell
/// model
@property (nonatomic, strong) WMNearbyStoreTagsModel *model;
@end

NS_ASSUME_NONNULL_END
