//
//  HDAuxiliaryToolWindow.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolWindow.h"
#import "HDAuxiliaryToolHomeWindow.h"
#import "HDAuxillaryToolStatusBarViewController.h"
#import <HDKitCore/HDKitCore.h>


@interface HDAuxiliaryToolWindow ()
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIButton *entryBtn;
@property (nonatomic, assign) CGFloat kEntryViewSize;
@end


@implementation HDAuxiliaryToolWindow
- (instancetype)init {
    _kEntryViewSize = 44;
    self = [super initWithFrame:CGRectMake(0, kScreenHeight / 4, _kEntryViewSize, _kEntryViewSize)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100.f;
        self.layer.masksToBounds = YES;
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 10.0) {
            if (!self.rootViewController) {
                self.rootViewController = [[UIViewController alloc] init];
            }
        } else {
            // iOS9.0的系统中，新建的window设置的rootViewController默认没有显示状态栏
            if (!self.rootViewController) {
                self.rootViewController = [[HDAuxillaryToolStatusBarViewController alloc] init];
            }
        }

        UIButton *entryBtn = [[UIButton alloc] initWithFrame:self.bounds];
        entryBtn.backgroundColor = [UIColor clearColor];
        // UIImage *image = [UIImage hd_imageWithShape:HDUIImageShapeDetailButtonImage size:CGSizeMake(40, 40) lineWidth:2 tintColor:UIColor.redColor];
        UIImage *image = [UIImage imageNamed:@"pn_wownow"];
        image = [image hd_imageWithClippedCornerRadius:image.size.height * 0.5];
        [entryBtn setImage:image forState:UIControlStateNormal];
        entryBtn.layer.cornerRadius = 20.;
        [entryBtn addTarget:self action:@selector(entryButtonClickedHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.rootViewController.view addSubview:entryBtn];
        _entryBtn = entryBtn;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)showClose:(NSNotification *)notification {
    UIImage *image = [UIImage hd_imageWithShape:HDUIImageShapeNavClose size:CGSizeMake(30, 30) lineWidth:2 tintColor:UIColor.blackColor];
    [_entryBtn setImage:image forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(showClose:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closePluginClick:(UIButton *)btn {
    UIImage *image = [UIImage imageNamed:@"pn_wownow"];
    image = [image hd_imageWithClippedCornerRadius:image.size.height * 0.5];
    [_entryBtn setImage:image forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(entryButtonClickedHandler:) forControlEvents:UIControlEventTouchUpInside];
}

// 不能让该View成为keyWindow，每一次它要成为keyWindow的时候，都要将appDelegate的window指为keyWindow
- (void)becomeKeyWindow {
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

/**
 进入工具主面板
 */
- (void)entryButtonClickedHandler:(UIButton *)btn {
    if ([HDAuxiliaryToolHomeWindow shared].isHidden) {
        [[HDAuxiliaryToolHomeWindow shared] show];
    } else {
        [[HDAuxiliaryToolHomeWindow shared] hide];
    }
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    // 1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    // 2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    // 3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.centerX + offsetPoint.x;
    CGFloat newY = panView.centerY + offsetPoint.y;
    if (newX < _kEntryViewSize / 2) {
        newX = _kEntryViewSize / 2;
    }
    if (newX > kScreenWidth - _kEntryViewSize / 2) {
        newX = kScreenWidth - _kEntryViewSize / 2;
    }
    if (newY < _kEntryViewSize / 2) {
        newY = _kEntryViewSize / 2;
    }
    if (newY > kScreenHeight - _kEntryViewSize / 2) {
        newY = kScreenHeight - _kEntryViewSize / 2;
    }
    panView.center = CGPointMake(newX, newY);
}

@end
