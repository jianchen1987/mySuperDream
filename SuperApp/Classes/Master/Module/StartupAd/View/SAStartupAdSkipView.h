//
//  SAStartupAdSkipView.h
//  SuperApp
//
//  Created by Chaos on 2021/4/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAStartupAdSkipView : SAView

/// 跳过时间
@property (nonatomic, assign) NSUInteger skipTime;
/// 跳过回调
/// isClick：true为主动点击，false为倒计时结束
/// shownTime：已经展示了多少秒
@property (nonatomic, copy) void (^skipBlock)(BOOL isClick, NSUInteger shownTime);
/// 已展示时长
@property (nonatomic, assign, readonly) NSUInteger shownTime;

- (void)startTimer;
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
