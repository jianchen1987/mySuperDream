//
//  SALoginGuidePagesViewController.m
//  SuperApp
//
//  Created by Tia on 2022/11/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginGuidePagesViewController.h"
#import "LKDataRecord.h"
#import "SALoginBannerCollectionViewCell.h"
#import "SAMultiLanguageManager.h"
#import "SAShadowBackgroundView.h"


@interface SALoginGuidePagesViewController () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
/// 轮播图
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// pageControl
//@property (nonatomic, strong) HDPageControl *pageControl;
/// 数据源
@property (nonatomic, strong) NSArray *dataSource;
/// 背景
@property (nonatomic, strong) SAShadowBackgroundView *bgView;
/// 底部视图
@property (nonatomic, strong) UIView *bottomView;
/// 选择您喜欢的业务文言
@property (nonatomic, strong) UILabel *tipLabel;
/// 标签容器
@property (nonatomic, strong) HDFloatLayoutView *tagsContainer;
/// 外卖
@property (nonatomic, strong) UIButton *button1;
/// 电商
@property (nonatomic, strong) UIButton *button2;
/// 游戏
@property (nonatomic, strong) UIButton *button3;
/// 团购
@property (nonatomic, strong) UIButton *button4;
/// 酒店
@property (nonatomic, strong) UIButton *button5;

@property (nonatomic, strong) NSMutableArray *buttons;
/// 立即体验按钮
@property (nonatomic, strong) SAOperationButton *submitButton;

@end


@implementation SALoginGuidePagesViewController

#define cellMargin 0

#define sideWidth 0

static CGFloat const kPageControlDotSize = 10;

- (void)hd_setupViews {
    [self.view addSubview:self.bannerView];

    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.bottomView];
    [self.bottomView addSubview:self.tipLabel];
    [self.bottomView addSubview:self.tagsContainer];
    //    [self.bottomView addSubview:self.button1];
    //    [self.bottomView addSubview:self.button2];
    //    [self.bottomView addSubview:self.button3];
    //    [self.bottomView addSubview:self.button4];
    //    [self.bottomView addSubview:self.button5];
    //    [self.bottomView addSubview:self.button6];

    [self.bottomView addSubview:self.submitButton];

    self.view.backgroundColor = UIColor.whiteColor;

    [LKDataRecord.shared tracePVEvent:@"new_user_guide_page_pv" parameters:nil SPM:nil];
}

- (void)hd_setupNavigation {
    //隐藏返回按钮
    [self setHd_navLeftBarButtonItem:nil];
}

- (void)updateViewConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.bannerView.mas_width).multipliedBy(2208 / 1242.0f);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];

    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kRealWidth(20));
        make.right.mas_equalTo(-kRealWidth(20));
    }];

    NSInteger row = [self getButtonRow];

    [self.tagsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(kRealWidth(15));
        make.left.equalTo(self.tipLabel);
        make.right.equalTo(self.bottomView).offset(-kRealWidth(20));

        make.height.mas_equalTo(row * 36 + 10 * (row - 1));
    }];

    [self.submitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(48));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_equalTo(-kRealHeight(20) - kiPhoneXSeriesSafeBottomHeight);
        make.top.equalTo(self.tagsContainer.mas_bottom).offset(kRealWidth(20));
    }];

    [super updateViewConstraints];
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SALoginBannerCollectionViewCell *cell = [SALoginBannerCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    NSString *imageName = self.dataSource[index];
    UIImage *bannerImage = [UIImage imageNamed:imageName];
    cell.imageView.image = bannerImage;
    return cell;
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame) - 2 * cellMargin - (pageView.isInfiniteLoop ? 2 * sideWidth : 0);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSpacing = cellMargin;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, cellMargin, 0, cellMargin);
    return layout;
}

#pragma mark private method
- (UIButton *)getButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HDAppTheme.color.sa_C666 forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    btn.titleLabel.font = HDAppTheme.font.sa_standard14;
    btn.contentEdgeInsets = UIEdgeInsetsMake(9, 25, 9, 25);
    [btn sizeToFit];
    btn.backgroundColor = HDAppTheme.color.sa_backgroundColor;
    btn.layer.cornerRadius = 18;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:btn];
    return btn;
}

- (NSInteger)getButtonRow {
    NSInteger row = 1;
    CGFloat maxWidth = SCREEN_WIDTH - kRealWidth(15) * 2;
    CGFloat width = 0;
    for (UIButton *btn in self.buttons) {
        width += btn.size.width;
        if (width >= maxWidth) {
            row++;
            width = btn.size.width;
        }
        width += 20;
    }
    return row;
}

