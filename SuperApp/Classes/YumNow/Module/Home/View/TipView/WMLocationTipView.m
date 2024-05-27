//
//  WMLocationTipView.m
//  SuperApp
//
//  Created by wmz on 2021/12/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMLocationTipView.h"


@interface WMLocationTipView () <CAAnimationDelegate>

@end


@implementation WMLocationTipView

- (void)hd_setupViews {
    self.alpa = 1;
    [self addSubview:self.iconIV];
    [self.iconIV addSubview:self.closeBTN];
    [self.iconIV addSubview:self.titleLB];
    [self hd_changeUI];
    //    self.backgroundColor = UIColor.orangeColor;
}

- (void)hd_changeUI {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];


    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.closeBTN.isHidden) {
            make.right.mas_equalTo(-kRealWidth(10));
            make.centerY.equalTo(self.titleLB);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(45), kRealWidth(45)));
        }
    }];


    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        if (self.closeBTN.isHidden || [self.subviews indexOfObject:self.closeBTN] == NSNotFound) {
            make.right.mas_equalTo(-kRealWidth(16));
        } else {
            make.right.equalTo(self.closeBTN.mas_left).offset(-kRealWidth(10));
        }
        make.bottom.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(20));
    }];
}

- (void)show {
    if (self.show || !self.hidden)
        return;
    self.hidden = NO;
    [self layoutIfNeeded];
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = [NSNumber numberWithFloat:1.25];
    scale.toValue = [NSNumber numberWithFloat:1.0];

    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:0.5];
    showViewAnn.toValue = [NSNumber numberWithFloat:1];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale, showViewAnn];
    group.duration = 0.2;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:group forKey:nil];
    self.show = YES;
}

- (void)dissmiss {
    if (!self.show || self.isHidden)
        return;
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = [NSNumber numberWithFloat:1];
    scale.toValue = [NSNumber numberWithFloat:1.25];

    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:self.alpa];
    showViewAnn.toValue = [NSNumber numberWithFloat:0];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale, showViewAnn];
    group.duration = 0.2;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [self.layer addAnimation:group forKey:nil];
    self.show = NO;
}

#pragma - mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.hidden = YES;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.image = [UIImage imageNamed:@"home_location_bg"];
        _iconIV.userInteractionEnabled = YES;
    }
    return _iconIV;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.textColor = UIColor.whiteColor;
        _titleLB.font = [HDAppTheme.font forSize:14];
        _titleLB.text = WMLocalizedString(@"wm_location_fail_tip", @"wm_location_fail_tip");
        _titleLB.numberOfLines = 0;
    }
    return _titleLB;
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        _closeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBTN setImage:[UIImage imageNamed:@"home_location_close"] forState:UIControlStateNormal];
        @HDWeakify(self)[_closeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self dissmiss];
        }];
    }
    return _closeBTN;
}

@end
