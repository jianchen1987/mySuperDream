//
//  SACancellationReasonModel.h
//  SuperApp
//
//  Created by Tia on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationReasonModel : SAModel
/** 注销原因，枚举：
unbind_mobile：需要解绑手机
security_concerns：安全/隐私顾虑
redundant_account：这是多余的账户
use_difficulty：WOWNOW使用遇到困难
other_reason：其他原因
 */
@property (nonatomic, copy) SACancellationReasonType type;
/// type为其他原因时，reason才有值
@property (nonatomic, copy) NSString *reason;

@end

NS_ASSUME_NONNULL_END
