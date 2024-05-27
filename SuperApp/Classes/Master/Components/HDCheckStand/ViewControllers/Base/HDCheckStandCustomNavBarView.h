//
//  HDCheckStandCustomNavBarView.h
//  SuperApp
//
//  Created by VanJay on 2019/5/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDCheckStandCustomNavBarView : UIView
- (void)setLeftBtnImage:(NSString *)imageName title:(NSString *)title;
- (void)setTitleBtnImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font;
- (void)setRightBtnImage:(NSString *)imageName title:(NSString *)title;

/// 点击了左按钮
@property (nonatomic, copy) void (^clickedLeftBtnHandler)(void);
/// 点击了右按钮
@property (nonatomic, copy) void (^clickedRightBtnHandler)(void);
@end
