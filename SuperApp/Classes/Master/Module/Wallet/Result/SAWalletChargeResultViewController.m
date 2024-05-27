
//
//  SAWalletChargeResultViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletChargeResultViewController.h"
#import "SAMoneyModel.h"

typedef NS_ENUM(NSUInteger, SAWalletChargeResult) {
    SAWalletChargeResultProcessing = 1, ///< 充值中
    SAWalletChargeResultSuccess = 2,    ///< 成功
    SAWalletChargeResultFaild = 3,      ///< 失败
};


@interface SAWalletChargeResultViewController ()
/// 状态
@property (nonatomic, assign) SAWalletChargeResult resultType;
/// 金额
@property (nonatomic, strong) SAMoneyModel *amountModel;
/// icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 金额
@property (nonatomic, strong) SALabel *moneyLB;
/// 完成
@property (nonatomic, strong) HDUIButton *finishBTN;
@end


@implementation SAWalletChargeResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.resultType = [[parameters objectForKey:@"resultType"] integerValue];
    self.amountModel = [parameters objectForKey:@"amountModel"];

    return self;
}

- (void)hd_setupViews {
    // 禁用滑动返回
    self.hd_interactivePopDisabled = true;

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.iconIV];
    [self.scrollViewContainer addSubview:self.titleLB];
    [self.scrollViewContainer addSubview:self.moneyLB];

    self.scrollViewContainer.backgroundColor = UIColor.whiteColor;
    self.scrollView.backgroundColor = HDAppTheme.color.G5;
    self.scrollViewContainer.layer.cornerRadius = 5;

    switch (self.resultType) {
        case SAWalletChargeResultProcessing: {
            self.iconIV.image = [UIImage imageNamed:@"online_state_process"];
            self.titleLB.text = SALocalizedString(@"recharging", @"充值中");
        } break;
        case SAWalletChargeResultSuccess: {
            self.iconIV.image = [UIImage imageNamed:@"online_state_success"];
            self.titleLB.text = SALocalizedString(@"top_up_success", @"充值成功");
        } break;
        case SAWalletChargeResultFaild: {
            self.iconIV.image = [UIImage imageNamed:@"online_state_fail"];
            self.titleLB.text = SALocalizedString(@"top_up_failure", @"充值失败");
        } break;

        default:
            break;
    }

    self.moneyLB.hidden = self.resultType != SAWalletChargeResultSuccess || HDIsObjectNil(self.amountModel);
    if (!self.moneyLB.isHidden) {
        self.moneyLB.text = self.amountModel.thousandSeparatorAmount;
    }
}

- (void)hd_setupNavigation {
    self.hd_navigationItem.leftBarButtonItem = nil;
    self.boldTitle = SALocalizedString(@"top_up", @"充值");
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.finishBTN];
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(kRealWidth(15));
        make.bottom.equalTo(self.scrollView).offset(-kRealWidth(15));
        make.width.equalTo(self.scrollView).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
        make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(20));
        make.centerX.equalTo(self.scrollViewContainer);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(15));
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        if (self.moneyLB.isHidden) {
            make.bottom.equalTo(self.scrollViewContainer).offset(-kRealWidth(20));
        }
    }];

    [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.bottom.equalTo(self.scrollViewContainer).offset(-kRealWidth(20));
    }];

    [super updateViewConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"wallet_charge"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)moneyLB {
    if (!_moneyLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:30];
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _moneyLB = label;
    }
    return _moneyLB;
}

- (HDUIButton *)finishBTN {
    if (!_finishBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 0);
        [button setTitle:SALocalizedStringFromTable(@"complete", @"完成", @"Buttons") forState:UIControlStateNormal];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.navigationController popToViewControllerClass:NSClassFromString(@"SAWalletViewController") animated:true];
        }];
        _finishBTN = button;
    }
    return _finishBTN;
}
@end
