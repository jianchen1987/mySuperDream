//
//  SAAggregateSearchViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAggregateSearchViewController.h"
#import "SASearchHistoryView.h"
#import "SASearchResultView.h"
#import "SASearchViewModel.h"
#import "UIView+FrameChangedHandler.h"
#import "SASearchLocationView.h"
#import "SAAddressCacheAdaptor.h"
#import "LKDataRecord.h"
#import "SASearchLocationTipsView.h"
#import "HDPopViewManager.h"
#import "SATableView.h"
#import "SASearchAssociateModel.h"
#import "SASearchAssociateCell.h"


@interface SAAggregateSearchViewController () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
/// 定位view
@property (nonatomic, strong) SASearchLocationView *locationView;
/// 搜索框
@property (nonatomic, strong) HDSearchBar *searchBar;
///搜索历史
@property (nonatomic, strong) SASearchHistoryView *historyView;
/// 搜索结果
@property (nonatomic, strong) SASearchResultView *resultView;

@property (nonatomic, strong) SASearchViewModel *viewModel;
/// 关键字
@property (nonatomic, copy) NSString *keyword;
/// 定位失败提示
@property (strong, nonatomic) SASearchLocationTipsView *locationTip;
/// 关联词的列表
@property (nonatomic, strong) SATableView *tableView;
/// 关联词初始页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 关联词的列表数据
@property (nonatomic, strong) NSMutableArray *associateDataSource;
/// 联系请求
@property (nonatomic, strong) CMNetworkRequest *associaRequest;
/// 显示搜索结果
@property (nonatomic, assign) BOOL shouldShowSearchResult;
/// 显示联想搜索结果
@property (nonatomic, assign) BOOL showAssociateSearchResult;
/// 联想词停顿时间
@property (nonatomic, assign) float associateTimeout;

@end


@implementation SAAggregateSearchViewController

- (void)hd_setupViews {
    [super hd_setupViews];

    [self.view addSubview:self.locationView];

    [self.view addSubview:self.searchBar];

    [self.searchBar hd_setFrameNonZeroOnceHandler:^(CGRect frame){

    }];

    [self.view addSubview:self.historyView];

    [self.view addSubview:self.resultView];

    [self.view addSubview:self.tableView];

    [self.view addSubview:self.locationTip];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
        if (!addressModel) {
            [self.locationTip show];
        } else {
            [self.locationTip dissmiss];
        }
    });

    ///获取联想词停顿时间
    [self requestWithAssociateTimeout];

    // 监听位置改变
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];
}

- (void)dealloc {
    [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(associateAction:))];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
}

- (void)hd_bindViewModel {
    [super hd_bindViewModel];

    [self.historyView hd_bindViewModel];
    [self.resultView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
    //    // 加载历史搜索
    [self.viewModel loadDefaultData];
    //    //获取推荐数据
    [self.viewModel getSearchRankAndDiscoveryData];
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];

    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)updateViewConstraints {
    [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HDAppTheme.value.statusBarHeight);
        make.width.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];

    [self.locationTip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.left.mas_equalTo(12);
        make.top.equalTo(self.locationView.mas_bottom).offset(-10);
        //        make.height.mas_equalTo(100);
    }];

    // 这里可以根据是否正在搜索对搜索栏做位置变化
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationView.mas_bottom);
        make.width.centerX.equalTo(self.view);
        make.height.mas_equalTo(36);
    }];

    [self.historyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(16);
        make.bottom.left.width.equalTo(self.view);
    }];
    [self.resultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.historyView);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.historyView);
    }];

    [super updateViewConstraints];
}

///获取联想词停顿时间
- (void)requestWithAssociateTimeout {
    @HDWeakify(self);
    [self.viewModel getSystemConfigWithKey:@"takeaway_store_associate_timeout" success:^(NSString *_Nonnull value) {
        @HDStrongify(self);
        if (value) {
            self.associateTimeout = [value floatValue];
        }
    } failure:nil];
}

#pragma mark - Notification
- (void)userChangedLocationHandler:(NSNotification *)notification {
    SAClientType clientType = notification.userInfo[@"clientType"];
    if (!notification || [clientType isEqualToString:SAClientTypeMaster]) {
        [self.locationView updateCurrentAdddress];
    }

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (!addressModel) {
        [self.locationTip show];
    } else {
        [self.locationTip dissmiss];
    }
}

