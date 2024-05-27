//
//  WMHomeTipView.h
//  SuperApp
//
//  Created by VanJay on 2020/8/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

typedef NS_ENUM(NSUInteger, WMHomeTipViewStyle) {
    WMHomeTipViewStyleDisapper = 0,               ///< 消失
    WMHomeTipViewStyleNotInTheScopeOfDeliverying, ///< 不在配送范围
    WMHomeTipViewStyleLackingLocationPermission,  ///< 无定位权限

};

NS_ASSUME_NONNULL_BEGIN


@interface WMHomeTipView : SAView
/// 更新 UI
- (void)updateUIForStyle:(WMHomeTipViewStyle)style;
/// 当前样式
@property (nonatomic, assign, readonly) WMHomeTipViewStyle style;
@end

NS_ASSUME_NONNULL_END
