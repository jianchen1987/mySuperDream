//
//  GNProductPagingRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNProductModel.h"
#import "SACommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNProductPagingRspModel : SACommonPagingRspModel
/// 列表
@property (nonatomic, copy) NSArray<GNProductModel *> *list;

@end

NS_ASSUME_NONNULL_END
