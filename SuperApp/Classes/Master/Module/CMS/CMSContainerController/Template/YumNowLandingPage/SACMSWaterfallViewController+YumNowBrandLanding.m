//
//  SACMSWaterfallViewController+YumNowBrandLanding.m
//  SuperApp
//
//  Created by seeu on 2023/11/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallViewController+YumNowBrandLanding.h"
#import <HDKitCore/HDAssociatedObjectHelper.h>
#import "SACMSPageViewConfig.h"
#import "SACMSWaterfallPageViewConfig.h"
#import "SAAddressModel.h"
#import "SAYumNowLandingPageCategoryModel.h"
#import "SAUser.h"
#import "WMQueryNearbyStoreRspModel.h"
#import "SACMSUserGeneratedContentCollectionViewCell.h"
#import "SANoDataCollectionViewCell.h"
#import "SACMSCollectionViewCell.h"
#import "SANoDataCellModel.h"
#import "SACMSCollectionViewCell.h"
#import "YumNowLandingPageStoreListCollectionViewCell.h"
#import "WMCMSStoreCollectionViewCell.h"
#import "YumNowLandingPageStoreListCollectionReusableView.h"
#import "WMNearbyFilterModel.h"
#import "SAAddressCacheAdaptor.h"


@implementation SACMSWaterfallViewController (YumNowBrandLanding)

HDSynthesizeIdStrongProperty(categoryTitleConfig, setCategoryTitleConfig);
HDSynthesizeIdStrongProperty(landingPageWaterFallConfig, setLandingPageWaterFallConfig);
HDSynthesizeNSIntegerProperty(currentPage, setCurrentPage);
HDSynthesizeIdStrongProperty(currentCategoryModel, setCurrentCategoryModel);
HDSynthesizeIdStrongProperty(filterModel, setFilterModel);
HDSynthesizeIdWeakProperty(reusableView, setReusableView);
HDSynthesizeNSIntegerProperty(currentReusableViewIndex, setCurrentReusableViewIndex);

