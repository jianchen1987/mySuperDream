//
//  WMOrderDetailOrderInfoView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOrderDetailRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailOrderInfoView : SAView

- (void)configureWithOrderDetailRspModel:(WMOrderDetailRspModel *)model;

@end

NS_ASSUME_NONNULL_END
