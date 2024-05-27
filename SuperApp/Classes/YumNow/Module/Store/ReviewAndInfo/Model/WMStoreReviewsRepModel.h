//
//  WMStoreReviewsRepModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"

@class WMStoreProductReviewModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreReviewsRepModel : SACommonPagingRspModel

@property (nonatomic, copy) NSArray<WMStoreProductReviewModel *> *list;

@end

NS_ASSUME_NONNULL_END
