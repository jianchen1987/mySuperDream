//
//  GNOrderResultViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderResultViewController.h"
#import "GNTimer.h"
#import "SATabBar.h"


@interface GNOrderResultViewController ()
/// 文本
@property (nonatomic, strong) HDLabel *tipLB;
/// 图片
@property (nonatomic, strong) UIImageView *iconIV;
/// 查看
@property (nonatomic, strong) HDUIButton *checkBtn;
/// 返回
@property (nonatomic, strong) HDUIButton *toHomeBtn;

@end


@implementation GNOrderResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.orderNo = [parameters objectForKey:@"orderNo"];
    }
    return self;
}

- (void)hd_setupViews {
    self.type = GNOrderFromResult;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.iconIV];
    [self.view addSubview:self.checkBtn];
    [self.view addSubview:self.toHomeBtn];
}

- (void)hd_bindViewModel {
    @HDWeakify(self)[self removeViewController:NO];
    [GNTimer cancel:@"result"];
    [GNTimer timerWithStartTime:1 interval:1 durtion:3 timeId:@"result" repeats:NO mainQueue:YES completion:^(NSInteger time) {
        if (time > 0) {
            self.checkBtn.layer.backgroundColor = HDAppTheme.color.gn_B6B6B6.CGColor;
            self.checkBtn.userInteractionEnabled = NO;
            [self.checkBtn setTitle:[NSString stringWithFormat:@"%@(%ld)", GNLocalizedString(@"gn_view_order", @"查看订单"), time] forState:UIControlStateNormal];
        } else if (time == 0) {
            self.checkBtn.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
            self.checkBtn.userInteractionEnabled = YES;
            [self.checkBtn setTitle:GNLocalizedString(@"gn_view_order", @"查看订单") forState:UIControlStateNormal];
        }
        if (time == 0) {
            [self.checkBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
                @HDStrongify(self)[HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": GNFillEmpty(self.orderNo)}];
                [self removeViewController:YES];
            }];
        }
    }];
}

- (void)updateViewConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kRealHeight(70), kRealHeight(70)));
        make.top.mas_equalTo(kNavigationBarH + kRealHeight(80));
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.top.equalTo(self.iconIV.mas_bottom).offset(HDAppTheme.value.gn_marginL);
    }];

    [self.checkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(40));
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealHeight(60));
        make.right.mas_equalTo(-kRealWidth(40));
        make.height.mas_equalTo(kRealHeight(44));
    }];

    [self.toHomeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(self.checkBtn);
        make.top.equalTo(self.checkBtn.mas_bottom).offset(HDAppTheme.value.gn_marginL);
    }];

    [super updateViewConstraints];
}

- (HDLabel *)tipLB {
    if (!_tipLB) {
        _tipLB = HDLabel.new;
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = GNLocalizedString(@"gn_order_success", @"下单成功");
    }
    return _tipLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.image = [UIImage imageNamed:@"gn_order_check"];
    }
    return _iconIV;
}

- (HDUIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.layer.cornerRadius = kRealHeight(8);
        [_checkBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
        [_checkBtn setTitle:[NSString stringWithFormat:@"%@(3)", GNLocalizedString(@"gn_view_order", @"查看订单")] forState:UIControlStateNormal];
        _checkBtn.layer.backgroundColor = HDAppTheme.color.gn_B6B6B6.CGColor;
        _checkBtn.userInteractionEnabled = NO;
    }
    return _checkBtn;
}

- (HDUIButton *)toHomeBtn {
    if (!_toHomeBtn) {
        _toHomeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _toHomeBtn.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
        _toHomeBtn.layer.cornerRadius = kRealHeight(8);
        _toHomeBtn.layer.borderWidth = 1;
        _toHomeBtn.layer.borderColor = HDAppTheme.color.gn_mainColor.CGColor;
        [_toHomeBtn setTitleColor:HDAppTheme.color.gn_mainColor forState:UIControlStateNormal];
        [_toHomeBtn setTitle:GNLocalizedString(@"gn_back", @"返回首页") forState:UIControlStateNormal];
        @HDWeakify(self)[_toHomeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) SATabBar *tabbar = (SATabBar *)self.tabBarController.tabBar;
            if ([tabbar isKindOfClass:SATabBar.class] && tabbar.buttons.count) {
                if (!tabbar.buttons.firstObject.isSelected && [tabbar.buttons.firstObject.config.loadPageName isEqualToString:@"GNHomeViewController"]) {
                    [tabbar.buttons.firstObject sendActionsForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
                    [self removeViewController:YES];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
    return _toHomeBtn;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [GNTimer cancel:@"result"];
}

@end
