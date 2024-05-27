//
//  WMShoppingCartEntryWindow.m
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartEntryWindow.h"
#import "HDMediator+YumNow.h"
#import "WMShoppingCartDTO.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDActionAlertView.h>


@implementation WMShoppingCartRootViewController
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end


@interface WMShoppingCartEntryWindow ()
/// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/// 购物车 DTO
@property (nonatomic, strong) WMShoppingCartDTO *shoppingCartDTO;
@end


@implementation WMShoppingCartEntryWindow

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WMShoppingCartEntryWindow *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - life cycle
static CGFloat _kEntryViewSize = 86;
- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.windowLevel = HDActionAlertViewWindowLevel - 2;
    self.layer.masksToBounds = YES;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 10.0) {
        if (!self.rootViewController) {
            self.rootViewController = [[UIViewController alloc] init];
        }
    } else {
        // iOS 9.0的系统中，新建的window设置的rootViewController默认没有显示状态栏
        if (!self.rootViewController) {
            self.rootViewController = [[WMShoppingCartRootViewController alloc] init];
        }
    }

    WMShoppingCartButton *entryBtn = [[WMShoppingCartButton alloc] initWithFrame:self.bounds];
    entryBtn.backgroundColor = [UIColor clearColor];
    entryBtn.adjustsImageWhenHighlighted = false;
    [entryBtn setImage:[UIImage imageNamed:@"shopping_cart"] forState:UIControlStateNormal];
    [entryBtn addTarget:self action:@selector(clickedShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootViewController.view addSubview:entryBtn];
    _entryBtn = entryBtn;

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panGestureRecognizer = panGestureRecognizer;
    [self addGestureRecognizer:panGestureRecognizer];

    [self getShopppingCartInfo];
}

- (instancetype)init {
    CGRect frame = (CGRect){0, 0, CGSizeMake(_kEntryViewSize, _kEntryViewSize)};
    frame.size = CGSizeMake(_kEntryViewSize, _kEntryViewSize);
    frame.origin.x = kScreenWidth - _kEntryViewSize - kRealWidth(10);
    frame.origin.y = kScreenHeight - _kEntryViewSize - kTabBarH - kRealWidth(25);
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

// 不能让该View成为keyWindow，每一次它要成为keyWindow的时候，都要将appDelegate的window指为keyWindow
- (void)becomeKeyWindow {
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

- (void)clickedShoppingCartButton:(WMShoppingCartButton *)btn {
    [self expand];

    [HDMediator.sharedInstance navigaveToShoppingCartViewController:nil];
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
    if (newX < _kEntryViewSize / 2 + margin) {
        newX = _kEntryViewSize / 2 + margin;
    }
    if (newX > kScreenWidth - _kEntryViewSize / 2) {
        newX = kScreenWidth - _kEntryViewSize / 2;
    }
    if (newY < _kEntryViewSize / 2 + kStatusBarH + margin) {
        newY = _kEntryViewSize / 2 + kStatusBarH + margin;
    }
    if (newY > kScreenHeight - _kEntryViewSize / 2 - kTabBarH) {
        newY = kScreenHeight - _kEntryViewSize / 2 - kTabBarH;
    }
    panView.center = CGPointMake(newX, newY);

    if (sender.state == UIGestureRecognizerStateEnded) {
        [self expand];
    }
}

#pragma mark - Data
- (void)getShopppingCartInfo {
    [self.shoppingCartDTO getUserShoppingCartInfoWithClientType:SABusinessTypeYumNow success:nil failure:nil];
}

#pragma mark - setter
- (void)setDisablePanGesture:(BOOL)disablePanGesture {
    _disablePanGesture = disablePanGesture;

    self.panGestureRecognizer.enabled = !disablePanGesture;
}

#pragma mark - public methods
- (void)expand {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - _kEntryViewSize - 10;
        } else {
            frame.origin.x = 10;
        }
        self.frame = frame;
        self.entryBtn.frame = self.bounds;
    }];
}

- (void)shrink {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - 0.5 * _kEntryViewSize;
        } else {
            frame.origin.x = -0.5 * _kEntryViewSize;
        }
        self.frame = frame;
        self.entryBtn.frame = self.bounds;
    }];
}

- (void)updateIndicatorDotWithCount:(NSUInteger)count {
    self.count = count;
    [self.entryBtn updateIndicatorDotWithCount:count];
}

#pragma mark - lazy load
- (WMShoppingCartDTO *)shoppingCartDTO {
    if (!_shoppingCartDTO) {
        _shoppingCartDTO = WMShoppingCartDTO.new;
    }
    return _shoppingCartDTO;
}
@end
