//
//  SearchNaviView.m
//  SuperApp
//
//  Created by wmz on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SearchNaviView.h"
#import "GNCellModel.h"


@interface SearchNaviView ()
/// bgView
@property (nonatomic, strong) UIView *bgView;

@end


@implementation SearchNaviView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.backBTN];
    [self.bgView addSubview:self.locationBTN];
    [self.bgView addSubview:self.searchBar];
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

    [self.locationBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
    }];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.left.equalTo(self.backBTN.mas_right);
        make.right.equalTo(self.locationBTN.mas_left);
        make.height.mas_equalTo(35);
    }];

    [self.locationBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.locationBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

#pragma mark 跳转搜索
- (void)clickedSearchViewHandler {
    [GNEvent eventResponder:self target:self.searchBar key:@"toSearch"];
}

- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"gn_home_nav_back"] forState:UIControlStateNormal];
        [button sizeToFit];
        _backBTN = button;
    }
    return _backBTN;
}

- (HDUIButton *)locationBTN {
    if (!_locationBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:GNLocalizedString(@"gn_search_searchfor", @"搜索") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        _locationBTN = button;
    }
    return _locationBTN;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        HDSearchBar *view = [[HDSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealHeight(36))];
        view.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        view.inputFieldBackgrounColor = HDAppTheme.color.gn_whiteColor;
        view.placeHolder = GNLocalizedString(@"gn_home_searchTip", @"gn_home_searchTip");
        view.placeholderColor = HDAppTheme.color.G3;
        view.textFieldHeight = 35;
        UIView *contenView = [view valueForKey:@"contentView"];
        contenView.layer.borderWidth = 1;
        contenView.layer.borderColor = HDAppTheme.color.gn_mainColor.CGColor;
        contenView.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
        contenView.layer.cornerRadius = 17.5;
        _searchBar = view;
    }
    return _searchBar;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

@end