- (void)btnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = HDAppTheme.color.sa_C1;
    } else {
        btn.backgroundColor = HDAppTheme.color.sa_backgroundColor;
    }
}

- (void)submitButtonClick:(UIButton *)btn {
    NSMutableArray *mArr = NSMutableArray.new;
    for (UIButton *b in self.buttons) {
        if (b.selected) {
            if ([b.currentTitle isEqualToString:SALocalizedString(@"guide_type_0", @"美食")]) {
                [mArr addObject:@"Food"];
            } else if ([b.currentTitle isEqualToString:SALocalizedString(@"guide_type_1", @"购物")]) {
                [mArr addObject:@"Shopping"];
            } else if ([b.currentTitle isEqualToString:SALocalizedString(@"guide_type_2", @"旅游")]) {
                [mArr addObject:@"Travel"];
            } else if ([b.currentTitle isEqualToString:SALocalizedString(@"guide_type_3", @"钱包")]) {
                [mArr addObject:@"Wallet"];
            } else if ([b.currentTitle isEqualToString:SALocalizedString(@"guide_type_4", @"充值")]) {
                [mArr addObject:@"Top up"];
            }
        }
    }

    NSDictionary *params = @{@"business": mArr};
    [LKDataRecord.shared traceEvent:@"new_user_guide_page_submit" name:nil parameters:params];

    [SAWindowManager switchWindowToMainTabBarControllerCompletion:nil];
}

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 3.0;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:SALoginBannerCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SALoginBannerCollectionViewCell.class)];
    }
    return _bannerView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"login_guide_en_01", @"login_guide_en_02", @"login_guide_en_03"];
        if ([SAMultiLanguageManager isCurrentLanguageCN])
            _dataSource = @[@"login_guide_cn_01", @"login_guide_cn_02", @"login_guide_cn_03"];
        ;
        if ([SAMultiLanguageManager isCurrentLanguageKH])
            _dataSource = @[@"login_guide_kh_01", @"login_guide_kh_02", @"login_guide_kh_03"];
        ;
    }
    return _dataSource;
}

- (SAShadowBackgroundView *)bgView {
    if (!_bgView) {
        SAShadowBackgroundView *view = SAShadowBackgroundView.new;
        view.backgroundColor = UIColor.clearColor;
        _bgView = view;
    }
    return _bgView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *view = UIView.new;
        _bottomView = view;
    }
    return _bottomView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = UILabel.new;
        _tipLabel.font = HDAppTheme.font.sa_standard16B;
        _tipLabel.text = SALocalizedString(@"guide_tips", @"请选择喜欢的场景");
    }
    return _tipLabel;
}

- (HDFloatLayoutView *)tagsContainer {
    if (!_tagsContainer) {
        _tagsContainer = HDFloatLayoutView.new;
        _tagsContainer.itemMargins = UIEdgeInsetsMake(0, 10, 10, 10);
        [_tagsContainer addSubview:self.button1];
        [_tagsContainer addSubview:self.button2];
        [_tagsContainer addSubview:self.button3];
        [_tagsContainer addSubview:self.button4];
        [_tagsContainer addSubview:self.button5];
    }
    return _tagsContainer;
}

- (UIButton *)button1 {
    if (!_button1) {
        UIButton *btn = [self getButtonWithTitle:SALocalizedString(@"guide_type_0", @"美食")];
        _button1 = btn;
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        UIButton *btn = [self getButtonWithTitle:SALocalizedString(@"guide_type_1", @"购物")];
        _button2 = btn;
    }
    return _button2;
}

- (UIButton *)button3 {
    if (!_button3) {
        UIButton *btn = [self getButtonWithTitle:SALocalizedString(@"guide_type_2", @"旅游")];
        _button3 = btn;
    }
    return _button3;
}

- (UIButton *)button4 {
    if (!_button4) {
        UIButton *btn = [self getButtonWithTitle:SALocalizedString(@"guide_type_3", @"钱包")];
        _button4 = btn;
    }
    return _button4;
}

- (UIButton *)button5 {
    if (!_button5) {
        UIButton *btn = [self getButtonWithTitle:SALocalizedString(@"guide_type_4", @"充值")];
        _button5 = btn;
    }
    return _button5;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = NSMutableArray.new;
    }
    return _buttons;
}

- (SAOperationButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setTitle:SALocalizedString(@"guide_submit", @"立即体验") forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitButton.titleLabel.font = HDAppTheme.font.sa_standard16H;
    }
    return _submitButton;
}

@end
