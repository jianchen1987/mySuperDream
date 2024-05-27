//
//  WMOrderDetailTrackingView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMOrderDetailTrackingTableViewCellModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailTrackingView : SAView <HDCustomViewActionViewProtocol>
- (instancetype)initWithTrackingModel:(NSArray<WMOrderDetailTrackingTableViewCellModel *> *)modelArray;
@end

NS_ASSUME_NONNULL_END
