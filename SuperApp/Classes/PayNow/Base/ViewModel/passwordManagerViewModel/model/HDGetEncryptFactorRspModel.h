//
//  HDGetEncryptFactorRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/2.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"


@interface HDGetEncryptFactorRspModel : HDJsonRspModel

//@property (nonatomic, copy) NSString *encrypFactor;//原支付
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *publicKey;

@end
