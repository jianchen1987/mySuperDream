//
//  PNGetCardTypeRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGetCardTypeRspModel : PNModel
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;
@end

NS_ASSUME_NONNULL_END
