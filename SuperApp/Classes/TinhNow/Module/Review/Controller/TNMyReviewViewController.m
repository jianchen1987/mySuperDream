//
//  TNMyReviewViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyReviewViewController.h"
#import "TNNotReviewViewController.h"
#import "TNHadReviewViewController.h"


@interface TNMyReviewViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 标题数组
@property (strong, nonatomic) NSArray<NSString *> *titleArr;
/// 控制器数组
@property (strong, nonatomic) NSArray *vcArr;
/// 显示tab  0 待评价   1 已评价
@property (nonatomic, assign) NSInteger index;
@end


@implementation TNMyReviewViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSString *index = [parameters objectForKey:@"index"];
        if (HDIsStringNotEmpty(index)) {
            self.index = [index integerValue];
        } else {
            self.index = 0;
        }
    }
    return self;
}
- (void)hd_setupViews {
    self.titleArr = @[TNLocalizedString(@"tn_not_review_k", @"待评价"), TNLocalizedString(@"tn_had_reviewed_k", @"已评价")];
    self.vcArr = @[[[TNNotReviewViewController alloc] init], [[TNHadReviewViewController alloc] init]];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
    if (self.index > 0) {
        [self.categoryTitleView reloadData];
        [self.categoryTitleView selectItemAtIndex:self.index];
        [self.listContainerView didClickSelectedItemAtIndex:self.index];
    }
}
- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"tn_my_review", @"我的评价");
}
- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}
#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArr[index];
}
- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.vcArr.count;
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
}
- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(30));
}
- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.titles = self.titleArr;
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontRegular:15];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:15];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.averageCellSpacingEnabled = YES;
    }
    return _categoryTitleView;
}
- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
@end
