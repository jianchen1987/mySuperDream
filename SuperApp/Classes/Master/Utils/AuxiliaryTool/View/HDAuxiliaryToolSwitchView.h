//
//  HDAuxiliaryToolSwitchView.h
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAuxiliaryToolSwitchView : UIView
- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn;
- (instancetype)init NS_UNAVAILABLE;
@property (nonatomic, assign, getter=isOn) BOOL on; ///< 开关
@property (nonatomic, copy) void (^switchValueChangedHandler)(BOOL isOn);
@end

NS_ASSUME_NONNULL_END
