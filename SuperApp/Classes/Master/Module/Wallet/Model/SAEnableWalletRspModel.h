//
//  SAEnableWalletRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAEnableWalletRspModel : SARspModel
/// 用户手机号
@property (nonatomic, copy) NSString *loginName;
/// 用户编号
@property (nonatomic, copy) NSString *userNo;
/// 电子账号
@property (nonatomic, copy) NSString *accountNo;
@end

NS_ASSUME_NONNULL_END
