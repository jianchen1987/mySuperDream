//
//  WMHomeSearchView.m
//  SuperApp
//
//  Created by Tia on 2023/7/11.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewHomeSearchView.h"


@interface WMNewHomeSearchView ()

@property (nonatomic, strong) UIView *containView;

@property (nonatomic, strong) UIImageView *searchIcon;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) SALabel *searchBtn;

@property (nonatomic, strong) UIImageView *bgView;

@end


@implementation WMNewHomeSearchView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self addSubview:self.bgView];
    [self addSubview:self.containView];
    [self.containView addSubview:self.searchIcon];
    [self.containView addSubview:self.tipLabel];
    [self.containView addSubview:self.searchBtn];

    UITapGestureRecognizer *tapTecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tapTecoginzer.delaysTouchesBegan = YES;
    [self.containView addGestureRecognizer:tapTecoginzer];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(40);
    }];

    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
    }];

    [self.searchIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(12);
    }];
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.searchIcon.mas_right).offset(8);
    }];

    [self.searchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (void)singleTap {
    !self.searchClick ?: self.searchClick();
}

#pragma mark - lazy load
- (UIView *)containView {
    if (!_containView) {
        _containView = UIView.new;
        _containView.backgroundColor = UIColor.whiteColor;
        _containView.layer.borderColor = HDAppTheme.color.sa_C1.CGColor;
        _containView.layer.borderWidth = 1;
        _containView.layer.cornerRadius = 18;
    }
    return _containView;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_zh_cate_search"]];
    }
    return _searchIcon;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = UILabel.new;
        _tipLabel.textColor = HDAppTheme.color.sa_searchBarTextColor;
        _tipLabel.font = HDAppTheme.font.sa_standard12;
        _tipLabel.text = WMLocalizedString(@"wm_hamburger_pizza", @"搜索门店、商品");
    }
    return _tipLabel;
}

- (SALabel *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = SALabel.new;
        _searchBtn.textColor = UIColor.whiteColor;
        _searchBtn.backgroundColor = HDAppTheme.color.sa_C1;
        _searchBtn.layer.cornerRadius = 18;
        _searchBtn.text = WMLocalizedString(@"search", @"搜索");
        _searchBtn.font = HDAppTheme.font.sa_standard14SB;
        _searchBtn.hd_edgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        _searchBtn.layer.masksToBounds = true;
    }
    return _searchBtn;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_home_top_bg2"]];
    }
    return _bgView;
}

@end