- (void)generateYumNowBrandLandingTemplateWithPageConfig:(SACMSPageViewConfig *)pageConfig {

    UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
    placeHolderModel.image = @"wm_home_placeholder";
    placeHolderModel.title = WMLocalizedString(@"wm_home_tip002", @"抱歉，当前定位地点附近无营业门店，请重新选择地址");
    placeHolderModel.needRefreshBtn = YES;
    placeHolderModel.refreshBtnTitle = WMLocalizedString(@"", @"选择地址");
    placeHolderModel.refreshBtnBackgroundColor = UIColor.sa_C1;
    @HDWeakify(self);
    placeHolderModel.clickOnRefreshButtonHandler = ^{
        @HDStrongify(self);
        [self gotoChooseAddress];
    };
    self.collectionView.placeholderViewModel = placeHolderModel;

    //重设筛选逻辑
    self.filterModel = nil;
    self.currentCategoryModel = nil;
    self.currentReusableViewIndex = 0;
    if(self.reusableView) {
        [self.reusableView reset];
    }
    
    // 瀑布流
    SACMSWaterfallPageViewConfig *waterfallConfig = [SACMSWaterfallPageViewConfig yy_modelWithDictionary:pageConfig.getPageTemplateContent];
    
    if (waterfallConfig && HDIsStringNotEmpty(waterfallConfig.categoryDataSource) && HDIsStringNotEmpty(waterfallConfig.waterfallDataSource)) {
        // 配置标题栏
        @HDWeakify(self);
        [self generateLandingPageCategoryViewWithConfig:waterfallConfig success:^{
            @HDStrongify(self);
            @HDWeakify(self);
            [self generateLandingPageWaterfallSectionWithConfig:waterfallConfig finish:^(BOOL hasNextPage) {
                @HDStrongify(self);
                [self.collectionView successGetNewDataWithNoMoreData:!hasNextPage scrollToTop:NO];

            }];

        } failure:^{
            @HDStrongify(self);
            [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        }];
    } else {
        // 没有配置，移除瀑布流
        self.categoryTitleConfig = nil;
        self.currentCategoryModel = nil;
        self.filterModel = nil;
        self.waterfallSection.list = @[];
        self.noDataSection.list = @[];
        [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }
}

- (void)yumNowBrandLandingTemplateLoadMoreData {
    @HDWeakify(self);
    [self getLandingPageWaterfallDataWithPage:++self.currentPage finish:^(BOOL hasNextPage) {
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!hasNextPage];
    }];
}


#pragma mark - private methods
/// 配置瀑布流分类header
- (void)generateLandingPageCategoryViewWithConfig:(SACMSWaterfallPageViewConfig *)config success:(void (^)(void))successBlock failure:(void (^)(void))failureBlock  {
    
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = config.categoryDataSource;
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([SAUser hasSignedIn]) {
        params[@"loginName"] = SAUser.shared.loginName;
    }
    if (!HDIsObjectNil(self.currentAddress) && HDIsStringNotEmpty(self.currentAddress.districtCode)) {
        params[@"cityCode"] = self.currentAddress.districtCode;
    }
    
    if (!HDIsObjectNil(self.currentAddress)) {
        params[@"latitude"] = self.currentAddress.lat.stringValue;
        params[@"longitude"] = self.currentAddress.lon.stringValue;
    }
    
    params[@"no"] = self.pageConfig.pageNo;
    
    request.requestParameter = params;
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        NSArray<SAYumNowLandingPageCategoryModel *> *titleModels = [NSArray yy_modelArrayWithClass:SAYumNowLandingPageCategoryModel.class json:rspModel.data];

        if(!titleModels.count) {
            // 没数据，有可能已经移除配置，去掉原有配置,不需要往下走
            self.categoryTitleConfig = nil;
            self.currentCategoryModel = nil;
            self.filterModel = nil;
            self.waterfallSection.list = @[];
            self.noDataSection.list = @[];
            
            !failureBlock ?: failureBlock();
            
        } else {
            
            SAYumNowLandingPageCategoryModel *titleModel = titleModels.firstObject;
            
            self.categoryTitleConfig = SAYumNowLandingPageCategoryRspModel.new;
            ///< 展示样式
            self.categoryTitleConfig.showLabel = titleModel.showLabel;
            ///< 是否展示筛选
            self.categoryTitleConfig.sortFilter = titleModel.sortFilter;
            ///< 门店卡片展示样式
            self.categoryTitleConfig.storeLogoShowType = titleModel.storeLogoShowType;
            ///< titles
            self.categoryTitleConfig.titles = titleModels;
        
            // 初始值
            self.currentCategoryModel = titleModel;

            !successBlock ?: successBlock();
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        // 接口失败 直接用旧数据，没有必要清空
        !successBlock ?: successBlock();
    }];
}

- (void)generateLandingPageWaterfallSectionWithConfig:(SACMSWaterfallPageViewConfig *)config finish:(void (^)(BOOL hasNextPage))finish {
    self.landingPageWaterFallConfig = config;
    [self getLandingPageWaterfallDataWithPage:1 finish:finish];
}

