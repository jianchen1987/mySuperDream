//
//  GNBannerCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTableViewCell.h"
#import "GNTagViewCellModel.h"
#import "SACollectionViewCell.h"
#import "SAWindowItemModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNBannerCell : GNTableViewCell

@property (nonatomic, strong) GNTagViewCellModel *model;

@end


@interface GNBannerCollectionViewCell : SACollectionViewCell

@property (nonatomic, strong) SAWindowItemModel *model;

@end

NS_ASSUME_NONNULL_END
