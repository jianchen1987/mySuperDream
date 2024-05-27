//
//  WMStoreSearchViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductSearchViewController.h"
#import "SACacheManager.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "SATagTableViewCell.h"
#import "UIView+FrameChangedHandler.h"
#import "WMChooseGoodsPropertyAndSkuView.h"
#import "WMCustomViewActionView.h"
#import "WMProductSearchDTO.h"
#import "WMPromotionLabel.h"
#import "WMShoppingCartPayFeeCalItem.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingGoodTableViewCell+Skeleton.h"
#import "WMShoppingGoodTableViewCell.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreDetailAdaptor.h"
#import "WMStoreDetailViewModel.h"
#import "WMStoreShoppingCartDTO.h"

static NSString *const kProductSearchHistoryKey = @"com.superapp.productSearch";


@interface WMProductSearchViewController () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource, HDStoreSearchTableViewCellDelegate>
@property (nonatomic, copy, readonly) NSString *storeNo;                   ///< 门店编号
@property (nonatomic, copy, readonly) NSString *storeName;                 ///< 门店名称
@property (nonatomic, strong, readonly) WMStoreStatusModel *storeStatus;   ///< 门店状态
@property (nonatomic, assign, readonly) NSUInteger availableBestSaleCount; /// 今日可购买特价商品数量

@property (nonatomic, strong) HDSearchBar *searchBar;                                       ///< 搜索框
@property (nonatomic, copy) NSString *keyWord;                                              ///< 搜索关键词
@property (nonatomic, strong) SATableView *tableView;                                       ///< tableView
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *defaultDataSource; ///< 默认数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *resultDataSource;  ///< 搜索结果数据源
@property (nonatomic, strong) HDTableViewSectionModel *historySectionModel;                 ///< 历史
@property (nonatomic, strong) HDTableViewSectionModel *searchResultSectionModel;            ///< 搜索结果
@property (nonatomic, strong) dispatch_group_t taskGroup;                                   ///< 队列组
@property (nonatomic, assign) BOOL shouldShowSearchResult;                                  ///< 显示搜索结果
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;                  ///< 骨架 loading 生成器
@property (nonatomic, assign) NSUInteger currentPageNo;                                     /// 当前页码
@property (nonatomic, strong) NSMutableArray *searchResultDataSource;                       /// 搜索结果数据源
/// 门店搜索 DTO
@property (nonatomic, strong) WMProductSearchDTO *productSearchDTO;
/// 购物车 DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 当前正在搜索的关键词
@property (nonatomic, copy) NSString *searchingKeyword;
/// 门店详情ViewModel
@property (nonatomic, strong) WMStoreDetailViewModel *storeDetailViewModel;
@end


@implementation WMProductSearchViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.storeDetailViewModel = parameters[@"storeDetailViewModel"];
    }
    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.searchBar];
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
}

- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)hd_languageDidChanged {
    self.searchBar.placeHolder = [NSString stringWithFormat:WMLocalizedString(@"wm_search_in_store", @"Search in %@'s"), self.storeName];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)updateViewConstraints {
    // 这里可以根据是否正在搜索对搜索栏做位置变化
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HDAppTheme.value.statusBarHeight);
        make.width.centerX.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(55));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.left.width.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark - Data
- (void)prepareDefaultData {
    // 加载历史搜索
    NSArray<NSString *> *historyArray = [SACacheManager.shared objectForKey:kProductSearchHistoryKey];
    self.historySectionModel = HDTableViewSectionModel.new;
    HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
    headerModel.title = WMLocalizedString(@"history_search", @"最近");
    headerModel.rightButtonImage = [UIImage imageNamed:@"icon_clear"];
    headerModel.rightButtonTitle = WMLocalizedStringFromTable(@"button_title_clear", @"清除", @"Buttons");
    headerModel.rightTitleToImageMarin = kRealWidth(3);
    self.historySectionModel.headerModel = headerModel;
    if (historyArray) {
        NSMutableArray<SAImageLabelCollectionViewCellModel *> *array = [NSMutableArray arrayWithCapacity:historyArray.count];
        for (NSString *str in historyArray) {
            SAImageLabelCollectionViewCellModel *model = SAImageLabelCollectionViewCellModel.new;
            model.title = str;
            [array addObject:model];
        }
        self.historySectionModel.list = @[array];

        // 有历史数据先显示
        [self showDefaultData];
    }
}

