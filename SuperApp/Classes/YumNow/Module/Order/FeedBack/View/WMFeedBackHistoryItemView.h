//
//  WMFeedBackHistoryItemView.h
//  SuperApp
//
//  Created by wmz on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOrderFeedBackDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMFeedBackHistoryItemView : SAView
/// model
@property (nonatomic, strong) WMOrderFeedBackDetailModel *model;
@end


@interface WMFeedBackHistoryItemFoodView : SAView
/// model
@property (nonatomic, strong) WMShoppingCartStoreProduct *model;
@end

NS_ASSUME_NONNULL_END
