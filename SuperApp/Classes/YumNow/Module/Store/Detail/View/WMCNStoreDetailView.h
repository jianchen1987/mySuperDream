//
//  WMCNStoreDetailView.h
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMStoreDetailBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCNStoreDetailView : WMStoreDetailBaseView
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *goodsProvider;
@end


@interface WMCNStoreScrollHeadView : UIScrollView <UIGestureRecognizerDelegate>

@end

NS_ASSUME_NONNULL_END
