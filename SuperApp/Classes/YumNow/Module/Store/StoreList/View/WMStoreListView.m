//
//  WMStoreListView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreListView.h"
#import "LKDataRecord.h"
#import "SAAddressCacheAdaptor.h"
#import "SACacheManager.h"
#import "SAWriteDateReadableModel.h"
#import "UITableView+RecordData.h"
#import "WMCNStoreListNavView.h"
#import "WMCNStoreTableViewCell.h"
#import "WMGetUserShoppingCartRspModel.h"
#import "WMHomeTipView.h"
#import "WMShoppingCartDTO.h"
#import "WMShoppingCartEntryWindow.h"
#import "WMStoreCateCacheModel.h"
#import "WMStoreListMenuView.h"
#import "WMStoreListViewModel.h"
#import "WMStoreSearchResultTableViewCell+Skeleton.h"
#import "WMStoreSearchResultTableViewCell.h"


@interface WMStoreListView () <UITableViewDelegate, UITableViewDataSource, WMStoreListMenuViewDelegate>
/// 导航部分
@property (nonatomic, strong) WMStoreListNavView *navView;
/// 新分类
@property (nonatomic, strong) WMStoreListMenuView *menuView;
/// VM
@property (nonatomic, strong) WMStoreListViewModel *viewModel;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 搜索结果数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 提示
@property (nonatomic, strong) WMHomeTipView *tipView;
/// menu高度
@property (nonatomic, assign) CGFloat menuHeight;
/// menu改变最大高度
@property (nonatomic, assign) CGFloat maxMenuChangeHead;
/// scrollToTop
@property (nonatomic, assign) BOOL scrollToTop;
///隐藏骨架
@property (nonatomic, assign) BOOL hideProder;
/// 购物车 DTO
@property (nonatomic, strong) WMShoppingCartDTO *shoppingCartDTO;

@end


@implementation WMStoreListView

- (void)hd_setupViews {
    [self addSubview:self.navView];
    [self addSubview:self.tableView];
    [self addSubview:self.tipView];
    @HDWeakify(self);
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };
    self.maxMenuChangeHead = kRealWidth(44);
    self.menuHeight = kRealWidth(84) + kRealWidth(36);
    [WMShoppingCartEntryWindow.sharedInstance shrink];
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        [self.shoppingCartDTO getUserShoppingCartInfoWithClientType:SABusinessTypeYumNow success:^(WMGetUserShoppingCartRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            if ([self.navView isKindOfClass:WMCNStoreListNavView.class]) {
                WMCNStoreListNavView *navi = (WMCNStoreListNavView *)self.navView;
                [navi updateMessageCount:rspModel.list.count];
            }
        } failure:nil];
    }
}

- (void)hd_getNewData {
    [self.tableView getNewData];
}

- (void)updateConstraints {
    [self.navView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kNavigationBarH);
        make.left.right.top.equalTo(self);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.left.right.equalTo(self);
    }];
    [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self);
        make.top.equalTo(self.navView.mas_bottom);
    }];
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    if (!self.viewModel.filterModel.businessScope) {
        self.viewModel.filterModel.businessScope = @"";
    }
    self.tableView.dataSource = self.provider;
    self.tableView.delegate = self.provider;

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"isRequestFailed" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL isRequestFailed = [change[NSKeyValueChangeNewKey] boolValue];
        if (isRequestFailed) {
            [self.tableView reloadFail];
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"shouldShowShoppingCartBTN" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        BOOL shouldShowShoppingCartBTN = [change[NSKeyValueChangeNewKey] boolValue];
        WMShoppingCartEntryWindow.sharedInstance.hidden = !shouldShowShoppingCartBTN;
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"tipViewStyle" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMHomeTipViewStyle tipViewStyle = [change[NSKeyValueChangeNewKey] integerValue];
        self.tipView.hidden = tipViewStyle == WMHomeTipViewStyleDisapper;
        if (!self.tipView.isHidden) {
            [self.tipView updateUIForStyle:tipViewStyle];
        }
        [self.navView updateNavUIWithTipViewHidden:self.tipView.hidden];
    }];
    [self.viewModel getMerchantCategorySuccess:^(NSArray<WMCategoryItem *> *_Nonnull list) {
        @HDStrongify(self);
        [self getCurrentCateory:list];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self getCurrentCateory:nil];
    }];
}

