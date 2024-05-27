//
//  TNStoreInfoSkeletonCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNStoreInfoSkeletonCellModel : NSObject
/// cell高度
@property (nonatomic, assign, readonly) NSUInteger cellHeight;

@end


@interface TNStoreInfoSkeletonCell : SACollectionViewCell <HDSkeletonLayerLayoutProtocol>

@end

NS_ASSUME_NONNULL_END
