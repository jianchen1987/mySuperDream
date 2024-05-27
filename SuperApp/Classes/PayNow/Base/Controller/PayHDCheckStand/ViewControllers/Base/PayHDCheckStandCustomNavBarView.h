//
//  PayHDCheckstandCustomNavBarView.h
//  ViPay
//
//  Created by VanJay on 2019/5/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNUtilMacro.h"
#import <UIKit/UIKit.h>


@interface PayHDCheckstandCustomNavBarView : UIView
- (void)setLeftBtnImage:(NSString *)imageName title:(NSString *)title;
- (void)setTitleBtnImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font;
- (void)setRightBtnImage:(NSString *)imageName title:(NSString *)title;

@property (nonatomic, copy) VoidBlock clickedLeftBtnHandler;  ///< 点击了左按钮
@property (nonatomic, copy) VoidBlock clickedRightBtnHandler; ///< 点击了右按钮
@end
