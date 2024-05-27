//
//  GNOrderPagingRspModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderCellModel.h"
#import "SACommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderPagingRspModel : SACommonPagingRspModel

@property (nonatomic, copy) NSArray<GNOrderCellModel *> *list; /// 列表

@end

NS_ASSUME_NONNULL_END
