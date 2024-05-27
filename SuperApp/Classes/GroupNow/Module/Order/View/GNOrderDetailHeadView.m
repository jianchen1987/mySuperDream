//
//  GNOrderDetailHeadView.m
//  SuperApp
//
//  Created by wmz on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderDetailHeadView.h"
#import "GNCellModel.h"


@interface GNOrderDetailHeadView ()
/// bgView
@property (nonatomic, strong) UIView *bgView;

@end


@implementation GNOrderDetailHeadView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.backBTN];
    [self.bgView addSubview:self.serverBTN];
    [self.bgView addSubview:self.titleLB];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarH);
        make.left.right.bottom.mas_equalTo(0);
    }];

    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(self.backBTN.bounds.size);
    }];

    [self.serverBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.size.mas_equalTo(self.serverBTN.imageView.image.size);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.left.equalTo(self.backBTN.mas_right);
        make.right.equalTo(self.serverBTN.mas_left);
    }];

    [self.serverBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"gn_home_nav_back"] forState:UIControlStateNormal];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [GNEvent eventResponder:self target:btn key:@"backAction"];
        }];
        _backBTN = button;
    }
    return _backBTN;
}

- (HDUIButton *)serverBTN {
    if (!_serverBTN) {
        _serverBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_serverBTN setImage:[UIImage imageNamed:@"gn_order_serve"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_serverBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [GNEvent eventResponder:self target:btn key:@"callServerAction"];
        }];
    }
    return _serverBTN;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        _titleLB = SALabel.new;
        _titleLB.font = [HDAppTheme.font gn_boldForSize:14];
        _titleLB.numberOfLines = 0;
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

@end
