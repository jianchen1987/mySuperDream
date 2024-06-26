//
//  GNHomeArticleCell.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleModel.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNHomeArticleCell : SACollectionViewCell <HDSkeletonLayerLayoutProtocol>
@property (nonatomic, strong) GNArticleModel *model;
@end

NS_ASSUME_NONNULL_END