#pragma mark -  找寻分类
- (void)getCurrentCateory:(nullable NSArray<WMCategoryItem *> *)list {
    /// 缓存
    if (!list || !list.count) {
        SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyMerchantKind];
        NSArray<WMCategoryItem *> *cachedList = [NSArray yy_modelArrayWithClass:WMCategoryItem.class json:cacheModel.storeObj];
        list = [NSArray arrayWithArray:cachedList];
    }
    /// 找寻对应分类
    WMCategoryItem *firstItem = nil;
    /// 是否有二级分类
    BOOL inSecondScope = NO;
    NSMutableArray *stack = NSMutableArray.new;
    [stack addObjectsFromArray:list];
    @autoreleasepool {
        while (stack.count) {
            WMCategoryItem *item = stack.lastObject;
            if ([item isKindOfClass:WMCategoryItem.class]) {
                if ([item.scopeCode isEqualToString:self.viewModel.businessScope] && !firstItem) {
                    firstItem = item;
                    firstItem.selected = YES;
                }
            }
            [stack removeLastObject];
            for (NSInteger i = item.subClassifications.count - 1; i >= 0; i--) {
                item.subClassifications[i].parentScopeCode = item.scopeCode;
                item.subClassifications[i].level++;
                [stack addObject:item.subClassifications[i]];
            }
        }
    }
    self.viewModel.filterModel.businessScope = firstItem ? firstItem.scopeCode : self.viewModel.businessScope;
    /// 判断传进来的分类所在level 是否是二级 如果是就找寻一级
    if (firstItem.parentScopeCode) {
        inSecondScope = YES;
        for (WMCategoryItem *item in list) {
            if ([item.scopeCode isEqualToString:firstItem.parentScopeCode]) {
                firstItem = item;
                break;
            }
        }
    }
    if (!firstItem) {
        firstItem = WMCategoryItem.new;
        firstItem.subClassifications = @[];
    }
    NSMutableArray *marr = [NSMutableArray arrayWithArray:firstItem.subClassifications];
    SAInternationalizationModel *allModel = [SAInternationalizationModel modelWithWMInternationalKey:@"title_all" value:@"全部" table:nil];
    WMCategoryItem *itemAll = WMCategoryItem.new;
    itemAll.imagesUrl = @"yn_zh_cate_all";
    itemAll.scopeCode = firstItem.scopeCode ?: self.viewModel.businessScope;
    itemAll.selected = inSecondScope ? NO : YES;
    itemAll.message = allModel;
    itemAll.localImage = YES;
    itemAll.all = YES;
    firstItem.subClassifications = [NSArray arrayWithArray:marr];
    self.menuView.allModel = itemAll;
    self.menuView.model = firstItem;
    self.navView.cateName = firstItem.message ? firstItem.message.desc : allModel.desc;
    [self getNewData];
}

