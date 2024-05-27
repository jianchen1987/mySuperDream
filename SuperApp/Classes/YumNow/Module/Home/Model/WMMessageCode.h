//
//  WMMessageCode.h
//  SuperApp
//
//  Created by wmz on 2022/3/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMMessageCode : WMModel
/// message
@property (nonatomic, copy) NSString *message;
/// code
@property (nonatomic, copy) NSString *code;
@end

NS_ASSUME_NONNULL_END
