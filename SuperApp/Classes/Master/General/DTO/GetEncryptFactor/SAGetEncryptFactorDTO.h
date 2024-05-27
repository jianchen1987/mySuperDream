//
//  SAGetEncryptFactorDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAGetEncryptFactorRspModel.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAGetEncryptFactorDTO : SAViewModel

/// 获取加密因子
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getEncryptFactorSuccess:(void (^)(SAGetEncryptFactorRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 获取钱包加密因子（写在这里是后端获取加密因子接口会统一，方便移除重复逻辑）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getWalletEncryptFactorSuccess:(void (^)(SAGetEncryptFactorRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
