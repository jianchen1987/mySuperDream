//
//  SAUGCReportView.h
//  SuperApp
//
//  Created by seeu on 2022/11/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUGCReportView : SAView

+ (SAUGCReportView *)reportViewWithFrame:(CGRect)frame;

///< 点击背景是否应该关闭，默认否
@property (nonatomic, assign) bool shouldRemoveMaskWhenTouchInBackground;

/// 点击了关闭
@property (nonatomic, copy) void (^closeClickedHandler)(void);
/// 点击了上报按钮
@property (nonatomic, copy) void (^reportClickedHander)(NSString *_Nonnull reason);

@end

NS_ASSUME_NONNULL_END
