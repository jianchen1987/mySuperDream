//
//  SADatePickerView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SADatePickerStyle) {
    SADatePickerStyleDMY, ///< 日月年
    SADatePickerStyleMY   ///< 月年
};

@class SADatePickerView;

@protocol SADatePickerViewDelegate <NSObject>

@optional
/// 日期变化
- (void)datePickerView:(SADatePickerView *)pickView valueChange:(NSString *)date;
/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date;
@end


@interface SADatePickerView : SAView
/// 最大日期
@property (nonatomic, strong) NSDate *maxDate;
/// 最小日期
@property (nonatomic, strong) NSDate *minDate;
/// 代理
@property (nonatomic, weak) id<SADatePickerViewDelegate> delegate;
/// 点击了取消
@property (nonatomic, copy) void (^clickedCancelBlock)(void);
/// 当前日期
@property (nonatomic, copy, readonly) NSString *currentDateStr;

- (instancetype)initWithFrame:(CGRect)frame style:(SADatePickerStyle)style;
/// 设置默认日期
- (void)setCurrentDate:(NSDate *)date;
/// 设置标题
- (void)setTitleText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
