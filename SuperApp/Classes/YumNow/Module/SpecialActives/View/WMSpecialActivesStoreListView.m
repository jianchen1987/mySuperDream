//
//  WMSpecialActivesStoreListView.m
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSpecialActivesStoreListView.h"
#import "WMSearchStoreRspModel.h"
#import "WMSpecialActivesPictureView.h"
#import "WMSpecialActivesViewModel.h"
#import "WMSpecialPromotionRspModel.h"
#import "WMStoreListItemModel.h"
#import "WMStoreSearchResultTableViewCell.h"
#import "UITableView+RecordData.h"


@interface WMSpecialActivesStoreListView () <UITableViewDelegate, UITableViewDataSource>
/// viewModel
@property (nonatomic, strong) WMSpecialActivesViewModel *viewModel;
/// tableview
@property (nonatomic, strong) WMTableView *tableView;
/// tableHeader
@property (nonatomic, strong) WMSpecialActivesPictureView *headView;
/// dataSource
@property (nonatomic, strong) NSMutableArray<WMStoreListNewItemModel *> *dataSource;
/// pageNo
@property (nonatomic, assign) NSUInteger pageNo;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// offset
@property (nonatomic, assign) CGFloat offset;
/// 是否显示筛选栏
@property (nonatomic, assign) BOOL showBusiness;

@end


@implementation WMSpecialActivesStoreListView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.pageNo = 1;
    self.dataSource = NSMutableArray.new;
    [self addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.tappedRefreshBtnHandler = self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        self.pageNo = 1;
        if (!self.tableView.hd_hasData) {
            self.tableView.dataSource = self.provider;
            self.tableView.delegate = self.provider;
        }
        [self requestNewData];
    };

    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        ++self.pageNo;
        [self requestNewData];
    };

    self.headView.frameBlock = ^(CGFloat realHeight) {
        @HDStrongify(self) self.tableView.tableHeaderView = self.headView;
    };
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"storeList" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.pageNo = 1;
        self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.storeList];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.showBusiness = self.viewModel.showBusiness;
        [self.tableView reloadData:!self.viewModel.proModel.storesV2.hasNextPage];
//        [self.tableView reloadData:!self.viewModel.proModel.stores.hasNextPage];
    }];
}

#pragma mark - Event
- (void)requestNewData {
    @HDWeakify(self);
    [self.viewModel getSpecialActivesWithPageNo:self.pageNo pageSize:10 sortType:self.filterModel.sortType marketingTypes:self.filterModel.marketingTypes storeFeature:self.filterModel.storeFeature businessCode:self.filterModel.category.scopeCode success:^(WMSpecialPromotionRspModel * _Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        if (self.pageNo == 1) {
            self.dataSource = [[NSMutableArray alloc] initWithArray:rspModel.storesV2.list];
//            self.dataSource = [[NSMutableArray alloc] initWithArray:rspModel.stores.list];
            self.showBusiness = rspModel.showBusiness;
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        } else {
            [self.dataSource addObjectsFromArray:rspModel.storesV2.list];
//            [self.dataSource addObjectsFromArray:rspModel.stores.list];
        }
        [self.tableView reloadData:!rspModel.storesV2.hasNextPage];
//        [self.tableView reloadData:!rspModel.stores.hasNextPage];
    } failure:^(SARspModel * _Nullable rspModel, CMResponseErrorType errorType, NSError * _Nullable error) {
        @HDStrongify(self);
        [self.tableView reloadFail];
    }];

}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.showBusiness){
        return self.filterBarView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.showBusiness){
        return kRealWidth(36);
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMStoreListNewItemModel *item = self.dataSource[indexPath.row];
    WMStoreSearchResultTableViewCell *cell = [WMStoreSearchResultTableViewCell cellWithTableView:tableView];
//    cell.model = item;
    cell.nModel = item;
    @HDWeakify(self);
    [cell setBlockOnClickPromotion:^{
        @HDStrongify(self);
        [self.tableView reloadData];
    }];
    cell.clickedProductViewBlock = ^(NSString *_Nonnull menuId, NSString *_Nonnull productId) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"storeNo"] = item.storeNo;
        params[@"storeName"] = item.storeName.desc;
        params[@"menuId"] = menuId;
        params[@"productId"] = productId;
        params[@"distance"] = [NSNumber numberWithDouble:item.distance];
        params[@"funnel"] = @"搜索结果商品";
        params[@"plateId"] = self.viewModel.plateId;
        params[@"collectType"] = self.viewModel.collectType;
        params[@"topicPageId"] = self.viewModel.topicPageId;
        
        params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|门店专题"] : @"门店专题";
        params[@"associatedId"] = HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : self.viewModel.activeNo;

        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];

    };
    cell.clickedMoreViewBlock = ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"storeNo"] = item.storeNo;
        if (item.signatures.count && [item.signatures.firstObject isKindOfClass:WMSpecialStoreSignaturesModel.class]) {
            params[@"productId"] = item.signatures.firstObject.productId;
        }
        params[@"storeName"] = item.storeName.desc;
        params[@"distance"] = [NSNumber numberWithDouble:item.distance];
        params[@"funnel"] = @"搜索结果商品";
        
        params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|门店专题"] : @"门店专题";
        params[@"associatedId"] = HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : self.viewModel.activeNo;

        params[@"plateId"] = self.viewModel.plateId;
        params[@"collectType"] = self.viewModel.collectType;
        params[@"topicPageId"] = self.viewModel.topicPageId;
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];

    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//<<<<<<< HEAD
    WMStoreListNewItemModel *model = self.dataSource[indexPath.row];
