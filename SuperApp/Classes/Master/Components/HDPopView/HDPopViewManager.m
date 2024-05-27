//
//  HDPopViewManager.m
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopViewManager.h"
#import "HDPopView.h"
#import <HDKitCore/NSArray+HDKitCore.h>


@interface HDPopViewManager ()
@property (nonatomic, strong) HDPopView *popTipView;                                                ///< 提示 View
@property (nonatomic, assign) BOOL observing;                                                       ///< 状态
@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(void)> *dismissHandlerQueue; ///< 消失回调
@end


@implementation HDPopViewManager
#pragma mark - life cycle
+ (HDPopViewManager *)shared {
    static dispatch_once_t onceToken;
    static HDPopViewManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

- (void)dealloc {
    if (_observing) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
}

#pragma mark - public methods
+ (void)showPopTipInView:(UIView *__nullable)view fromView:(UIView *)fromView config:(HDPopViewConfig *__nullable)config {
    [[self shared] showPopTipInView:view fromView:fromView config:config];
}

+ (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopViewConfig *> *)configs {
    [self.shared showPopTipInView:view configs:configs];
}

+ (void)dismissAnimated:(BOOL)animated {
    [[self shared] dismissAnimated:animated];
}

- (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopViewConfig *> *)configs {
    view = view ?: [UIApplication sharedApplication].keyWindow;

    if (_popTipView) {
        [_popTipView removeFromSuperview];
        _popTipView = nil;
    }

    if (!_observing) {
        _observing = YES;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }

    _popTipView = [[HDPopView alloc] init];

    // 过滤没有 sourceView 的
    configs = [configs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDPopViewConfig *_Nullable obj, NSDictionary<NSString *, id> *_Nullable bindings) {
                           return obj.sourceView != nil;
                       }]];

    [_popTipView showPopTipInView:view configs:configs];
}

- (void)showPopTipInView:(UIView *)view fromView:(UIView *)fromView config:(HDPopViewConfig *)config {
    config = config ?: [[HDPopViewConfig alloc] init];
    if (!fromView)
        return;
    config.sourceView = fromView;
    [self showPopTipInView:view configs:@[config]];
}

+ (void)setDissmissHandler:(void (^__nullable)(void))completion withKey:(NSString *)key {
    if (key && [key isKindOfClass:NSString.class] && key.length > 0) {
        [self.shared.dismissHandlerQueue setObject:completion forKey:key];
    }

    __weak __typeof(self) weakSelf = self;
    self.shared.popTipView.dismissHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.shared invokeCallDismissHandler];
    };
}

#pragma mark - private methods
- (void)dismissAnimated:(BOOL)animated {
    if (_popTipView) {
        [_popTipView dismissAnimated:animated];
    }

    if (_observing) {
        _observing = NO;
        [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
}

- (void)orientationWillChange:(NSNotification *)n {
    [self dismissAnimated:NO];
}

- (void)invokeCallDismissHandler {
    [self.dismissHandlerQueue enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, void (^_Nullable dismissHandler)(void), BOOL *_Nonnull stop) {
        !dismissHandler ?: dismissHandler();
    }];
    // 移除所有回调
    [self.dismissHandlerQueue removeAllObjects];

    self.popTipView = nil;
}

#pragma mark - lazy load
- (NSMutableDictionary<NSString *, void (^)(void)> *)dismissHandlerQueue {
    if (!_dismissHandlerQueue) {
        _dismissHandlerQueue = [NSMutableDictionary dictionary];
    }
    return _dismissHandlerQueue;
}
@end
