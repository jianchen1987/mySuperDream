//
//  PNMSReceiveCodeRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSReceiveCodeRspModel : PNModel
@property (nonatomic, copy) NSString *qrData;

/// 辅助
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *currency;
@end

NS_ASSUME_NONNULL_END
