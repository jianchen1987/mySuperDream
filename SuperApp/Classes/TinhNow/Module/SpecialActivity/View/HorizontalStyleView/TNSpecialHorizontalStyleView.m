//
//  TNSpecialHorizontalStyleView.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecialHorizontalStyleView.h"
#import "SATalkingData.h"
#import "TNCategoryFilterView.h"
#import "TNNotificationConst.h"
#import "TNOneLevelCategoryFilterView.h"
#import "TNSpeciaActivityViewModel.h"
#import "TNSpecialActivityContentView.h"
#import "TNSpecialActivityGuidePopView.h"


@interface TNSpecialHorizontalStyleView () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 推荐列表控制器
@property (strong, nonatomic) TNSpecialActivityContentView *recommentContentView;
/// 分类筛选按钮
@property (strong, nonatomic) HDUIButton *filterBtn;
/// 改变样式按钮
@property (strong, nonatomic) HDUIButton *changeStyleBtn;
/// 背景视图
@property (strong, nonatomic) UIView *changeStyleBackGroundView;
/// 筛选后的分类id  初始化控制器的时候  这个有值优先使用这个
@property (nonatomic, copy) NSString *selectedCategoryId;
///// 当前页面
@property (nonatomic, assign) NSInteger currentIndex;
/// 筛选弹窗
@property (strong, nonatomic) TNCategoryFilterView *filterView;
@property (nonatomic, strong) TNSpeciaActivityViewModel *viewModel;
@end