//=======
//    WMStoreListItemModel *model = self.dataSource[indexPath.row];
//    
//>>>>>>> master
    [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
        @"storeNo": model.storeNo,
        @"funnel": @"专题门店",
        @"plateId": self.viewModel.plateId,
        @"collectType": self.viewModel.collectType,
        @"topicPageId": self.viewModel.topicPageId,
        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|门店专题"] : @"门店专题",
        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : self.viewModel.activeNo
    }];

    /// 3.0.19.0 点击
    NSDictionary *param = @{
        @"exposureSort": @(indexPath.row).stringValue,
        @"storeNo": model.storeNo,
        @"type": @"customTopicPageStore",
        @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
        @"plateId": WMManage.shareInstance.plateId
    };
    [LKDataRecord.shared traceEvent:@"takeawayStoreClick" name:@"takeawayStoreClick" parameters:param SPM:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    WMStoreListNewItemModel *model = self.dataSource[indexPath.row];
    /// 3.0.19.0
    NSDictionary *param = @{
        @"exposureSort": @(indexPath.row).stringValue,
        @"storeNo": model.storeNo,
        @"type": @"customTopicPageStore",
        @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
        @"plateId": WMManage.shareInstance.plateId
    };
    [tableView recordStoreExposureCountWithValue:model.storeNo key:model.mShowTime indexPath:indexPath info:param eventName:@"takeawayStoreExposure"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.offset = scrollView.contentOffset.y;
    if(self.showBusiness && self.headView.bounds.size.height > 0) {
        if (scrollView.contentOffset.y >kNavigationBarH) {
            [scrollView setContentInset:UIEdgeInsetsMake(kNavigationBarH, 0, 0, 0)];
        }else{
            [scrollView setContentInset:UIEdgeInsetsZero];
        }
    }
}

- (void)setIsShowingInWindow:(BOOL)isShowingInWindow {
    _isShowingInWindow = isShowingInWindow;
    if(!isShowingInWindow && self.showBusiness) {
        [self.filterBarView hideAllSlideDownView];
    }
}

#pragma mark - lazy load
/** @lazy tableview */
- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = HDAppTheme.color.G5;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = YES;
        _tableView.needRefreshHeader = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.needShowErrorView = YES;
        _tableView.dataSource = self.provider;
        _tableView.delegate = self.provider;
        _tableView.tableHeaderView = self.headView;
        _tableView.backgroundColor = HDAppTheme.WMColor.bg3;
    }
    return _tableView;
}
/** @lazy headview */
- (WMSpecialActivesPictureView *)headView {
    if (!_headView) {
        _headView = [[WMSpecialActivesPictureView alloc] initWithViewModel:self.viewModel];
    }
    return _headView;
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

- (WMNearbyFilterBarView *)filterBarView {
    if (!_filterBarView) {
        _filterBarView = [[WMNearbyFilterBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(36)) filterModel:self.filterModel startOffsetY:kNavigationBarH + kRealWidth(36)];
        @HDWeakify(self);
        _filterBarView.viewWillDisappear = ^(UIView *_Nonnull view) {
            @HDStrongify(self);
            self.pageNo = 1;
//            if (self.tableView.hd_hasData) {
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
//            [self wm_getListData];
            [self requestNewData];
        };
        
        _filterBarView.viewWillAppear = ^(UIView * _Nonnull view) {
            @HDStrongify(self);
            if(self.headView.bounds.size.height > 0) {
                [self.tableView setContentOffset:CGPointMake(0, self.headView.bounds.size.height - kNavigationBarH) animated:NO];
            }else{
                [self.tableView setContentOffset:CGPointZero animated:NO];
            }
        };
    }
    return _filterBarView;
}

- (WMNearbyFilterModel *)filterModel {
    return _filterModel ?: ({ _filterModel = WMNearbyFilterModel.new; });
}

@end
