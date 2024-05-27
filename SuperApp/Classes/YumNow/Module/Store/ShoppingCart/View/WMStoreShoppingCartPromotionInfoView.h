//
//  WMStoreShoppingCartPromotionInfoView.h
//  SuperApp
//
//  Created by Chaos on 2020/9/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreShoppingCartPromotionInfoView : SAView

- (void)updateUIWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel isStoreResting:(BOOL)isStoreResting;

@end

NS_ASSUME_NONNULL_END
