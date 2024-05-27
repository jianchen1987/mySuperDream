//
//  WMShoppingCartEntryWindow.m
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCartEntryWindow.h"
#import "HDMediator+TinhNow.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "TNShoppingCar.h"
#import "TNShoppingCartButton.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDActionAlertView.h>
#import <LOTAnimationView.h>


@implementation TNShoppingCartRootViewController
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end


@interface TNShoppingCartEntryWindow ()
/// 按钮
@property (nonatomic, strong) TNShoppingCartButton *entryBtn;
/// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/// 是否正在展示
@property (atomic, assign) BOOL isShowing;
/// 数据中心
@property (strong, nonatomic) TNShoppingCar *shopCarDataCenter;
/// 卡片动画图片
@property (strong, nonatomic) LOTAnimationView *animationImageView;
@end


@implementation TNShoppingCartEntryWindow
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
}
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TNShoppingCartEntryWindow *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - life cycle
static CGFloat _kEntryViewSize = 53;
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
    //            self.rootViewController = [[TNShoppingCartRootViewController alloc] init];
    //        }
    //    }

    TNShoppingCartButton *entryBtn = [[TNShoppingCartButton alloc] initWithFrame:self.bounds];
    entryBtn.backgroundColor = [UIColor clearColor];
    entryBtn.adjustsImageWhenHighlighted = false;
    [entryBtn setImage:[UIImage imageNamed:@"tn_cart_background"] forState:UIControlStateNormal];
    [entryBtn insertSubview:self.animationImageView atIndex:0];
    [entryBtn addTarget:self action:@selector(clickedShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.rootViewController.view addSubview:entryBtn];
    [self addSubview:entryBtn];
    _entryBtn = entryBtn;

    self.animationImageView.frame = CGRectMake(6, 6, entryBtn.bounds.size.width - 12, entryBtn.bounds.size.height - 12);

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panGestureRecognizer = panGestureRecognizer;
    [self addGestureRecognizer:panGestureRecognizer];

    self.isShowing = YES; //默认进来是显示的

    self.disablePanGesture = YES; //默认不能拖动

    [self updateIndicatorDotWithCount:self.shopCarDataCenter.totalGoodsCount];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"totalGoodsCount" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateIndicatorDotWithCount:self.shopCarDataCenter.totalGoodsCount];
    }];
}

- (instancetype)init {
    CGRect frame = (CGRect){0, 0, CGSizeMake(_kEntryViewSize, _kEntryViewSize)};
    frame.size = CGSizeMake(_kEntryViewSize, _kEntryViewSize);
    frame.origin.x = kScreenWidth - _kEntryViewSize;
    frame.origin.y = kScreenHeight - _kEntryViewSize - kRealWidth(130);
    //    kTabBarH - kRealWidth(25);
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)shake {
    [self.animationImageView play];
}
// 不能让该View成为keyWindow，每一次它要成为keyWindow的时候，都要将appDelegate的window指为keyWindow
//- (void)becomeKeyWindow {
//    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
//    [appWindow makeKeyWindow];
//}

- (void)clickedShoppingCartButton:(TNShoppingCartButton *)btn {
    [self expand];
    !self.cartClickTrackEventCallback ?: self.cartClickTrackEventCallback();
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(self.salesType)) {
        dict[@"tab"] = self.salesType;
    }
    [SAWindowManager openUrl:@"SuperApp://TinhNow/ShoppingCar" withParameters:dict];
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

//#pragma mark - Data
- (void)getShopppingCartInfo {
    // 刷新购物车浮层数量
    if ([SAUser hasSignedIn]) {
        [self.shopCarDataCenter queryUserShoppingTotalCountSuccess:nil failure:nil];
    }
}

#pragma mark - setter
- (void)setDisablePanGesture:(BOOL)disablePanGesture {
    _disablePanGesture = disablePanGesture;

    self.panGestureRecognizer.enabled = !disablePanGesture;
}

- (CGPoint)getCartButtonConvertPoint {
    CGPoint point = [self convertPoint:self.entryBtn.frame.origin toView:[UIApplication sharedApplication].keyWindow];
    point.x += 10;

    return point;
}

#pragma mark - public methods
// 显示
- (void)expand {
    if (self.isShowing) {
        return;
    }
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - _kEntryViewSize;
        } else {
            frame.origin.x = 0;
        }
        self.frame = frame;
        self.entryBtn.frame = self.bounds;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = YES;
    }];
}
// 隐藏
- (void)shrink {
    if (!self.isShowing) {
        return;
    }
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - 0.5 * _kEntryViewSize;
        } else {
            frame.origin.x = -0.5 * _kEntryViewSize;
        }
        self.frame = frame;
        self.entryBtn.frame = self.bounds;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = NO;
    }];
}
- (void)show {
    UIWindow *keyWindow = [SAWindowManager keyWindow];
    if (![keyWindow.subviews containsObject:self]) {
        [keyWindow addSubview:self];
        [self getShopppingCartInfo];
    } else {
        self.hidden = NO;
    }
}
- (void)dismiss {
    self.hidden = YES;
}
- (void)updateIndicatorDotWithCount:(NSUInteger)count {
    [self.entryBtn updateIndicatorDotWithCount:count];
}
- (void)setShoppintCarOffsetY:(CGFloat)offsetY {
    CGRect rect = self.frame;
    rect.origin.y = offsetY - _kEntryViewSize;
    self.frame = rect;
    [self layoutIfNeeded];
}
- (void)resetShoppintCarOffsetY {
    CGRect rect = self.frame;
    rect.origin.y = kScreenHeight - _kEntryViewSize - kRealWidth(130);
    self.frame = rect;
    [self layoutIfNeeded];
}
/** @lazy shopCarDataCenter */
- (TNShoppingCar *)shopCarDataCenter {
    if (!_shopCarDataCenter) {
        _shopCarDataCenter = [TNShoppingCar share];
    }
    return _shopCarDataCenter;
}
/** @lazy animationImageView */
- (LOTAnimationView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [LOTAnimationView animationNamed:@"CartShake"];
        _animationImageView.loopAnimation = NO;
        _animationImageView.cacheEnable = YES;
        _animationImageView.userInteractionEnabled = NO;
    }
    return _animationImageView;
}
#pragma mark - lazy load

@end
