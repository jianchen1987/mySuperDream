//
//  PNValidateSMSCodeRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNValidateSMSCodeRspModel : PNModel
/// token
@property (nonatomic, strong) NSString *token;
/// 流水号
@property (nonatomic, strong) NSString *serialNumber;
@end

NS_ASSUME_NONNULL_END
