//
//  TNMyNotReviewListRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"
@class TNMyNotReviewModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNMyNotReviewListRspModel : TNPagingRspModel
/// 列表数据
@property (strong, nonatomic) NSArray<TNMyNotReviewModel *> *list;
@end

NS_ASSUME_NONNULL_END
