//
//  WMStoreSearchViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreSearchViewController.h"
#import "LKDataRecord.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "UITableView+RecordData.h"
#import "UIView+FrameChangedHandler.h"
#import "WMAssociateSearchCell.h"
#import "WMSearchBar.h"
#import "WMStoreFilterModel.h"
#import "WMStoreListViewModel.h"
#import "WMStoreSearchResultTableViewCell+Skeleton.h"
#import "WMStoreSearchResultTableViewCell.h"
#import "WMTagTableViewCell.h"
#import "WMZPageMenuView.h"
#import "SAAddressCacheAdaptor.h"

static NSString *const kStoreSearchHistoryKey = @"com.superapp.storeSearch";


@interface WMStoreSearchViewController () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource, HDStoreSearchTableViewCellDelegate, WMZPageMunuDelegate>
@property (nonatomic, strong) WMSearchBar *searchBar;                                         ///< 搜索框
@property (nonatomic, strong) SATableView *tableView;                                         ///< tableView
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *defaultDataSource;   ///< 默认数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *resultDataSource;    ///< 搜索结果数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *associateDataSource; ///< 联想词结果
@property (nonatomic, strong) WMStoreListViewModel *storeListVM;                              ///< 商户 VM
@property (nonatomic, strong) HDTableViewSectionModel *historySectionModel;                   ///< 历史
@property (nonatomic, strong) HDTableViewSectionModel *hotSearchSectionModel;                 ///< 热搜
@property (nonatomic, strong) HDTableViewSectionModel *nearbySectionModel;                    ///< 附近
@property (nonatomic, strong) HDTableViewSectionModel *searchResultSectionModel;              ///< 搜索结果
@property (nonatomic, strong) HDTableViewSectionModel *associateResultSectionModel;           ///< 联想词结果
@property (nonatomic, strong) dispatch_group_t taskGroup;                                     ///< 队列组
@property (nonatomic, assign) BOOL shouldShowSearchResult;                                    ///< 显示搜索结果
@property (nonatomic, assign) BOOL showAssociateSearchResult;                                 ///< 显示联想搜索结果
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;                    ///< 骨架 loading 生成器
@property (nonatomic, copy) WMStoreSearchSourceType sourceType;                               ///< 跳转来源
@property (nonatomic, assign) NSUInteger currentPageNo;                                       /// 当前页码
@property (nonatomic, strong) NSMutableArray *searchResultDataSource;                         /// 搜索结果数据源
/// 当前正在搜索的关键词
@property (nonatomic, copy) NSString *searchingKeyword;
/// 分页菜单
@property (nonatomic, strong) WMZPageMenuView *menuView;
/// 搜索top图
@property (nonatomic, strong) UIImageView *searchTopView;
/// 点击了关键词
@property (nonatomic, assign) BOOL clickPrimkey;
/// 联想词停顿时间
@property (nonatomic, assign) float associateTimeout;
/// 搜索id
@property (nonatomic, copy) NSString *searchId;
/// 联系请求
@property (nonatomic, strong) CMNetworkRequest *associaRequest;

@end


@implementation WMStoreSearchViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSString *sourceType = parameters[@"sourceType"];
        if (HDIsStringNotEmpty(sourceType)) {
            _sourceType = sourceType;
        }
    }
    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.searchTopView];
    @HDWeakify(self);
    [self.searchBar hd_setFrameNonZeroOnceHandler:^(CGRect frame) {
        @HDStrongify(self);
        [self.searchBar becomeFirstResponder];
    }];
    [self.view addSubview:self.tableView];
    self.tableView.hd_tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        [self searchListForKeyWord:self.keyWord];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };

    [self prepareDefaultData];
    [self requestWithAssociateTimeout];

    ///埋点 进入搜索页面
    [LKDataRecord.shared traceEvent:@"takeawayPageEnter" name:@"takeawayPageEnter"
                         parameters:@{@"type": @"searchPage", @"pageSource": [WMManage.shareInstance currentCompleteSource:self includeSelf:NO], @"plateId": WMManage.shareInstance.plateId}
                                SPM:nil];
}

- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)hd_languageDidChanged {
    self.searchBar.placeHolder = WMLocalizedString(@"wm_hamburger_pizza", @"搜索门店、商品");
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)updateViewConstraints {
    // 这里可以根据是否正在搜索对搜索栏做位置变化
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HDAppTheme.value.statusBarHeight);
        make.width.centerX.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(44));
    }];

    [self.searchTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.searchTopView.isHidden) {
            make.top.equalTo(self.menuView.mas_bottom).offset(1);
            make.height.mas_equalTo(kRealWidth(9));
            make.left.right.mas_equalTo(0);
        }
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.menuView.hidden) {
            make.top.equalTo(self.searchBar.mas_bottom);
        } else {
            make.top.equalTo(self.searchTopView.mas_bottom);
        }
        make.bottom.left.width.equalTo(self.view);
    }];

    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.menuView.isHidden) {
            make.top.equalTo(self.searchBar.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kRealWidth(40));
        }
    }];

    [super updateViewConstraints];
}

///获取联想词停顿时间
- (void)requestWithAssociateTimeout {
    @HDWeakify(self)[self.storeListVM getSystemConfigWithKey:@"takeaway_store_associate_timeout" success:^(NSString *_Nonnull value) {
        @HDStrongify(self) if (value) {
            self.associateTimeout = [value floatValue];
        }
    } failure:nil];
}

#pragma mark - Data
- (void)prepareDefaultData {
    // 加载历史搜索
    NSArray<NSString *> *historyArray = [SACacheManager.shared objectForKey:kStoreSearchHistoryKey];
    self.historySectionModel = HDTableViewSectionModel.new;
    HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
    headerModel.title = WMLocalizedString(@"history_search", @"最近");
    headerModel.titleFont = [HDAppTheme.WMFont wm_boldForSize:12];
    headerModel.titleColor = HDAppTheme.WMColor.B6;
    headerModel.rightButtonTitle = @" ";
    headerModel.rightButtonImage = [UIImage imageNamed:@"yn_search_delete"];
    self.historySectionModel.headerModel = headerModel;
    if (historyArray) {
        NSMutableArray<SAImageLabelCollectionViewCellModel *> *array = [NSMutableArray arrayWithCapacity:historyArray.count];
        for (NSString *str in historyArray) {
            SAImageLabelCollectionViewCellModel *model = SAImageLabelCollectionViewCellModel.new;
            model.title = str;
            model.textFont = [HDAppTheme.WMFont wm_ForSize:14];
            model.textColor = HDAppTheme.WMColor.B3;
            model.backgroundColor = HDAppTheme.WMColor.F6F6F6;
            model.cornerRadius = kRealWidth(15);
            model.edgeInsets = UIEdgeInsetsMake(kRealWidth(6.5), kRealWidth(18), kRealWidth(6.5), kRealWidth(18));
            [array addObject:model];
        }
        self.historySectionModel.list = @[array];

        // 有历史数据先显示
        [self showDefaultData];
    }

    // 加载热搜
    [self getHotSearchKewords];

    // 加载附近
    if ([HDLocationUtils getCLAuthorizationStatus] == HDCLAuthorizationStatusAuthed) { // 有位置权限
        [self getNearbyMerchantStore];
    }

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        [self showDefaultData];
    });
}

/// 展示未搜索时的列表
- (void)showDefaultData {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.defaultDataSource removeAllObjects];
    if (self.historySectionModel) {
        [self.defaultDataSource addObject:self.historySectionModel];
    }
    if (self.hotSearchSectionModel) {
        [self.defaultDataSource addObject:self.hotSearchSectionModel];
    }
    if (self.nearbySectionModel) {
        [self.defaultDataSource addObject:self.nearbySectionModel];
    }
    HDLog(@"热搜、附近数据获取完成，刷新界面");
    [self.tableView successGetNewDataWithNoMoreData:true];
}

- (void)getHotSearchKewords {
    dispatch_group_enter(self.taskGroup);

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];

    @HDWeakify(self);
    [self.storeListVM getStoreSearchHotKeywordsWithProvince:addressModel.city district:addressModel.subLocality latitude:addressModel.lat longitude:addressModel.lon
        success:^(NSArray<NSString *> *_Nonnull list) {
            @HDStrongify(self);
            if (list.count > 0) {
                self.hotSearchSectionModel = HDTableViewSectionModel.new;
                HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
                headerModel.title = WMLocalizedString(@"hot_search", @"热搜");
                headerModel.titleFont = [HDAppTheme.WMFont wm_boldForSize:12];
                headerModel.titleColor = HDAppTheme.WMColor.B6;
                self.hotSearchSectionModel.headerModel = headerModel;
                NSMutableArray<SAImageLabelCollectionViewCellModel *> *array = [NSMutableArray arrayWithCapacity:list.count];
                for (NSString *title in list) {
                    SAImageLabelCollectionViewCellModel *model = SAImageLabelCollectionViewCellModel.new;
                    model.title = title;
                    model.textFont = [HDAppTheme.WMFont wm_ForSize:14];
                    model.textColor = HDAppTheme.WMColor.B3;
                    model.backgroundColor = HDAppTheme.WMColor.F6F6F6;
                    model.cornerRadius = kRealWidth(15);
                    model.edgeInsets = UIEdgeInsetsMake(kRealWidth(6.5), kRealWidth(18), kRealWidth(6.5), kRealWidth(18));
                    [array addObject:model];
                }
                self.hotSearchSectionModel.list = @[array.mutableCopy];
            } else {
                self.hotSearchSectionModel = nil;
            }
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            @HDStrongify(self);
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        }];
}

