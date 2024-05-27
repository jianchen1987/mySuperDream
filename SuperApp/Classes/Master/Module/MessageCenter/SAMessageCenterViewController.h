//
//  SAMessageCenterViewController.h
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageCenterViewController : SAViewController
/// 业务线
@property (nonatomic, copy) SAClientType clientType;
@end

NS_ASSUME_NONNULL_END
