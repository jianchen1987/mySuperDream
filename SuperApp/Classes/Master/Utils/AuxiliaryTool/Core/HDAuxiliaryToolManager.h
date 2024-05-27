//
//  HDAuxiliaryToolManager.h
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAuxiliaryToolManager : NSObject
+ (instancetype)shared;
- (void)setup;
@end

NS_ASSUME_NONNULL_END
