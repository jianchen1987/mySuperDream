//
//  WMOrderResultView.m
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderResultView.h"
#import "SACouponRedemptionBannerView.h"
#import "SACouponRedemptionRspModel.h"
#import "WMOrderResultViewModel.h"


@interface WMOrderResultView ()
/// 顶部背景
@property (nonatomic, strong) UIView *bgView;
/// 图标
@property (nonatomic, strong) UIImageView *iconView;
/// 状态
@property (nonatomic, strong) SALabel *statusLabel;
/// 描述
@property (nonatomic, strong) SALabel *descLabel;
/// 查看订单按钮
@property (nonatomic, strong) HDUIButton *orderBtn;
/// viewmodel
@property (nonatomic, strong) WMOrderResultViewModel *viewModel;

@end


@implementation WMOrderResultView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bg3;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.statusLabel];
    [self.bgView addSubview:self.descLabel];
    [self.bgView addSubview:self.orderBtn];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(24));
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(self.iconView.image.size);
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(kRealWidth(8));
        make.centerX.equalTo(self.bgView);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(4));
        make.centerX.equalTo(self.statusLabel.mas_centerX);
        make.left.equalTo(self.bgView).offset(kRealWidth(26));
        make.right.equalTo(self.bgView).offset(-kRealWidth(26));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.orderBtn sizeToFit];
    [self.orderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.statusLabel.mas_centerX);
        make.top.equalTo(self.descLabel.mas_bottom).offset(kRealWidth(32));
        make.height.mas_equalTo(kRealWidth(40));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"yn_order_success"];
    }
    return _iconView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[SALabel alloc] init];
        _statusLabel.textColor = HDAppTheme.WMColor.B3;
        _statusLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _statusLabel.text = WMLocalizedString(@"EfGW1nyJ", @"下单成功");
    }
    return _statusLabel;
}

- (SALabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[SALabel alloc] init];
        _descLabel.textColor = HDAppTheme.WMColor.B9;
        _descLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
        _descLabel.text = WMLocalizedString(@"pK5DO0Pj", @"请等待商家确认与联系");
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

- (HDUIButton *)orderBtn {
    if (!_orderBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"wm_button_orderdetails", @"查看订单") forState:UIControlStateNormal];
        button.layer.cornerRadius = kRealWidth(22);
        button.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
        button.layer.borderWidth = HDAppTheme.WMValue.line;
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(36), kRealWidth(8), kRealWidth(36));
        button.layer.backgroundColor = UIColor.whiteColor.CGColor;
        @HDWeakify(self)[button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self.viewController.navigationController popToRootViewControllerAnimated:false];
            [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": self.viewModel.orderNo, @"isFromOrderSubmit": @(1)}];
        }];
        _orderBtn = button;
    }
    return _orderBtn;
}

@end
