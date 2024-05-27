//
//  GNNewsPagingRspModel.h
//  SuperApp
//
//  Created by wmz on 2021/7/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsCellModel.h"
#import "SACommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNNewsPagingRspModel : SACommonPagingRspModel

/// 列表
@property (nonatomic, copy) NSArray<GNNewsCellModel *> *list;

@end

NS_ASSUME_NONNULL_END
