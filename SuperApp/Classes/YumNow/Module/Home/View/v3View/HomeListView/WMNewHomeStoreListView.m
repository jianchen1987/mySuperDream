//
//  WMNewHomeStoreListView.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewHomeStoreListView.h"
#import "WMCardTableViewCell.h"
#import "WMHomeLayoutModel.h"
#import "SAAddressCacheAdaptor.h"


@interface WMNewHomeStoreListView () {
    CGFloat _startOffsetY;
}
@end


@implementation WMNewHomeStoreListView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel columnModel:(WMHomeColumnModel *)columnModel {
    self.viewModel = (id)viewModel;
    self.columnModel = columnModel;
    return [super initWithViewModel:viewModel];
}

- (void)pageViewDidAppear {
    if (!self.dataSource.count) {
        self.tableView.pageNum = 1;
        [self wm_getListData];
    }
}

- (void)wm_getNewData {
    self.tableView.pageNum = 1;
    [self wm_getListData];
}

- (void)wm_getListData {
    @HDWeakify(self);
    if (!self.viewModel.columnFlag)
        return;
    CGPoint position = [self getPosition];
    NSMutableArray *marketingTypes = self.filterModel.tags.mutableCopy;
    [marketingTypes addObjectsFromArray:self.filterModel.marketingTypes];
    [self.storeDTO getNearbyStoreWithRequestSource:WMMerchantRecommendTypeMain
                                         longitude:@(position.y).stringValue
                                          latitude:@(position.x).stringValue
                                          pageSize:10
                                           pageNum:self.tableView.pageNum
                                          sortType:self.filterModel.sortType
                                    marketingTypes:marketingTypes
                                      storeFeature:self.filterModel.storeFeature
                                     businessScope:self.filterModel.category.scopeCode 
                                           success:^(WMQueryNearbyStoreNewRspModel *rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (self.tableView.pageNum == 1) {
            self.dataSource = NSMutableArray.new;
        }
        [self.dataSource addObjectsFromArray:rspModel.list];
        [self adjustInsertingAdvertisementDataToNeayBySectionList];
        [self adjustInsertingThemeData];
        
        [self.tableView reloadData:!rspModel.hasNextPage];
        self.viewModel.finishRequestType = 2;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self dismissLoading];
        [self.tableView reloadFail];
    }];
}

#pragma mark 往附近门店列表插入广告
- (void)adjustInsertingAdvertisementDataToNeayBySectionList {
    if (HDIsArrayEmpty(self.dataSource) || !self.viewModel.insertModel)
        return;
    NSArray *insertArr = [self.dataSource hd_filterWithBlock:^BOOL(WMStoreModel *item) {
        if ([item isKindOfClass:WMHomeLayoutModel.class]) {
            WMHomeLayoutModel *layoutModel = (WMHomeLayoutModel *)item;
            return [layoutModel.identity isEqualToString:WMHomeLayoutTypeNearStoreAdvertise];
        }
        return nil;
    }];
    ///已经插入过门店广告
    if (!HDIsArrayEmpty(insertArr))
        return;
    ///门店数量小于2个
    if (self.dataSource.count < 2)
        return;
    if (self.dataSource.count == 2) {
        [self.dataSource addObject:self.viewModel.insertModel];
    } else {
        [self.dataSource insertObject:self.viewModel.insertModel atIndex:2];
    }
}

