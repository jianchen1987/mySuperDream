//
//  HDPopTip.m
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopTip.h"
#import "HDPopTipView.h"
#import <HDKitCore/NSArray+HDKitCore.h>


@interface HDPopTip ()
@property (nonatomic, strong) HDPopTipView *popTipView;                                             ///< 提示 View
@property (nonatomic, assign) BOOL observing;                                                       ///< 状态
@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(void)> *dismissHandlerQueue; ///< 消失回调
@end


@implementation HDPopTip
#pragma mark - life cycle
+ (HDPopTip *)shared {
    static dispatch_once_t onceToken;
    static HDPopTip *instance = nil;
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
+ (void)showPopTipInView:(UIView *__nullable)view fromView:(UIView *)fromView config:(HDPopTipConfig *__nullable)config {
    [[self shared] showPopTipInView:view fromView:fromView config:config];
}

+ (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopTipConfig *> *)configs onlyInControllerClass:(Class __nullable)controllerClass {
    [self.shared showPopTipInView:view configs:configs onlyInControllerClass:controllerClass];
}

+ (void)dismissAnimated:(BOOL)animated {
    [[self shared] dismissAnimated:animated];
}

- (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopTipConfig *> *)configs onlyInControllerClass:(Class __nullable)controllerClass {
    view = view ?: [UIApplication sharedApplication].windows.firstObject;

    if (_popTipView) {
        // 保存剩余配置
        NSArray<HDPopTipConfig *> *leftConfigs = _popTipView.currentLeftConfigs.copy;

        if (leftConfigs && leftConfigs.count > 0) {
            // 新的优先级更高
            [leftConfigs enumerateObjectsUsingBlock:^(HDPopTipConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                [configs enumerateObjectsUsingBlock:^(HDPopTipConfig *_Nonnull objNew, NSUInteger idxNew, BOOL *_Nonnull stopNew) {
                    if ([obj.identifier isEqualToString:objNew.identifier]) {
                        obj.sourceView = objNew.sourceView;
                    }
                }];
            }];

            // 原来的配置在前面
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:leftConfigs];

            NSArray<NSString *> *leftIDArr = [leftConfigs mapObjectsUsingBlock:^id _Nonnull(HDPopTipConfig *_Nonnull obj, NSUInteger idx) {
                return obj.identifier;
            }];
            // 加上新增的
            configs = [configs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDPopTipConfig *_Nullable cfg, NSDictionary<NSString *, id> *_Nullable bindings) {
                                   return ![leftIDArr containsObject:cfg.identifier];
                               }]];

            [newArray addObjectsFromArray:configs];

            configs = newArray;
        }
        [_popTipView setCurrentConfigs:configs onlyInControllerClass:controllerClass];
        return;
    }

    if (!_observing) {
        _observing = YES;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }

    _popTipView = [[HDPopTipView alloc] init];

    // 过滤没有 sourceView 的
    configs = [configs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDPopTipConfig *_Nullable obj, NSDictionary<NSString *, id> *_Nullable bindings) {
                           return obj.sourceView != nil;
                       }]];

    [_popTipView showPopTipInView:view configs:configs onlyInControllerClass:controllerClass];
}

- (void)showPopTipInView:(UIView *)view fromView:(UIView *)fromView config:(HDPopTipConfig *)config {
    config = config ?: [[HDPopTipConfig alloc] init];
    if (!fromView)
        return;
    config.sourceView = fromView;
    [self showPopTipInView:view configs:@[config] onlyInControllerClass:nil];
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
