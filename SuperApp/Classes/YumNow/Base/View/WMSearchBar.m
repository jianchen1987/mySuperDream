//
//  WMSearchBar.m
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSearchBar.h"
#import "HDAppTheme+YumNow.h"


@implementation WMSearchBar

- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *contentView = [self valueForKey:@"contentView"];
    contentView.layer.cornerRadius = 2;

    UIImageView *imageView = [self valueForKey:@"imageView"];
    imageView.image = [UIImage imageNamed:@"yn_home_sear"];

    UIButton *leftButton = [self valueForKey:@"leftButton"];
    [leftButton setImage:[UIImage imageNamed:@"yn_home_back"] forState:UIControlStateNormal];

    UIButton *rightButton = [self valueForKey:@"rightButton"];
    rightButton.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
}

///防止崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
