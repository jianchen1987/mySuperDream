//
//  WMStoreProductDetailNavigationBarView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductDetailNavigationBarView.h"


@interface WMStoreProductDetailNavigationBarView ()
/// 背景
@property (nonatomic, strong) UIView *backgroundView;
/// 返回按钮
@property (nonatomic, strong) HDUIButton *backBTN;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 阴影图层
@property (nonatomic, strong) CAShapeLayer *shadowLayer;
@end


@implementation WMStoreProductDetailNavigationBarView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.titleLB];
    [self addSubview:self.backBTN];

    @HDWeakify(self);
    self.backgroundView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.shadowLayer) {
            [self.shadowLayer removeFromSuperlayer];
            self.shadowLayer = nil;
        }
        self.shadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                       shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                         fillColor:UIColor.whiteColor.CGColor
                                      shadowOffset:CGSizeMake(0, 3)];
    };
}

#pragma mark - public methods
- (void)updateTitle:(NSString *)title {
    self.titleLB.text = title;
}

- (void)updateUIWithScrollViewOffsetY:(CGFloat)offsetY {
    CGFloat offsetLimit = 0;
    offsetLimit = CGRectGetHeight(self.frame);

    // 布局未完成
    if (offsetLimit <= 0)
        return;

    CGFloat rate = offsetY / offsetLimit;
    rate = rate > 0.98 ? 1 : rate;
    rate = rate < 0.02 ? 0 : rate;

    if (rate > 0.5) {
        self.viewController.hd_statusBarStyle = UIStatusBarStyleDefault;
    } else {
        self.viewController.hd_statusBarStyle = UIStatusBarStyleLightContent;
    }
    // HDLog(@"offsetY:%.2f ，rate: %.2f", offsetY, rate);
    self.backgroundView.alpha = rate;

    // 更新返回按钮和消息按钮图片
    UIColor *toColor = [HDCategoryFactory interpolationColorFrom:UIColor.whiteColor to:HDAppTheme.color.G1 percent:rate];
    UIImage *backImage = rate > 0 ? [[UIImage imageNamed:@"icon_close"] hd_imageWithTintColor:toColor] : [UIImage imageNamed:@"icon_close_round"];
    [self.backBTN setImage:backImage forState:UIControlStateNormal];
}

#pragma mark - private methods

#pragma mark - layout
- (void)updateConstraints {
    CGFloat offsetY = UIApplication.sharedApplication.statusBarFrame.size.height;

    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(offsetY * 0.5);
        make.size.mas_equalTo(self.backBTN.bounds.size);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBTN.mas_right);
        make.top.equalTo(self).offset(offsetY);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];

    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"icon_close_round"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewController dismissAnimated:true completion:nil];
        }];
        _backBTN = button;
    }
    return _backBTN;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = UIView.new;
        _backgroundView.backgroundColor = UIColor.whiteColor;
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}
@end