/// 展示未搜索时的列表
- (void)showDefaultData {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.defaultDataSource removeAllObjects];
    // 暂不显示历史搜索
    //    if (self.historySectionModel) {
    //        [self.defaultDataSource addObject:self.historySectionModel];
    //    }

    self.shouldShowSearchResult = false;
    [self.tableView successGetNewDataWithNoMoreData:true];
}

- (void)searchListForKeyWord:(NSString *)keyword {
    if (HDIsStringEmpty(keyword))
        return;

    self.searchingKeyword = keyword;

    self.currentPageNo = 1;

    // 保存搜索关键词到本地
    [self saveMerchantHistorySearchWithKeyWord:keyword];

    HDLog(@"发出根据关键词 %@ 查找商家请求", keyword);

    self.tableView.dataSource = self.provider;
    self.tableView.delegate = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:true];
    [self searchProductWithKeyword:keyword pageNum:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self searchProductWithKeyword:self.keyWord pageNum:self.currentPageNo];
}

- (void)searchProductWithKeyword:(NSString *)keyword pageNum:(NSInteger)pageNum {
    __block BOOL isNoData = false;    // 是否显示Nodata页面
    __block BOOL hasNextPage = false; // 是否还有下一页
    __block BOOL searchFail = false;  // 搜索失败
    __block BOOL needLoadData = true; // 是否需要刷新数据（当前界面搜索框是否还有关键词，如果在数据返回之前用户已经清空输入框，则不用刷新）

    @HDWeakify(self);
    dispatch_group_enter(self.taskGroup);
    [self.productSearchDTO searchProductInStore:self.storeNo keyword:keyword pageNum:self.currentPageNo success:^(WMProductSearchRspModel *_Nonnull rspModel) {
        NSArray<WMStoreGoodsItem *> *list = rspModel.list;
        @HDStrongify(self);

        // 先判断当前界面搜索框是否还有关键词，如果在数据返回之前用户已经清空输入框，则不用刷新
        if (HDIsStringNotEmpty(self.searchingKeyword) && [self.searchingKeyword isEqualToString:keyword]) {
            if (pageNum == 1) {
                [self.searchResultDataSource removeAllObjects];
                if (list.count) {
                    [self.searchResultDataSource addObjectsFromArray:list];
                } else {
                    isNoData = true;
                    SANoDataCellModel *cellModel = SANoDataCellModel.new;
                    UIImage *placeholderImage = [UIImage imageNamed:@"wm_home_placeholder"];
                    cellModel.image = placeholderImage;
                    cellModel.descText = [NSString stringWithFormat:WMLocalizedString(@"not_found_results", @"暂时没有找到'%@'的相关信息"), keyword];
                    cellModel.marginImageToTop = kScreenHeight * 0.5 - kNavigationBarH - placeholderImage.size.height * 0.5 - 20;
                    [self.searchResultDataSource addObject:cellModel];
                }
            } else {
                if (list.count) {
                    [self.searchResultDataSource addObjectsFromArray:list];
                }
            }
            hasNextPage = rspModel.hasNextPage;
        } else {
            needLoadData = false;
            HDLog(@"搜索结果返回，但当前关键词已经清空或者关键词不匹配，不刷新界面");
        }
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        searchFail = true;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        // 搜索结果失败
        if (searchFail) {
            pageNum == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
            self.tableView.mj_footer.hidden = true;
            return;
        }
        // 当前界面搜索框关键词已改变，不需要刷新
        if (!needLoadData) {
            return;
        }

        // 刷新tableView
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        self.shouldShowSearchResult = true;
        [self.resultDataSource removeAllObjects];
        self.searchResultSectionModel.list = self.searchResultDataSource;
        [self.resultDataSource addObject:self.searchResultSectionModel];
        // 处理数据
        [self dealSearchResultData];
        [self.tableView successGetNewDataWithNoMoreData:!hasNextPage];
        self.tableView.mj_footer.hidden = isNoData;
    });
}

