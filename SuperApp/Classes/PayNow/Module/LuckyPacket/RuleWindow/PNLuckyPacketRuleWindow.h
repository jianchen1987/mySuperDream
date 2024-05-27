//
//  PNRuleWindow.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNLuckyPacketRuleWindow : PNView
+ (instancetype)sharedInstance;
- (void)expand;
- (void)shrink;
- (void)show;
@end

NS_ASSUME_NONNULL_END
