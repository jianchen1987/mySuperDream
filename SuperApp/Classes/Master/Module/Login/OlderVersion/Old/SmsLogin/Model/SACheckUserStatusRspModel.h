//
//  SACheckUserStatusRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACheckUserStatusRspModel : SARspModel
/// 是否已激活，可能注册了但未设置密码，就是未激活
@property (nonatomic, assign) BOOL isActive;
/// 是否已注册
@property (nonatomic, assign) BOOL isRegistered;
@end

NS_ASSUME_NONNULL_END
