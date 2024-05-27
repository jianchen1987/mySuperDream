//
//  BizEntityModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"
#import "PNEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface BizEntityModel : HDJsonRspModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) PNTransferType code;
@end

NS_ASSUME_NONNULL_END