- (void)getNearbyMerchantStore {
}

- (void)searchListForKeyWord:(NSString *)keyword {
    if (HDIsStringEmpty(keyword))
        return;

    self.searchingKeyword = keyword;

    self.currentPageNo = 1;

    // 保存搜索关键词到本地
    [self saveMerchantHistorySearchWithKeyWord:keyword];

    HDLog(@"发出根据关键词 %@ 查找商家请求", keyword);
    [self.tableView setContentOffset:CGPointZero];
    self.tableView.dataSource = self.provider;
    self.tableView.delegate = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:true];
    if (self.tableView.hd_hasData) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    self.storeListVM.filterModel.keyword = keyword;
    //    self.storeListVM.filterModel.sortType = @"MS_001";
    self.storeListVM.filterModel.inRange = SABoolValueTrue;
    [self queryStoreWithKeyword:keyword pageNum:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self queryStoreWithKeyword:self.keyWord pageNum:self.currentPageNo];
}

- (void)queryStoreWithKeyword:(NSString *)keyword pageNum:(NSInteger)pageNum {
    if ([self.associaRequest isKindOfClass:CMNetworkRequest.class]) {
        [self.associaRequest cancel];
    }
    self.shouldShowSearchResult = true;
    @HDWeakify(self);
    self.storeListVM.filterModel.type = (self.menuView.currentTitleIndex == 0 ? WMSearchTypeStore : WMSearchTypeProduct);
    [self.storeListVM getStoreListWithPageSize:10 pageNum:pageNum success:^(WMSearchStoreRspModel *_Nonnull rspModel) {
        NSArray<WMStoreListItemModel *> *list = rspModel.list;
        @HDStrongify(self);
        self.clickPrimkey = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        BOOL isNoData = false;
        // 先判断当前界面搜索框是否还有关键词，如果在数据返回之前用户已经清空输入框，则不用刷新
        if (HDIsStringNotEmpty(self.searchingKeyword) && [self.searchingKeyword isEqualToString:keyword]) {
            [self.resultDataSource removeAllObjects];
            if (pageNum == 1) {
                [self.searchResultDataSource removeAllObjects];
                if (list.count) {
                    [self.searchResultDataSource addObjectsFromArray:list];
                } else {
                    isNoData = true;
                    SANoDataCellModel *cellModel = SANoDataCellModel.new;
                    cellModel.image = [UIImage imageNamed:@"yn_search_noData"];
                    cellModel.descText = [NSString stringWithFormat:WMLocalizedString(@"not_found_results", @"暂时没有找到'%@'的相关信息"), keyword];
                    [self.searchResultDataSource addObject:cellModel];
                }
                self.searchResultSectionModel.list = self.searchResultDataSource;
                [self.resultDataSource addObject:self.searchResultSectionModel];
                [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
                if (self.nearbySectionModel) {
                    // 附近
                    [self.resultDataSource addObject:self.nearbySectionModel];
                }
            } else {
                if (list.count) {
                    [self.searchResultDataSource addObjectsFromArray:list];
                }
                self.searchResultSectionModel.list = self.searchResultDataSource;
                [self.resultDataSource addObject:self.searchResultSectionModel];
                [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }
        } else {
            HDLog(@"搜索结果返回，但当前关键词已经清空或者关键词不匹配，不刷新界面");
        }
        self.tableView.mj_footer.hidden = isNoData;

        ///埋点
        //        SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];        self.searchId = NSUUID.UUID.UUIDString;
        [LKDataRecord.shared traceEvent:@"takeawaySearch" name:@"搜索" parameters:@{
            @"searchId": self.searchId,
            @"geo": @{@"lat": addressModel.lat.stringValue, @"lon": addressModel.lon.stringValue},
            @"keyword": self.keyWord,
            @"lang": [HDDeviceInfo getDeviceLanguage],
            @"phone": SAUser.shared.loginName,
            @"userName": SAUser.shared.operatorNo,
            @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970],
        }
                                    SPM:[LKSPM SPMWithPage:@"WMStoreSearchViewController" area:@"" node:@""]];

        NSArray *storeList = [list mapObjectsUsingBlock:^id _Nonnull(WMStoreListItemModel *_Nonnull obj, NSUInteger idx) {
            return obj.storeNo;
        }];

        if (!HDIsArrayEmpty(storeList)) {
            [LKDataRecord.shared traceEvent:@"takeawaySearchPageResult" name:@"takeawaySearchPageResult" parameters:@{
                @"storeNoList": storeList ?: @[],
                @"plateId": WMManage.shareInstance.plateId,
            }
                                        SPM:[LKSPM SPMWithPage:@"WMStoreSearchViewController" area:@"" node:@""]];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.clickPrimkey = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        pageNum == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
        self.tableView.mj_footer.hidden = true;
    }];
}

#pragma mark - getters and setters
- (void)setKeyWord:(NSString *)keyWord {
    // 去首尾空格
    keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _keyWord = keyWord;
    HDLog(@"关键词变化：%@", keyWord);
    if (!HDIsStringEmpty(keyWord)) {
        [HDFunctionThrottle throttleWithInterval:0 key:NSStringFromSelector(@selector(searchListForKeyWord:)) handler:^{
            [self searchListForKeyWord:keyWord];
        }];
    } else {
        [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(searchListForKeyWord:))];
        [self showDefaultData];
    }
}

#pragma mark - private methods
- (NSMutableArray<HDTableViewSectionModel *> *)currentDataSource {
    if (self.showAssociateSearchResult)
        return self.associateDataSource;
    return self.shouldShowSearchResult ? self.resultDataSource : self.defaultDataSource;
}

/// 保存历史搜索关键词
/// @param keyword 关键词
- (void)saveMerchantHistorySearchWithKeyWord:(NSString *)keyword {
    NSArray<NSArray<SAImageLabelCollectionViewCellModel *> *> *listContainer = self.historySectionModel.list;
    if (!listContainer || listContainer.count <= 0) {
        listContainer = @[@[]];
    }
    if (listContainer.count > 0) {
        NSMutableArray<SAImageLabelCollectionViewCellModel *> *historyKeywordsList = [NSMutableArray arrayWithArray:listContainer.firstObject];
        // 去除重复当前
        NSArray<SAImageLabelCollectionViewCellModel *> *copiedArray = historyKeywordsList.mutableCopy;
        for (SAImageLabelCollectionViewCellModel *model in copiedArray) {
            if ([model.title isEqualToString:keyword]) {
                [historyKeywordsList removeObjectAtIndex:[copiedArray indexOfObject:model]];
            }
        }
        // 生成新关键词模型
        SAImageLabelCollectionViewCellModel *model = SAImageLabelCollectionViewCellModel.new;
        model.title = keyword;
        model.textFont = [HDAppTheme.WMFont wm_ForSize:14];
        model.textColor = HDAppTheme.WMColor.B3;
        model.backgroundColor = HDAppTheme.WMColor.F6F6F6;
        model.cornerRadius = kRealWidth(15);
        model.edgeInsets = UIEdgeInsetsMake(kRealWidth(6.5), kRealWidth(18), kRealWidth(6.5), kRealWidth(18));
        [historyKeywordsList insertObject:model atIndex:0];

        static NSUInteger maxHistoryRecordCount = 5;
        if (historyKeywordsList.count > maxHistoryRecordCount) {
            [historyKeywordsList removeObjectsInRange:NSMakeRange(maxHistoryRecordCount, historyKeywordsList.count - maxHistoryRecordCount)];
        }
        self.historySectionModel.list = @[historyKeywordsList.mutableCopy];
        NSArray<NSString *> *keywordStrArray = [historyKeywordsList mapObjectsUsingBlock:^id _Nonnull(SAImageLabelCollectionViewCellModel *obj, NSUInteger idx) {
            return obj.title;
        }];

        // 保存
        [SACacheManager.shared setObject:keywordStrArray forKey:kStoreSearchHistoryKey];
    }
}

/// 清除商户搜索历史纪录
- (void)clearMerchantSearchHistoryRecord {
    // 删除内存中历史搜索纪录
    self.historySectionModel.list = @[];
    // 删除缓存的搜索纪录
    [SACacheManager.shared removeObjectForKey:kStoreSearchHistoryKey];
    // 如果当前展示的是默认数据就展示
    if (!self.shouldShowSearchResult) {
        [self.tableView successGetNewDataWithNoMoreData:true];
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

#pragma mark - HDSearchBarDelegate
- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar {
    HDLog(@"清空搜索");
    [searchBar setShowRightButton:false animated:true];
    self.showAssociateSearchResult = NO;
    self.shouldShowSearchResult = NO;
    [self showDefaultData];
    return true;
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    HDLog(@"开始编辑");
}

- (void)searchBarLeftButtonClicked:(HDSearchBar *)searchBar {
    [self dismissAnimated:true completion:nil];
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.keyWord = fixedKeywordWithOriginalKeyword(searchBar.getText);
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    self.keyWord = fixedKeywordWithOriginalKeyword(textField.text);
    return true;
}

- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.textField.markedTextRange)
        return;
    ///点击了关键词 或者关键词和输入的一致 显示结果
    if (self.clickPrimkey) {
        if (self.showAssociateSearchResult) {
            self.shouldShowSearchResult = YES;
            if (self.tableView.hd_hasData) {
                UITableView *tableView = (UITableView *)self.tableView;
                [tableView reloadData];
            } else {
                [self.tableView successGetNewDataWithNoMoreData:NO];
            }
        }
        return;
    }
    if (!HDIsStringEmpty(searchBar.textField.text)) {
        [HDFunctionThrottle throttleWithInterval:MAX(0, self.associateTimeout / 1000.0) key:NSStringFromSelector(@selector(associateAction:)) handler:^{
            [self associateAction:searchText];
        }];
    } else {
        if (self.showAssociateSearchResult) {
            [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(associateAction:))];
        }
        [searchBar setShowRightButton:false animated:true];
        self.showAssociateSearchResult = NO;
        self.shouldShowSearchResult = NO;
        [self showDefaultData];
    }
}

