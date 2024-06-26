//
//  WMOrderRefundDetailHeaderView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class WMOrderDetailRefundInfoModel;


@interface WMOrderRefundDetailHeaderView : SAView
- (void)updateUIWithOrderDetailRefundInfo:(WMOrderDetailRefundInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
