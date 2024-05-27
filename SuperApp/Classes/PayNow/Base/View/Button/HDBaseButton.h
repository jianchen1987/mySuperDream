//
//  HDBaseButton.h
//  customer
//
//  Created by 陈剑 on 2018/7/5.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDBaseButton : UIButton

@property (nonatomic, strong) UIColor *fromColor;
@property (nonatomic, strong) UIColor *toColor;

@property (nonatomic, assign) BOOL showShadow;

@end