#pragma - mark 联想词
- (void)associateAction:(NSString *)searchText {
    [_searchBar setShowRightButton:YES animated:YES];
    //    [self.view showloading];
    @HDWeakify(self) self.associaRequest = [self.storeListVM getAssociateSearchKeyword:searchText success:^(NSArray<WMAssociateSearchModel *> *_Nonnull list) {
        @HDStrongify(self) if (!self) return;
        if (self.shouldShowSearchResult)
            return;
        self.showAssociateSearchResult = YES;
        NSMutableArray *marr = [NSMutableArray new];
        ///历史词
        NSArray<NSArray<SAImageLabelCollectionViewCellModel *> *> *listContainer = self.historySectionModel.list;
        if (!HDIsArrayEmpty(listContainer.firstObject)) {
            for (int i = 0; i < listContainer.firstObject.count; i++) {
                SAImageLabelCollectionViewCellModel *cellModel = listContainer.firstObject[i];
                if ([cellModel isKindOfClass:SAImageLabelCollectionViewCellModel.class] && marr.count < 2 && [cellModel.title containsString:searchText]) {
                    WMAssociateSearchModel *searchModel = WMAssociateSearchModel.new;
                    searchModel.history = YES;
                    searchModel.name = [SAInternationalizationModel modelWithCN:cellModel.title en:cellModel.title kh:cellModel.title];
                    [marr addObject:searchModel];
                }
            }
        }
        ///联想词
        [marr addObjectsFromArray:list];
        ///最多12
        while (marr.count > 12) {
            [marr removeLastObject];
        }
        ///搜索词
        WMAssociateSearchModel *searchModel = WMAssociateSearchModel.new;
        [marr addObject:searchModel];
        [marr enumerateObjectsUsingBlock:^(WMAssociateSearchModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.keyword = searchText;
        }];
        self.associateResultSectionModel.list = [NSArray arrayWithArray:marr];
        self.associateDataSource = [NSMutableArray arrayWithArray:@[self.associateResultSectionModel]];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) if (!self) return;
        if (self.shouldShowSearchResult)
            return;
        self.showAssociateSearchResult = YES;
        WMAssociateSearchModel *searchModel = WMAssociateSearchModel.new;
        searchModel.keyword = searchText;
        self.associateResultSectionModel.list = @[searchModel];
        self.associateDataSource = [NSMutableArray arrayWithArray:@[self.associateResultSectionModel]];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view.window endEditing:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.currentDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.currentDataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.currentDataSource.count)
        return UITableViewCell.new;

    HDTableViewSectionModel *sectionModel = self.currentDataSource[indexPath.section];

    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:NSArray.class]) {
        WMTagTableViewCell *cell = [WMTagTableViewCell cellWithTableView:tableView];
        cell.dataSource = (NSArray<SAImageLabelCollectionViewCellModel *> *)model;
        cell.delegate = self;
        return cell;
    } else if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreSearchResultTableViewCell *cell = [WMStoreSearchResultTableViewCell cellWithTableView:tableView];
        WMStoreListItemModel *item = (WMStoreListItemModel *)model;
        item.isShowSaleCount = true;
        item.keyWord = self.keyWord;
        cell.range = YES;
        cell.model = item;
        @HDWeakify(self);
        cell.clickedProductViewBlock = ^(NSString *_Nonnull menuId, NSString *_Nonnull productId) {
            @HDStrongify(self);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"storeNo"] = item.storeNo;
            params[@"storeName"] = item.storeName.desc;
            params[@"menuId"] = menuId;
            params[@"productId"] = productId;
            params[@"sourceType"] = self.detailSourceType;
            params[@"distance"] = [NSNumber numberWithDouble:item.distance];
            params[@"funnel"] = @"搜索结果商品";
            params[@"searchId"] = self.searchId;
            params[@"source"] = HDIsStringNotEmpty(self.storeListVM.source) ? [self.storeListVM.source stringByAppendingFormat:@"|外卖搜索.%@.关键词:%@", self.storeListVM.filterModel.type == WMSearchTypeStore ? @"门店" : @"商品", self.keyWord] : [NSString stringWithFormat:@"外卖搜索.%@.关键词:%@", self.storeListVM.filterModel.type == WMSearchTypeStore ? @"门店" : @"商品", self.keyWord];
            params[@"associatedId"] = self.storeListVM.associatedId;
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        };
        cell.clickedMoreViewBlock = ^{
            @HDStrongify(self);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"storeNo"] = item.storeNo;
            params[@"storeNo"] = item.storeNo;
            params[@"storeName"] = item.storeName.desc;
            params[@"sourceType"] = self.sourceType;
            params[@"distance"] = [NSNumber numberWithDouble:item.distance];
            params[@"funnel"] = @"搜索结果商品";
            params[@"searchId"] = self.searchId;
            params[@"source"] = HDIsStringNotEmpty(self.storeListVM.source) ? [self.storeListVM.source stringByAppendingFormat:@"|外卖搜索.%@.关键词:%@", self.storeListVM.filterModel.type == WMSearchTypeStore ? @"门店" : @"商品", self.keyWord] : [NSString stringWithFormat:@"外卖搜索.%@.关键词:%@", self.storeListVM.filterModel.type == WMSearchTypeStore ? @"门店" : @"商品", self.keyWord];
            params[@"associatedId"] = self.storeListVM.associatedId;
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        };
        cell.BlockOnClickPromotion = ^{
            @HDStrongify(self);
            UITableView *tableView = self.tableView;
            [tableView reloadData];
        };

        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = (SANoDataCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:WMAssociateSearchModel.class]) {
        WMAssociateSearchCell *cell = [WMAssociateSearchCell cellWithTableView:tableView];
        cell.model = (WMAssociateSearchModel *)model;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showAssociateSearchResult) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = HDAppTheme.WMColor.F5F5F5;
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showAssociateSearchResult) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = UIColor.whiteColor;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.currentDataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.marginToBottom = -1;
    headView.model = model;
    // 清除历史记录
    if ([sectionModel.headerModel.title isEqualToString:WMLocalizedString(@"history_search", @"最近")]) {
        @HDWeakify(self);
        headView.rightButtonClickedHandler = ^{
            @HDStrongify(self);
            // 一个就直接删除
            NSArray *wordList = sectionModel.list.firstObject;
            if ([wordList isKindOfClass:NSArray.class] && wordList.count > 1) {
                [NAT showAlertWithMessage:WMLocalizedString(@"confirm_delete_all", @"确认全部删除？") confirmButtonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                     confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                         [alertView dismiss];
                         [self clearMerchantSearchHistoryRecord];
                     }
                        cancelButtonTitle:WMLocalizedStringFromTable(@"cancel", @"取消", @"Buttons")
                      cancelButtonHandler:nil];
            } else {
                [self clearMerchantSearchHistoryRecord];
            }
        };
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.currentDataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return kRealWidth(50);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.currentDataSource[indexPath.section].list[indexPath.row];

    if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreListItemModel *item = (WMStoreListItemModel *)model;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"storeNo"] = item.storeNo;
        params[@"storeNo"] = item.storeNo;
        params[@"storeName"] = item.storeName.desc;
        params[@"distance"] = [NSNumber numberWithDouble:item.distance];
        params[@"funnel"] = @"搜索结果门店";
        params[@"searchId"] = self.searchId;
        if (self.shouldShowSearchResult) {
            params[@"sourceType"] = self.detailSourceType;
        } else {
            params[@"sourceType"] = WMStoreDetailSourceTypeSearchPageNearBy;
        }
        params[@"source"] = HDIsStringNotEmpty(self.storeListVM.source) ? [self.storeListVM.source stringByAppendingFormat:@"|外卖搜索.%@.关键词:%@", self.storeListVM.filterModel.type == WMSearchTypeStore ? @"门店" : @"商品", self.keyWord] : [NSString stringWithFormat:@"外卖搜索.%@.关键词:%@", self.storeListVM.filterModel.type == WMSearchTypeStore ? @"门店" : @"商品", self.keyWord];
        params[@"associatedId"] = self.storeListVM.associatedId;
        
        
        ///曝光
        if (item.payFlag) {
            [LKDataRecord.shared traceEvent:@"sortClickStore" name:@"sortClickStore" parameters:@{@"plateId": item.uuid, @"storeNo": item.storeNo} SPM:nil];
            params[@"payFlag"] = item.uuid;
        }
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        
        
    } else if ([model isKindOfClass:WMAssociateSearchModel.class]) {
        WMAssociateSearchModel *item = (WMAssociateSearchModel *)model;
        self.clickPrimkey = YES;
        [self.view endEditing:true];
        self.searchBar.text = item.name ? item.name.desc : item.keyword;
        [self searchBarRightButtonClicked:self.searchBar];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    id model = self.currentDataSource[indexPath.section].list[indexPath.row];
    ///曝光
    if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreListItemModel *itemModel = model;
        [tableView recordExposureCountWithModel:model indexPath:indexPath position:3];

        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"pageSource": [WMManage.shareInstance currentCompleteSource:self includeSelf:YES],
            @"storeNo": itemModel.storeNo,
            @"type": self.storeListVM.filterModel.type == WMSearchTypeStore ? @"searchStore" : @"searchProduct",
            @"plateId": WMManage.shareInstance.plateId
        };
        NSString *eventName = self.storeListVM.filterModel.type == WMSearchTypeStore ? @"takeawayStoreExposure" : @"takeawayProductExposure";
        [tableView recordStoreExposureCountWithValue:itemModel.storeNo key:itemModel.mShowTime indexPath:indexPath info:param eventName:eventName];
    }
}

