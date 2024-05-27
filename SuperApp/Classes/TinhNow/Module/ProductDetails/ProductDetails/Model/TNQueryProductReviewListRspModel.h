//
//  TNQueryProductReviewListRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNProductReviewModel;


@interface TNQueryProductReviewListRspModel : TNPagingRspModel
/// 评论列表
@property (nonatomic, strong) NSArray<TNProductReviewModel *> *content;
@end

NS_ASSUME_NONNULL_END
