//
//  SAUrlBizMappingModel.h
//  SuperApp
//
//  Created by seeu on 2023/5/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUrlBizMappingModel : SACodingModel

///< 域名
@property (nonatomic, copy) NSString *hostName;
///< 路径
@property (nonatomic, copy) NSString *regx;
///< 业务线
@property (nonatomic, copy) NSString *bizName;

@end

NS_ASSUME_NONNULL_END
