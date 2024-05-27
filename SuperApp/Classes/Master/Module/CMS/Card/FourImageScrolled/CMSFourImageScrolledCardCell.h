//
//  CMSFourImageScrolledCardCell.h
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CMSFourImageScrolledCardCellConfig;
@class SACMSNode;


@interface CMSFourImageScrolledCardCell : SACollectionViewCell

@property (nonatomic, strong) CMSFourImageScrolledCardCellConfig *config;

@property (nonatomic, copy) void (^clickedBlock)(SACMSNode *node, NSString *link);

@end

NS_ASSUME_NONNULL_END