- (void)getLandingPageWaterfallDataWithPage:(NSUInteger)page finish:(void (^)(BOOL hasNextPage))finish {
    if (HDIsObjectNil(self.landingPageWaterFallConfig)) {
        !finish ?: finish(NO);
        return;
    }
    
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = self.landingPageWaterFallConfig.waterfallDataSource;
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = @(page);
    params[@"pageSize"] = @(10);
    
    if (!HDIsObjectNil(self.currentAddress)) {
        params[@"location"] = @{
            @"lat" : self.currentAddress.lat.stringValue,
            @"lon" : self.currentAddress.lon.stringValue
        };
        
        params[@"areaCode"] = HDIsStringNotEmpty(self.currentAddress.districtCode) ? self.currentAddress.districtCode : @"855120000";
    }
    
    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    
    if(!HDIsObjectNil(self.filterModel)) {
        
        params[@"sortType"] = self.filterModel.sortType;
        params[@"marketingTypes"] = self.filterModel.marketingTypes;
        params[@"storeFeature"] = self.filterModel.storeFeature;
        params[@"businessCode"] = self.filterModel.category.scopeCode;
    }
    
    if(!HDIsObjectNil(self.currentCategoryModel)) {
        
        params[@"queryParam"] = self.currentCategoryModel.queryParam;
    }
    
    params[@"pageNo"] = self.pageConfig.pageNo;
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        WMQueryNearbyStoreNewRspModel *rsp = [WMQueryNearbyStoreNewRspModel yy_modelWithJSON:rspModel.data];
        self.currentPage = page;
        
        NSMutableArray<SAModel *> *tmp = [[NSMutableArray alloc] initWithCapacity:10];
        //        [rsp.list enumerateObjectsUsingBlock:^(SACMSWaterfallCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        //            obj.cellWidth = kWaterfallCellMaxWidth;
        //            obj.taskId = [self.taskId copy];
        //        }];
        if (1 == page) {
            if (rsp.list.count == 0) {
                self.collectionView.needRefreshFooter = NO;
                self.noDataSection.list = @[SANoDataCellModel.new];
            } else {
                self.collectionView.needRefreshFooter = YES;
                self.noDataSection.list = @[];
            }
        } else {
            [tmp addObjectsFromArray:[self.waterfallSection.list hd_filterWithBlock:^BOOL(id _Nonnull item) {
                     return ![item isKindOfClass:SACMSPlaceholderCollectionViewCellModel.class] && ![item isKindOfClass:SACMSWaterfallSkeletonCollectionViewCellModel.class];
                 }]];
        }
        [tmp addObjectsFromArray:rsp.list];
        
        if(tmp.count > 0 && tmp.count < 6) {
            // 为了标题置顶，动态添加占位cell
            __block CGFloat placeholderViewCellHeight = CGRectGetHeight(self.container.frame) - [self waterfallHeaderHeight];
            HDLog(@"当前容器高度:%f", placeholderViewCellHeight);
            [tmp enumerateObjectsUsingBlock:^(SAModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:WMNewStoreModel.class]) {
                    WMNewStoreModel *trueModel = (WMNewStoreModel *)obj;
                    placeholderViewCellHeight -= [trueModel storeCardHeightWith:self.categoryTitleConfig.storeLogoShowType];
                }
            }];
            HDLog(@"去掉后剩余高度:%f", placeholderViewCellHeight);
            if(placeholderViewCellHeight > 0) {
                HDLog(@"填充占位图");
                SACMSPlaceholderCollectionViewCellModel *cellModel = SACMSPlaceholderCollectionViewCellModel.new;
                cellModel.cellHeight = placeholderViewCellHeight;
                [tmp addObject:cellModel];
            }
        }
            
        self.waterfallSection.list = tmp;
        !finish ?: finish(rsp.hasNextPage);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !finish ?: finish(NO);
    }];
}

- (void)clickOnCategoryTitle:(SAYumNowLandingPageCategoryModel *)categoryModel filterOption:(WMNearbyFilterModel *)filterOption reusableView:(UICollectionReusableView *_Nullable)view scrollToTop:(BOOL)scrollToTop {
    
    self.currentCategoryModel = categoryModel;
    self.filterModel = filterOption;
    @HDWeakify(self);
//    [self showloading];
    [self getLandingPageWaterfallDataWithPage:1 finish:^(BOOL hasNextPage) {
        @HDStrongify(self);
//        [self dismissLoading];
        [self.collectionView successGetNewDataWithNoMoreData:!hasNextPage scrollToTop:NO];
        if(scrollToTop) {
            [self scrollToWaterfallHeader:view];
        }
    }];
                
}

- (void)scrollToWaterfallHeader:(UICollectionReusableView *_Nullable)view {
    UICollectionViewLayoutAttributes *layouts = nil;
    if (self.waterfallSection.list.count) {
        layouts = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.dataSource indexOfObject:self.waterfallSection]]];
    } else {
        layouts = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.dataSource indexOfObject:self.noDataSection]]];
    }
    if (!HDIsObjectNil(layouts)) {
        [self.collectionView setContentOffset:CGPointMake(0, layouts.frame.origin.y - [self waterfallHeaderHeight]) animated:NO];
    } else {
        [self.collectionView setContentOffset:CGPointMake(0, view.frame.origin.y) animated:NO];
    }
}

