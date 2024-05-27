//
//  SAUploadFileGetAccessTokenRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUploadFileGetAccessTokenRspModel : SARspModel

/// 上传凭证
@property (nonatomic, copy) NSString *uploadTicket;
@end

NS_ASSUME_NONNULL_END
