//
//  GNTopicProductCell.h
//  SuperApp
//
//  Created by wmz on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNProductModel.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNTopicProductCell : SACollectionViewCell
@property (nonatomic, strong) GNProductModel *model;
@end

NS_ASSUME_NONNULL_END
