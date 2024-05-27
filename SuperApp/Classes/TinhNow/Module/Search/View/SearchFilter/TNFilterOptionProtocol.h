//
//  TNFilterOptionProtocol.h
//  SuperApp
//
//  Created by seeu on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNFilterEnum.h"
#import <UIKit/UIKit.h>

@protocol TNFilterOptionProtocol <NSObject>

@required
/// 用指定宽度布局
/// @param width 宽度
- (CGFloat)TN_layoutWithWidth:(CGFloat)width;

/// 当前的筛选值
- (NSDictionary<TNSearchFilterOptions, NSObject *> *)TN_currentOptions;

@end
