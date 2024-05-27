//
//  TNReviewGoodItemView.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNProductReviewModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNReviewGoodItemView : TNView
/// 数据源
@property (strong, nonatomic) TNProductReviewModel *model;
@end

NS_ASSUME_NONNULL_END
