//
//  UIView+KeyBoardManager.m
//  customer
//
//  Created by VanJay on 2019/4/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAssociatedObjectHelper.h"
#import "HDDispatchMainQueueSafe.h"
#import "NSObject+HD_Swizzle.h"
#import "PNUtilMacro.h"
#import "UIView+HD_Extension.h"
#import "UIView+KeyBoardManager.h"
#import "UIViewController+HDKitCore.h"


@interface UIView ()

@property (nonatomic, assign, getter=isEnableUpSpring) BOOL enableUpSpring; ///< 是否开启跟随键盘向上弹起
@property (nonatomic, assign) CGFloat marginForSelfBottomToKeyBoardTop;     ///< 底部和键盘顶部间距
@property (nonatomic, assign) CGFloat distance;                             ///< 移动距离
@property (nonatomic, strong) UIView *maxTopRefrenceView;                   ///< 最大到其底部的参考 view
@property (nonatomic, assign) BOOL judgeCover;                              ///< 判断是否覆盖决定移动
@property (nonatomic, assign) CGFloat distanceToRefViewBottom;              ///< 距离参考控件的底部距离

@end


@implementation UIView (KeyBoardManager)
- (void)hd_dealloc {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (!self.isEnableUpSpring) {
        [self performSelector:NSSelectorFromString(@"hd_dealloc")];
        return;
    };

    // 移除监听键盘
    if ([self respondsToSelector:@selector(isEnableUpSpring)] && [self isEnableUpSpring]) {
        HDLog(@"%@ 移除了键盘监听", NSStringFromClass(self.class));
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [self performSelector:NSSelectorFromString(@"hd_dealloc")];
    }

#pragma clang diagnostic pop
}

#pragma mark - public methods
- (void)setFollowKeyBoardConfigEnable:(BOOL)enable margin:(CGFloat)margin refView:(UIView *__nullable)refView distanceToRefViewBottom:(CGFloat)distanceToRefViewBottom {
    [self setFollowKeyBoardConfigEnable:enable margin:margin refView:refView];
    self.distanceToRefViewBottom = distanceToRefViewBottom;
}

- (void)setFollowKeyBoardConfigEnable:(BOOL)enable margin:(CGFloat)margin refView:(UIView *__nullable)refView {
    self.judgeCover = YES;
    self.enableUpSpring = enable;
    self.marginForSelfBottomToKeyBoardTop = margin;
    self.maxTopRefrenceView = refView;
    self.distanceToRefViewBottom = 10;
}

- (void)setFollowKeyBoardConfigEnable:(BOOL)enable distance:(CGFloat)distance {
    self.judgeCover = NO;
    self.enableUpSpring = enable;
    self.distance = distance;
}

#pragma mark - event response
/**
 *  监听键盘弹出，改变View的frame
 */
- (void)hd_keyboardWillChangeFrame:(NSNotification *)notification {
    if (!self.isEnableUpSpring)
        return;

    // 取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 取得键盘最后和开始的frame
    CGFloat originEndY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;

    // 先清空 transform，解决切换键盘产生的错误位移
    self.transform = CGAffineTransformIdentity;

    CGFloat endY = originEndY - self.marginForSelfBottomToKeyBoardTop;

    // CGFloat startY = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;

    // 转换坐标系得到当前view相对于整个屏幕的坐标
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect selfFrameToKeywindow = [self convertRect:self.bounds toView:keyWindow];

    CGFloat minus = selfFrameToKeywindow.origin.y + selfFrameToKeywindow.size.height - endY;

    if (self.maxTopRefrenceView) {
        // 转换参考 view 的坐标
        CGRect refViewFrame = [self.maxTopRefrenceView convertRect:self.maxTopRefrenceView.bounds toView:keyWindow];

        // 判断是否高出参考 view，最大只能到 参考 view 的底部
        CGFloat refViewBottom = refViewFrame.origin.y + refViewFrame.size.height + self.distanceToRefViewBottom;
        if (selfFrameToKeywindow.origin.y - minus < refViewBottom) {
            minus = selfFrameToKeywindow.origin.y - refViewBottom;
        }
    }

    // 处理容器本身有 transform 的情况
    // UIView *superView = self.superview;
    // CGAffineTransform trans = superView.transform;
    // CGFloat transTy = trans.ty;

    //    BOOL isVCActive = self.viewController.isDisplaying && self.viewController.isLastVCInNavController;
    BOOL isVCActive = self.viewController.isLastVCInNavController;
    if (isVCActive && minus > 0) { // 遮住了当前输入框
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -minus);
            }];
        });
    }

    if (originEndY == [UIScreen mainScreen].bounds.size.height) { // 键盘下降
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        });
    }
}

/**
 *  监听键盘弹出，改变View的frame
 */
- (void)hd_keyboardWillChangeFrameNoJudge:(NSNotification *)notification {
    // 取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 取得键盘最后和开始的frame
    CGFloat originEndY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;

    CGFloat minus = self.distance;

    //    BOOL isVCActive = self.viewController.isDisplaying && self.viewController.isLastVCInNavController;
    BOOL isVCActive = self.viewController.isLastVCInNavController;
    isVCActive = YES;
    if (isVCActive && minus > 0) { // 遮住了当前输入框
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -minus);
            }];
        });
    }

    if (originEndY == [UIScreen mainScreen].bounds.size.height) { // 键盘下降
        hd_dispatch_main_async_safe(^{
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        });
    }
}

#pragma mark - getters and setters
- (void)setEnableUpSpring:(BOOL)enableUpSpring {
    if (enableUpSpring) {
        if (self.judgeCover) {
            // 监听键盘
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hd_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        } else {
            // 监听键盘
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hd_keyboardWillChangeFrameNoJudge:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
// 交换 dealloc 方法，销毁通知监听
// [self swizzleInstanceMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(hd_dealloc)];
#pragma clang diagnostic pop
    }

    [self willChangeValueForKey:@"enableUpSpring"];
    objc_setAssociatedObject(self, @selector(isEnableUpSpring), @(enableUpSpring), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"enableUpSpring"];
}

- (BOOL)isEnableUpSpring {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

HDSynthesizeCGFloatProperty(marginForSelfBottomToKeyBoardTop, setMarginForSelfBottomToKeyBoardTop);
HDSynthesizeCGFloatProperty(distance, setDistance);
HDSynthesizeCGFloatProperty(distanceToRefViewBottom, setDistanceToRefViewBottom);
HDSynthesizeBOOLProperty(judgeCover, setJudgeCover);
HDSynthesizeIdWeakProperty(maxTopRefrenceView, setMaxTopRefrenceView);
@end
