//
//  SACMSFloatWindowPluginView.h
//  SuperApp
//
//  Created by seeu on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSPluginView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSFloatWindowPluginView : SACMSPluginView

/// 禁用拖动。默认开启手势，即不禁用
@property (nonatomic, assign) BOOL disablePanGesture;
/// 点击回调
@property (nonatomic, copy) void (^clickedHander)(SACMSPluginViewConfig *config);
/// 展开
- (void)expand;
/// 收起
- (void)shrink;

@end

NS_ASSUME_NONNULL_END
