//
//  WMCNStoreListNavView.m
//  SuperApp
//
//  Created by wmz on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCNStoreListNavView.h"
#import "SAMessageButton.h"
#import "WMSearchBar.h"


@interface WMCNStoreListNavView ()
/// 分类信息
@property (nonatomic, strong) HDLabel *cateLB;
/// 地址
@property (nonatomic, strong) WMSearchBar *searchBar;
/// statusBarView
@property (nonatomic, strong) UIView *statusBarView;

@end


@implementation WMCNStoreListNavView

- (void)hd_setupViews {
    WMZPageNaviBtn *button = [WMZPageNaviBtn buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"yn_zh_cate_car"] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, kRealWidth(8), 10, kRealWidth(12));
    @HDWeakify(self);
    [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        @HDStrongify(self);
        [HDMediator.sharedInstance navigaveToShoppingCartViewController:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖门店列表.分类%@.购物车", self.viewModel.filterModel.businessScope] : [NSString stringWithFormat:@"外卖门店列表.分类%@.购物车", self.viewModel.filterModel.businessScope],
            @"associatedId" : self.viewModel.associatedId
        }];
    }];
    self.messageBTN = (id)button;

    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.statusBarView];
    [self.statusBarView addSubview:self.backBTN];
    [self.statusBarView addSubview:self.cateLB];
    [self.statusBarView addSubview:self.searchBar];
    [self.statusBarView addSubview:self.messageBTN];
    [self.backBTN setImage:[UIImage imageNamed:@"yn_back_red_24"] forState:UIControlStateNormal];
    self.backBTN.imageEdgeInsets = UIEdgeInsetsMake(10, kRealWidth(12), 10, kRealWidth(4));

    [self.statusBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kStatusBarH);
    }];

    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(self.backBTN.bounds.size);
    }];

    [self.cateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBTN.mas_right);
        make.centerY.equalTo(self.backBTN);
    }];

    [self.cateLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.cateLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cateLB.mas_right).offset(kRealWidth(8));
        make.centerY.equalTo(self.backBTN);
        make.right.equalTo(self.messageBTN.mas_left);
        make.height.top.bottom.equalTo(self.statusBarView);
    }];

    [self.messageBTN sizeToFit];
    [self.messageBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(self.messageBTN.bounds.size);
    }];
}

- (void)updateMessageCount:(NSInteger)count {
    WMZPageNaviBtn *button = (id)self.messageBTN;
    if ([button isKindOfClass:WMZPageNaviBtn.class]) {
        if (count) {
            [button showWMBadgeWithTopMagin:@{WMZPageKeyBadge: @(MIN(count, 99))}];
        } else {
            [button hidenBadge];
        }
    }
}

- (HDLabel *)cateLB {
    if (!_cateLB) {
        _cateLB = HDLabel.new;
        _cateLB.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _cateLB.textColor = HDAppTheme.WMColor.B3;
    }
    return _cateLB;
}

- (WMSearchBar *)searchBar {
    if (!_searchBar) {
        WMSearchBar *view = [[WMSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - kRealWidth(120), kRealWidth(44))];
        view.marginToSide = 0;
        view.marginButtonTextField = 0;
        [view disableTextField];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSearchViewHandler)];
        [view addGestureRecognizer:recognizer];
        view.backgroundColor = HDAppTheme.WMColor.bg3;
        view.inputFieldBackgrounColor = HDAppTheme.WMColor.F6F6F6;
        view.placeHolder = WMLocalizedString(@"wm_hamburger_pizza", @"搜索门店、商品");
        view.placeholderColor = HDAppTheme.WMColor.B9;
        view.textFieldHeight = kRealWidth(32);
        _searchBar = view;
    }
    return _searchBar;
}

- (UIView *)statusBarView {
    if (!_statusBarView) {
        _statusBarView = UIView.new;
    }
    return _statusBarView;
}

- (void)clickedSearchViewHandler {
    [GNEvent eventResponder:self target:self.searchBar key:@"clickToSearch" indexPath:nil info:nil];
}

@end
