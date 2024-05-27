//
//  SADatePickerViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SADatePickerView.h"
#import "SANonePresentAnimationViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SADatePickerViewController : SANonePresentAnimationViewController
/// 代理
@property (nonatomic, weak) id<SADatePickerViewDelegate> delegate;
/// 风格
@property (nonatomic, assign) SADatePickerStyle datePickStyle;
/// 最大日期
@property (nonatomic, strong) NSDate *maxDate;
/// 最小日期
@property (nonatomic, strong) NSDate *minDate;

/// 设置标题
- (void)setTitleText:(NSString *)text;

/// 设置默认日期
- (void)setCurrentDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
