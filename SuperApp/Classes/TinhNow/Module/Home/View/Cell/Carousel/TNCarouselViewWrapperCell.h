//
//  SACarouselViewWrapperCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNCarouselViewWrapperCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCarouselViewWrapperCell : TNCollectionViewCell
@property (nonatomic, strong) TNCarouselViewWrapperCellModel *model; ///< 模型
@end

NS_ASSUME_NONNULL_END
