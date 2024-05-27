//
//  PNLocationView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLocationView.h"


@interface PNLocationView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) HDUIButton *userLocationButton;
/// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) BOOL isShowing;
@end


@implementation PNLocationView

- (void)hd_setupViews {
    [self addSubview:self.userLocationButton];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGestureRecognizer.delegate = self;
    self.panGestureRecognizer = panGestureRecognizer;
    [self addGestureRecognizer:panGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    HDLog(@"跌倒：%@", gestureRecognizer.view.class);
    HDLog(@"跌倒2：%@", otherGestureRecognizer.view.class);
    return NO;
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.userLocationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark
static CGFloat _kEntryViewSize = 70;
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
        HDLog(@"UIGestureRecognizerStateEnded");
        [self fixesFrame];
    }
}

// 修正位置
- (void)fixesFrame {
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (self.center.x < kScreenWidth * 0.5f) {
            frame.origin.x = 0;
        } else {
            frame.origin.x = kScreenWidth - self.userLocationButton.width;
        }

        self.frame = frame;
        self.userLocationButton.frame = self.bounds;
    } completion:^(BOOL finished){
    }];
}

#pragma mark
- (HDUIButton *)userLocationButton {
    if (!_userLocationButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:@"pn_user_current_location"] forState:0];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.buttonClickBlock ?: self.buttonClickBlock();
        }];

        _userLocationButton = button;
    }
    return _userLocationButton;
}

@end
