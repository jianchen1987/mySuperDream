//
//  WMBusinessCouponListViewController.m
//  SuperApp
//
//  Created by wmz on 2022/8/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SABusinessCouponListViewController.h"


@interface SABusinessCouponListViewController ()
///< 外卖兑换码兑换入口
@property (nonatomic, strong) UIButton *redemptionCodeBTN;

@property (nonatomic, strong) UIView *line;

@end


@implementation SABusinessCouponListViewController

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.bottomButtonsContainView addSubview:self.redemptionCodeBTN];
    [self.bottomButtonsContainView addSubview:self.line];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        //        make.height.mas_equalTo(self.hidesBottomBarWhenPushed?kiPhoneXSeriesSafeBottomHeight:0);
        make.height.mas_equalTo((self.hidesBottomBarWhenPushed ? kiPhoneXSeriesSafeBottomHeight : 0) + kRealHeight(44));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.filterView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    if (self.redemptionCodeBTN.isHidden) {
        [self.getMoreCouponBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomButtonsContainView);
        }];
    } else {
        [self.getMoreCouponBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.bottom.mas_equalTo(self.bottomButtonsContainView);
        }];
        [self.redemptionCodeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.equalTo(self.getMoreCouponBtn.mas_right);
            make.width.bottom.height.equalTo(self.getMoreCouponBtn);
        }];
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bottomButtonsContainView);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(kRealHeight(20));
        }];
    }
}

- (UIButton *)redemptionCodeBTN {
    if (!_redemptionCodeBTN) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = [HDAppTheme.font boldForSize:14];
        [button setImage:[UIImage imageNamed:@"coupon_code_change"] forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"coupon_Change_code_to_voucher", @"兑换码兑券") forState:UIControlStateNormal];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/redemption-code"}];
        }];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _redemptionCodeBTN = button;
    }
    return _redemptionCodeBTN;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = UIColor.whiteColor;
    }
    return _line;
}

@end
