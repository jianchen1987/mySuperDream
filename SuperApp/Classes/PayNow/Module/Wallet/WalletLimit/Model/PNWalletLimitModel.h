//
//  WalletLimitModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletLimitModel : PNModel

/// 业务类型
@property (nonatomic, assign) PNLimitType bizType;
@property (nonatomic, copy) NSString *bizName;
/// 币种
@property (nonatomic, copy) NSString *currency;
/// 经典账户
@property (nonatomic, copy) NSString *classicsLevel;
/// 高级账户
@property (nonatomic, copy) NSString *seniorLevel;
/// 尊享账户
@property (nonatomic, copy) NSString *enjoyLevel;
@end

NS_ASSUME_NONNULL_END