#pragma mark - HDStoreSearchTableViewCellDelegate
- (void)storeSearchCollectionViewTableViewCell:(WMTagTableViewCell *)tableViewCell didSelectedTag:(SAImageLabelCollectionViewCellModel *)tagModel {
    HDLog(@"点击了关键词:%@", tagModel.title);
    self.clickPrimkey = YES;
    [self.view endEditing:true];
    self.searchBar.text = tagModel.title;
    // 触发搜索
    [self searchBarRightButtonClicked:self.searchBar];
}

#pragma mark - WMZPageMunuDelegate
/// 切换菜单type
- (void)titleClick:(WMZPageNaviBtn *)btn fix:(BOOL)fixBtn {
    self.currentPageNo = 1;
    [self searchBarRightButtonClicked:self.searchBar];
}

#pragma mark - private methods
- (WMStoreDetailSourceType)detailSourceType {
    WMStoreDetailSourceType type = WMStoreDetailSourceTypeRecommendHome;
    if ([self.sourceType isEqualToString:WMStoreSearchSourceTypeDiscoverMap]) {
        type = WMStoreDetailSourceTypeSearchDiscoverMap;
    } else if ([self.sourceType isEqualToString:WMStoreSearchSourceTypeDiscoverList]) {
        type = WMStoreSearchSourceTypeDiscoverList;
    }
    return type;
}

