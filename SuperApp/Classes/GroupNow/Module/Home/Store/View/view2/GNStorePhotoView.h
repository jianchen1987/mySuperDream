//
//  GNStorePhotoView.h
//  SuperApp
//
//  Created by wmz on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNView.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStorePhotoView : GNView
///数据源
@property (nonatomic, copy) NSArray<NSString *> *dataSource;

@end


@interface GNStorePhotoItemCell : SACollectionViewCell

@end

NS_ASSUME_NONNULL_END
