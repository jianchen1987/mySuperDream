//
//  WMOrderDeliveryOrToStoreView.h
//  SuperApp
//
//  Created by Tia on 2023/8/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDeliveryOrToStoreView : SAView
/// 是否到店自取
@property (nonatomic, copy) void (^pickupMethod)(BOOL toStore);

@end

NS_ASSUME_NONNULL_END
