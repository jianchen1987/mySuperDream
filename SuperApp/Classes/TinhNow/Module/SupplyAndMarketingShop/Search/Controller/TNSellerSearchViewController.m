//
//  TNSellerSearchViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerSearchViewController.h"
#import "TNSearchHistoryView.h"
#import "TNSellerSearchConfig.h"
#import "TNSellerSearchResultView.h"


@interface TNSellerSearchViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource, HDSearchBarDelegate>
/// 搜索历史页面
@property (nonatomic, strong) TNSearchHistoryView *historyView;
/// searchBar
@property (nonatomic, strong) HDSearchBar *searchBar;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 页面配置
@property (strong, nonatomic) NSMutableArray<TNSellerSearchConfig *> *configList;
/// viewModel
@property (strong, nonatomic) TNSellerSearchViewModel *viewModel;
@end


@implementation TNSellerSearchViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    if (parameters.allKeys.count) {
        NSString *categoryId = parameters[@"categoryId"];
        NSString *sp = parameters[@"sp"];
        NSString *keyWord = parameters[@"keyWord"];
        NSArray *categoryModelList = parameters[@"categoryModelList"]; //搜索同级分类数据源
        NSNumber *type = parameters[@"type"];                          // 视角类型(1:卖家,2:用户) 用于搜索微店商品
        NSString *storeNo = parameters[@"storeNo"];
        if (HDIsStringNotEmpty(storeNo)) {
            self.viewModel.searchSortFilterModel.storeNo = storeNo;
            self.viewModel.storeNo = storeNo;
        }
        if (type != nil && [type integerValue] != TNMicroShopProductSearchTypeNone) {
            self.viewModel.searchSortFilterModel.searchType = [type integerValue];
            self.categoryTitleView.hidden = YES; //搜索微店商品
        }
        if (HDIsStringNotEmpty(categoryId)) {
            self.viewModel.searchSortFilterModel.categoryId = categoryId;
        }
        if (HDIsStringNotEmpty(sp)) {
            self.viewModel.searchSortFilterModel.sp = sp;
        }
        if (HDIsStringNotEmpty(keyWord)) {
            self.viewModel.searchSortFilterModel.keyWord = keyWord;
            self.searchBar.text = keyWord;
        }
        if (!HDIsArrayEmpty(categoryModelList)) {
            self.viewModel.categoryList = categoryModelList;
            self.categoryTitleView.hidden = YES;
        }
    }
    if (HDIsStringNotEmpty(self.viewModel.searchSortFilterModel.categoryId) || HDIsStringNotEmpty(self.viewModel.searchSortFilterModel.keyWord)) {
        [self.historyView setHidden:YES];
        [self.viewModel getNewDataByResultType:TNSellerSearchResultTypeProduct];
    }
    return self;
}
//埋点
- (void)trackingPage {
    if (HDIsStringNotEmpty(self.viewModel.storeNo)) {
        [TNEventTrackingInstance trackPage:@"store_search" properties:@{@"storeId": self.viewModel.storeNo}];
    }
}
- (void)hd_setupViews {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.historyView];
}
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}
#pragma mark - HDSearchBarDelegate
- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar {
    //清空条件
    self.viewModel.searchSortFilterModel.keyWord = @"";
    return true;
}

- (void)searchBarLeftButtonClicked:(HDSearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    NSString *keyWord = fixedKeywordWithOriginalKeyword(textField.text);
    [self searchBeginWithKey:keyWord];
    return true;
}
- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    //准备开始搜索
    if (self.historyView.isHidden) {
        self.historyView.hidden = NO;
    }
}

