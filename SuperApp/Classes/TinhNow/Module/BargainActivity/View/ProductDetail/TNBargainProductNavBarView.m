//
//  TNBargainProductNavBarView.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNBargainProductNavBarView.h"


@interface TNBargainProductNavBarView () <HDCategoryViewDelegate>
/// 背景
@property (nonatomic, strong) UIView *backgroundView;
/// 返回按钮
@property (nonatomic, strong) HDUIButton *backBTN;
/// 分享按钮
@property (nonatomic, strong) HDUIButton *shareBTN;
/// 搜索按钮
@property (nonatomic, strong) HDUIButton *searchBTN;
/// 更多
@property (nonatomic, strong) HDUIButton *moreBTN;
/// 阴影图层
@property (nonatomic, strong) CAShapeLayer *shadowLayer;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *sectionTitleView;
/// 标题宽度
@property (nonatomic, assign) CGFloat titleViewWidth;
@end


@implementation TNBargainProductNavBarView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.sectionTitleView];
    [self addSubview:self.backBTN];
    [self addSubview:self.searchBTN];
    [self addSubview:self.moreBTN];
    [self addSubview:self.shareBTN];

    @HDWeakify(self);
    self.backgroundView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.shadowLayer) {
            [self.shadowLayer removeFromSuperlayer];
            self.shadowLayer = nil;
        }
        self.shadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                       shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                         fillColor:UIColor.whiteColor.CGColor
                                      shadowOffset:CGSizeMake(0, 3)];
    };
}

- (void)updateConstraints {
    CGFloat offsetY = UIApplication.sharedApplication.statusBarFrame.size.height;

    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(offsetY * 0.5);
        make.size.mas_equalTo(self.backBTN.bounds.size);
    }];

    if (!self.shareBTN.isHidden) {
        [self.shareBTN sizeToFit];
        [self.shareBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBTN);
            make.right.equalTo(self);
            make.size.mas_equalTo(self.shareBTN.bounds.size);
        }];
    }
    [self.moreBTN sizeToFit];
    [self.moreBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        if (self.shareBTN.isHidden) {
            make.right.equalTo(self);
        } else {
            make.right.equalTo(self.shareBTN.mas_left);
        }
        make.size.mas_equalTo(self.moreBTN.bounds.size);
    }];

    [self.searchBTN sizeToFit];
    [self.searchBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN);
        make.right.equalTo(self.moreBTN.mas_left);
        make.size.mas_equalTo(self.searchBTN.bounds.size);
    }];

    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.sectionTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBTN.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(kRealWidth(40));
        make.width.mas_equalTo(self.titleViewWidth);
    }];
    [super updateConstraints];
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    if (HDIsArrayEmpty(titleArr) || !HDIsArrayEmpty(self.sectionTitleView.titles)) {
        return;
    }
    self.sectionTitleView.titles = titleArr;
    [self.sectionTitleView reloadDataWithoutListContainer];

    for (NSString *title in titleArr) {
        CGFloat width = [title boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(40)) font:[UIFont boldSystemFontOfSize:14]].width;
        self.titleViewWidth += width;
    }
    //加间距
    self.titleViewWidth += (titleArr.count + 1) * kRealWidth(20);
    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)hiddinShareBtn {
    self.shareBTN.hidden = YES;
    [self setNeedsUpdateConstraints];
}

- (NSInteger)currentTitleIndex {
    return self.sectionTitleView.selectedIndex;
}

- (void)updateSectionViewSelectedItemWithIndex:(NSInteger)index {
    if (index >= 0 && self.sectionTitleView.selectedIndex != index) {
        [self.sectionTitleView selectItemAtIndex:index];
    }
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
    //     HDLog(@"offsetY:%.2f ，rate: %.2f", offsetY, rate);
    self.backgroundView.alpha = rate;
    [self updateNavBarRightImages:rate];
}
- (void)updateNavBarRightImages:(CGFloat)rate {
    if (rate > 0.6) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.backBTN setImage:[UIImage imageNamed:@"tn_back_image_new"] forState:UIControlStateNormal];
            [self.moreBTN setImage:[UIImage imageNamed:@"tinhnow_nav_more"] forState:UIControlStateNormal];
            [self.shareBTN setImage:[UIImage imageNamed:@"tinhnow-black-share-new"] forState:UIControlStateNormal];
            self.searchBTN.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [self.backBTN setImage:[UIImage imageNamed:@"tinhnow_back_lucency"] forState:UIControlStateNormal];
            [self.moreBTN setImage:[UIImage imageNamed:@"tinhnow_nav_more_lucency"] forState:UIControlStateNormal];
            [self.shareBTN setImage:[UIImage imageNamed:@"tinhnow_share_lucency"] forState:UIControlStateNormal];
            self.searchBTN.alpha = 1;
        }];
    }
}

- (void)hiddenShareAndMoreBtn {
    self.shareBTN.hidden = YES;
    self.moreBTN.hidden = YES;
    self.searchBTN.hidden = YES;
    [self setNeedsUpdateConstraints];
}

- (void)showShareBtn {
    self.shareBTN.hidden = NO;
    [self setNeedsUpdateConstraints];
}

- (void)showMoreBtn {
    self.moreBTN.hidden = NO;
    self.searchBTN.hidden = NO;
    [self setNeedsUpdateConstraints];
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)itemIndex {
    if (self.selectedItemCallBack) {
        self.selectedItemCallBack(itemIndex);
    }
}
#pragma mark - lazy load
- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"tinhnow_back_lucency"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
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

- (HDUIButton *)shareBTN {
    if (!_shareBTN) {
        HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"tinhnow_share_lucency"] forState:UIControlStateNormal];
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 10);
        @HDWeakify(self);
        [shareButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.shareCallBack) {
                self.shareCallBack();
            }
        }];
        _shareBTN = shareButton;
    }
    return _shareBTN;
}
- (HDUIButton *)moreBTN {
    if (!_moreBTN) {
        HDUIButton *moreBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [moreBTN setImage:[UIImage imageNamed:@"tinhnow_nav_more_lucency"] forState:UIControlStateNormal];
        moreBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 10);
        @HDWeakify(self);
        [moreBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.moreCallBack) {
                self.moreCallBack(self.moreBTN);
            }
        }];

        _moreBTN = moreBTN;
    }
    return _moreBTN;
}

- (HDUIButton *)searchBTN {
    if (!_searchBTN) {
        HDUIButton *searchBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [searchBTN setImage:[UIImage imageNamed:@"tinhnow_nav_search_lucency"] forState:UIControlStateNormal];
        searchBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 10);
        @HDWeakify(self);
        [searchBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.searchCallBack) {
                self.searchCallBack();
            }
        }];

        _searchBTN = searchBTN;
    }
    return _searchBTN;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = UIView.new;
        _backgroundView.backgroundColor = UIColor.whiteColor;
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}

- (HDCategoryTitleView *)sectionTitleView {
    if (!_sectionTitleView) {
        _sectionTitleView = HDCategoryTitleView.new;
        _sectionTitleView.averageCellSpacingEnabled = false;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        lineView.verticalMargin = kRealWidth(10);
        _sectionTitleView.indicators = @[lineView];
        _sectionTitleView.delegate = self;
        _sectionTitleView.titleFont = [UIFont boldSystemFontOfSize:14];
        _sectionTitleView.titleSelectedFont = [UIFont boldSystemFontOfSize:14];
        _sectionTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _sectionTitleView.titleLabelZoomEnabled = false;
        _sectionTitleView.cellSpacing = kRealWidth(20);
    }
    return _sectionTitleView;
}

@end
