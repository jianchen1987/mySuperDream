//
//  WMCheckIsStoreCanDeliveryRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCheckIsStoreCanDeliveryRspModel : WMRspModel
/// 是否可配送
@property (nonatomic, copy) SABoolValue canDelivery;
@end

NS_ASSUME_NONNULL_END