- (void)adjustInsertingThemeData {
    if (self.viewModel.themeList.count) {
        NSArray *insertArr = [self.dataSource hd_filterWithBlock:^BOOL(WMStoreModel *item) {
            if ([item isKindOfClass:WMHomeLayoutModel.class]) {
                WMHomeLayoutModel *layoutModel = (WMHomeLayoutModel *)item;
                return [layoutModel.identity isEqualToString:WMHomeLayoutTypeStoreTheme] || [layoutModel.identity isEqualToString:WMHomeLayoutTypeMerchantTheme] ||
                       [layoutModel.identity isEqualToString:WMHomeLayoutTypeProductTheme];
            }
            return nil;
        }];

        if (insertArr.count == self.viewModel.themeList.count)
            return;

        NSArray *insertStoreAdvertiseArr = [self.dataSource hd_filterWithBlock:^BOOL(WMStoreModel *item) {
            if ([item isKindOfClass:WMHomeLayoutModel.class]) {
                WMHomeLayoutModel *layoutModel = (WMHomeLayoutModel *)item;
                return [layoutModel.identity isEqualToString:WMHomeLayoutTypeNearStoreAdvertise];
            }
            return nil;
        }];

        if (insertArr.count == 0 && self.viewModel.themeList.count >= 1) {
            if (insertStoreAdvertiseArr > 0 && self.dataSource.count > 10) {
                [self.dataSource insertObject:self.viewModel.themeList[0] atIndex:11];
            } else if (self.dataSource.count > 9) {
                [self.dataSource insertObject:self.viewModel.themeList[0] atIndex:10];
            }
        } else if (insertArr.count == 1 && self.viewModel.themeList.count >= 2) {
            if (insertStoreAdvertiseArr > 0 && self.dataSource.count > 21) {
                [self.dataSource insertObject:self.viewModel.themeList[1] atIndex:22];
            } else if (self.dataSource.count > 20) {
                [self.dataSource insertObject:self.viewModel.themeList[1] atIndex:21];
            }
        } else if (insertArr.count == 2 && self.viewModel.themeList.count >= 3) {
            if (insertStoreAdvertiseArr > 0 && self.dataSource.count > 32) {
                [self.dataSource insertObject:self.viewModel.themeList[2] atIndex:33];
            } else if (self.dataSource.count > 31) {
                [self.dataSource insertObject:self.viewModel.themeList[2] atIndex:32];
            }
        }
    }
}

- (CGPoint)getPosition {
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        lat = HDLocationManager.shared.coordinate2D.latitude;
        lon = HDLocationManager.shared.coordinate2D.longitude;
    }
    return CGPointMake(lat, lon);
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    @HDWeakify(self);
    if ([self.tableView.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
        if ([SAUser hasSignedIn]) {
            footer.triggerAutomaticallyRefreshPercent = -2;
        }
    }


    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self wm_getListData];
    };
    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

