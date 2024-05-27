//
//  HDAuxiliaryToolShowFPSWindow.m
//  SuperApp
//
//  Created by VanJay on 2019/11/25.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolShowFPSWindow.h"
#import "HDAuxiliaryToolShowFPSViewController.h"


@implementation HDAuxiliaryToolShowFPSWindow

+ (instancetype)shared {
    static dispatch_once_t once;
    static HDAuxiliaryToolShowFPSWindow *instance;
    dispatch_once(&once, ^{
        instance = [[HDAuxiliaryToolShowFPSWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        instance.windowLevel = UIWindowLevelStatusBar + 3;
    });
    return instance;
}

- (void)addRootVc {
    HDAuxiliaryToolShowFPSViewController *vc = [[HDAuxiliaryToolShowFPSViewController alloc] init];
    self.rootViewController = vc;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UILabel *label = ((HDAuxiliaryToolShowFPSViewController *)self.rootViewController).displayLabel;

    if (label.userInteractionEnabled && CGRectContainsPoint(label.frame, point)) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

@end
