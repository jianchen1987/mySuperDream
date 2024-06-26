//
//  PNFactorRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNFactorRspModel : PNModel
/// 私钥索引
@property (nonatomic, copy) NSString *index;
/// RSA公钥
@property (nonatomic, copy) NSString *publicKey;
@end

NS_ASSUME_NONNULL_END