#pragma mark - OVERWRITE
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - private method
- (void)searchListForKeyWord:(NSString *)keyword {
    self.resultView.hidden = NO;
    self.tableView.hidden = YES;
    self.shouldShowSearchResult = YES;
    [self.resultView searchListForKeyWord:keyword];
    // 保存搜索关键词到本地
    [self.viewModel saveMerchantHistorySearchWithKeyword:keyword];

    self.currentPageNo = 1;
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    //    [self queryStoreWithKeyword:self.keyword pageNum:self.currentPageNo];
}

#pragma mark - getters and setters
- (void)setKeyword:(NSString *)keyword {
    // 去首尾空格
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.viewModel.keyword = keyword;
    HDLog(@"关键词变化：%@", keyword);

    self.tableView.hidden = YES;
    self.showAssociateSearchResult = NO;
    if (!HDIsStringEmpty(keyword)) {
        [HDFunctionThrottle throttleWithInterval:0.3 key:NSStringFromSelector(@selector(searchListForKeyWord:)) handler:^{
            [self searchListForKeyWord:keyword];
        }];
    } else {
        [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(searchListForKeyWord:))];
    }
}

#pragma mark - private methods
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
    self.resultView.hidden = true;
    self.tableView.hidden = true;
    self.shouldShowSearchResult = NO;
    return true;
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    HDLog(@"开始编辑");
    self.showAssociateSearchResult = YES;
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar {
    HDLog(@"结束编辑");
    self.showAssociateSearchResult = NO;
}

- (void)searchBarLeftButtonClicked:(HDSearchBar *)searchBar {
    [self dismissAnimated:true completion:nil];
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.keyword = fixedKeywordWithOriginalKeyword(searchBar.getText);
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    self.keyword = fixedKeywordWithOriginalKeyword(textField.text);
    return true;
}

- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText {
    HDLog(@"搜索内容 %@", searchText);

    if (searchBar.textField.markedTextRange) {
        self.tableView.hidden = YES;
        return;
    }

    if (!HDIsStringEmpty(searchBar.textField.text)) {
        [HDFunctionThrottle throttleWithInterval:MAX(0, self.associateTimeout / 1000.0) key:NSStringFromSelector(@selector(associateAction:)) handler:^{
            [self associateAction:searchText];
        }];
        self.showAssociateSearchResult = YES;
    } else {
        self.resultView.hidden = YES;
        self.tableView.hidden = YES;
        self.shouldShowSearchResult = NO;
        self.showAssociateSearchResult = NO;
    }
}

