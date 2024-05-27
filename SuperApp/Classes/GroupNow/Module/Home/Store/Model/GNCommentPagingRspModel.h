//
//  GNCommentPagingRspModel.h
//  SuperApp
//
//  Created by wmz on 2021/9/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCommentModel.h"
#import "SACommonPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNCommentPagingRspModel : SACommonPagingRspModel

@property (nonatomic, copy) NSArray<GNCommentModel *> *list; /// 列表

@end

NS_ASSUME_NONNULL_END
