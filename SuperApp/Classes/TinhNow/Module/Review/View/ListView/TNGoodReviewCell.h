//
//  TNGoodReviewListCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNProductReviewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNGoodReviewCell : SATableViewCell
/// 商品评论数据源
@property (strong, nonatomic) TNProductReviewModel *model;
/// 点击了用户评论查看更多或更少
@property (nonatomic, copy) void (^clickedUserReviewContentReadMoreOrReadLessBlock)(void);
@end

NS_ASSUME_NONNULL_END