- (CGFloat)waterfallHeaderHeight {
    
    if(HDIsObjectNil(self.categoryTitleConfig)) {
        return 0;
    }
    
    // kRealWith(64)
    CGFloat height = 8;
    
    // icon 高度
    if(self.categoryTitleConfig.showLabel == YumNowLandingPageCategoryStyleIconOnly || self.categoryTitleConfig.showLabel == YumNowLandingPageCategoryStyleIconText) {
        height += 44;
    }
    
    //文字高度
    if(self.categoryTitleConfig.showLabel == YumNowLandingPageCategoryStyleTextOnly || self.categoryTitleConfig.showLabel == YumNowLandingPageCategoryStyleIconText) {
        __block CGFloat maxTitleHeight = 0;
        [self.categoryTitleConfig.titles enumerateObjectsUsingBlock:^(SAYumNowLandingPageCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj.name.desc;
            CGSize fitSize = [title boundingAllRectWithSize:CGSizeMake(kRealWidth(64), CGFLOAT_MAX) font:[UIFont systemFontOfSize:self.landingPageWaterFallConfig.categoryFont weight:UIFontWeightRegular]];
            maxTitleHeight = MAX(maxTitleHeight, fitSize.height);
//            HDLog(@"title:%@ 高度:%f", title, fitSize.height);
        }];
        
//        HDLog(@"title 最大高度:%f", maxTitleHeight);
        CGSize twoLineHeight = [@"呵\n呵" boundingAllRectWithSize:CGSizeMake(kRealWidth(64), CGFLOAT_MAX) font:[UIFont systemFontOfSize:self.landingPageWaterFallConfig.categoryFont weight:UIFontWeightRegular]];
//        HDLog(@"title 两行最大高度:%f", twoLineHeight.height);
        height += MIN(maxTitleHeight, twoLineHeight.height);
        
    }
    
    height += 8;
    
    if(self.categoryTitleConfig.sortFilter) {
        height += kRealWidth(36);
    }
    
//    HDLog(@"header 最终高度:%f", height);
    return height;
}

- (void)gotoChooseAddress {
    @HDWeakify(self);
    void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
        @HDStrongify(self);
        addressModel.fromType = SAAddressModelFromTypeUserChoosed;
        // 如果选择的地址信息不包含省市字段，需要重新去解析一遍
        if (HDIsStringEmpty(addressModel.city) && HDIsStringEmpty(addressModel.subLocality)) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
            [self showloading];
            @HDWeakify(self);
            [SALocationUtil transferCoordinateToAddress:coordinate
                                             completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                @HDStrongify(self);
                                                 [self dismissLoading];
                                                 if (HDIsStringEmpty(address)) {
                                                     [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
                                                     return;
                                                 }
                                                 SAAddressModel *newAddressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                 newAddressModel.lat = @(coordinate.latitude);
                                                 newAddressModel.lon = @(coordinate.longitude);
                                                 newAddressModel.address = address;
                                                 newAddressModel.consigneeAddress = consigneeAddress;
                                                 newAddressModel.fromType = SAAddressModelFromTypeOnceTime;
                                                 [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:newAddressModel];
                                             }];
        } else {
            [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];
        }
    };

    /// 当前选择的地址模型
    SAAddressModel *currentAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    [HDMediator.sharedInstance navigaveToChooseAddressViewController:@{@"callback": callback, @"currentAddressModel": currentAddressModel}];
}


