//
//  SAEnumModel.h
//  SuperApp
//
//  Created by seeu on 2021/8/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAEnumModel : SACodingModel
@property (nonatomic, copy) NSString *message; ///< 枚举描述
@property (nonatomic, assign) NSUInteger code; ///< 枚举值
@end

NS_ASSUME_NONNULL_END
