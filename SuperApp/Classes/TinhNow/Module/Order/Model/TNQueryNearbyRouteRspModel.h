//
//  TNQueryNearbyRouteRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/9/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNQueryNearbyRouteRspModel : TNRspModel
@property (nonatomic, copy) NSString *url; ///< 路由
@end

NS_ASSUME_NONNULL_END
