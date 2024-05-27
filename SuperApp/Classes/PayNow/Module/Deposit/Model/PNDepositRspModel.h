//
//  PNDepositRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNDepositRspModel : PNModel
@property (nonatomic, copy) NSString *CoolCash;
@property (nonatomic, copy) NSString *Bakong;
@property (nonatomic, copy) NSString *Bank;
@property (nonatomic, copy) NSString *Other;
@end

NS_ASSUME_NONNULL_END