#pragma - mark 联想词
- (void)associateAction:(NSString *)searchText {
    @HDWeakify(self);
    if (!self.showAssociateSearchResult || self.shouldShowSearchResult)
        return;
    self.associaRequest = [self.viewModel getAssociateSearchKeyword:searchText success:^(NSArray<SASearchAssociateModel *> *_Nonnull list) {
        @HDStrongify(self) if (!self) return;
        if (!self.showAssociateSearchResult || self.shouldShowSearchResult)
            return;

        HDLog(@"联想结果有 %ld个", list.count);

        NSMutableArray *marr = [NSMutableArray new];

        ///联想词
        [marr addObjectsFromArray:list];
        ///最多12
        while (marr.count > 12) {
            [marr removeLastObject];
        }
        self.tableView.hidden = YES;
        [self.associateDataSource removeAllObjects];
        if (marr.count) {
            [marr enumerateObjectsUsingBlock:^(SASearchAssociateModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.keyword = searchText;
            }];

            self.tableView.hidden = NO;
            self.associateDataSource = [NSMutableArray arrayWithArray:marr];
            [self.tableView successGetNewDataWithNoMoreData:YES];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"联想结果异常");
        @HDStrongify(self) if (!self) return;
        if (!self.showAssociateSearchResult || self.shouldShowSearchResult)
            return;
        self.tableView.hidden = YES;
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.showAssociateSearchResult = NO;
    [self.view.window endEditing:true];
}

#pragma mark - private methods
- (void)navigaveToChooseAddressViewController {
    void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
        self.locationView.detailAddressLB.text = HDIsStringEmpty(addressModel.shortName) ? addressModel.address : addressModel.shortName;
        HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
        if (status == HDCLAuthorizationStatusNotAuthed) {
            addressModel.fromType = SAAddressModelFromTypeOnceTime;
        }
        // 如果选择的地址信息不包含省市字段，需要重新去解析一遍
        if (HDIsStringEmpty(addressModel.city) && HDIsStringEmpty(addressModel.subLocality)) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
            [self.view showloading];
            [SALocationUtil transferCoordinateToAddress:coordinate
                                             completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                 [self.view dismissLoading];
                                                 if (HDIsStringEmpty(address)) {
                                                     addressModel.address = WMLocalizedString(@"wm_unkown_oad", @"Unkown Road");
                                                     [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
                                                     return;
                                                 }
                                                 SAAddressModel *newAddressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                 newAddressModel.lat = @(coordinate.latitude);
                                                 newAddressModel.lon = @(coordinate.longitude);
                                                 newAddressModel.address = address;
                                                 newAddressModel.consigneeAddress = consigneeAddress;
                                                 newAddressModel.fromType = addressModel.fromType;
                                                 [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:newAddressModel];
                                             }];
        } else {
            [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
        }
    };
    /// 当前选择的地址模型
    SAAddressModel *currentAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    [HDMediator.sharedInstance navigaveToChooseAddressViewController:@{@"callback": callback, @"currentAddressModel": currentAddressModel}];

    //    [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"AD"} SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:@"" node:@""]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.associateDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.associateDataSource.count) {
        return UITableViewCell.new;
    }
    id model = self.associateDataSource[indexPath.row];
    if ([model isKindOfClass:SASearchAssociateModel.class]) {
        SASearchAssociateCell *cell = [SASearchAssociateCell cellWithTableView:tableView];
        cell.model = (SASearchAssociateModel *)model;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
    return UITableViewCell.new;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.associateDataSource[indexPath.row];
    if ([model isKindOfClass:SASearchAssociateModel.class]) {
        SASearchAssociateModel *item = (SASearchAssociateModel *)model;
        //        self.clickPrimkey = YES;
        [self.view endEditing:true];
        self.searchBar.text = item.name ? item.name.desc : item.keyword;
        [self searchBarRightButtonClicked:self.searchBar];
    }
}

#pragma mark - lazy load
- (SASearchLocationView *)locationView {
    if (!_locationView) {
        _locationView = SASearchLocationView.new;
        @HDWeakify(self);
        _locationView.clickedBackHandler = ^{
            @HDStrongify(self);
            [self dismissAnimated:true completion:nil];
        };

        _locationView.clickedHandler = ^{
            @HDStrongify(self);
            [self navigaveToChooseAddressViewController];
        };
    }
    return _locationView;
}

- (SASearchLocationTipsView *)locationTip {
    if (!_locationTip) {
        _locationTip = SASearchLocationTipsView.new;
        _locationTip.hidden = YES;
    }
    return _locationTip;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.showSquareBorder = true;
        [_searchBar setShowLeftButton:false animated:true];
        _searchBar.textFieldHeight = 35;
        _searchBar.placeholderColor = HDAppTheme.color.G3;
        _searchBar.borderColor = HDAppTheme.color.G4;
        _searchBar.buttonTitleColor = HDAppTheme.color.G1;
        _searchBar.tintColor = [UIColor hd_colorWithHexString:@"FC2040"];
        [_searchBar setLeftButtonImage:[UIImage imageNamed:@"icon_navi_back_black"]];
        [_searchBar setRightButtonTitle:WMLocalizedString(@"search", @"搜索")];
        [_searchBar setShowRightButton:false animated:false];
        _searchBar.searchImage = [UIImage imageNamed:@"search_icon_searchBar"];
    }
    return _searchBar;
}

- (SASearchHistoryView *)historyView {
    if (!_historyView) {
        _historyView = [[SASearchHistoryView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _historyView.keywordSelectedBlock = ^(NSString *_Nonnull keyword) {
            @HDStrongify(self);
            [self.view endEditing:true];
            self.searchBar.text = keyword;
            // 触发搜索
            [self searchBarRightButtonClicked:self.searchBar];
        };
    }
    return _historyView;
}

- (SASearchResultView *)resultView {
    if (!_resultView) {
        _resultView = [[SASearchResultView alloc] initWithViewModel:self.viewModel];
        _resultView.backgroundColor = UIColor.whiteColor;
        _resultView.hidden = true;
    }
    return _resultView;
}

- (SASearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SASearchViewModel alloc] init];
        _viewModel.currentlyAddress = [self.parameters objectForKey:@"currentlyAddress"];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.backgroundColor = HDAppTheme.WMColor.bg3;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.hidden = YES;
    }
    return _tableView;
}

- (float)associateTimeout {
    if (!_associateTimeout) {
        _associateTimeout = 300;
    }
    return _associateTimeout;
}

- (NSMutableArray *)associateDataSource {
    if (!_associateDataSource) {
        _associateDataSource = NSMutableArray.new;
    }
    return _associateDataSource;
}

@end