- (void)userLoginHandler {
    if ([self.tableView.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
        if ([SAUser hasSignedIn]) {
            footer.triggerAutomaticallyRefreshPercent = -2;
        }
    }
}

- (void)userLogoutHandler {
    if ([self.tableView.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
        if (![SAUser hasSignedIn]) {
            footer.triggerAutomaticallyRefreshPercent = 1;
        }
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMHomeLayoutModel.class]) {
        ///阿波罗配置布局
        WMHomeLayoutModel *itemModel = (WMHomeLayoutModel *)model;
        WMCardTableViewCell *cell = [itemModel.cellClass cellWithTableView:tableView];
        ///对应的数据源
        [cell setGNModel:itemModel.dataSource];
        ///配置
        cell.layoutModel = itemModel;
        @HDWeakify(tableView);
        cell.refreshCell = ^{
            @HDStrongify(tableView);
            [tableView reloadData];
        };
        @HDWeakify(self);
        @HDWeakify(cell);
        cell.changeDataCell = ^(WMHomeLayoutModel *_Nonnull layoutModel) {
            @HDStrongify(self);
            @HDStrongify(cell);
            @HDWeakify(self);
            @HDWeakify(cell);
            [self.viewModel reloadDataWithLayoutModel:model completion:^(id _Nonnull rspModel, BOOL result) {
                if (result) {
                    @HDStrongify(self);
                    @HDStrongify(cell);
                    if ([cell.collectionView isKindOfClass:WMHomeCollectionView.class]) {
                        WMHomeCollectionView *view = (WMHomeCollectionView *)cell.collectionView;
                        [view scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    }
                    [self.tableView reloadData];
                }
            }];
        };
        return cell;
    } else if ([model isKindOfClass:WMStoreModel.class]) {
        /// 门店卡片
        WMStoreModel *trueModel = (WMStoreModel *)model;
        trueModel.isFirst = indexPath.row == 0;
        trueModel.indexPath = indexPath;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            trueModel.numberOfLinesOfNameLabel = 1;
            WMNewCNStoreTableViewCell *cell = [WMNewCNStoreTableViewCell cellWithTableView:tableView];
            cell.model = trueModel;
            return cell;
        } else {
            trueModel.numberOfLinesOfNameLabel = 2;
            WMNewStoreCell *cell = [WMNewStoreCell cellWithTableView:tableView];
            //            WMStoreCell *cell = [WMStoreCell cellWithTableView:tableView];
            cell.model = trueModel;
            return cell;
        }
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.filterBarView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealWidth(36);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreModel.class]) {
        WMStoreModel *itemModel = model;
        ///付费曝光
        [tableView recordExposureCountWithModel:model indexPath:indexPath position:1];
        ///普通门店曝光
        [tableView recordNormalStoreExposureCountWithModel:model indexPath:indexPath iocntype:self.iocntype];
        /// 3.0.19.0 曝光
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": itemModel.storeNo,
            @"type": [self.iocntype isEqualToString:@"nearbyMerchant"] ? @"nearStore" : @"freeDeliveryFee",
            @"plateId": WMManage.shareInstance.plateId,
        };
        [tableView recordStoreExposureCountWithValue:itemModel.storeNo key:itemModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayStoreExposure"];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([model isKindOfClass:WMStoreModel.class]) {
        WMStoreModel *trueModel = (WMStoreModel *)model;
        NSMutableDictionary *params = NSMutableDictionary.dictionary;
        params[@"storeNo"] = trueModel.storeNo;
        params[@"storeName"] = trueModel.storeName.desc;
        params[@"funnel"] = @"首页";
        ///付费商家点击
        if (trueModel.payFlag) {
            [LKDataRecord.shared traceEvent:@"sortClickStore" name:@"sortClickStore" parameters:@{@"plateId": trueModel.uuid, @"storeNo": trueModel.storeNo} SPM:nil];
            params[@"payFlag"] = trueModel.uuid;
        }
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"NEARBY"} SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
        ///普通门店点击 3.0.16.0
        [LKDataRecord.shared traceEvent:@"merchantClick" name:@"merchantClick"
                             parameters:@{@"type": @"merchantClick", @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000], @"iocntype": self.iocntype}
                                    SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];

        ///门店点击 3.0.19.0
        [LKDataRecord.shared traceEvent:@"takeawayStoreClick" name:@"takeawayStoreClick" parameters:@{
            @"storeNo": trueModel.storeNo,
            @"type": [self.iocntype isEqualToString:@"nearbyMerchant"] ? @"nearStore" : @"freeDeliveryFee",
            @"exposureSort": @(indexPath.row).stringValue,
            @"plateId": WMManage.shareInstance.plateId
        }
                                    SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
    }
}

- (CGFloat)startOffsetY {
    if (!_startOffsetY) {
        _startOffsetY = kNavigationBarH + kRealWidth(36) + kRealWidth(53);
    }
    return _startOffsetY;
}

- (void)setStartOffsetY:(CGFloat)startOffsetY {
    _startOffsetY = startOffsetY;
    self.filterBarView.startOffsetY = startOffsetY;
}

- (WMNearbyFilterBarView *)filterBarView {
    if (!_filterBarView) {
        _filterBarView = [[WMNearbyFilterBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(36)) filterModel:self.filterModel startOffsetY:self.startOffsetY];
        @HDWeakify(self);
        _filterBarView.viewWillDisappear = ^(UIView *_Nonnull view) {
            @HDStrongify(self);
            self.tableView.pageNum = 1;
            if (self.tableView.hd_hasData) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            [self wm_getListData];
        };
    }
    return _filterBarView;
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.useFootBottom = YES;
        _tableView.needRefreshFooter = true;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.customPlaceHolder = ^(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError) {
            placeholderViewModel.image = @"home_no_store";
            placeholderViewModel.title = WMLocalizedString(@"search_store_nearby_none_tip", @"没有附近商家相关的信息");
        };
        _tableView.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMStoreSkeletonCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 176;
        }];
        _tableView.delegate = _tableView.provider;
        _tableView.dataSource = _tableView.provider;
        _tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
    }
    return _tableView;
}

- (WMNearbyFilterModel *)filterModel {
    return _filterModel ?: ({ _filterModel = WMNearbyFilterModel.new; });
}

- (UIScrollView *)getMyScrollView {
    return self.tableView;
}

- (WMStoreDTO *)storeDTO {
    return _storeDTO ?: ({ _storeDTO = WMStoreDTO.new; });
}

- (NSMutableArray *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.new; });
}
@end