#pragma mark - Data
- (void)getNewData {
    if (!self.tableView.hd_hasData && !self.hideProder) {
        self.tableView.dataSource = self.provider;
        self.tableView.delegate = self.provider;
        [self.tableView reloadData];
    } else {
        [self showloading];
    }
    self.currentPageNo = 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)getDataForPageNo:(NSInteger)pageNo {
    @HDWeakify(self);
    self.viewModel.filterModel.type = WMSearchTypeStore;
    [self.viewModel getNewStoreListWithPageSize:20 pageNum:pageNo success:^(WMSearchStoreNewRspModel * _Nonnull rspModel) {

        @HDStrongify(self);
        [self dismissLoading];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.currentPageNo = rspModel.hasNextPage;
        NSArray<WMStoreListNewItemModel *> *list = rspModel.list;
        if (pageNo == 1) {
            [self.dataSource removeAllObjects];
            if (self.scrollToTop) {
                [self.tableView setContentOffset:CGPointMake(0, self.maxMenuChangeHead) animated:NO];
            } else {
                [self.tableView setContentOffset:CGPointZero animated:NO];
            }
        }
        if (list.count) {
            [self.dataSource addObjectsFromArray:list];
        }
        [self.tableView reloadData:!rspModel.hasNextPage];
        self.hideProder = NO;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView reloadFail];
        self.tableView.mj_footer.hidden = YES;
        self.hideProder = NO;
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0)
        scrollView.contentOffset = CGPointZero;
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (point.y >= 0) {
        [WMShoppingCartEntryWindow.sharedInstance expand];
    } else {
        [WMShoppingCartEntryWindow.sharedInstance shrink];
    }
    if (scrollView.contentOffset.y <= self.maxMenuChangeHead && scrollView.contentOffset.y >= 0)
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    else if (scrollView.contentOffset.y > self.maxMenuChangeHead)
        scrollView.contentInset = UIEdgeInsetsMake(-self.maxMenuChangeHead, 0, 0, 0);
    self.scrollToTop = scrollView.contentOffset.y >= self.maxMenuChangeHead;
    CGFloat num = MIN(1, MAX(0, (scrollView.contentOffset.y / self.maxMenuChangeHead * 1.0)));
    [self.menuView updateAlpah:num];
    [self.menuView setNeedsUpdateConstraints];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.menuHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.menuView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreListNewItemModel.class]) {
        WMStoreListNewItemModel *trueModel = (WMStoreListNewItemModel *)model;
        trueModel.isShowSaleCount = true;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            WMCNStoreTableViewCell *cell = [WMCNStoreTableViewCell cellWithTableView:tableView];
            cell.model = trueModel;
            return cell;
        } else {
            WMStoreSearchResultTableViewCell *cell = [WMStoreSearchResultTableViewCell cellWithTableView:tableView];
//            cell.model = trueModel;
            cell.nModel = trueModel;
            return cell;
        }
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= self.dataSource.count)
        return;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreListNewItemModel.class]) {
        WMStoreListNewItemModel *trueModel = (WMStoreListNewItemModel *)model;
        NSMutableDictionary *params = NSMutableDictionary.dictionary;
        params[@"storeNo"] = trueModel.storeNo;
        params[@"storeName"] = trueModel.storeName.desc;
        params[@"storeNo"] = trueModel.storeNo;
        params[@"funnel"] = @"分类页";
        params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖门店列表.分类%@", self.viewModel.filterModel.businessScope] : [NSString stringWithFormat:@"外卖门店列表.分类%@", self.viewModel.filterModel.businessScope];
        params[@"associatedId"] = self.viewModel.associatedId;

        ///点击
        if (trueModel.payFlag) {
            [LKDataRecord.shared traceEvent:@"sortClickStore" name:@"sortClickStore" parameters:@{@"plateId": trueModel.uuid, @"storeNo": trueModel.storeNo} SPM:nil];
            params[@"payFlag"] = trueModel.uuid;
        }

        /// 3.0.19.0 点击
        NSDictionary *param = @{
            @"storeNo": trueModel.storeNo,
            @"type": @"classificationStore",
            @"classificationName": self.viewModel.filterModel.businessScope,
            @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
            @"plateId": WMManage.shareInstance.plateId
        };
        [LKDataRecord.shared traceEvent:@"takeawayStoreClick" name:@"takeawayStoreClick" parameters:param SPM:nil];
        
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    if (indexPath.row >= self.dataSource.count)
        return;
    id model = self.dataSource[indexPath.row];
    ///曝光
    if ([model isKindOfClass:WMStoreListNewItemModel.class]) {
        WMStoreListNewItemModel *itemModel = model;
        [tableView recordExposureCountWithModel:model indexPath:indexPath position:2];
        /// 3.0.19.0 曝光
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": itemModel.storeNo,
            @"type": @"classificationStore",
            @"classificationName": self.viewModel.filterModel.businessScope,
            @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
            @"plateId": WMManage.shareInstance.plateId
        };
        [tableView recordStoreExposureCountWithValue:itemModel.storeNo key:itemModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayStoreExposure"];
    }
}

