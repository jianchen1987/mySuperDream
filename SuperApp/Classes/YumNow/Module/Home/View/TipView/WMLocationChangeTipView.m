//
//  WMLocationChangeTipView.m
//  SuperApp
//
//  Created by Tia on 2023/7/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMLocationChangeTipView.h"


@interface WMLocationChangeTipView () <CAAnimationDelegate>
///关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// icon
@property (nonatomic, strong) UIImageView *bgIV;
///文本
@property (nonatomic, strong) YYLabel *titleLB;
///是否正在显示
@property (nonatomic, assign, getter=isShow) BOOL show;
///透明度 default 1
@property (nonatomic, assign) CGFloat alpa;

@property (nonatomic, strong) UIImageView *arrowIV;

@end


@implementation WMLocationChangeTipView

- (void)hd_setupViews {
    self.alpa = 1;
    [self addSubview:self.arrowIV];
    [self addSubview:self.bgIV];

    [self.bgIV addSubview:self.closeBTN];
    [self.bgIV addSubview:self.titleLB];
}

- (void)updateConstraints {
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(18, 8));
    }];

    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, 0, 0, 0));
    }];

    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(self.titleLB);
        make.size.mas_equalTo(CGSizeMake(16, 34));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.equalTo(self.closeBTN.mas_left).offset(-8);
        make.bottom.mas_equalTo(-8);
        make.top.mas_equalTo(8);
    }];

    [super updateConstraints];
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


#pragma mark - lazy load

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_trangle"]];
    }
    return _arrowIV;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.backgroundColor = UIColor.blackColor;
        _bgIV.userInteractionEnabled = YES;
        _bgIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _bgIV;
}

- (YYLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = YYLabel.new;
        _titleLB.textColor = UIColor.whiteColor;
        _titleLB.font = HDAppTheme.font.sa_standard12;
        _titleLB.preferredMaxLayoutWidth = kScreenWidth - 12 * 2 - 16 - 8;
        NSString *stringBlack1 = WMLocalizedString(@"wm_home_locaiton_relocaite", @"重新定位");
        NSString *stringGray = [NSString stringWithFormat:@"%@%@", WMLocalizedString(@"wm_home_locaiton_tip", @"当前定位发生改变，点击"), stringBlack1];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:stringGray];

        text.yy_font = HDAppTheme.font.sa_standard12;
        text.yy_color = UIColor.whiteColor;
        @HDWeakify(self);
        [text yy_setTextHighlightRange:[stringGray rangeOfString:stringBlack1] color:UIColor.whiteColor backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                 @HDStrongify(self);
                                 !self.relocationBlock ?: self.relocationBlock();
                             }];

        [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[stringGray rangeOfString:stringBlack1]];

        _titleLB.attributedText = text;
        _titleLB.numberOfLines = 0;
    }
    return _titleLB;
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        _closeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBTN setImage:[UIImage imageNamed:@"icon_search_del_bai"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_closeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dissmiss];
        }];
    }
    return _closeBTN;
}

@end
