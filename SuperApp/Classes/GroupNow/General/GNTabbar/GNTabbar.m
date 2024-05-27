//
//  GNTabbar.m
//  SuperApp
//
//  Created by wmz on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTabbar.h"
#import "GNTheme.h"


@implementation GNTabbar

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    if (self.selectedIndex != self.lastSelectIndex) {
        CGFloat indicatorWidth = kRealWidth(4);
        SATabBarButton *_btnLeft = nil;
        SATabBarButton *_btnRight = nil;
        if (self.selectedIndex > self.lastSelectIndex) {
            _btnLeft = self.buttons[self.lastSelectIndex];
            _btnRight = self.buttons[selectedIndex];
        } else {
            _btnLeft = self.buttons[selectedIndex];
            _btnRight = self.buttons[self.lastSelectIndex];
        }
        if (self.selectedIndex > self.lastSelectIndex) {
            [UIView animateWithDuration:0.1 animations:^{
                CGRect rect = self.line.frame;
                rect.origin.x = _btnLeft.center.x - indicatorWidth / 2;
                rect.size.width = indicatorWidth + (_btnRight.center.x - _btnLeft.center.x);
                self.line.frame = rect;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect rect = self.line.frame;
                    rect.origin.x = _btnRight.center.x;
                    rect.size.width -= (_btnRight.center.x - _btnLeft.center.x);
                    self.line.frame = rect;
                }];
            }];
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                CGRect rect = self.line.frame;
                rect.origin.x = _btnRight.center.x - indicatorWidth / 2 - (_btnRight.center.x - _btnLeft.center.x);
                rect.size.width = indicatorWidth + (_btnRight.center.x - _btnLeft.center.x);
                self.line.frame = rect;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect rect = self.line.frame;
                    rect.origin.x = _btnLeft.center.x;
                    rect.size.width -= (_btnRight.center.x - _btnLeft.center.x);
                    self.line.frame = rect;
                }];
            }];
        }
    }
    self.lastSelectIndex = selectedIndex;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    ///线条
    if ([self.subviews indexOfObject:self.line] == NSNotFound) {
        [self addSubview:self.line];
    }
    //    if ([self.subviews indexOfObject:self.backView] == NSNotFound) {
    //        ///毛玻璃
    ////        [self insertSubview:self.backView atIndex:0];
    //        if (@available(iOS 15.0, *)) {
    //            self.standardAppearance.backgroundImage = self.backView.image;
    //            self.scrollEdgeAppearance.backgroundImage = self.backView.image;
    //            ;
    //        } else {
    //            self.backgroundImage = self.backView.image;
    //        }
    //    }
    //
    //    ///隐藏挡住的背景
    //    for (UIView *view in self.subviews) {
    //        if ([NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"]) {
    //            view.alpha = (self.selectedIndex != 0);
    //        }
    //    }
}

- (UIImageView *)backView {
    if (!_backView) {
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTabBarH)];
        backView.image = [UIImage hd_imageWithColor:[UIColor colorWithWhite:1 alpha:0.5] size:CGSizeMake(SCREEN_WIDTH, kTabBarH)];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTabBarH);
        [backView addSubview:effectView];
        _backView = backView;
    }
    return _backView;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
        _line.layer.cornerRadius = kRealWidth(1);
        _line.frame = CGRectMake(0, 0, kRealWidth(4), kRealWidth(2));
        if (self.buttons.count > self.selectedIndex) {
            _line.center = CGPointMake(self.buttons[self.selectedIndex].center.x, _line.center.y);
        }
    }
    return _line;
}

@end
