//
//  TNSearchViewController.m
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchViewController.h"
#import "SATalkingData.h"
#import "TNCategoryModel.h"
#import "TNSearchHistoryView.h"
#import "TNSearchResultView.h"
#import "TNSearchSortFilterModel.h"
#import "TNSearchTitlesConfigModel.h"
#import "TNSearchViewModel.h"
#import "TNShareManager.h"
#import <HDUIKit/HDSearchBar.h>


@interface TNSearchViewController () <HDSearchBarDelegate, HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// searchBar
@property (nonatomic, strong) HDSearchBar *searchBar;
/// 搜索历史页面
@property (nonatomic, strong) TNSearchHistoryView *historyView;
/// viewModel
@property (nonatomic, strong) TNSearchViewModel *viewModel;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 标题数组
@property (strong, nonatomic) NSMutableArray *titleArr;

@end


@implementation TNSearchViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    if (parameters.allKeys.count) {
        NSString *categoryId = parameters[@"categoryId"];
        NSString *storeNo = parameters[@"storeNo"];
        NSString *keyWord = parameters[@"keyWord"];
        NSString *brandId = parameters[@"brandId"];
        NSArray *categoryIds = parameters[@"categoryIds"];
        NSArray *categoryModelList = parameters[@"categoryModelList"]; //搜索同级分类数据源
        NSString *parentSC = parameters[@"parentSC"];                  //二级分类id
        NSString *funnel = parameters[@"funnel"];                      //埋点
        NSString *specialId = parameters[@"specialId"];                //专题id

        NSArray *pageNameArray = [[TNGlobalData trackingPageEventMap] objectForKey:NSStringFromClass([self class])];
        self.viewModel.eventPageId = pageNameArray.firstObject;
        [self.viewModel.eventProperty setObject:@"1" forKey:@"type"];
        if (HDIsStringNotEmpty(specialId)) {
            self.viewModel.specialId = specialId;
            self.viewModel.searchSortFilterModel.specialId = specialId;
            self.viewModel.scopeType = TNSearchScopeTypeSpecial;
            TNSearchTitlesConfigModel *config = [[TNSearchTitlesConfigModel alloc] init];
            config.title = TNLocalizedString(@"aYqIpIoH", @"专题");
            config.isNeedRefresh = YES;
            config.scopeType = TNSearchScopeTypeSpecial;
            [self.titleArr insertObject:config atIndex:0];
            self.viewModel.eventPageId = pageNameArray[2];
            [self.viewModel.eventProperty setObject:specialId forKey:@"specialId"];
            [self.viewModel.eventProperty removeObjectForKey:@"type"]; //专题不传type
        }

        if (HDIsStringNotEmpty(categoryId)) {
            self.viewModel.searchSortFilterModel.categoryId = categoryId;
        }
        if (HDIsStringNotEmpty(storeNo)) {
            self.viewModel.storeNo = storeNo;
            self.viewModel.searchSortFilterModel.storeNo = storeNo;
            self.viewModel.scopeType = TNSearchScopeTypeStore;
            TNSearchTitlesConfigModel *config = [[TNSearchTitlesConfigModel alloc] init];
            config.title = TNLocalizedString(@"tn_product_store", @"店铺");
            config.isNeedRefresh = YES;
            config.scopeType = TNSearchScopeTypeStore;
            [self.titleArr insertObject:config atIndex:0];
            self.viewModel.eventPageId = pageNameArray[1];
            [self.viewModel.eventProperty setObject:storeNo forKey:@"storeId"];
            [self.viewModel.eventProperty setObject:@"3" forKey:@"type"];
        }
        if (HDIsStringNotEmpty(keyWord)) {
            self.viewModel.searchSortFilterModel.keyWord = keyWord;
            self.searchBar.text = keyWord;
        }
        if (HDIsStringNotEmpty(brandId)) {
            self.viewModel.searchSortFilterModel.brandId = brandId;
        }
        if (!HDIsArrayEmpty(categoryIds)) {
            self.viewModel.searchSortFilterModel.categoryIds = categoryIds;
        }
        if (!HDIsArrayEmpty(categoryModelList)) {
            self.viewModel.categoryList = categoryModelList;
        }
        if (HDIsStringNotEmpty(parentSC)) {
            self.viewModel.parentSC = parentSC;
        }
        if (HDIsStringNotEmpty(funnel)) {
            self.viewModel.funnel = funnel;
        }
    }

    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    if(!HDIsObjectNil(self.listContainerView.validListDict)){
    //        NSArray *listVC = [self.listContainerView.validListDict allValues];
    //        [listVC enumerateObjectsUsingBlock:^(TNSearchResultView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            [obj viewWillDisappear];
    //        }];
    //    }
}

