//
//  WMAppTheme.h
//  SuperApp
//
//  Created by VanJay on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDAppTheme+YumNow.h"
#import <Foundation/Foundation.h>
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAppThemeColor (YumNow)
/// 金额颜色，#FF4444
@property (nonatomic, strong, readonly) UIColor *money;
/// 主题色
@property (nonatomic, strong, readonly) UIColor *mainColor;
/// 主题色2（FC821A）
@property (nonatomic, strong, readonly) UIColor *mainOrangeColor;

@end

NS_ASSUME_NONNULL_END
