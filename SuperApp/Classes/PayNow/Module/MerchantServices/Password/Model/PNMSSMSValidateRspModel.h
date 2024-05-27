//
//  PNMSSMSValidateRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSSMSValidateRspModel : PNModel
/// 流水号
@property (nonatomic, copy) NSString *serialNumber;
///
@property (nonatomic, copy) NSString *token;
@end

NS_ASSUME_NONNULL_END
