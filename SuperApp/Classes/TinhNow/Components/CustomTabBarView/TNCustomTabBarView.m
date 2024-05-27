//
//  TNCustomTabBarView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCustomTabBarView.h"


@interface TNCustomTabBarView ()
@property (strong, nonatomic) TNCustomTabBarConfig *config;  ///<
@property (strong, nonatomic) UIStackView *containStackView; ///<
@property (strong, nonatomic) NSMutableArray *btnsArr;       ///<  按钮数组
@end


@implementation TNCustomTabBarView
+ (instancetype)tabBarViewWithConfig:(TNCustomTabBarConfig *)config {
    TNCustomTabBarView *tabBarView = [[TNCustomTabBarView alloc] initWithConfig:config];
    return tabBarView;
}

- (instancetype)initWithConfig:(TNCustomTabBarConfig *)config {
    if (self = [super init]) {
        self.config = config;
        [self setupViews];
    }
    return self;
}
- (void)setupViews {
    [self addSubview:self.containStackView];
    if (!HDIsArrayEmpty(self.config.tabBarItems)) {
        [self.btnsArr removeAllObjects];
        NSInteger index = 0;
        for (TNCustomTabBarItem *item in self.config.tabBarItems) {
            item.index = index;
            HDUIButton *btn = [self createBtnByTabBarItem:item];
            [self.containStackView addArrangedSubview:btn];
            [self.btnsArr addObject:btn];
            index++;
        }
    }
}
- (void)setSelectedIndex:(BOOL)selectedIndex {
    _selectedIndex = selectedIndex;
    if (selectedIndex < self.config.tabBarItems.count) {
        HDUIButton *btn = self.btnsArr[selectedIndex];
        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)btnClick:(HDUIButton *)btn {
    TNCustomTabBarItem *item = self.config.tabBarItems[btn.tag];
    if (HDIsStringNotEmpty(item.selectImageName)) {
        if (btn.isSelected) {
            return;
        }
        for (UIView *subView in self.containStackView.subviews) {
            if ([subView isKindOfClass:HDUIButton.class]) {
                HDUIButton *subBtn = (HDUIButton *)subView;
                subBtn.selected = NO;
            }
        }
        btn.selected = YES;
        !self.tabBarItemClickCallBack ?: self.tabBarItemClickCallBack(item.index);
    } else {
        !self.tabBarItemClickCallBack ?: self.tabBarItemClickCallBack(item.index);
    }
}
- (HDUIButton *)createBtnByTabBarItem:(TNCustomTabBarItem *)item {
    HDUIButton *btn = [[HDUIButton alloc] init];
    btn.imagePosition = HDUIButtonImagePositionTop;
    btn.spacingBetweenImageAndTitle = 3;
    btn.adjustsButtonWhenHighlighted = NO;
    [btn setTitle:item.title forState:UIControlStateNormal];
    [btn setTitleColor:item.unSelectColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:item.unSelectImageName] forState:UIControlStateNormal];
    if (HDIsStringNotEmpty(item.selectImageName)) {
        [btn setImage:[UIImage imageNamed:item.selectImageName] forState:UIControlStateSelected];
        [btn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
    }
    btn.titleLabel.font = item.font;
    btn.tag = item.index;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)updateConstraints {
    [self.containStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [super updateConstraints];
}
/** @lazy stackView */
- (UIStackView *)containStackView {
    if (!_containStackView) {
        _containStackView = [[UIStackView alloc] init];
        _containStackView.axis = UILayoutConstraintAxisHorizontal;
        _containStackView.distribution = UIStackViewDistributionFillEqually;
        _containStackView.spacing = 0;
    }
    return _containStackView;
}
/** @lazy btnsArr */
- (NSMutableArray *)btnsArr {
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray array];
    }
    return _btnsArr;
}
@end
