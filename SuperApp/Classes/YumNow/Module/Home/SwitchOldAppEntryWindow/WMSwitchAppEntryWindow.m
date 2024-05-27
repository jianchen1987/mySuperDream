//
//  WMSwitchAppEntryWindow.m
//  SuperApp
//
//  Created by seeu on 2020/9/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSwitchAppEntryWindow.h"
#import "SAWindowManager.h"
#import "WMMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>


@implementation WMSwitchAppViewController
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end


@interface WMSwitchAppEntryWindow ()

@property (nonatomic, strong) HDUIButton *buttton; ///<
/// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIImageView *tipsBackgroundView; ///< 背景
@property (nonatomic, strong) UILabel *tipsLabel;              ///< 引导文字

@end


@implementation WMSwitchAppEntryWindow

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WMSwitchAppEntryWindow *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - life cycle
static CGFloat _kEntryViewHight = 76;
static CGFloat _kEntryViewWidth = 98;
- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    //    self.windowLevel = HDActionAlertViewWindowLevel - 2;
    //    self.layer.masksToBounds = YES;
    //    NSString *version = [UIDevice currentDevice].systemVersion;
    //    if (version.doubleValue >= 10.0) {
    //        if (!self.rootViewController) {
    //            self.rootViewController = [[UIViewController alloc] init];
    //        }
    //    } else {
    //        // iOS 9.0的系统中，新建的window设置的rootViewController默认没有显示状态栏
    //        if (!self.rootViewController) {
    //            self.rootViewController = [[WMSwitchAppViewController alloc] init];
    //        }
    //    }

    HDUIButton *entryBtn = [[HDUIButton alloc] initWithFrame:CGRectMake((_kEntryViewWidth - 46) / 2.0, 0, 46, 46)];
    entryBtn.backgroundColor = [UIColor clearColor];
    entryBtn.adjustsImageWhenHighlighted = false;
    [entryBtn setImage:[UIImage imageNamed:@"back_YumNow_normal"] forState:UIControlStateNormal];
    [entryBtn setImage:[UIImage imageNamed:@"back_YumNow_highlight"] forState:UIControlStateHighlighted];
    [entryBtn addTarget:self action:@selector(clickedOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:entryBtn];
    _buttton = entryBtn;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_YumNow_bg"]];
    [imageView sizeToFit];
    imageView.center = CGPointMake(entryBtn.center.x, entryBtn.bottom + imageView.bounds.size.height / 2.0);
    [self addSubview:imageView];
    _tipsBackgroundView = imageView;

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10.0];
    label.textColor = HDAppTheme.color.G1;
    label.numberOfLines = 1;
    label.text = WMLocalizedString(@"wm_home_backYumNow", @"Back YumNow App");
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.center = CGPointMake(_tipsBackgroundView.bounds.size.width / 2.0, _tipsBackgroundView.bounds.size.height / 2.0 + 2);
    [_tipsBackgroundView addSubview:label];
    _tipsLabel = label;

    //    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //    self.panGestureRecognizer = panGestureRecognizer;
    //    [self addGestureRecognizer:panGestureRecognizer];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(languageDidChanged:) name:kNotificationNameLanguageChanged object:nil];
}

- (instancetype)init {
    CGRect frame = (CGRect){0, 0, CGSizeMake(_kEntryViewWidth, _kEntryViewHight)};
    frame.size = CGSizeMake(_kEntryViewWidth, _kEntryViewHight);
    frame.origin.x = kScreenWidth - _kEntryViewWidth - kRealWidth(10);
    frame.origin.y = kScreenHeight - _kEntryViewHight - kTabBarH - kRealWidth(10);
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLanguageChanged object:nil];
}

- (void)languageDidChanged:(NSNotification *)notification {
    self.tipsLabel.text = WMLocalizedString(@"wm_home_backYumNow", @"Back YumNow App");
    [self.tipsLabel sizeToFit];
    self.tipsLabel.center = CGPointMake(self.tipsBackgroundView.bounds.size.width / 2.0, self.tipsBackgroundView.bounds.size.height / 2.0 + 2);
}

// 不能让该View成为keyWindow，每一次它要成为keyWindow的时候，都要将appDelegate的window指为keyWindow
//- (void)becomeKeyWindow {
//    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
//    [appWindow makeKeyWindow];
//}

- (void)clickedOnButton:(HDUIButton *)btn {
    [self expand];
    NSURL *YumNow = [NSURL URLWithString:@"jhwaimai://"];
    if ([UIApplication.sharedApplication canOpenURL:YumNow]) {
        [UIApplication.sharedApplication openURL:YumNow options:@{} completionHandler:nil];
    } else {
        [SAWindowManager openUrl:@"https://h5.lifekh.com/mobile-h5/super/app/user/v1/download-app" withParameters:@{}];
    }
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    // 获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    // 清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    // 重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.center.x + offsetPoint.x;
    CGFloat newY = panView.center.y + offsetPoint.y;

    const CGFloat margin = kRealWidth(10);
    if (newX < _kEntryViewWidth / 2 + margin) {
        newX = _kEntryViewWidth / 2 + margin;
    }
    if (newX > kScreenWidth - _kEntryViewWidth / 2) {
        newX = kScreenWidth - _kEntryViewWidth / 2;
    }
    if (newY < _kEntryViewHight / 2 + kStatusBarH + margin) {
        newY = _kEntryViewHight / 2 + kStatusBarH + margin;
    }
    if (newY > kScreenHeight - _kEntryViewHight / 2 - kTabBarH) {
        newY = kScreenHeight - _kEntryViewHight / 2 - kTabBarH;
    }
    panView.center = CGPointMake(newX, newY);

    if (sender.state == UIGestureRecognizerStateEnded) {
        [self expand];
    }
}

#pragma mark - public methods
- (void)expand {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - _kEntryViewWidth - 10;
        } else {
            frame.origin.x = 10;
        }
        self.frame = frame;
        //                         self.buttton.frame = self.bounds;
    }];
}

- (void)shrink {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - 0.5 * _kEntryViewWidth;
        } else {
            frame.origin.x = -0.5 * _kEntryViewWidth;
        }
        self.frame = frame;
        //                         self.buttton.frame = self.bounds;
    }];
}

@end
