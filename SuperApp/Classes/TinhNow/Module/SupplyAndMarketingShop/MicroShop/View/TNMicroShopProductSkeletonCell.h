//
//  TNMicroShopProductSkeletonCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopProductSkeletonCellModel : NSObject
/// cell高度
@property (nonatomic, assign, readonly) NSUInteger cellHeight;

@end


@interface TNMicroShopProductSkeletonCell : TNCollectionViewCell <HDSkeletonLayerLayoutProtocol>

@end

NS_ASSUME_NONNULL_END