#pragma mark menuDelegate
- (void)clickItem:(WMCategoryItem *)model {
    
    [self.menuView hideAllSlideDownView];
    
    self.viewModel.filterModel.businessScope = model.scopeCode;
    /// 如果还有在请求的 暂停请求
    if ([self.viewModel.getStoreListRequest isExecuting]) {
        [self.viewModel.getStoreListRequest cancel];
    }
    self.hideProder = YES;
    /// 请求数据
    [self getNewData];
}

- (void)clickSort:(WMNearbyFilterModel *)filterModel {
    HDLog(@"%s",__func__);
    self.viewModel.filterModel.sortType = filterModel.sortType;
    
    /// 如果还有在请求的 暂停请求
    if ([self.viewModel.getStoreListRequest isExecuting]) {
        [self.viewModel.getStoreListRequest cancel];
    }
    self.hideProder = YES;
    /// 请求数据
    [self getNewData];
    
}

- (void)clickFilter:(WMNearbyFilterModel *)filterModel {
    HDLog(@"%s",__func__);
    self.viewModel.filterModel.marketingTypes = filterModel.marketingTypes;
    self.viewModel.filterModel.storeFeature = filterModel.storeFeature;
    /// 如果还有在请求的 暂停请求
    if ([self.viewModel.getStoreListRequest isExecuting]) {
        [self.viewModel.getStoreListRequest cancel];
    }
    self.hideProder = YES;
    /// 请求数据
    [self getNewData];
}

- (void)setIsShowingInWindow:(BOOL)isShowingInWindow {
    _isShowingInWindow = isShowingInWindow;
    if(!isShowingInWindow) {
        [self.menuView hideAllSlideDownView];
    }
}

#pragma mark - lazy load
- (WMStoreListNavView *)navView {
    if (!_navView) {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            _navView = [[WMCNStoreListNavView alloc] initWithViewModel:self.viewModel];
        } else {
            _navView = [[WMStoreListNavView alloc] initWithViewModel:self.viewModel];
        }
        @HDWeakify(self);
        _navView.clickBackOperatingBlock = ^{
            @HDStrongify(self);
            if (self.viewModel.isFromMasterHome) {
                //                [SAAddressCacheAdaptor removeWMOnceTimeAddress];
            }
        };
    }
    return _navView;
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = true;
        _tableView.needShowNoDataView = YES;
        _tableView.needShowErrorView = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
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

- (NSMutableArray *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.array; });
}

- (WMHomeTipView *)tipView {
    if (!_tipView) {
        _tipView = WMHomeTipView.new;
        _tipView.hidden = true;
    }
    return _tipView;
}

- (WMStoreListMenuView *)menuView {
    if (!_menuView) {
        _menuView = WMStoreListMenuView.new;
        _menuView.delegate = self;
        @HDWeakify(self);
        _menuView.viewWillAppear = ^(UIView * _Nonnull view) {
            @HDStrongify(self);
            [self.tableView setContentOffset:CGPointMake(0, kRealWidth(44)) animated:NO];
            [self.menuView updateAlpah:1];
            [self.menuView setNeedsUpdateConstraints];
            if(self.tableView.hd_hasData){
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        };
        
    }
    return _menuView;
}

- (WMShoppingCartDTO *)shoppingCartDTO {
    if (!_shoppingCartDTO) {
        _shoppingCartDTO = WMShoppingCartDTO.new;
    }
    return _shoppingCartDTO;
}

@end