#pragma mark - lazy load
- (WMSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = WMSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.marginToSide = kRealWidth(12);
        _searchBar.marginButtonTextField = kRealWidth(12);
        [_searchBar setShowLeftButton:true animated:true];
        _searchBar.backgroundColor = HDAppTheme.WMColor.bg3;
        _searchBar.inputFieldBackgrounColor = HDAppTheme.WMColor.F6F6F6;
        _searchBar.placeHolder = WMLocalizedString(@"wm_hamburger_pizza", @"搜索门店、商品");
        _searchBar.placeholderColor = HDAppTheme.WMColor.B9;
        _searchBar.textFieldHeight = kRealHeight(40);
        _searchBar.buttonTitleColor = HDAppTheme.WMColor.B3;
        [_searchBar setRightButtonTitle:WMLocalizedString(@"search", @"搜索")];
    }
    return _searchBar;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = true;
        _tableView.needRefreshHeader = false;
        _tableView.backgroundColor = HDAppTheme.WMColor.bg3;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray<HDTableViewSectionModel *> *)defaultDataSource {
    return _defaultDataSource ?: ({ _defaultDataSource = [NSMutableArray array]; });
}

- (NSMutableArray<HDTableViewSectionModel *> *)resultDataSource {
    if (!_resultDataSource) {
        _resultDataSource = [NSMutableArray array];
    }
    return _resultDataSource;
}

