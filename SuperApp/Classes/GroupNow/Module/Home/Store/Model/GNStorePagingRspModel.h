//
//  GNStorePagingRspModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreCellModel.h"
#import "SACommonPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNStorePagingRspModel : SACommonPagingRspModel

@property (nonatomic, copy) NSArray<GNStoreCellModel *> *list; /// 列表

@end

NS_ASSUME_NONNULL_END
