//
//  HDAuxiliaryToolSliderView.h
//  SuperApp
//
//  Created by VanJay on 2019/11/24.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAuxiliaryToolSliderView : UIView

- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value;
- (instancetype)init NS_UNAVAILABLE;
@property (nonatomic, assign) CGFloat value; ///< 值
@property (nonatomic, copy) void (^sliderValueChangedHandler)(CGFloat value);
@end

NS_ASSUME_NONNULL_END