- (void)getStoreShoppingCartNeedRefreshData:(BOOL)needRefreshData success:(void (^)(void))success failure:(void (^)(void))failure {
    @HDWeakify(self);
    [self.storeDetailViewModel reGetShoppingCartItemsSuccess:^(WMShoppingCartStoreItem *_Nonnull storeItem) {
        HDLog(@"重拿购物车数据成功");
        @HDStrongify(self);
        if (needRefreshData) {
            [self refreshData];
        }
        !success ?: success();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"重拿购物车数据失败");
        !failure ?: failure();
    }];
}

- (void)refreshData {
    [self dealSearchResultData];
    BOOL noMoreData = self.tableView.mj_footer.state == MJRefreshStateNoMoreData;
    BOOL tableViewFooterHidden = self.tableView.mj_footer.hidden;
    [self.tableView successGetNewDataWithNoMoreData:noMoreData];
    self.tableView.mj_footer.hidden = tableViewFooterHidden;
}

// 处理数据
- (void)dealSearchResultData {
    for (id model in self.searchResultSectionModel.list) {
        if (![model isKindOfClass:WMStoreGoodsItem.class]) {
            break;
        }
        WMStoreGoodsItem *goodsItem = (WMStoreGoodsItem *)model;
        goodsItem.storeStatus = self.storeStatus;
        WMShoppingCartStoreItem *storeItem = self.storeDetailViewModel.shopppingCartStoreItem;

        NSArray<WMShoppingCartStoreProduct *> *productList = [WMStoreDetailAdaptor shoppingCardStoreProductListInStoreItem:storeItem goodsId:goodsItem.goodId];
        if (HDIsArrayEmpty(productList)) {
            goodsItem.skuCountModelList = nil;
            continue;
        }
        goodsItem.skuCountModelList = [productList mapObjectsUsingBlock:^WMStoreGoodsSkuCountModel *_Nonnull(WMShoppingCartStoreProduct *_Nonnull productModel, NSUInteger idx) {
            WMStoreGoodsSkuCountModel *skuCountModel = WMStoreGoodsSkuCountModel.new;
            skuCountModel.skuId = productModel.goodsSkuId;
            skuCountModel.countInCart = productModel.purchaseQuantity;
            return skuCountModel;
        }];
    }
}

#pragma mark - getters and setters
- (void)setKeyWord:(NSString *)keyWord {
    // 去首尾空格
    keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _keyWord = keyWord;
    HDLog(@"关键词变化：%@", keyWord);
    if (!HDIsStringEmpty(keyWord)) {
        [HDFunctionThrottle throttleWithInterval:0.5 key:NSStringFromSelector(@selector(searchListForKeyWord:)) handler:^{
            [self searchListForKeyWord:keyWord];
        }];
    } else {
        [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(searchListForKeyWord:))];
        [self showDefaultData];
    }
}

#pragma mark - private methods
- (NSMutableArray<HDTableViewSectionModel *> *)currentDataSource {
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
        [SACacheManager.shared setObject:keywordStrArray forKey:kProductSearchHistoryKey];
    }
}