#pragma mark - Collection Delegate
- (UICollectionReusableView *)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section >= self.dataSource.count) {
        HDLog(@"越界了!!");
        return nil;
    }
    
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    
    if([sectionModel isEqual:self.waterfallSection] && !HDIsObjectNil(self.categoryTitleConfig) && self.categoryTitleConfig.titles.count && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YumNowLandingPageStoreListCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YumNowLandingPageStoreListCollectionReusableView.class) forIndexPath:indexPath];
        
        YumNowLandingPageStoreListCollectionReusableViewModel *viewModel = YumNowLandingPageStoreListCollectionReusableViewModel.new;
        viewModel.categoryFont = self.landingPageWaterFallConfig.categoryFont;
        viewModel.categoryColor = self.landingPageWaterFallConfig.categoryColor;
        viewModel.categoryDefaultColor = self.landingPageWaterFallConfig.categoryDefaultColor;
        viewModel.categoryBottomLineColor = self.landingPageWaterFallConfig.categoryBottomLineColor;
        viewModel.categoryModels = [self.categoryTitleConfig.titles copy];
        viewModel.showLabel = self.categoryTitleConfig.showLabel;
        viewModel.sortFilter = self.categoryTitleConfig.sortFilter;
        viewModel.storeLogoShowType = self.categoryTitleConfig.storeLogoShowType;
        viewModel.viewHeight = [self waterfallHeaderHeight];
        view.model = viewModel;
        @HDWeakify(self);
        view.filterViewWillAppear = ^(UICollectionReusableView * _Nullable view) {
            // 筛选框要出来了，置顶
            [self scrollToWaterfallHeader:view];
        };
        
        view.filterViewWillDisAppear = ^(UICollectionReusableView * _Nullable view, WMNearbyFilterModel * _Nonnull filterModel) {
            @HDStrongify(self);
            [self clickOnCategoryTitle:self.currentCategoryModel filterOption:filterModel reusableView:view scrollToTop:NO];
        };
        
        view.categoryTitleClicked = ^(UICollectionReusableView *_Nullable view, NSInteger index, WMNearbyFilterModel * _Nonnull filterModel) {
            @HDStrongify(self);
            if(index >= self.categoryTitleConfig.titles.count) {
                HDLog(@"严重异常！！！退出");
                return;
            }
            
            if(index == self.currentReusableViewIndex) return;
                
            self.currentReusableViewIndex = index;
            
            SAYumNowLandingPageCategoryModel *model = self.categoryTitleConfig.titles[index];
            [self clickOnCategoryTitle:model filterOption:filterModel reusableView:view scrollToTop:NO];
            
        };
        self.reusableView = view;
        return view;
    }
        
    return nil;
}

- (UICollectionViewCell *)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *tmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];

    if(indexPath.section >= self.dataSource.count) {
        HDLog(@"越界了!!");
        return tmp;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if(indexPath.row >= sectionModel.list.count) {
        HDLog(@"越界了!!");
        return tmp;
    }
    
    id model = sectionModel.list[indexPath.row];
    

    if ([model isKindOfClass:WMNewStoreModel.class]) { // 门店cell
        WMNewStoreModel *trueModel = (WMNewStoreModel *)model;
        if ([self.categoryTitleConfig.storeLogoShowType isEqualToString: YumNowLandingPageStoreCardStyleBig]) {
            trueModel.numberOfLinesOfNameLabel = 2;
        }else{
            trueModel.numberOfLinesOfNameLabel = 1;
        }
        trueModel.storeLogoShowType = self.categoryTitleConfig.storeLogoShowType;
        WMCMSStoreCollectionViewCell *cell = [WMCMSStoreCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(WMCMSStoreCollectionViewCell.class)];
        cell.storeModel = trueModel;
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) { // 没有数据的占位
        SANoDataCellModel *trueModel = (SANoDataCellModel *)model;
        SANoDataCollectionViewCell *cell = [SANoDataCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SANoDataCollectionViewCell.class)];
        trueModel.descText = WMLocalizedString(@"wm_home_tip003", @"暂无符合条件的商家～");
        trueModel.marginDescToImage = 10;
        cell.model = trueModel;
        return cell;
        
    } else if ([model isKindOfClass:SACMSPlaceholderCollectionViewCellModel.class]) { // 瀑布流占位图
        SACMSPlaceholderCollectionViewCell *cell = [SACMSPlaceholderCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                   identifier:NSStringFromClass(SACMSPlaceholderCollectionViewCell.class)];
        return cell;
        
    } else if ([model isKindOfClass:SACMSWaterfallSkeletonCollectionViewCellModel.class]) { // 瀑布流加载骨架
        SACMSWaterfallSkeletonCollectionViewCell *cell = [SACMSWaterfallSkeletonCollectionViewCell cellWithCollectionView:collectionView
                                                                                                             forIndexPath:indexPath
                                                                                                               identifier:NSStringFromClass(SACMSWaterfallSkeletonCollectionViewCell.class)];
        SACMSWaterfallSkeletonCollectionViewCellModel *trueModel = (SACMSWaterfallSkeletonCollectionViewCellModel *)model;
        cell.model = trueModel;
        return cell;
        
    } else if([model isKindOfClass:YumNowLandingPageStoreListCollectionViewCellModel.class]) {
        YumNowLandingPageStoreListCollectionViewCell *cell = [YumNowLandingPageStoreListCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(YumNowLandingPageStoreListCollectionViewCell.class)];
        cell.model = model;
        @HDWeakify(self);
        cell.filterViewWillAppear = ^(UIView * _Nonnull filterView) {
            @HDStrongify(self);
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.dataSource indexOfObject:self.waterfallSection]] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        };
        return cell;
    }
    HDLog(@"越界了!!");
    return tmp;

}

