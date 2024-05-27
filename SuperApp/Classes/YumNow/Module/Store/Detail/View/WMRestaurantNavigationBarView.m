//
//  WMRestaurantNavigationBarView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRestaurantNavigationBarView.h"
#import "SAMessageButton.h"
#import "WMActionSheetView.h"
#import "WMActionSheetViewButton.h"
#import "WMSearchBar.h"


@interface WMRestaurantNavigationBarView ()
/// 背景
@property (nonatomic, strong) UIView *backgroundView;
/// 返回按钮
@property (nonatomic, strong) HDUIButton *backBTN;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 信息按钮
@property (nonatomic, strong) SAMessageButton *messageBTN;
/// 分享按钮
@property (nonatomic, strong) HDUIButton *shareBTN;
/// 搜索按钮
@property (nonatomic, strong) HDUIButton *searchBTN;
/// 收藏按钮
@property (nonatomic, strong) HDUIButton *favouriteBTN;
/// 更多按钮
@property (nonatomic, strong) HDUIButton *moreBTN;
/// 搜索
@property (nonatomic, strong) WMSearchBar *searchBar;
/// 收藏按钮
@property (nonatomic, strong) HDUIButton *nFavouriteBTN;
@end


@implementation WMRestaurantNavigationBarView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.titleLB];
    [self addSubview:self.backBTN];
    [self addSubview:self.messageBTN];
    [self addSubview:self.shareBTN];
    [self addSubview:self.searchBTN];
    [self addSubview:self.favouriteBTN];
    [self addSubview:self.moreBTN];
    [self addSubview:self.searchBar];
    [self addSubview:self.nFavouriteBTN];
}

- (void)updateConstraints {
    CGFloat offsetY = UIApplication.sharedApplication.statusBarFrame.size.height;

    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(offsetY * 0.5);
        make.size.mas_equalTo(self.backBTN.bounds.size);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBTN.mas_right);
        make.top.equalTo(self).offset(offsetY);
        make.bottom.equalTo(self);
        make.right.equalTo(self.favouriteBTN.mas_left);
    }];

    [self.messageBTN sizeToFit];
    [self.messageBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.right.equalTo(self);
        make.size.mas_equalTo(self.messageBTN.bounds.size);
    }];

    [self.shareBTN sizeToFit];
    [self.shareBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageBTN);
        make.right.equalTo(self.messageBTN.mas_left);
        make.size.mas_equalTo(self.shareBTN.bounds.size);
    }];

    [self.searchBTN sizeToFit];
    [self.searchBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareBTN);
        make.right.equalTo(self.shareBTN.mas_left);
        make.size.mas_equalTo(self.searchBTN.bounds.size);
    }];

    [self.favouriteBTN sizeToFit];
    [self.favouriteBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBTN);
        make.right.equalTo(self.searchBTN.mas_left);
        make.size.mas_equalTo(self.favouriteBTN.bounds.size);
    }];

    [self.nFavouriteBTN sizeToFit];
    [self.nFavouriteBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moreBTN);
        make.right.equalTo(self.moreBTN.mas_left);
        make.size.mas_equalTo(self.nFavouriteBTN.bounds.size);
    }];

    [self.moreBTN sizeToFit];
    [self.moreBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.right.equalTo(self);
        make.size.mas_equalTo(self.moreBTN.bounds.size);
    }];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBTN.mas_right);
        make.right.equalTo(self.nFavouriteBTN.mas_left);
        make.centerY.equalTo(self.backBTN);
        make.height.mas_equalTo(kRealWidth(32));
    }];

    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - public methods
- (void)updateTitle:(NSString *)title {
    self.titleLB.text = title;
}

- (void)updateFavouriteBTN:(BOOL)favourite {
    self.favouriteBTN.selected = favourite;
    self.nFavouriteBTN.selected = favourite;
}

- (void)showOrHiddenFunctionBTN:(BOOL)show {
    self.searchBTN.hidden = self.favouriteBTN.hidden = self.shareBTN.hidden = !show;
    self.nFavouriteBTN.hidden = self.searchBar.hidden = self.moreBTN.hidden = !show;
}