@implementation TNSpecialHorizontalStyleView
- (void)dealloc {
    HDLog(@"TNSpecialHorizontalStyleView -- 销毁");
    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:@{@"specialId": self.viewModel.activityId}];
}
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"adsAndCategoryRefrehFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self reloadAdsAndCategoryData];
    }];
}
- (void)hd_setupViews {
    [self addSubview:self.categoryTitleView];
    [self addSubview:self.listContainerView];
    [self.categoryTitleView addSubview:self.filterBtn];
    [self.categoryTitleView addSubview:self.changeStyleBackGroundView];
    [self.changeStyleBackGroundView addSubview:self.changeStyleBtn];
}
#pragma mark -新手指导
- (void)showNewFutureGuide {
    BOOL hasShowed = [[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsKeySpecialNewFutureShowed];
    if (!hasShowed) {
        TNSpecialActivityGuidePopView *popView = [[TNSpecialActivityGuidePopView alloc] initWithSpecialType:TNSpecialStyleTypeHorizontal];
        [popView showFromSourceView:self.changeStyleBtn];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSUserDefaultsKeySpecialNewFutureShowed];
    }
}
#pragma mark - 重置列表视图
- (void)resetView {
    self.viewModel.activityCardRspModel.isSpecialStyleVertical = NO;
    [self reloadAdsAndCategoryData];
    [self.recommentContentView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}
#pragma mark - 弹窗分类筛选框 左右两级分类
- (void)showTwoLevelCategoryFilterView {
    self.filterBtn.selected = YES;
    if (self.filterView && self.filterView.isShowing && HDIsArrayEmpty(self.viewModel.categoryArr) && self.viewModel.categoryArr.count < 1) {
        return;
    }
    NSArray *filterArr = [self.viewModel.categoryArr subarrayWithRange:NSMakeRange(1, self.viewModel.categoryArr.count - 1)];
    self.filterView = [[TNCategoryFilterView alloc] initWithView:self.categoryTitleView categoryArr:filterArr];
    @HDWeakify(self);
    self.filterView.dismissCallBack = ^{
        @HDStrongify(self);
        self.filterBtn.selected = NO;
    };
    self.filterView.selectedCallBack = ^(NSInteger targetIndex, NSString *_Nonnull childId) {
        @HDStrongify(self);
        // 因为筛选框没有推荐栏目  下标要 +1
        [self selectedCategoryTitleByIndex:HDIsStringNotEmpty(childId) ? targetIndex + 1 : targetIndex categoryId:childId];
    };
    [self.filterView show];
    [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击分类筛选"]];
}
#pragma mark - 弹窗分类筛选框 只有一级分类数据
- (void)showOneLevelCategoryFilterView {
    NSArray *filterArr = [self.viewModel.categoryArr subarrayWithRange:NSMakeRange(1, self.viewModel.categoryArr.count - 1)];
    TNOneLevelCategoryFilterView *filterView = [[TNOneLevelCategoryFilterView alloc] initWithView:self.categoryTitleView categoryArr:filterArr];
    @HDWeakify(self);
    filterView.selectedCategoryCallBack = ^(TNCategoryModel *_Nonnull model) {
        @HDStrongify(self);
        NSInteger targetIndex = [self.viewModel.categoryArr indexOfObject:model];
        [self selectedCategoryTitleByIndex:targetIndex categoryId:model.menuId];
    };
    [filterView show];
}
#pragma mark - 刷新列表数据
- (void)refreshListData {
    if (self.currentIndex != 0) {
        [self.categoryTitleView selectItemAtIndex:0];
        [self.listContainerView didClickSelectedItemAtIndex:0];
    }
    [self.recommentContentView refreshData];
}
#pragma mark - 刷新分类和广告数据
- (void)reloadAdsAndCategoryData {
    //    如果没有分类标题数据  就要隐藏整个分类视图
    if (self.viewModel.categoryArr.count <= 1) {
        self.filterBtn.hidden = YES;
    } else {
        self.filterBtn.hidden = NO;
    }
    [self setNeedsUpdateConstraints];
    self.categoryTitleView.titles = [self.viewModel.categoryArr mapObjectsUsingBlock:^id _Nonnull(TNCategoryModel *_Nonnull obj, NSUInteger idx) {
        if (HDIsStringNotEmpty(obj.menuName.desc)) {
            return obj.menuName.desc;
        } else {
            return obj.name;
        }
    }];
    [self.categoryTitleView reloadData];
    // 展示新手指导
    [self showNewFutureGuide];
    // 因为推荐列表预加载了 这里拿到数据刷新一下
    [self.recommentContentView reloadAdsData:self.viewModel.activityCardRspModel];
}
- (void)scrollerToTop {
    TNSpecialActivityContentView *contentView = (TNSpecialActivityContentView *)self.listContainerView.validListDict[@(self.currentIndex)];
    if (contentView != nil) {
        [contentView scrollerToTop];
    }
}
#pragma mark 是否可以滚动
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    TNSpecialActivityContentView *contentView = (TNSpecialActivityContentView *)self.listContainerView.validListDict[@(self.currentIndex)];
    if (contentView != nil) {
        contentView.canScroll = canScroll;
    }
}

#pragma mark - 选中某个分类
- (void)selectedCategoryTitleByIndex:(NSInteger)index categoryId:(NSString *)categoryId {
    self.selectedCategoryId = categoryId;
    // 控制器是否已经加载  如果已经加载 重新刷新数据
    TNSpecialActivityContentView *contentView = (TNSpecialActivityContentView *)self.listContainerView.validListDict[@(index)];
    if (contentView != nil) {
        contentView.categoryId = categoryId;
        [contentView refreshData];
    }
    if (self.categoryTitleView.selectedIndex != index) {
        [self.categoryTitleView selectItemAtIndex:index];
        [self.listContainerView didClickSelectedItemAtIndex:index];
    }
}
#pragma mark - categoryView delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNCategoryModel *model = self.viewModel.categoryArr[index];
    TNSpecialActivityContentView *contentView;
    if (index == 0) {
        contentView = self.recommentContentView;
    } else {
        NSString *categoryId;
        if (HDIsStringNotEmpty(self.selectedCategoryId)) {
            categoryId = self.selectedCategoryId;
        } else {
            categoryId = model.menuId;
        }
        contentView = [[TNSpecialActivityContentView alloc] initWithViewModel:self.viewModel categoryId:categoryId];
        [contentView getNewData];
    }
    @HDWeakify(self);
    contentView.scrollerViewScrollerToTopCallBack = ^{
        @HDStrongify(self);
        !self.scrollerViewScrollerToTopCallBack ?: self.scrollerViewScrollerToTopCallBack();
    };
    contentView.scrollerShowTopBtnCallBack = ^(BOOL isShow) {
        @HDStrongify(self);
        !self.scrollerShowTopBtnCallBack ?: self.scrollerShowTopBtnCallBack(isShow);
    };
    return contentView;
}
- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.viewModel.categoryArr.count;
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.currentIndex = index;
    if (HDIsStringEmpty(self.selectedCategoryId)) {
        // 如果是用户自己点击标题或者滚动标题  设置选中
        [self.viewModel.categoryArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
            if (index == idx) {
                obj.isSelected = YES;
            }
            [obj.children enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
                subObj.isSelected = NO;
            }];
        }];
    }
    // 每次用户重新点击分类标题后  清除筛选的分类id
    self.selectedCategoryId = nil;
    // 侧滑手势处理
    //    self.hd_interactivePopDisabled = index > 0;
}
- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(80));
}
- (void)updateConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    if (!self.filterBtn.isHidden) {
        [self.filterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.categoryTitleView);
            make.height.mas_equalTo(kRealWidth(40));
        }];
        self.categoryTitleView.contentEdgeInsetRight = self.filterBtn.width;
    }
    [self.changeStyleBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.categoryTitleView);
    }];

    [self.changeStyleBtn sizeToFit];
    [self.changeStyleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.changeStyleBackGroundView);
        make.left.equalTo(self.changeStyleBackGroundView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.changeStyleBackGroundView.mas_right).offset(-kRealWidth(10));
    }];
    self.categoryTitleView.contentEdgeInsetLeft = self.changeStyleBtn.width + kRealWidth(20);

    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.categoryTitleView.isHidden ? self : self.categoryTitleView.mas_bottom);
        make.height.mas_equalTo(self.viewModel.kProductsListViewHeight - (self.categoryTitleView.isHidden ? 0 : kRealWidth(40)));
        make.bottom.equalTo(self.mas_bottom);
    }];
    [super updateConstraints];
}
- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 10;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        lineView.verticalMargin = 4;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.contentEdgeInsetLeft = kRealWidth(15);
        _categoryTitleView.contentEdgeInsetRight = 80;
        _categoryTitleView.cellSpacing = kRealWidth(20);
        _categoryTitleView.averageCellSpacingEnabled = NO;
        //        _categoryTitleView.hidden = YES;
    }
    return _categoryTitleView;
}
- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
/** @lazy recommentVC */
- (TNSpecialActivityContentView *)recommentContentView {
    if (!_recommentContentView) {
        _recommentContentView = [[TNSpecialActivityContentView alloc] initWithViewModel:self.viewModel categoryId:@""];
        [_recommentContentView getNewData];
    }
    return _recommentContentView;
}
/** @lazy filterBtn */
- (HDUIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_filterBtn setBackgroundImage:[UIImage imageNamed:@"tn_filter_background"] forState:UIControlStateNormal];
        [_filterBtn setTitle:TNLocalizedString(@"tn_page_category_title", @"分类") forState:UIControlStateNormal];
        [_filterBtn setImage:[UIImage imageNamed:@"tn_direction_down"] forState:UIControlStateNormal];
        [_filterBtn setImage:[UIImage imageNamed:@"tn_direction_up"] forState:UIControlStateSelected];
        _filterBtn.imagePosition = HDUIButtonImagePositionRight;
        _filterBtn.spacingBetweenImageAndTitle = 5;
        [_filterBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
        [_filterBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_filterBtn sizeToFit];
        @HDWeakify(self);
        [_filterBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.viewModel.configModel.showGrade == TNSpeciaActivityShowGradeThree) {
                /// 只有三级分类
                [self showOneLevelCategoryFilterView];
            } else {
                [self showTwoLevelCategoryFilterView];
            }
        }];
        _filterBtn.hidden = YES;
    }
    return _filterBtn;
}
/** @lazy changeStyleBtn */
- (HDUIButton *)changeStyleBtn {
    if (!_changeStyleBtn) {
        _changeStyleBtn = [[HDUIButton alloc] init];
        [_changeStyleBtn setImage:[UIImage imageNamed:@"tn_verticalStyle_topic"] forState:UIControlStateNormal];
        _changeStyleBtn.adjustsButtonWhenHighlighted = NO;
        @HDWeakify(self);
        [_changeStyleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:kTNNotificationNameChangedSpecialStyle object:nil userInfo:@{@"type": @(TNSpecialStyleTypeVertical)}];
            [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击导航样式切换按钮"]];
        }];
    }
    return _changeStyleBtn;
}
/** @lazy changeStyleBackGroundView */
- (UIView *)changeStyleBackGroundView {
    if (!_changeStyleBackGroundView) {
        _changeStyleBackGroundView = [[UIView alloc] init];
        _changeStyleBackGroundView.backgroundColor = [UIColor whiteColor];
    }
    return _changeStyleBackGroundView;
}
@end
