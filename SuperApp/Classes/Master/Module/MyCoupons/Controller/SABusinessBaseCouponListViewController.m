//
//  SABusinessCouponListViewController.m
//  SuperApp
//
//  Created by seeu on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SABusinessBaseCouponListViewController.h"
#import "SAApolloManager.h"
#import "SACouponListViewModel.h"
#import "SAExpiredUsedCouponsViewController.h"
#import "SAOperationButton.h"
#import "SATableView.h"


@interface SABusinessBaseCouponListViewController ()
@property (nonatomic, strong) HDUIButton *pastCouponBTN;
//@property (nonatomic, copy) SAClientType businessLine;
///< 获取更多优惠券按钮
//@property (nonatomic, strong) SAOperationButton *getMoreCouponBtn;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *bottomButtonsContainView;
///< 获取更多优惠券按钮
@property (nonatomic, strong) UIButton *getMoreCouponBtn;
/// 底部阴影
@property (nonatomic, strong) UIView *bottomShadowView;

///< 获取更多优惠券链接
@property (nonatomic, copy) NSString *getMoreCouponsUrlStr;
@end


@implementation SABusinessBaseCouponListViewController

- (void)hd_setupViews {
    [super hd_setupViews];

    NSString *moreCouponUrl = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyGetMoreCoupons];
    if (HDIsStringNotEmpty(moreCouponUrl)) {
        self.getMoreCouponBtn.hidden = NO;
        self.bottomShadowView.hidden = NO;
        self.getMoreCouponsUrlStr = moreCouponUrl;
    } else {
        self.getMoreCouponBtn.hidden = YES;
        self.bottomShadowView.hidden = YES;
    }
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomButtonsContainView];
    [self.bottomButtonsContainView addSubview:self.getMoreCouponBtn];
    [self.view addSubview:self.bottomShadowView];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"coupon_ticket", @"优惠券");

    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.pastCouponBTN];
}

- (void)updateViewConstraints {
    if (!self.getMoreCouponBtn.isHidden) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kiPhoneXSeriesSafeBottomHeight + kRealHeight(44));
        }];

        [self.getMoreCouponBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomButtonsContainView);
        }];
        [self.bottomButtonsContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView);
            make.height.mas_equalTo(kRealHeight(44));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
        }];
        [self.bottomShadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomButtonsContainView.mas_top);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(kRealWidth(8));
        }];

        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
    }
    [super updateViewConstraints];
}

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - action
- (void)clickOnGetMoreCouponsButton:(SAOperationButton *)button {
    if (HDIsStringNotEmpty(self.getMoreCouponsUrlStr)) {
        [SAWindowManager openUrl:self.getMoreCouponsUrlStr withParameters:nil];
    }
}

- (HDUIButton *)pastCouponBTN {
    if (!_pastCouponBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:SALocalizedString(@"coupon_match_UsageRecord", @"使用记录") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor hd_colorWithHexString:@"333333"] forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:14];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            SAExpiredUsedCouponsViewController *vc = [[SAExpiredUsedCouponsViewController alloc] initWithRouteParameters:@{@"businessLine": self.businessLine}];
            [SAWindowManager navigateToViewController:vc];
        }];
        _pastCouponBTN = button;
    }
    return _pastCouponBTN;
}

- (UIButton *)getMoreCouponBtn {
    if (!_getMoreCouponBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        button.backgroundColor = UIColor.whiteColor;
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:@"coupon_more_coupons"] forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font boldForSize:14];

        [button setTitle:SALocalizedString(@"coupon_match_GoCouponCenter", @"去领券中心") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOnGetMoreCouponsButton:) forControlEvents:UIControlEventTouchUpInside];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        _getMoreCouponBtn = button;
    }

    return _getMoreCouponBtn;
}

- (UIView *)bottomShadowView {
    if (!_bottomShadowView) {
        _bottomShadowView = UIView.new;
        _bottomShadowView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = view.bounds;
            gl.endPoint = CGPointMake(0.5, 0);
            gl.startPoint = CGPointMake(0.5, 1);
            gl.colors = @[
                (__bridge id)[UIColor colorWithRed:243 / 255.0 green:244 / 255.0 blue:250 / 255.0 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:243 / 255.0 green:244 / 255.0 blue:250 / 255.0 alpha:0.0].CGColor
            ];
            gl.locations = @[@(0), @(1.0f)];
            [view.layer addSublayer:gl];
        };
    }
    return _bottomShadowView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.backgroundColor = HDAppTheme.color.sa_backgroundColor;
    }
    return _bottomView;
}

- (UIView *)bottomButtonsContainView {
    if (!_bottomButtonsContainView) {
        _bottomButtonsContainView = UIView.new;
        _bottomButtonsContainView.backgroundColor = HDAppTheme.color.sa_C1;
        _bottomButtonsContainView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(22)];
        };
    }
    return _bottomButtonsContainView;
}

@end
