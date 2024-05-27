//
//  WMHomeStoreListView.m
//  SuperApp
//
//  Created by wmz on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMHomeStoreListView.h"
#import "WMCardTableViewCell.h"
#import "WMHomeLayoutModel.h"
#import "SAAddressCacheAdaptor.h"


@interface WMHomeStoreListView () {
    CGFloat _startOffsetY;
}
@end


@implementation WMHomeStoreListView

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
                                          latitude:@(position.x).stringValue pageSize:10 pageNum:self.tableView.pageNum
                                          sortType:self.filterModel.sortType
                                    marketingTypes:marketingTypes
                                      storeFeature:self.filterModel.storeFeature
                                     businessScope:self.filterModel.category.scopeCode success:^(WMQueryNearbyStoreNewRspModel *rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (self.tableView.pageNum == 1) {
            self.dataSource = NSMutableArray.new;
        }
        [self.dataSource addObjectsFromArray:rspModel.list];
        [self adjustInsertingAdvertisementDataToNeayBySectionList];
        [self.tableView reloadData:!rspModel.hasNextPage];
        self.viewModel.finishRequestType = 2;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        if([rspModel.code isEqualToString:@"ME077"]) {
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadFail];
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
    
            [self.tableView reloadFail];
        }
    }];
}
#pragma mark - private methods
// 往附近门店列表插入广告
- (void)adjustInsertingAdvertisementDataToNeayBySectionList {
    if (HDIsArrayEmpty(self.dataSource) || !self.viewModel.insertModel)
        return;
    NSArray *insertArr = [self.dataSource hd_filterWithBlock:^BOOL(WMBaseStoreModel *item) {
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
        //        footer.triggerAutomaticallyRefreshPercent = -2;
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
    
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:WMCNStoreTableViewCell.class]) {
            WMBaseStoreModel *model = [(WMCNStoreTableViewCell *)obj model];
            if(model.willDisplayTime > 0) {
                [self traceStoreExposureWithStoreModel:model];
            }
        } else if([obj isKindOfClass:WMStoreCell.class]) {
            WMBaseStoreModel *model = [(WMStoreCell *)obj model];
            if(model.willDisplayTime > 0) {
                [self traceStoreExposureWithStoreModel:model];
            }
        } else if([obj isKindOfClass:WMCardTableViewCell.class]) {
            WMHomeLayoutModel *model = [(WMCardTableViewCell *)obj layoutModel];
            if(model.willDisplayTime > 0) {
                [self traceStoreAdsExposureWithLayoutModel:model];
            }
        }
    }];
}

- (void)traceStoreExposureWithStoreModel:(WMBaseStoreModel *)storeModel {
    if([[NSDate new] timeIntervalSince1970] - storeModel.willDisplayTime > 0.5) {
        [LKDataRecord.shared traceEvent:@"wm_store_exposure"
                                   name:@"外卖门店曝光" parameters:@{
            @"storeNo" : storeModel.storeNo,
            @"source" : self.columnModel.nameZh,
            @"categoryName" : self.filterModel.category.message.desc,
            @"sortType" : self.filterModel.sortType,
            @"payFlag" : storeModel.payFlag ? @"1" : @"0",
            @"staySec" : [NSString stringWithFormat:@"%.4f",[[NSDate new] timeIntervalSince1970] - storeModel.willDisplayTime]
        }];
    }
}

- (void)traceStoreAdsExposureWithLayoutModel:(WMHomeLayoutModel *)layoutModel {
    if([[NSDate new] timeIntervalSince1970] - layoutModel.willDisplayTime > 0.5) {
        [LKDataRecord.shared traceEvent:@"wm_ad_exposure"
                                   name:@"外卖广告曝光" parameters:@{
            @"identify" : layoutModel.identity,
            @"source" : self.columnModel.nameZh,
            @"categoryName" : self.filterModel.category.message.desc,
            @"sortType" : self.filterModel.sortType,
            @"staySec" : [NSString stringWithFormat:@"%.4f",[[NSDate new] timeIntervalSince1970] - layoutModel.willDisplayTime]
        }];
    }
    
    
}