- (void)updateUIWithScrollViewOffsetY:(CGFloat)offsetY {
    CGFloat offsetLimit = 0;
    offsetLimit = CGRectGetHeight(self.frame);

    // 布局未完成
    if (offsetLimit <= 0)
        return;

    CGFloat rate = offsetY / offsetLimit;
    rate = rate > 0.98 ? 1 : rate;
    rate = rate < 0.02 ? 0 : rate;

    if (rate > 0.5) {
        self.viewController.hd_statusBarStyle = UIStatusBarStyleDefault;
    } else {
        self.viewController.hd_statusBarStyle = UIStatusBarStyleLightContent;
    }
    //     HDLog(@"offsetY:%.2f ，rate: %.2f", offsetY, rate);
    self.backgroundView.alpha = rate;

    // 更新返回按钮和消息按钮图片
    UIColor *toColor = [HDCategoryFactory interpolationColorFrom:UIColor.whiteColor to:HDAppTheme.color.G1 percent:rate];
    UIImage *backImage = [[UIImage imageNamed:@"icon_back_black"] hd_imageWithTintColor:toColor];
    [self.backBTN setImage:backImage forState:UIControlStateNormal];

    UIImage *messageImage = [[UIImage imageNamed:@"yn_store_message"] hd_imageWithTintColor:toColor];
    [self.messageBTN setImage:messageImage forState:UIControlStateNormal];

    UIImage *shareImage = [[UIImage imageNamed:@"yn_store_share"] hd_imageWithTintColor:toColor];
    [self.shareBTN setImage:shareImage forState:UIControlStateNormal];

    UIImage *searchImage = [[UIImage imageNamed:@"yn_store_search"] hd_imageWithTintColor:toColor];
    [self.searchBTN setImage:searchImage forState:UIControlStateNormal];

    UIImage *favouriteImage = [[UIImage imageNamed:@"yn_store_collect"] hd_imageWithTintColor:toColor];
    [self.favouriteBTN setImage:favouriteImage forState:UIControlStateNormal];
}

- (void)updateCNUIWithScrollViewOffsetY:(CGFloat)offsetY {
    CGFloat offsetLimit = 0;
    offsetLimit = CGRectGetHeight(self.frame);
    if (offsetLimit <= 0)
        return;

    CGFloat rate = offsetY / offsetLimit;
    rate = rate > 0.98 ? 1 : rate;
    rate = rate < 0.02 ? 0 : rate;

    if (rate > 0.5) {
        self.viewController.hd_statusBarStyle = UIStatusBarStyleDefault;
    } else {
        self.viewController.hd_statusBarStyle = UIStatusBarStyleLightContent;
    }
    self.backgroundView.alpha = rate;
    self.titleLB.alpha = 0;
    self.favouriteBTN.alpha = self.searchBTN.alpha = self.shareBTN.alpha = self.messageBTN.alpha = 1 - rate;
    self.searchBar.alpha = self.moreBTN.alpha = self.nFavouriteBTN.alpha = rate;
    UIColor *toColor = [HDCategoryFactory interpolationColorFrom:UIColor.whiteColor to:HDAppTheme.WMColor.B3 percent:rate];
    UIImage *backImage = [[UIImage imageNamed:@"icon_back_black"] hd_imageWithTintColor:[HDCategoryFactory interpolationColorFrom:UIColor.whiteColor to:HDAppTheme.WMColor.mainRed percent:rate]];
    [self.backBTN setImage:backImage forState:UIControlStateNormal];

    UIImage *favouriteImage = [[UIImage imageNamed:@"yn_store_collect"] hd_imageWithTintColor:toColor];
    [self.nFavouriteBTN setImage:favouriteImage forState:UIControlStateNormal];
}

- (void)clickedSearchViewHandler {
    !self.searchInStore ?: self.searchInStore();
}

- (void)clickMoreHandle {
    HDActionSheetViewConfig *config = HDActionSheetViewConfig.new;
    config.containerCorner = kRealWidth(12);
    config.lineColor = HDAppTheme.WMColor.lineColor1;
    config.lineHeight = 0.8;
    config.buttonHeight = kRealWidth(65);
    WMActionSheetView *sheetView = [WMActionSheetView alertViewWithCancelButtonTitle:nil config:config];
    sheetView.allowTapBackgroundDismiss = YES;
    sheetView.solidBackgroundColorAlpha = 0.5;
    [sheetView addButton:[WMActionSheetViewButton initWithTitle:TNLocalizedString(@"tn_share_category_title", @"分享")
                                                          image:[[UIImage imageNamed:@"yn_store_share"] hd_imageWithTintColor:HDAppTheme.WMColor.B3]
                                                           type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                               [alertView dismiss];
                                                               !self.shareStore ?: self.shareStore();
                                                           }]];
    [sheetView addButton:[WMActionSheetViewButton initWithTitle:WMLocalizedString(@"messages", @"消息") image:[[UIImage imageNamed:@"yn_store_message"] hd_imageWithTintColor:HDAppTheme.WMColor.B3]
                                                           type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
                                                               [alertView dismiss];
                                                               [HDMediator.sharedInstance navigaveToMessagesViewController:@{@"clientType": SAClientTypeYumNow}];
                                                           }]];
    [sheetView show];
}

