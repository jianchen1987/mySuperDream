//
//  WMOrderDetailCancelOrderRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailCancelOrderRspModel : WMRspModel
/// 业务状态
@property (nonatomic, assign) WMBusinessStatus targetBizState;
@end

NS_ASSUME_NONNULL_END
