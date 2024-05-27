//
//  HDAuxiliaryToolHomeWindow.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolHomeWindow.h"
#import <HDKitCore/HDKitCore.h>


@implementation HDAuxiliaryToolHomeWindow

+ (instancetype)shared {
    static dispatch_once_t once;
    static HDAuxiliaryToolHomeWindow *instance;
    dispatch_once(&once, ^{
        instance = [[HDAuxiliaryToolHomeWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.f;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

- (void)openPlugin:(UIViewController *)vc {
    [self setRootVc:vc];
    self.hidden = NO;
}

- (void)show {
    HDAuxiliaryToolViewController *vc = [[HDAuxiliaryToolViewController alloc] init];
    [self setRootVc:vc];

    self.hidden = NO;
}

- (void)hide {
    [self setRootVc:nil];

    self.hidden = YES;
}

- (void)setRootVc:(UIViewController *)rootVc {
    if (rootVc) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVc];
        NSDictionary *attributesDic = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
        [nav.navigationBar setTitleTextAttributes:attributesDic];
        _nav = nav;

        self.rootViewController = nav;
    } else {
        self.rootViewController = nil;
        _nav = nil;
    }
}
@end
