//
//  SAOrderRefundDetailHeaderView.h
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class SAOrderRefundInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderRefundDetailHeaderView : SAView

- (void)updateUIWithOrderDetailRefundInfo:(SAOrderRefundInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