- (void)userLoginHandler {
    if ([self.tableView.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
        if ([SAUser hasSignedIn]) {
            footer.triggerAutomaticallyRefreshPercent = -2;
        }
    }
    [self wm_getNewData];
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
        return cell;
    } else if ([model isKindOfClass:WMBaseStoreModel.class]) {
        /// 门店卡片
        WMBaseStoreModel *trueModel = (WMBaseStoreModel *)model;
        trueModel.isFirst = indexPath.row == 0;
        trueModel.indexPath = indexPath;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            trueModel.numberOfLinesOfNameLabel = 1;
            WMCNStoreTableViewCell *cell = [WMCNStoreTableViewCell cellWithTableView:tableView];
            cell.model = trueModel;
            return cell;
        } else {
            trueModel.numberOfLinesOfNameLabel = 2;
            WMStoreCell *cell = [WMStoreCell cellWithTableView:tableView];
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
    
    if(indexPath.section > 0 || indexPath.row >= self.dataSource.count) {
        return;
    }
    
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMBaseStoreModel.class]) {
        WMBaseStoreModel *itemModel = model;
        itemModel.willDisplayTime = [[NSDate new] timeIntervalSince1970];
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
        [tableView recordStoreExposureCountWithValue:itemModel.storeNo
                                                 key:itemModel.mShowTime
                                           indexPath:indexPath
                                                info:param
                                           eventName:@"takeawayStoreExposure"];

    } else if([model isKindOfClass:WMHomeLayoutModel.class]) {
        WMHomeLayoutModel *itemModel = model;
        itemModel.willDisplayTime = [[NSDate new] timeIntervalSince1970];
        
//        HDLog(@"[Debug]这是一个广告要出来了:%@ %@", itemModel.identity, self.columnModel.nameZh);
    } else {
        HDLog(@"[Debug]这不知道是什么玩意要出来了:%@ %@", model, self.columnModel.nameZh);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section > 0 || indexPath.row >= self.dataSource.count) {
        return;
    }
    
    id model = self.dataSource[indexPath.row];
    if([model isKindOfClass:WMBaseStoreModel.class]) {
        WMBaseStoreModel *itemModel = model;
        if(itemModel.willDisplayTime > 0) {
            [self traceStoreExposureWithStoreModel:itemModel];

        }
        
    } else if([model isKindOfClass:WMHomeLayoutModel.class]) {
        WMHomeLayoutModel *itemModel = model;
        if(itemModel.willDisplayTime > 0) {
            [self traceStoreAdsExposureWithLayoutModel:itemModel];
        }

    } else {
        HDLog(@"[Debug]这不知道是什么玩意要消失了:%@", model);
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([model isKindOfClass:WMBaseStoreModel.class]) {
        WMBaseStoreModel *trueModel = (WMBaseStoreModel *)model;
        NSMutableDictionary *params = NSMutableDictionary.dictionary;
        params[@"storeNo"] = trueModel.storeNo;
        params[@"storeName"] = trueModel.storeName.desc;
        params[@"funnel"] = @"首页";
        
        params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row] : [NSString stringWithFormat:@"外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row];
        params[@"associatedId"] = self.viewModel.associatedId;
        ///付费商家点击
        if (trueModel.payFlag) {
            [LKDataRecord.shared traceEvent:@"sortClickStore"
                                       name:@"sortClickStore"
                                 parameters:@{
                @"plateId": trueModel.uuid,
                @"storeNo": trueModel.storeNo,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row] : [NSString stringWithFormat:@"外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row]
                
            }
                                        SPM:nil];
            params[@"payFlag"] = trueModel.uuid;
        }
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        
        [LKDataRecord.shared traceEvent:@"clickBtn"
                                   name:@"clickBtn"
                             parameters:@{
            @"clickType": @"NEARBY",
            @"storeNo" : trueModel.storeNo,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row] : [NSString stringWithFormat:@"外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row]
            
        }
                                    SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:@"" node:@""]];
        ///普通门店点击 3.0.16.0
        [LKDataRecord.shared traceEvent:@"merchantClick"
                                   name:@"merchantClick"
                             parameters:@{
            @"type": @"merchantClick",
            @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
            @"iocntype": self.iocntype,
            @"storeNo" : trueModel.storeNo,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row] : [NSString stringWithFormat:@"外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row]
        }
                                    SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:@"" node:@""]];

        ///门店点击 3.0.19.0
        [LKDataRecord.shared traceEvent:@"takeawayStoreClick"
                                   name:@"takeawayStoreClick"
                             parameters:@{
            @"storeNo": trueModel.storeNo,
            @"type": [self.iocntype isEqualToString:@"nearbyMerchant"] ? @"nearStore" : @"freeDeliveryFee",
            @"exposureSort": @(indexPath.row).stringValue,
            @"plateId": WMManage.shareInstance.plateId,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row] : [NSString stringWithFormat:@"外卖首页.%@@%zd", self.columnModel.nameZh, indexPath.row]
        }
                                    SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:@"" node:@""]];
    }
}

- (CGFloat)startOffsetY {
    if (!_startOffsetY) {
        _startOffsetY = kNavigationBarH + kRealWidth(36) + kRealWidth(51);
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
        @HDWeakify(self);
        _tableView.customPlaceHolder = ^(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError) {
            @HDStrongify(self);
//            placeholderViewModel.image = @"home_no_store";
            placeholderViewModel.image = @"wm_home_placeholder";
//            placeholderViewModel.title = WMLocalizedString(@"search_store_nearby_none_tip", @"没有附近商家相关的信息");
            placeholderViewModel.title = WMLocalizedString(@"wm_home_tip002", @"抱歉，当前定位地点附近无营业门店，请重新选择地址");
            placeholderViewModel.needRefreshBtn = YES;
            placeholderViewModel.refreshBtnTitle = WMLocalizedString(@"", @"选择地址");
            placeholderViewModel.refreshBtnBackgroundColor = UIColor.sa_C1;
            @HDWeakify(self);
            placeholderViewModel.clickOnRefreshButtonHandler = ^{
                @HDStrongify(self);
                @HDWeakify(self);
                void (^callback)(SAAddressModel *) = ^(SAAddressModel *addressModel) {
                                @HDStrongify(self);
                                addressModel.fromType = SAAddressModelFromTypeOnceTime;
                                // 如果选择的地址信息不包含省市字段，需要重新去解析一遍
                                if (HDIsStringEmpty(addressModel.city) && HDIsStringEmpty(addressModel.subLocality)) {
                                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
                                    [self.viewController.view showloading];
                                    [SALocationUtil transferCoordinateToAddress:coordinate
                                                                     completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                                         [self.viewController.view dismissLoading];
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
                            //            SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
                            SAAddressModel *currentAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
                            [HDMediator.sharedInstance navigaveToChooseAddressViewController:@{@"callback": callback, @"currentAddressModel": currentAddressModel}];
            };
        };
        _tableView.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMStoreSkeletonCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 176;
        }];
        _tableView.delegate = _tableView.provider;
        _tableView.dataSource = _tableView.provider;
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
