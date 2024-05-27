//
//  PNContactUSModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNContactUSModel : PNModel
/// 电话
@property (nonatomic, strong) NSArray<NSString *> *hotlines;
/// 邮箱
@property (nonatomic, strong) NSArray<NSString *> *emails;
@end

NS_ASSUME_NONNULL_END
