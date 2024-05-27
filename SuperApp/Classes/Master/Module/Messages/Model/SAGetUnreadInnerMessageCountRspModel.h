//
//  SAGetUnreadInnerMessageCountRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/7/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAGetUnreadInnerMessageCountRspModel : SARspModel
@property (nonatomic, assign) NSUInteger marketingMessageUnReadNumber; ///< 营销未读消息数
@property (nonatomic, assign) NSUInteger personalMessageUnReadNumber;  ///< 个人未读消息数
@end

NS_ASSUME_NONNULL_END
