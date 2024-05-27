//
//  CMSThreeImage3x2ScrolledCardCell.h
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class CMSThreeImage3x2ItemConfig;


@interface CMSThreeImage3x2ScrolledCardCell : SACollectionViewCell
@property (nonatomic, strong) CMSThreeImage3x2ItemConfig *model;

@end

NS_ASSUME_NONNULL_END