- (WMStoreListViewModel *)storeListVM {
    if (!_storeListVM) {
        _storeListVM = WMStoreListViewModel.new;
        _storeListVM.source = self.parameters[@"source"];
        _storeListVM.associatedId = self.parameters[@"associatedId"];
    }
    return _storeListVM;
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMStoreSearchResultTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [WMStoreSearchResultTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}

- (NSMutableArray *)searchResultDataSource {
    return _searchResultDataSource ?: ({ _searchResultDataSource = NSMutableArray.array; });
}

- (NSMutableArray<HDTableViewSectionModel *> *)associateDataSource {
    return _associateDataSource ?: ({ _associateDataSource = NSMutableArray.array; });
}

- (HDTableViewSectionModel *)searchResultSectionModel {
    if (!_searchResultSectionModel) {
        _searchResultSectionModel = HDTableViewSectionModel.new;
    }
    return _searchResultSectionModel;
}

- (HDTableViewSectionModel *)associateResultSectionModel {
    return _associateResultSectionModel ?: ({ _associateResultSectionModel = HDTableViewSectionModel.new; });
}

- (WMZPageMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[WMZPageMenuView alloc] initWithFrame:CGRectMake(0, 0, PageVCWidth, kRealWidth(40))];
        _menuView.menuDelegate = self;
        _menuView.hidden = YES;
        WMZPageParam *param = WMZPageParam.new;
        param.wTitleArr = @[WMLocalizedString(@"wm_store", @"门店"), WMLocalizedString(@"wm_item", @"商品")];
        param.wMenuTitleWidth = PageVCWidth / 2.0;
        param.wScrollCanTransfer = NO;
        param.wMenuAnimal = PageTitleMenuLine;
        param.wMenuPosition = PageMenuPositionCenter;
        param.wMenuTitleUIFont = [HDAppTheme.WMFont wm_ForSize:14];
        param.wMenuIndicatorWidth = kRealWidth(32);
        param.wMenuIndicatorColor = HDAppTheme.WMColor.mainRed;
        param.wMenuTitleSelectColor = HDAppTheme.WMColor.B3;
        param.wMenuTitleColor = HDAppTheme.WMColor.B6;
        param.wMenuIndicatorHeight = kRealWidth(4);
        param.wMenuIndicatorRadio = kRealWidth(2);
        param.wMenuIndicatorY = 1;
        param.wMenuTitleSelectUIFont = [HDAppTheme.WMFont wm_boldForSize:15];
        _menuView.param = param;
        [_menuView setDefaultSelect:0];
    }
    return _menuView;
}