/// 清除商户搜索历史纪录
- (void)clearMerchantSearchHistoryRecord {
    // 删除内存中历史搜索纪录
    self.historySectionModel.list = @[];
    // 删除缓存的搜索纪录
    [SACacheManager.shared removeObjectForKey:kProductSearchHistoryKey];
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
        SATagTableViewCell *cell = [SATagTableViewCell cellWithTableView:tableView];
        cell.dataSource = (NSArray<SAImageLabelCollectionViewCellModel *> *)model;
        cell.delegate = self;
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = (SANoDataCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:WMStoreGoodsItem.class]) {
        WMShoppingGoodTableViewCell *cell = [WMShoppingGoodTableViewCell cellWithTableView:tableView];
        WMStoreGoodsItem *trueModel = (WMStoreGoodsItem *)model;
        trueModel.needHideBottomLine = true;
        trueModel.keyWord = self.keyWord;
        cell.model = trueModel;
        @HDWeakify(self);
        cell.goodsFromShoppingCartShouldChangeBlock = ^BOOL(WMStoreGoodsItem *_Nonnull model, BOOL isIncreate, NSUInteger count) {
            @HDStrongify(self);
            if (isIncreate && self.storeDetailViewModel.storeProductTotalCount >= 150) {
                [NAT showAlertWithTitle:nil message:WMLocalizedString(@"cart_is_full", @"Shopping cart is full, please clean up.") confirmButtonTitle:WMLocalizedString(@"view_cart", @"View Cart")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [HDMediator.sharedInstance navigaveToShoppingCartViewController:nil];
                        [alertView dismiss];
                    }
                    cancelButtonTitle:WMLocalizedString(@"cart_not_now", @"Not now") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];
                return NO;
            }
            return YES;
        };
        cell.goodsFromShoppingCartChangedBlock = ^(WMStoreGoodsItem *_Nonnull model, BOOL isIncreate, NSUInteger count) {
            @HDStrongify(self);
            if (isIncreate) {
                WMManage.shareInstance.selectGoodId = model.goodId;
                [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:model.productPromotion currentCount:count otherSkuCount:0];
                if (model.bestSale) {
                    [WMPromotionLabel showToastWithMaxCount:self.availableBestSaleCount currentCount:count otherSkuCount:[self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:model]
                                                 promotions:self.storeDetailViewModel.payFeeTrialCalRspModel.promotions];
                }
            }
            NSMutableArray<NSString *> *propertyIds = [NSMutableArray arrayWithCapacity:model.propertyList.count];
            for (WMStoreGoodsProductProperty *propertyModel in model.propertyList) {
                if (propertyModel.optionList.firstObject.optionId) {
                    [propertyIds addObject:propertyModel.optionList.firstObject.optionId];
                }
            }
            [self updateShoppingGoodsWithCount:count goodsId:model.goodId goodsSkuId:model.specificationList.firstObject.specificationId propertyIds:propertyIds
                             inEffectVersionId:model.inEffectVersionId];
        };
        cell.plusGoodsToShoppingCartBlock = ^(WMStoreGoodsItem *model, NSUInteger forwardCount) {
            @HDStrongify(self);
            WMManage.shareInstance.selectGoodId = model.goodId;
            [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:model.productPromotion currentCount:forwardCount otherSkuCount:0];
            if (model.bestSale) {
                [WMPromotionLabel showToastWithMaxCount:self.availableBestSaleCount currentCount:forwardCount otherSkuCount:[self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:model]
                                             promotions:self.storeDetailViewModel.payFeeTrialCalRspModel.promotions];
            }
            NSMutableArray<NSString *> *propertyIds = [NSMutableArray arrayWithCapacity:model.propertyList.count];
            for (WMStoreGoodsProductProperty *propertyModel in model.propertyList) {
                if (propertyModel.optionList.firstObject.optionId) {
                    [propertyIds addObject:propertyModel.optionList.firstObject.optionId];
                }
            }
            if (self.storeDetailViewModel.storeProductTotalCount >= 150) {
                [NAT showAlertWithTitle:nil message:WMLocalizedString(@"cart_is_full", @"Shopping cart is full, please clean up.") confirmButtonTitle:WMLocalizedString(@"view_cart", @"View Cart")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [HDMediator.sharedInstance navigaveToShoppingCartViewController:nil];
                        [alertView dismiss];
                    }
                    cancelButtonTitle:WMLocalizedString(@"cart_not_now", @"Not now") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];
            } else {
                [self addShoppingGoodsWithAddDelta:forwardCount goodsId:model.goodId goodsSkuId:model.specificationList.firstObject.specificationId propertyIds:propertyIds
                                 inEffectVersionId:model.inEffectVersionId];
            }
        };
        cell.showChooseGoodsPropertyAndSkuViewBlock = ^(WMStoreGoodsItem *_Nonnull model) {
            @HDStrongify(self);
            [self showChooseGoodsSkuAndPropertyViewWithModel:model];
        };
        @HDWeakify(tableView);
        cell.cellClickedEventBlock = ^(WMStoreGoodsItem *_Nonnull model) {
            @HDStrongify(self);
            @HDStrongify(tableView);
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        };
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.currentDataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard2Bold;
    model.marginToBottom = kRealWidth(1);
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

    return kRealWidth(30);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= self.currentDataSource.count)
        return;
    HDTableViewSectionModel *sectionModel = self.currentDataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return;

    id model = self.currentDataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:WMStoreGoodsItem.class]) {
        WMStoreGoodsItem *trueModel = (WMStoreGoodsItem *)model;
        [HDMediator.sharedInstance
            navigaveToStoreProductDetailController:@{@"storeNo": self.storeNo, @"goodsId": trueModel.goodId, @"isPresent": @(false), @"availableBestSaleCount": @(self.availableBestSaleCount)}];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

#pragma mark - HDStoreSearchTableViewCellDelegate
- (void)storeSearchCollectionViewTableViewCell:(SATagTableViewCell *)tableViewCell didSelectedTag:(SAImageLabelCollectionViewCellModel *)tagModel {
    HDLog(@"点击了关键词:%@", tagModel.title);
    [self.view endEditing:true];

    self.searchBar.text = tagModel.title;

    // 触发搜索
    [self searchBarRightButtonClicked:self.searchBar];
}

#pragma mark - private methods
- (void)showChooseGoodsSkuAndPropertyViewWithModel:(WMStoreGoodsItem *)goodsModel {
    WMChooseGoodsPropertyAndSkuView *chooseView = [[WMChooseGoodsPropertyAndSkuView alloc] initWithStoreGoodsItem:goodsModel availableBestSaleCount:self.availableBestSaleCount];
    [chooseView show];
    chooseView.addToCartBlock = ^(NSUInteger count, WMStoreGoodsProductSpecification *specificationModel, NSArray<WMStoreGoodsProductPropertyOption *> *_Nonnull propertyOptionList) {
        [self addShoppingGoodsWithAddDelta:count goodsId:goodsModel.goodId goodsSkuId:specificationModel.specificationId
                               propertyIds:[propertyOptionList mapObjectsUsingBlock:^id _Nonnull(WMStoreGoodsProductPropertyOption *_Nonnull obj, NSUInteger idx) {
                                   return obj.optionId;
                               }]
                         inEffectVersionId:goodsModel.inEffectVersionId];
    };
    chooseView.otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart = ^NSUInteger(WMStoreGoodsItem *_Nonnull model) {
        return [self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:model];
    };
    chooseView.storeShoppingCartPromotions = ^NSArray<WMStoreDetailPromotionModel *> *_Nonnull {
        return self.storeDetailViewModel.payFeeTrialCalRspModel.promotions;
    };
}
// 门店购物车中其他爆款商品数量
- (NSUInteger)otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:(WMStoreGoodsItem *)currentGoods {
    NSUInteger otherCount = 0;
    for (WMShoppingCartStoreProduct *goods in self.storeDetailViewModel.shopppingCartStoreItem.goodsList) {
        if (goods.bestSale && ![goods.identifyObj.goodsId isEqualToString:currentGoods.goodId]) {
            otherCount += goods.purchaseQuantity;
        }
    }
    return otherCount;
}

#pragma mark - Data
- (void)updateShoppingGoodsWithCount:(NSUInteger)count
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId {
    @HDWeakify(self);
    [self.storeShoppingCartDTO updateGoodsCountInShoppingCartWithClientType:SABusinessTypeYumNow count:count goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:self.storeNo
        inEffectVersionId:inEffectVersionId success:^(WMShoppingCartUpdateGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"更新商品数量成功");
            @HDStrongify(self);
            [self.storeDetailViewModel updateLocalShoppingCartItemCountWithUpdateGoodsRspMode:rspModel];
            [self refreshData];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"更新商品数量失败");
            @HDStrongify(self);
            [self addToCartFailureWithRspModel:rspModel];
        }];
}

