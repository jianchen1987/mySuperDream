//
//  PNGuarateenShareManager.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNGuarateenDetailModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenShareManager : NSObject

+ (instancetype)sharedInstance;

- (void)shareGuarateenWithModel:(PNGuarateenDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
