//
//  TNSpecialActivityGuidePopView.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecialActivityGuidePopView.h"
#import <LOTAnimationView.h>


@interface TNSpecialActivityGuidePopView ()
///
@property (nonatomic, assign) TNSpecialStyleType styleType;
/// 动画视图
@property (strong, nonatomic) LOTAnimationView *animationView;
///
@property (strong, nonatomic) UILabel *descLabel;
@end


@implementation TNSpecialActivityGuidePopView
- (instancetype)initWithSpecialType:(TNSpecialStyleType)styleType {
    self.styleType = styleType;
    return [super init];
}

- (void)hd_setupViews {
    self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.8];
    [self addSubview:self.animationView];
    [self addSubview:self.descLabel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.animationView addGestureRecognizer:tap];
}

- (void)showFromSourceView:(UIView *)sourceView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];

    CGRect sourceFrame = [sourceView convertRect:sourceView.bounds fromView:self];
    [self.animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(-sourceFrame.origin.y);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(155), kRealWidth(90)));
    }];
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.animationView.mas_bottom).offset(kRealWidth(30));
    }];

    [self.animationView play];
    /// 6s后关闭
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:6];
}
- (void)dismiss {
    if (self.animationView) {
        [self.animationView stop];
    }
    if (self) {
        [self removeFromSuperview];
    }
}
/** @lazy animationView */
- (LOTAnimationView *)animationView {
    if (!_animationView) {
        _animationView = [[LOTAnimationView alloc] init];
        if (self.styleType == TNSpecialStyleTypeHorizontal) {
            [_animationView setAnimationNamed:@"SpecialTopicHorizontalGuide"];
        } else if (self.styleType == TNSpecialStyleTypeVertical) {
            [_animationView setAnimationNamed:@"SpecialTopicVerticalGuide"];
        }
        _animationView.loopAnimation = YES;
        _animationView.userInteractionEnabled = YES;
    }
    return _animationView;
}
/** @lazy descLabel */
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _descLabel.numberOfLines = 0;
        _descLabel.text = TNLocalizedString(@"jeKXcBaw", @"点击按钮可切换页面的样式");
    }
    return _descLabel;
}
@end
