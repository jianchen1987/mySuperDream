//
//  CMSThreeImageScrolled1_1CardCell.h
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class CMSThreeImage1x1ItemConfig;


@interface CMSThreeImage1x1ScrolledCardCell : SACollectionViewCell
/// model
@property (nonatomic, strong) CMSThreeImage1x1ItemConfig *model;
@end

NS_ASSUME_NONNULL_END