- (void)searchBeginWithKey:(NSString *)keyword {
    self.viewModel.searchSortFilterModel.keyWord = keyword;
    [self.historyView setHidden:YES];
    [self.configList enumerateObjectsUsingBlock:^(TNSellerSearchConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isNeedRefresh = YES;
    }];
    [self refreshDataWithIndex:self.categoryTitleView.selectedIndex];

    [TNEventTrackingInstance trackEvent:@"search_keyword" properties:@{@"key": keyword, @"storeId": self.viewModel.storeNo, @"type": @"3"}];
}
///刷新数据
- (void)refreshDataWithIndex:(NSInteger)selectedIndex {
    TNSellerSearchConfig *config = self.configList[selectedIndex];
    if (HDIsStringNotEmpty(self.viewModel.storeNo)) {
        if (selectedIndex == 0) {
            self.viewModel.searchSortFilterModel.storeNo = self.viewModel.storeNo;
        } else if (selectedIndex == 1) {
            self.viewModel.searchSortFilterModel.storeNo = @"";
        }
        [self.viewModel getNewDataByResultType:config.type];
    } else {
        [self.viewModel getNewDataByResultType:config.type];
    }
    config.isNeedRefresh = NO;
}
NS_INLINE NSString *fixedKeywordWithOriginalKeyword(NSString *originalKeyword) {
    // 去除两端空格
    NSString *keyWord = [originalKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [keyWord copy];
}

- (void)updateViewConstraints {
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(UIApplication.sharedApplication.statusBarFrame.size.height);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kRealHeight(44));
    }];
    [self.historyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    if (!self.categoryTitleView.isHidden) {
        [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.searchBar.mas_bottom);
            make.height.mas_equalTo(kRealWidth(50));
        }];
    }
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (!self.categoryTitleView.isHidden) {
            make.top.equalTo(self.categoryTitleView.mas_bottom);
        } else {
            make.top.equalTo(self.searchBar.mas_bottom);
        }
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNSellerSearchConfig *config = self.configList[index];
    TNSellerSearchResultView *resultView = [[TNSellerSearchResultView alloc] initWithViewModel:self.viewModel resultType:config.type];
    return resultView;
}
- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    TNSellerSearchConfig *config = self.configList[index];
    if (config.isNeedRefresh) {
        [self refreshDataWithIndex:index];
    }
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
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(TNSellerSearchConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        lineView.indicatorWidth = 20;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontRegular:15];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:15];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleColor = HDAppTheme.TinhNowColor.G2;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.averageCellSpacingEnabled = YES;
        _categoryTitleView.contentScrollView.scrollEnabled = NO;
    }
    return _categoryTitleView;
}
- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
/** @lazy configList */
- (NSMutableArray *)configList {
    if (!_configList) {
        _configList = [NSMutableArray array];
        if (HDIsStringNotEmpty(self.viewModel.storeNo)) {
            //搜索店铺商品
            TNSellerSearchConfig *storeConfig = [TNSellerSearchConfig configWithTitle:TNLocalizedString(@"tn_product_store", @"店铺") resultType:TNSellerSearchResultTypeProductInStore];
            [_configList addObject:storeConfig];

            TNSellerSearchConfig *allConfig = [TNSellerSearchConfig configWithTitle:TNLocalizedString(@"tn_title_all", @"全部") resultType:TNSellerSearchResultTypeAllProductInMall];
            [_configList addObject:allConfig];

        } else {
            TNSellerSearchConfig *productConfig = [TNSellerSearchConfig configWithTitle:TNLocalizedString(@"tn_productDetail_item", @"商品") resultType:TNSellerSearchResultTypeProduct];
            [_configList addObject:productConfig];
            if (HDIsArrayEmpty(self.viewModel.categoryList)) {
                TNSellerSearchConfig *storeConfig = [TNSellerSearchConfig configWithTitle:TNLocalizedString(@"tn_product_store", @"店铺") resultType:TNSellerSearchResultTypeStore];
                [_configList addObject:storeConfig];
            }
        }
    }
    return _configList;
}
#pragma mark - lazy load
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.showBottomShadow = NO;
        [_searchBar setLeftButtonImage:[UIImage imageNamed:@"tn_back_image_new"]];
        [_searchBar setShowLeftButton:true animated:true];
        _searchBar.textFieldHeight = 34;
        _searchBar.placeHolder = TNLocalizedString(@"GeKA8B9E", @"搜索商品");
        _searchBar.borderColor = [UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:1.0];
        _searchBar.placeholderColor = HDAppTheme.TinhNowColor.G3;
    }
    return _searchBar;
}
/** @lazy viewModel */
- (TNSellerSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNSellerSearchViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy historyView */
- (TNSearchHistoryView *)historyView {
    if (!_historyView) {
        _historyView = [[TNSearchHistoryView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _historyView.searchHistoryKeyWordSelected = ^(NSString *_Nonnull keyWord) {
            @HDStrongify(self);
            self.searchBar.text = keyWord;
            [self searchBeginWithKey:keyWord];
        };
    }
    return _historyView;
}
@end
