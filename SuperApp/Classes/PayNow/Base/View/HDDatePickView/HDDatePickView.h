//
//  HDDatePickView.h
//  customer
//
//  Created by 帅呆 on 2018/11/5.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDDatePickStyle) { HDDatePickStyleDMY, HDDatePickStyleMY };

@class HDDatePickView;

@protocol HDDatePickViewDelegate <NSObject>
@optional
- (void)HDDatePickView:(HDDatePickView *)pickView ValueChange:(NSString *)date;

@end


@interface HDDatePickView : UIPickerView

@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, weak) id<HDDatePickViewDelegate> HDDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(HDDatePickStyle)style;
- (NSString *)getSelectDate;
- (void)setCurrentDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
