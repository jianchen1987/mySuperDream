//
//  SAMCListViewController.h
//  SuperApp
//
//  Created by Tia on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMCListViewController : SAViewController
/// 业务线类型
@property (nonatomic, copy) SAClientType clientType;
/// 消息类型： 营销 | 个人
@property (nonatomic, copy) SAAppInnerMessageType messageType; ///< 消息类型

@end

NS_ASSUME_NONNULL_END