- (void)hd_setupViews {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.historyView];
    // 如果是分类列表来的  就需要分享按钮  其它进入的没有分享按钮
    if (!HDIsArrayEmpty(self.viewModel.categoryList)) {
        [self.searchBar setRightButtonImage:[UIImage imageNamed:@"tinhnow-black-share-new"]];
        [self.searchBar setShowRightButton:YES animated:NO];
    }
    if (HDIsStringNotEmpty(self.viewModel.searchSortFilterModel.storeNo)) {
        self.searchBar.placeHolder = TNLocalizedString(@"tn_page_store_search_title", @"Search");
    }

    if (self.titleArr.count == 1) {
        self.categoryTitleView.hidden = YES;
    }

    if (HDIsStringNotEmpty(self.viewModel.searchSortFilterModel.categoryId) || HDIsStringNotEmpty(self.viewModel.searchSortFilterModel.brandId)
        || HDIsStringNotEmpty(self.viewModel.searchSortFilterModel.keyWord)) {
        [self.historyView setHidden:YES];
        [self.categoryTitleView reloadData];
        [[self getCurrentResultView] requestNewData];
    }

    //如果搜索历史页面存在 就自动弹出键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.historyView.isHidden) {
            [self.searchBar becomeFirstResponder];
        }
    });
}
- (void)trackingPage {
    //页面埋点
    [TNEventTrackingInstance trackPage:self.viewModel.eventPageId properties:self.viewModel.eventProperty];
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
            make.top.equalTo(self.searchBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(kRealWidth(50));
        }];
    }
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.categoryTitleView.isHidden) {
            make.top.equalTo(self.categoryTitleView.mas_bottom);
        } else {
            make.top.equalTo(self.searchBar.mas_bottom);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - private methods
- (void)searchGoodsListWithKeyWord:(NSString *)keyWord {
    [self.titleArr enumerateObjectsUsingBlock:^(TNSearchTitlesConfigModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isNeedRefresh = YES;
    }];
    [self.historyView setHidden:YES];
    self.viewModel.searchSortFilterModel.keyWord = keyWord;
    [self requestCurrentResultData];
    if (HDIsStringNotEmpty(self.viewModel.funnel)) {
        [SATalkingData trackEvent:[NSString stringWithFormat:@"%@_搜索商品", self.viewModel.funnel]];
    }
    self.viewModel.eventProperty[@"key"] = keyWord;
    [TNEventTrackingInstance trackEvent:@"search_keyword" properties:self.viewModel.eventProperty];
}
//刷新当前结果页数据
- (void)requestCurrentResultData {
    TNSearchResultView *resultView = [self getCurrentResultView];
    [resultView requestGoodListData];

    TNSearchTitlesConfigModel *config = self.titleArr[self.categoryTitleView.selectedIndex];
    config.isNeedRefresh = NO;
}
/// 当前展示的搜索结果页
- (TNSearchResultView *)getCurrentResultView {
    NSInteger index = self.categoryTitleView.selectedIndex;
    TNSearchResultView *resultView = (TNSearchResultView *)self.listContainerView.validListDict[@(index)];
    return resultView;
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

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    if (HDIsArrayEmpty(self.viewModel.categoryList)) {
        return;
    }
    TNCategoryModel *model = nil;
    for (TNCategoryModel *oModel in self.viewModel.categoryList) {
        if ([oModel.menuId isEqualToString:self.viewModel.searchSortFilterModel.categoryId]) {
            model = oModel;
            break;
        }
    }
    if (model != nil) {
        TNShareModel *shareModel = [[TNShareModel alloc] init];
        shareModel.shareImage = model.logo;
        shareModel.shareTitle = model.name;
        shareModel.shareContent = TNLocalizedString(@"tn_share_default_desc", @"商品品类多，质量好，价格低，快来一起WOWNOW吧");
        shareModel.shareLink =
            [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingFormat:@"/h5%@parentSC=%@&categoryId=%@", kTinhNowClassification, self.viewModel.parentSC, model.menuId];
        [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
    }
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    NSString *keyWord = fixedKeywordWithOriginalKeyword(textField.text);
    [self searchGoodsListWithKeyWord:keyWord];
    return true;
}
- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    //准备开始搜索
    if (self.historyView.isHidden) {
        self.historyView.hidden = NO;
        [[self getCurrentResultView] resetData];
    }
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
#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNSearchTitlesConfigModel *config = self.titleArr[index];
    TNSearchResultView *resultView = [[TNSearchResultView alloc] initWithViewModel:self.viewModel scopeType:config.scopeType];
    return resultView;
}
- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.titleArr.count;
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    TNSearchTitlesConfigModel *config = self.titleArr[index];
    self.viewModel.scopeType = config.scopeType;
    switch (config.scopeType) {
        case TNSearchScopeTypeAllMall: {
            self.viewModel.searchSortFilterModel.specialId = @"";
            self.viewModel.searchSortFilterModel.storeNo = @"";
        } break;
        case TNSearchScopeTypeSpecial:
            self.viewModel.searchSortFilterModel.specialId = self.viewModel.specialId;
            break;
        case TNSearchScopeTypeStore:
            self.viewModel.searchSortFilterModel.storeNo = self.viewModel.storeNo;
            break;

        default:
            break;
    }
    if (config.isNeedRefresh) {
        [self requestCurrentResultData];
    }
}
- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(30));
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
        _searchBar.placeHolder = TNLocalizedString(@"tn_page_search_title", @"Search");
        _searchBar.borderColor = [UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:1.0];
        _searchBar.placeholderColor = HDAppTheme.TinhNowColor.G3;
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraBtn setBackgroundImage:[UIImage imageNamed:@"tn_camera_search"] forState:UIControlStateNormal];
        [cameraBtn sizeToFit];
        [cameraBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [[HDMediator sharedInstance] navigaveToTinhNowPictureSearchViewController:@{}];
            [TNEventTrackingInstance trackEvent:@"search_photo" properties:self.viewModel.eventProperty];
        }];
        _searchBar.textField.rightView = cameraBtn;
        _searchBar.textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _searchBar;
}
/** @lazy historyView */
- (TNSearchHistoryView *)historyView {
    if (!_historyView) {
        _historyView = [[TNSearchHistoryView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _historyView.searchHistoryKeyWordSelected = ^(NSString *_Nonnull keyWord) {
            @HDStrongify(self);
            HDLog(@"选了:%@", keyWord);
            self.searchBar.text = keyWord;
            [self searchGoodsListWithKeyWord:keyWord];
            [self.searchBar resignFirstResponder];
        };
    }
    return _historyView;
}
- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.titles = [self.titleArr mapObjectsUsingBlock:^id _Nonnull(TNSearchTitlesConfigModel *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 10;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        lineView.verticalMargin = 4;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleLabelZoomEnabled = NO;
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
/** @lazy viewmodel */
- (TNSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNSearchViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy titleArr */
- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
        TNSearchTitlesConfigModel *config = [[TNSearchTitlesConfigModel alloc] init];
        config.title = TNLocalizedString(@"tn_title_all", @"全部");
        config.isNeedRefresh = YES;
        config.scopeType = TNSearchScopeTypeAllMall;
        [_titleArr addObject:config];
    }
    return _titleArr;
}

#pragma mark - navConfig
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

@end
