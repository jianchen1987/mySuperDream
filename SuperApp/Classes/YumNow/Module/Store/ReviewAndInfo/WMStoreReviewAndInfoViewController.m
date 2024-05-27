//
//  WMStoreReviewAndInfoViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreReviewAndInfoViewController.h"
#import "WMCategoryChildViewControllerConfig.h"
#import "WMStoreInfoViewController.h"
#import "WMStoreReviewsViewController.h"


@interface WMStoreReviewAndInfoViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryDotView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 所有标题
@property (nonatomic, copy) NSArray<WMCategoryChildViewControllerConfig *> *configList;
@end


@implementation WMStoreReviewAndInfoViewController

- (void)hd_setupNavigation {
    self.categoryTitleView.bounds = CGRectMake(0, 0, kScreenWidth * 0.8, kRealWidth(40));
    self.hd_navigationItem.titleView = self.categoryTitleView;
}

- (void)hd_setupViews {
    [self.view addSubview:self.listContainerView];
    self.categoryTitleView.defaultSelectedIndex = [self.parameters[@"defaultSelectedIndex"] intValue];
}

- (void)updateViewConstraints {
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    UIViewController<HDCategoryListContentViewDelegate> *listVC = self.configList[index].vc;
    return listVC;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
}

#pragma mark - lazy load
- (HDCategoryDotView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryDotView.new;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(WMCategoryChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];
        _categoryTitleView.cellSpacing = 60;
        _categoryTitleView.titleFont = HDAppTheme.font.standard2;
        _categoryTitleView.titleSelectedFont = HDAppTheme.font.standard2Bold;
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleSelectedColor = HDAppTheme.color.mainColor;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = HDAppTheme.color.mainColor;
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 80;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (NSArray<WMCategoryChildViewControllerConfig *> *)configList {
    if (!_configList) {
        NSMutableArray<WMCategoryChildViewControllerConfig *> *configList = [NSMutableArray arrayWithCapacity:2];
        NSString *title = WMLocalizedString(@"review", @"评论");
        WMStoreReviewsViewController *revireVC = WMStoreReviewsViewController.new;
        revireVC.parameters = self.parameters;
        WMCategoryChildViewControllerConfig *config = [WMCategoryChildViewControllerConfig configWithTitle:title vc:revireVC];
        [configList addObject:config];

        title = WMLocalizedString(@"store_detail", @"门店详情");
        WMStoreInfoViewController *infoVC = WMStoreInfoViewController.new;
        infoVC.parameters = self.parameters;
        config = [WMCategoryChildViewControllerConfig configWithTitle:title vc:infoVC];
        [configList addObject:config];

        _configList = configList;
    }
    return _configList;
}
@end
