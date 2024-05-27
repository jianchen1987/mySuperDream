//
//  TNBargainSuspendWindow.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainSuspendWindow.h"
#import "HDMediator+TinhNow.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDActionAlertView.h>


@implementation TNBargainRootViewController
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end


@interface TNBargainSuspendWindow ()
/// 按钮
@property (nonatomic, strong) UIButton *entryBtn;
/// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/// 是否正在展示
@property (atomic, assign) BOOL isShowing;

@end


@implementation TNBargainSuspendWindow
#pragma mark - life cycle
static CGFloat _kEntryViewSize = 72;
- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    UIButton *entryBtn = [[UIButton alloc] initWithFrame:self.bounds];
    entryBtn.backgroundColor = [UIColor clearColor];
    entryBtn.adjustsImageWhenHighlighted = false;
    [entryBtn setImage:[UIImage imageNamed:@"tinhnow_my_record"] forState:UIControlStateNormal];
    [entryBtn addTarget:self action:@selector(clickedMineRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:entryBtn];
    _entryBtn = entryBtn;

    //    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //    self.panGestureRecognizer = panGestureRecognizer;
    //    [self addGestureRecognizer:panGestureRecognizer];
}

- (instancetype)init {
    CGRect frame = (CGRect){0, 0, CGSizeMake(_kEntryViewSize, _kEntryViewSize)};
    frame.size = CGSizeMake(_kEntryViewSize, _kEntryViewSize);
    frame.origin.x = kScreenWidth - _kEntryViewSize - 10;
    frame.origin.y = kScreenHeight - _kEntryViewSize - kTabBarH - 157;
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)clickedMineRecordButton:(UIButton *)btn {
    [self expand];
    [[HDMediator sharedInstance] navigaveToTinhNowMyBargainRecordViewController:@{}];
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

#pragma mark - setter
- (void)setDisablePanGesture:(BOOL)disablePanGesture {
    _disablePanGesture = disablePanGesture;

    self.panGestureRecognizer.enabled = !disablePanGesture;
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
            frame.origin.x = kScreenWidth - _kEntryViewSize - 10;
        } else {
            frame.origin.x = 10;
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
    [self showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)showInView:(UIView *)inView {
    if (inView != nil) {
        [inView addSubview:self];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (CGRect)getIconFrame {
    CGRect rect = [_entryBtn convertRect:_entryBtn.bounds toView:[UIApplication sharedApplication].keyWindow];
    return rect;
}
@end
