//
//  TNCartBarView.m
//  SuperApp
//
//  Created by wownow on 2023/9/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNCartBarView.h"
#import "TNShoppingCar.h"
#import "TNSpecialActivityViewController.h"
#import <LOTAnimationView.h>


@interface TNCartBarView ()
/// 按钮
@property (nonatomic, strong) HDUIButton *cartBtn;
/// 数据中心
@property (strong, nonatomic) TNShoppingCar *shopCarDataCenter;
/// 卡片动画图片
@property (strong, nonatomic) LOTAnimationView *animationImageView;

/// 按钮
@property (nonatomic, strong) HDUIButton *enterBtn;
/// 指示器图
@property (nonatomic, strong) HDLabel *indicatorLabel;
@end


@implementation TNCartBarView

- (void)hd_setupViews {
    [self addSubview:self.cartBtn];
    [self.cartBtn insertSubview:self.animationImageView atIndex:0];
    [self addSubview:self.enterBtn];
    [self addSubview:self.indicatorLabel];

    [self updateIndicatorDotWithCount:self.shopCarDataCenter.totalGoodsCount];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"totalGoodsCount" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateIndicatorDotWithCount:self.shopCarDataCenter.totalGoodsCount];
    }];

    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"activityShake" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self shake];
    }];
}

#pragma mark - public methods
- (void)updateIndicatorDotWithCount:(NSUInteger)count {
    if (count > 99) {
        self.indicatorLabel.text = @"99+";
    } else {
        self.indicatorLabel.text = [NSString stringWithFormat:@"%ld", count];
    }
    self.indicatorLabel.hidden = count <= 0;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    CGFloat bottomSpace = kiPhoneXSeriesSafeBottomHeight;
    if ([self.viewController.navigationController.viewControllers.firstObject isKindOfClass:[TNSpecialActivityViewController class]]) {
        bottomSpace = 0;
    }

    [self.cartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.mas_top).offset(kRealWidth(6));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(6) - bottomSpace);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
    }];

    if (!self.indicatorLabel.hidden) {
        [self.indicatorLabel sizeToFit];
        [self.indicatorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.indicatorLabel.frame.size.height);
            make.width.mas_greaterThanOrEqualTo(self.indicatorLabel.frame.size.height);
            make.centerX.equalTo(self.cartBtn.mas_right).offset(-5);
            make.centerY.equalTo(self.cartBtn.mas_top).offset(6);
        }];
    }

    [self.animationImageView sizeToFit];
    [self.animationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.mas_left).offset(kRealWidth(6));
        //        make.right.equalTo(self.mas_right).offset(kRealWidth(6));
        //        make.top.equalTo(self.mas_top).offset(kRealWidth(6));
        //        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(6));
        make.center.equalTo(self.cartBtn);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(35), kRealWidth(35)));
    }];

    [self.enterBtn sizeToFit];
    [self.enterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cartBtn.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
    }];

    [super updateConstraints];
}
- (void)clickedShoppingCartButton:(HDUIButton *)btn {
    [SAWindowManager openUrl:@"SuperApp://TinhNow/ShoppingCar" withParameters:@{}];
}
- (void)shake {
    [self.animationImageView play];
}
/** @lazy shopCarDataCenter */
- (TNShoppingCar *)shopCarDataCenter {
    if (!_shopCarDataCenter) {
        _shopCarDataCenter = [TNShoppingCar share];
    }
    return _shopCarDataCenter;
}
/** @lazy animationImageView */
- (LOTAnimationView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [LOTAnimationView animationNamed:@"CartShake"];
        _animationImageView.loopAnimation = NO;
        _animationImageView.cacheEnable = YES;
        _animationImageView.userInteractionEnabled = NO;
    }
    return _animationImageView;
}
- (HDUIButton *)cartBtn {
    if (!_cartBtn) {
        _cartBtn = [[HDUIButton alloc] initWithFrame:self.bounds];
        _cartBtn.backgroundColor = [UIColor clearColor];
        _cartBtn.adjustsImageWhenHighlighted = false;
        _cartBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        //        [_cartBtn setImage:[UIImage imageNamed:@"tn_cart_background"] forState:UIControlStateNormal];
        //
        [_cartBtn addTarget:self action:@selector(clickedShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
        _cartBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width / 2];
        };
    }
    return _cartBtn;
}
- (HDUIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [[HDUIButton alloc] init];
        _enterBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:16];
        _enterBtn.titleEdgeInsets = UIEdgeInsetsMake(7, 28, 7, 28);
        [_enterBtn setTitle:TNLocalizedString(@"tn_go_to_cart", @"去购物车") forState:UIControlStateNormal];
        _enterBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _enterBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:15];
        };
        [_enterBtn addTarget:self action:@selector(clickedShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}
#pragma mark - lazy load
- (HDLabel *)indicatorLabel {
    if (!_indicatorLabel) {
        _indicatorLabel = [[HDLabel alloc] init];
        _indicatorLabel.textColor = UIColor.whiteColor;
        _indicatorLabel.hd_edgeInsets = UIEdgeInsetsMake(1, 3, 1, 3);
        _indicatorLabel.font = [HDAppTheme.TinhNowFont fontSemibold:9];

        _indicatorLabel.layer.borderWidth = 1;
        _indicatorLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        _indicatorLabel.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _indicatorLabel.textAlignment = NSTextAlignmentCenter;
        _indicatorLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2;
            view.layer.masksToBounds = YES;
        };
        _indicatorLabel.hidden = YES;
    }
    return _indicatorLabel;
}
@end
