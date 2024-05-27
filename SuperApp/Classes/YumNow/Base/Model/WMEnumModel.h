//
//  WMEnumModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMEnumModel : WMModel
/// 信息
@property (nonatomic, copy) NSString *message;
/// 枚举值
@property (nonatomic, copy) NSString *code;
/// 名称
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
