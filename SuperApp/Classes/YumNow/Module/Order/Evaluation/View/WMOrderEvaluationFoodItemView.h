//
//  WMOrderEvaluationFoodItemView.h
//  SuperApp
//
//  Created by Chaos on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMOrderEvaluationGoodsModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderEvaluationFoodItemView : SAView

/// food
@property (nonatomic, strong) WMOrderEvaluationGoodsModel *model;

@end

NS_ASSUME_NONNULL_END
