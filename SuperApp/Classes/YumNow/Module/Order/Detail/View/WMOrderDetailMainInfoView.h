//
//  WMOrderDetailMainInfoView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMOrderDetailRspModel, SAInfoView;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailMainInfoView : SAView
/// 配送费
@property (nonatomic, strong, readonly) SAInfoView *deliveryFeeView;

- (void)configureWithOrderDetailRspModel:(WMOrderDetailRspModel *)model;
@end

NS_ASSUME_NONNULL_END
