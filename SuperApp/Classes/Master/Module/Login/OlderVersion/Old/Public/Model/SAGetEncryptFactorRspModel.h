//
//  SAGetEncryptFactorRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAGetEncryptFactorRspModel : SARspModel
/// 私钥索引
@property (nonatomic, copy) NSString *index;
/// RSA 公钥
@property (nonatomic, copy) NSString *publicKey;
@end

NS_ASSUME_NONNULL_END