- (UIImageView *)searchTopView {
    if (!_searchTopView) {
        _searchTopView = UIImageView.new;
        _searchTopView.image = [UIImage imageNamed:@"yn_search_top"];
    }
    return _searchTopView;
}

- (void)setShouldShowSearchResult:(BOOL)shouldShowSearchResult {
    _shouldShowSearchResult = shouldShowSearchResult;
    if (shouldShowSearchResult) {
        self.showAssociateSearchResult = NO;
        self.tableView.mj_footer.hidden = NO;
        self.tableView.needShowErrorView = true;
        self.tableView.needShowNoDataView = true;
    }
    self.searchTopView.hidden = self.menuView.hidden = !shouldShowSearchResult;
    [self.view setNeedsUpdateConstraints];
}

- (void)setShowAssociateSearchResult:(BOOL)showAssociateSearchResult {
    _showAssociateSearchResult = showAssociateSearchResult;
    if (showAssociateSearchResult) {
        self.searchTopView.hidden = self.menuView.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
        self.tableView.needShowErrorView = false;
        self.tableView.needShowNoDataView = false;
    } else {
        if (self.shouldShowSearchResult) {
            self.searchTopView.hidden = self.menuView.hidden = NO;
            self.tableView.mj_footer.hidden = NO;
            self.tableView.needShowErrorView = true;
            self.tableView.needShowNoDataView = true;
        }
    }
    [self.view setNeedsUpdateConstraints];
}

- (float)associateTimeout {
    if (!_associateTimeout) {
        _associateTimeout = 300;
    }
    return _associateTimeout;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeSearch;
}

- (void)dealloc {
    [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(associateAction:))];
}

@end
