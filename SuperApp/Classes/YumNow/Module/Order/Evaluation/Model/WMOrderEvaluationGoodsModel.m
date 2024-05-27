//
//  WMOrderEvaluationFeedbackItemModel.m
//  SuperApp
//
//  Created by Chaos on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderEvaluationGoodsModel.h"


@implementation WMOrderEvaluationGoodsModel

- (NSDictionary *)submitItem {
    return @{
        @"itemId": self.commodityId ?: @"",
        @"itemName": self.commodityName ?: @"",
        @"orderNo": self.orderNo ?: @"",
        @"dislike": self.status == WMOrderEvaluationFoodItemViewStatusLike ? @(10) : @(11),
        // @"businessLine":
    };
}
@end
