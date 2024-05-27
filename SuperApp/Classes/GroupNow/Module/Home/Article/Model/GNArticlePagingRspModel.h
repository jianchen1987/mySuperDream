//
//  GNArticlePagingRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleModel.h"
#import "SACommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNArticlePagingRspModel : SACommonPagingRspModel
/// 列表
@property (nonatomic, copy) NSArray<GNArticleModel *> *list;

@end

NS_ASSUME_NONNULL_END
