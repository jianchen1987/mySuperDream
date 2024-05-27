//
//  WMOrderBriefRspModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

@class WMOrderEvaluationGoodsModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderBriefRspModel : WMRspModel

/// 数据源
@property (nonatomic, copy) NSArray<WMOrderEvaluationGoodsModel *> *list;

@end

NS_ASSUME_NONNULL_END
