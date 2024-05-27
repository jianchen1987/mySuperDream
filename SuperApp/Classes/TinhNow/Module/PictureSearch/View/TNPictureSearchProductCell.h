//
//  TNPictureSearchProductCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNPictureSearchRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNPictureSearchProductCell : TNCollectionViewCell
///
@property (strong, nonatomic) TNPictureSearchModel *model;
@end

NS_ASSUME_NONNULL_END