- (void)addShoppingGoodsWithAddDelta:(NSUInteger)addDelta
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId {
    @HDWeakify(self);
    [self.storeShoppingCartDTO addGoodsToShoppingCartWithClientType:SABusinessTypeYumNow addDelta:addDelta goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:self.storeNo
        inEffectVersionId:inEffectVersionId success:^(WMShoppingCartAddGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"添加商品数量成功");
            @HDStrongify(self);
            [self getStoreShoppingCartNeedRefreshData:true success:nil failure:nil];
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            HDLog(@"添加商品数量失败");
            @HDStrongify(self);
            [self addToCartFailureWithRspModel:rspModel];
        }];
}

// 加购物车异常处理
- (void)addToCartFailureWithRspModel:(SARspModel *)rspModel {
    void (^showAlert)(NSString *, NSString *, NSString *, void (^)(void)) = ^void(NSString *msg, NSString *confirm, NSString *cancel, void (^afterBlock)(void)) {
        WMNormalAlertConfig *config = WMNormalAlertConfig.new;
        config.confirmHandle = ^(WMNormalAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
            [alertView dismiss];
            !afterBlock ?: afterBlock();
        };
        config.contentAligment = NSTextAlignmentCenter;
        config.content = msg;
        config.confirm = confirm ?: WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons");
        config.cancel = cancel;
        [WMCustomViewActionView WMAlertWithConfig:config];
    };

    SAResponseType code = rspModel.code;
    if ([code isEqualToString:@"ME1007"]) {
        [self getStoreShoppingCartNeedRefreshData:true success:nil failure:nil];
        showAlert(rspModel.msg, nil, nil, nil);
    } else if ([rspModel.code isEqualToString:@"ME1003"] || // 查询购物项详细信息出现异常
               [rspModel.code isEqualToString:@"ME1005"] || // 商品状态为空异常
               [rspModel.code isEqualToString:@"ME3005"]) { // 订单中的商品都卖光啦，再看看其他商品吧.
        showAlert(rspModel.msg, nil, nil, ^{
            [self searchListForKeyWord:self.keyWord];
        });
    } else if ([rspModel.code isEqualToString:@"ME3008"]) { // 购物车已满
        showAlert(WMLocalizedString(@"wm_shopcar_full_clear_title", @"购物车已满，请及时清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_confirm_clear", @"去清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_cancel_see", @"再想想"),
                  ^{
                      [HDMediator.sharedInstance navigaveToShoppingCartViewController:@{@"willDelete": @(YES)}];
                  });
    } else {
        [self getStoreShoppingCartNeedRefreshData:true success:nil failure:nil];
        showAlert(rspModel.msg, nil, nil, nil);
    }
}

