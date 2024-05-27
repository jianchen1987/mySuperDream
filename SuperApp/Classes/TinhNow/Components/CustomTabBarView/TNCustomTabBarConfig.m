//
//  TNCustomTabBarConfig.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCustomTabBarConfig.h"


@implementation TNCustomTabBarItem
+ (instancetype)itemWithTitle:(NSString *)title
            unSelectImageName:(NSString *)unSelectImageName
              selectImageName:(NSString *)selectImageName
                unSelectColor:(UIColor *)unSelectColor
                  selectColor:(UIColor *)selectColor
                         font:(nonnull UIFont *)font {
    TNCustomTabBarItem *item = [[TNCustomTabBarItem alloc] init];
    item.title = title;
    item.unSelectImageName = unSelectImageName;
    item.selectImageName = selectImageName;
    item.unSelectColor = unSelectColor;
    item.selectColor = selectColor;
    item.font = font;
    return item;
}
@end


@implementation TNCustomTabBarConfig
@end
