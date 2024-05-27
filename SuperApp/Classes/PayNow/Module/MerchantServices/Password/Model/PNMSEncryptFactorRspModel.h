//
//  PNMSEncryptFactorRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSEncryptFactorRspModel : PNModel

@property (nonatomic, copy) NSString *encrypFactor;
@property (nonatomic, copy) NSString *index;

@end

NS_ASSUME_NONNULL_END
