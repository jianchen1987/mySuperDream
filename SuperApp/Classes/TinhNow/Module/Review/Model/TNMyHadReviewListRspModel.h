//
//  TNMyHadReviewListRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"
@class TNMyHadReviewModel;
@class TNProductReviewModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNMyHadReviewListRspModel : TNPagingRspModel
/// 列表数据
@property (strong, nonatomic) NSArray<TNMyHadReviewModel *> *list;

/// 获取转换后的商品评论模型
- (NSArray<TNProductReviewModel *> *)getTransformProductReviewList;
@end

NS_ASSUME_NONNULL_END
