//
//  TNStoreTabBarView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreTabBarView.h"


@interface TNStoreTabBarView ()
/// 顶部分割线
@property (strong, nonatomic) UIView *topLineView;
/// 按钮背景视图
@property (strong, nonatomic) UIView *containerView;
/// 首页
@property (strong, nonatomic) HDUIButton *homeBtn;
/// 分类
@property (strong, nonatomic) HDUIButton *categoryBtn;
/// 客服
@property (strong, nonatomic) HDUIButton *customerBtn;
@end


@implementation TNStoreTabBarView
- (void)hd_setupViews {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.homeBtn];
    [self.containerView addSubview:self.categoryBtn];
    [self.containerView addSubview:self.customerBtn];
    [self.containerView addSubview:self.topLineView];
}
- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.homeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.containerView);
    }];
    [self.categoryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.containerView);
        make.left.equalTo(self.homeBtn.mas_right);
        make.width.equalTo(self.homeBtn.mas_width);
    }];
    [self.customerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.containerView);
        make.left.equalTo(self.categoryBtn.mas_right);
        make.width.equalTo(self.homeBtn.mas_width);
    }];
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.height.mas_offset(PixelOne);
    }];

    [super updateConstraints];
}
- (void)sendActiconClickType:(TNStoreTabBarViewItemClickType)type {
    switch (type) {
        case TNStoreTabBarViewItemClickTypeHome:
            [self.homeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        case TNStoreTabBarViewItemClickTypeCategory:
            [self.categoryBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        case TNStoreTabBarViewItemClickTypeCustomer:
            [self.customerBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
}
#pragma mark - 点击事件
- (void)btnClick:(HDUIButton *)btn {
    if (btn == self.homeBtn) {
        if (btn.isSelected) {
            return;
        }
        self.homeBtn.selected = YES;
        self.categoryBtn.selected = NO;
        if (self.homeClickCallBack) {
            self.homeClickCallBack();
        }
    } else if (btn == self.categoryBtn) {
        if (btn.isSelected) {
            return;
        }
        self.homeBtn.selected = NO;
        self.categoryBtn.selected = YES;
        if (self.categoryClickCallBack) {
            self.categoryClickCallBack();
        }
    } else if (btn == self.customerBtn) {
        if (self.customerClickCallBack) {
            self.customerClickCallBack();
        }
    }
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _topLineView;
}
/** @lazy homeBtn */
- (HDUIButton *)homeBtn {
    if (!_homeBtn) {
        _homeBtn = [self createBtnByTitle:TNLocalizedString(@"tn_tabbar_home_title", @"首页") unselectedImage:[UIImage imageNamed:@"tn_store_tab_index_unselected"]
                            selectedImage:[UIImage imageNamed:@"tn_store_tab_index_selected"]];
        _homeBtn.selected = YES;
    }
    return _homeBtn;
}
/** @lazy categoryBtn */
- (HDUIButton *)categoryBtn {
    if (!_categoryBtn) {
        _categoryBtn = [self createBtnByTitle:TNLocalizedString(@"tn_tabbar_category_title", @"分类") unselectedImage:[UIImage imageNamed:@"tn_store_tab_category_unselected"]
                                selectedImage:[UIImage imageNamed:@"tn_store_tab_category_selected"]];
    }
    return _categoryBtn;
}
/** @lazy customerBtn */
- (HDUIButton *)customerBtn {
    if (!_customerBtn) {
        _customerBtn = [self createBtnByTitle:TNLocalizedString(@"tn_product_customer", @"客服") unselectedImage:[UIImage imageNamed:@"tn_store_tab_customer"] selectedImage:nil];
    }
    return _customerBtn;
}

- (HDUIButton *)createBtnByTitle:(NSString *)title unselectedImage:(UIImage *)unselectedImage selectedImage:(UIImage *)selectedImage {
    HDUIButton *btn = [[HDUIButton alloc] init];
    btn.imagePosition = HDUIButtonImagePositionTop;
    btn.spacingBetweenImageAndTitle = 3;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HexColor(0x5D667F) forState:UIControlStateNormal];
    [btn setImage:unselectedImage forState:UIControlStateNormal];
    if (selectedImage != nil) {
        [btn setImage:selectedImage forState:UIControlStateSelected];
        [btn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
    }
    btn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