#pragma mark - lazy load
- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[[UIImage imageNamed:@"icon_back_black"] hd_imageWithTintColor:UIColor.whiteColor] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 5);
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewController dismissAnimated:true completion:nil];
        }];
        _backBTN = button;
    }
    return _backBTN;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        _titleLB = label;
    }
    return _titleLB;
}

- (SAMessageButton *)messageBTN {
    if (!_messageBTN) {
        SAMessageButton *button = [SAMessageButton buttonWithType:UIButtonTypeCustom clientType:SAClientTypeYumNow];
        [button setImage:[[UIImage imageNamed:@"yn_store_message"] hd_imageWithTintColor:UIColor.whiteColor] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{@"clientType": SAClientTypeYumNow}];
            @HDStrongify(self);
            !self.newList ?: self.newList();
        }];
        _messageBTN = button;
    }
    return _messageBTN;
}

- (HDUIButton *)shareBTN {
    if (!_shareBTN) {
        HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"yn_store_share"] forState:UIControlStateNormal];
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        @HDWeakify(self);
        [shareButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.shareStore ?: self.shareStore();
        }];
        shareButton.hidden = true;
        _shareBTN = shareButton;
    }
    return _shareBTN;
}

- (HDUIButton *)searchBTN {
    if (!_searchBTN) {
        HDUIButton *searchBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [searchBTN setImage:[UIImage imageNamed:@"yn_store_search"] forState:UIControlStateNormal];
        searchBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        @HDWeakify(self);
        [searchBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.searchInStore ?: self.searchInStore();
        }];
        searchBTN.hidden = true;
        _searchBTN = searchBTN;
    }
    return _searchBTN;
}

- (HDUIButton *)favouriteBTN {
    if (!_favouriteBTN) {
        HDUIButton *favouriteBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [favouriteBTN setImage:[UIImage imageNamed:@"yn_store_collect"] forState:UIControlStateNormal];
        [favouriteBTN setImage:[UIImage imageNamed:@"yn_store_collect_select"] forState:UIControlStateSelected];
        favouriteBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        @HDWeakify(self);
        [favouriteBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.favouriteStore ?: self.favouriteStore();
        }];
        favouriteBTN.adjustsButtonWhenHighlighted = false;
        favouriteBTN.hidden = true;
        _favouriteBTN = favouriteBTN;
    }
    return _favouriteBTN;
}

- (HDUIButton *)nFavouriteBTN {
    if (!_nFavouriteBTN) {
        HDUIButton *favouriteBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [favouriteBTN setImage:[UIImage imageNamed:@"yn_store_collect"] forState:UIControlStateNormal];
        [favouriteBTN setImage:[UIImage imageNamed:@"yn_store_collect_select"] forState:UIControlStateSelected];
        favouriteBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        @HDWeakify(self);
        [favouriteBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.favouriteStore ?: self.favouriteStore();
        }];
        favouriteBTN.adjustsButtonWhenHighlighted = false;
        favouriteBTN.alpha = 0;
        _nFavouriteBTN = favouriteBTN;
    }
    return _nFavouriteBTN;
}

- (HDUIButton *)moreBTN {
    if (!_moreBTN) {
        HDUIButton *favouriteBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [favouriteBTN setImage:[UIImage imageNamed:@"yn_store_more"] forState:UIControlStateNormal];
        favouriteBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        @HDWeakify(self);
        [favouriteBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self clickMoreHandle];
        }];
        favouriteBTN.alpha = 0;
        _moreBTN = favouriteBTN;
    }
    return _moreBTN;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = UIView.new;
        _backgroundView.backgroundColor = UIColor.whiteColor;
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}

- (WMSearchBar *)searchBar {
    if (!_searchBar) {
        WMSearchBar *view = [[WMSearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, kRealWidth(32))];
        view.alpha = 0;
        [view disableTextField];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSearchViewHandler)];
        [view addGestureRecognizer:recognizer];
        view.backgroundColor = HDAppTheme.WMColor.F6F6F6;
        view.inputFieldBackgrounColor = HDAppTheme.WMColor.F6F6F6;
        view.placeHolder = TNLocalizedString(@"GeKA8B9E", @"搜索商品");
        view.placeholderColor = HDAppTheme.WMColor.B9;
        view.textFieldHeight = kRealHeight(40);
        _searchBar = view;
        _searchBar.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setCorner:UIRectCornerAllCorners cornerRadii:CGSizeMake(kRealWidth(2), kRealWidth(2))];
        };
    }
    return _searchBar;
}
@end
