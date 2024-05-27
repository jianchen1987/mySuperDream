//
//  PNEnumModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNEnumModel : SAModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSString *code;
@end

NS_ASSUME_NONNULL_END