- (void)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >= self.dataSource.count) {
        HDLog(@"越界了!!");
        return;
    }

    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if(indexPath.row >= sectionModel.list.count) {
        HDLog(@"越界了!!");
        return;
    }
    
    id model = sectionModel.list[indexPath.row];
    if([model isKindOfClass:WMBaseStoreModel.class]) {
        WMBaseStoreModel *trueModel = (WMBaseStoreModel *)model;
        NSMutableDictionary *params = NSMutableDictionary.dictionary;
        params[@"storeNo"] = trueModel.storeNo;
        params[@"storeName"] = trueModel.storeName.desc;
        
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
    }
    
}

- (CGSize)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= self.dataSource.count) {
        HDLog(@"越界了!!");
        return CGSizeZero;
    }
    
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if(indexPath.row >= sectionModel.list.count) {
        HDLog(@"越界了!!");
        return CGSizeZero;
    }
    
    id model = sectionModel.list[indexPath.row];
    
    if ([model isKindOfClass:WMNewStoreModel.class]) { // 瀑布流cell
        WMNewStoreModel *trueModel = (WMNewStoreModel *)model;
        return CGSizeMake(kScreenWidth, [trueModel storeCardHeightWith:self.categoryTitleConfig.storeLogoShowType]);
    } else if([model isKindOfClass:YumNowLandingPageStoreListCollectionViewCellModel.class]) {
        return CGSizeMake(CGRectGetWidth(self.container.frame), CGRectGetHeight(self.container.frame));
        
    } else if([model isKindOfClass:SACMSPlaceholderCollectionViewCellModel.class]) {
        SACMSPlaceholderCollectionViewCellModel *trueModel = (SACMSPlaceholderCollectionViewCellModel *)model;
        return CGSizeMake(CGRectGetWidth(self.container.frame), trueModel.cellHeight);
        
    } else if([model isKindOfClass:SANoDataCellModel.class]) {
        return CGSizeMake(CGRectGetWidth(self.container.frame), CGRectGetHeight(self.container.frame) - [self waterfallHeaderHeight]);
    }
    return CGSizeZero;
}

- (CGSize)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if(section >= self.dataSource.count) {
        HDLog(@"越界了!!");
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if([sectionModel isEqual:self.waterfallSection] && self.categoryTitleConfig.titles.count) {
        return CGSizeMake(CGRectGetWidth(self.container.frame), [self waterfallHeaderHeight]);
    }
    
    
    
    return CGSizeZero;
}

- (UIEdgeInsets)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;;
}

- (NSInteger)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 1;
}

@end
