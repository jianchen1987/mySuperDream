//
//  GNTagViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCollectionView.h"
#import "GNTableViewCell.h"
#import "GNTagViewCellModel.h"
#import "HDCollectionViewVerticalLayout.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNTagCollectionViewCell : SACollectionViewCell

@property (strong, nonatomic) HDUIButton *nameLb;

@end


@interface GNTagViewCell : GNTableViewCell <YBIBDataProtocol>

@property (nonatomic, strong) GNTagViewCellModel *model;

@end

NS_ASSUME_NONNULL_END
