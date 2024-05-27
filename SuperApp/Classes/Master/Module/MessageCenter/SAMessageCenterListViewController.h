//
//  SAMessageCenterListViewController.h
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageCenterListViewController : SAViewController <HDCategoryListContentViewDelegate>
/// 业务线类型
@property (nonatomic, copy) SAClientType clientType;
/// 消息类型： 营销 | 个人
@property (nonatomic, copy) SAAppInnerMessageType messageType; ///< 消息类型

@end

NS_ASSUME_NONNULL_END
