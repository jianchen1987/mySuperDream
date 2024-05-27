//
//  WMOrderDeliveryOrToStoreView.m
//  SuperApp
//
//  Created by Tia on 2023/8/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMOrderDeliveryOrToStoreView.h"


@interface WMOrderDeliveryOrToStoreView ()

@property (nonatomic, strong) UIView *defaultBgView;

@property (nonatomic, strong) UIButton *deliveryBtn;

@property (nonatomic, strong) UIButton *toStoreBtn;

@property (nonatomic, strong) UIView *redLine;

@end


@implementation WMOrderDeliveryOrToStoreView

- (void)hd_setupViews {
    [self addSubview:self.defaultBgView];
    [self addSubview:self.toStoreBtn];
    [self addSubview:self.deliveryBtn];
    [self addSubview:self.redLine];
}

- (void)updateConstraints {
    [self.defaultBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.right.bottom.mas_equalTo(0);
    }];

    [self.deliveryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.deliveryBtn.selected) {
            make.top.mas_equalTo(0);
        } else {
            make.top.mas_equalTo(4);
        }
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(204);
    }];

    [self.toStoreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.toStoreBtn.selected) {
            make.top.mas_equalTo(0);
        } else {
            make.top.mas_equalTo(4);
        }
        make.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(204);
    }];

    [self.redLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 3));
        make.bottom.mas_equalTo(0);
        if (self.deliveryBtn.selected) {
            make.centerX.equalTo(self.deliveryBtn).offset(-6);
        } else {
            make.centerX.equalTo(self.toStoreBtn).offset(6);
        }
    }];

    [super updateConstraints];
}


- (void)btnClick:(UIButton *)btn {
    if (btn.selected)
        return;
    btn.selected = !btn.selected;
    btn.titleLabel.font = HDAppTheme.font.sa_standard16SB;
    if (btn == self.deliveryBtn) {
        self.toStoreBtn.titleLabel.font = HDAppTheme.font.sa_standard16;
        self.toStoreBtn.selected = NO;
    } else {
        self.deliveryBtn.titleLabel.font = HDAppTheme.font.sa_standard16;
        self.deliveryBtn.selected = NO;
    }

    !self.pickupMethod ?: self.pickupMethod(self.toStoreBtn.isSelected);

    [self setNeedsUpdateConstraints];
}

- (UIView *)defaultBgView {
    if (!_defaultBgView) {
        _defaultBgView = UIView.new;
        _defaultBgView.backgroundColor = UIColor.sa_backgroundColor;
    }
    return _defaultBgView;
}


- (UIButton *)deliveryBtn {
    if (!_deliveryBtn) {
        UIButton *btn = UIButton.new;
        [btn setTitle:WMLocalizedString(@"wm_pickup_Delivery", @"外卖配送") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.sa_C333 forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.font.sa_standard16SB;
        [btn setBackgroundImage:[UIImage imageNamed:@"yn_deliveryBtn_bg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        btn.selected = YES;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        _deliveryBtn = btn;
    }
    return _deliveryBtn;
}

- (UIButton *)toStoreBtn {
    if (!_toStoreBtn) {
        UIButton *btn = UIButton.new;
        [btn setTitle:WMLocalizedString(@"wm_pickup_Pickup", @"到店自取") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.sa_C333 forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.font.sa_standard16;
        [btn setBackgroundImage:[UIImage imageNamed:@"yn_toStoreBtn_bg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        _toStoreBtn = btn;
    }
    return _toStoreBtn;
}

- (UIView *)redLine {
    if (!_redLine) {
        _redLine = UIView.new;
        _redLine.backgroundColor = UIColor.sa_C1;
    }
    return _redLine;
}
@end
