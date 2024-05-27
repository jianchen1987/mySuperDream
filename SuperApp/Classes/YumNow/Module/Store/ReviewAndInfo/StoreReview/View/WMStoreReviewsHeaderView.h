//
//  WMStoreReviewsHeaderView.h
//  SuperApp
//
//  Created by Chaos on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMStoreReviewsViewModel.h"

@class WMReviewFilterView;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreReviewsHeaderView : SAView

/// VM
@property (nonatomic, strong) WMStoreReviewsViewModel *viewModel;
/// 筛选 View
@property (nonatomic, strong, readonly) WMReviewFilterView *filterView;

@end

NS_ASSUME_NONNULL_END
