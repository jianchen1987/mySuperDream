//
//  GNStoreProductHeadCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCouPonImageView.h"
#import "GNProductModel.h"
#import "GNTableViewCell.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreProductHeadCell : GNTableViewCell

@property (nonatomic, strong) GNProductModel *model;

@end


@interface GNProductBannerItem : SACollectionViewCell
/// 图片
@property (nonatomic, strong) GNCouPonImageView *iconIV;

@end

NS_ASSUME_NONNULL_END
