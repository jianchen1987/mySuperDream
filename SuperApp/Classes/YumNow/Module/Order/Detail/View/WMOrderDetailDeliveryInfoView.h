//
//  WMOrderDetailDeliveryInfoView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailDeliveryInfoView : SAView
- (void)configureWithOrderDetailModel:(WMOrderDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
