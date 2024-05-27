//
//  WMOrderDetailNaviBar.m
//  SuperApp
//
//  Created by wmz on 2022/10/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderDetailNaviBar.h"


@interface WMOrderDetailNaviBar ()

@end


@implementation WMOrderDetailNaviBar

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLB];
    [self addSubview:self.backBTN];
    [self addSubview:self.contactBTN];
    [self addSubview:self.updateBTN];
}

- (void)updateConstraints {
    CGFloat offsetY = UIApplication.sharedApplication.statusBarFrame.size.height;

    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(offsetY * 0.5);
        make.size.mas_equalTo(self.backBTN.bounds.size);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(offsetY);
        make.bottom.equalTo(self);
        make.centerX.mas_equalTo(0);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.5);
    }];

    [self.contactBTN sizeToFit];
    [self.contactBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.contactBTN.isHidden) {
            make.centerY.equalTo(self.backBTN);
            make.right.equalTo(self);
            make.size.mas_equalTo(self.contactBTN.bounds.size);
        }
    }];

    [self.updateBTN sizeToFit];
    [self.updateBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        if (self.contactBTN.isHidden) {
            make.right.equalTo(self);
        } else {
            make.right.equalTo(self.contactBTN.mas_left);
        }
        make.size.mas_equalTo(self.updateBTN.bounds.size);
    }];
    [super updateConstraints];
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
    UIColor *backToColor = [HDCategoryFactory interpolationColorFrom:HDAppTheme.WMColor.mainRed to:UIColor.whiteColor percent:rate];
    UIColor *toColor = [HDCategoryFactory interpolationColorFrom:HDAppTheme.WMColor.B3 to:UIColor.whiteColor percent:rate];
    UIImage *backImage = [[UIImage imageNamed:@"icon_back_black"] hd_imageWithTintColor:backToColor];
    [self.backBTN setImage:backImage forState:UIControlStateNormal];

    UIImage *messageImage = [[UIImage imageNamed:@"yn_order_detail_update"] hd_imageWithTintColor:toColor];
    [self.updateBTN setImage:messageImage forState:UIControlStateNormal];

    UIImage *shareImage = [[UIImage imageNamed:@"yn_order_detail_kefu"] hd_imageWithTintColor:toColor];
    [self.contactBTN setImage:shareImage forState:UIControlStateNormal];
    self.titleLB.textColor = toColor;
}

#pragma mark - lazy load
- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[[UIImage imageNamed:@"icon_back_black"] hd_imageWithTintColor:HDAppTheme.WMColor.mainRed] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 5);
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
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.textColor = HDAppTheme.WMColor.B3;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        _titleLB = label;
    }
    return _titleLB;
}

- (HDUIButton *)updateBTN {
    if (!_updateBTN) {
        HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[[UIImage imageNamed:@"yn_order_detail_update"] hd_imageWithTintColor:HDAppTheme.WMColor.B3] forState:UIControlStateNormal];
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _updateBTN = shareButton;
    }
    return _updateBTN;
}

- (HDUIButton *)contactBTN {
    if (!_contactBTN) {
        HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[[UIImage imageNamed:@"yn_order_detail_kefu"] hd_imageWithTintColor:HDAppTheme.WMColor.B3] forState:UIControlStateNormal];
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        shareButton.hidden = true;
        _contactBTN = shareButton;
    }
    return _contactBTN;
}

@end
