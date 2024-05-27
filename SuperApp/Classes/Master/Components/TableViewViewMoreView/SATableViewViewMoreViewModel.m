//
//  SATableViewViewMoreViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewViewMoreViewModel.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDAppTheme.h>


@implementation SATableViewViewMoreViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(15), kRealWidth(8), kRealWidth(15));
        self.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:247 / 255.0 blue:250 / 255.0 alpha:1.0];
        self.textColor = HDAppTheme.color.C1;
        self.textFont = HDAppTheme.font.standard2Bold;
        self.iconTextMargin = 6;
        self.image = [UIImage imageNamed:@"arrow_right_bold"];
        self.topMargin = kRealWidth(12.5);
        self.bottomMargin = kRealWidth(12.5);
    }
    return self;
}
@end