#pragma mark - getter
- (NSString *)storeNo {
    return self.storeDetailViewModel.storeNo;
}

- (NSString *)storeName {
    return self.storeDetailViewModel.storeName;
}

- (WMStoreStatusModel *)storeStatus {
    return self.storeDetailViewModel.detailInfoModel.storeStatus;
}

- (NSUInteger)availableBestSaleCount {
    return self.storeDetailViewModel.availableBestSaleCount;
}

#pragma mark - lazy load
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.showBottomShadow = true;
        [_searchBar setShowLeftButton:true animated:true];
        _searchBar.textFieldHeight = 35;
        _searchBar.placeholderColor = HDAppTheme.color.G3;
        _searchBar.borderColor = HDAppTheme.color.G4;
        _searchBar.buttonTitleColor = HDAppTheme.color.G1;
        _searchBar.tintColor = HexColor(0x4A9FFF);
        [_searchBar setLeftButtonImage:[UIImage imageNamed:@"back_icon_black"]];
        [_searchBar setRightButtonTitle:WMLocalizedString(@"search", @"搜索")];
        [_searchBar setShowRightButton:false animated:false];
    }
    return _searchBar;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.mj_footer.hidden = true;
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

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMShoppingGoodTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [WMShoppingGoodTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}

- (NSMutableArray *)searchResultDataSource {
    return _searchResultDataSource ?: ({ _searchResultDataSource = NSMutableArray.array; });
}

- (HDTableViewSectionModel *)searchResultSectionModel {
    if (!_searchResultSectionModel) {
        _searchResultSectionModel = HDTableViewSectionModel.new;
    }
    return _searchResultSectionModel;
}

- (WMProductSearchDTO *)productSearchDTO {
    if (!_productSearchDTO) {
        _productSearchDTO = WMProductSearchDTO.new;
    }
    return _productSearchDTO;
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

@end
