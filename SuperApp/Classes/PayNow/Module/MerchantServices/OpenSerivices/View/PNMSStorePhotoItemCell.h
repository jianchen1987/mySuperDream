//
//  PNMSStorePhotoItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"
#import "PNMSStorePhotoModel.h"

typedef void (^DeleteBlock)(void);

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStorePhotoItemCell : PNCollectionViewCell
@property (nonatomic, strong) PNMSStorePhotoItemModel *model;
@property (nonatomic, copy) DeleteBlock deleteBlock;
@end

NS_ASSUME_NONNULL_END
