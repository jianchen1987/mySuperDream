//
//  TNCategoryRightCollectionViewCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNCategoryModel;


@interface TNCategoryRightCollectionViewCell : TNCollectionViewCell
/// 模型
@property (strong, nonatomic) TNCategoryModel *model;
@end

NS_ASSUME_NONNULL_END
