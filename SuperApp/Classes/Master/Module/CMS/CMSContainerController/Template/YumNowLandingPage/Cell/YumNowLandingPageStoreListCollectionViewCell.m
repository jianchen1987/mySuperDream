//
//  YumNowLandingPageStoreListCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2023/12/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "YumNowLandingPageStoreListCollectionViewCell.h"
#import <HDUIKit/HDUIKit.h>
#import "SAYumNowLandingPageCategoryModel.h"
#import "SATableView.h"
#import "WMStoreModel.h"
#import "WMStoreCell.h"
#import "WMCNStoreTableViewCell.h"
#import "WMQueryNearbyStoreRspModel.h"
#import "SAAddressModel.h"
#import "YumNowStoreListFilterHeaderView.h"
#import "WMNearbyFilterModel.h"
#import "WMCategoryItem.h"

@interface YumNowLandingPageStoreListCollectionViewCell()<UITableViewDelegate, UITableViewDataSource>

///< headerView
@property (nonatomic, strong) YumNowStoreListFilterHeaderView *headerView;

@property (nonatomic, strong) SATableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
///< page
@property (nonatomic, assign) NSUInteger currentPage;
///< 筛选
@property (nonatomic, strong) WMNearbyFilterModel *filterOption;
///< 当前选项
@property (nonatomic, assign) NSInteger index;
@end

@implementation YumNowLandingPageStoreListCollectionViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.tableView];
    self.index = 0;
    
    @HDWeakify(self);
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };
}

- (void)setModel:(YumNowLandingPageStoreListCollectionViewCellModel *)model {
    _model = model;
    
    YumNowStoreListFilterHeaderViewModel *headerModel = YumNowStoreListFilterHeaderViewModel.new;
    
    headerModel.categoryFont = model.categoryFont;
    headerModel.categoryDefaultColor = model.categoryDefaultColor;
    headerModel.categoryColor = model.categoryColor;
    headerModel.categoryBottomLineColor = model.categoryBottomLineColor;
    headerModel.iconSize = CGSizeMake(44, 44);
    headerModel.titles = [model.categoryModels mapObjectsUsingBlock:^id _Nonnull(SAYumNowLandingPageCategoryModel * _Nonnull obj, NSUInteger idx) {
        return obj.name.desc;
    }];
    headerModel.iconUrls = [model.categoryModels mapObjectsUsingBlock:^id _Nonnull(SAYumNowLandingPageCategoryModel * _Nonnull obj, NSUInteger idx) {
        return obj.iconUrl;
    }];
    
    self.headerView.model = headerModel;
    
    [self getNewData];
    
    [self setNeedsUpdateConstraints];
}
#pragma mark - data

- (void)getNewData {
    [self getDataWithPage:1];
}

- (void)loadMoreData {
    [self getDataWithPage:++self.currentPage];
}


- (void)getDataWithPage:(NSUInteger)page {

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = self.model.dataSourcePath;
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNum"] = @(page);
    params[@"pageSize"] = @(10);

    if (!HDIsObjectNil(self.model.address)) {
        params[@"location"] = @{
            @"lat" : self.model.address.lat.stringValue,
            @"lon" : self.model.address.lon.stringValue
        };
        params[@"areaCode"] = HDIsStringNotEmpty(self.model.address.districtCode) ? self.model.address.districtCode : @"855120000";
    }

    if ([SAUser hasSignedIn]) {
        params[@"operatorNo"] = SAUser.shared.operatorNo;
    }
    
    params[@"sortType"] = self.filterOption.sortType;
    params[@"marketingTypes"] = self.filterOption.marketingTypes;
    params[@"storeFeature"] = self.filterOption.storeFeature;
    params[@"businessCode"] = self.filterOption.category.scopeCode;
    
    SAYumNowLandingPageCategoryModel *category = self.model.categoryModels.firstObject;
    if(self.index < self.model.categoryModels.count) {
        category = self.model.categoryModels[self.index];
    }
    params[@"queryParam"] = category.queryParam;

    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    @HDWeakify(self);
    [self showloading];
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [self dismissLoading];
        SARspModel *rspModel = response.extraData;
        WMQueryNearbyStoreNewRspModel *storeListRspModel = [WMQueryNearbyStoreNewRspModel yy_modelWithJSON:rspModel.data];
        self.currentPage = page;
        
        NSMutableArray<SAModel *> *tmp = [[NSMutableArray alloc] initWithCapacity:10];
        if (1 == page) {
            [tmp addObjectsFromArray:storeListRspModel.list];
            self.dataSource = tmp;
            [self.tableView successGetNewDataWithNoMoreData:!storeListRspModel.hasNextPage];
            
        } else {
            [tmp addObjectsFromArray:self.dataSource];
            [tmp addObjectsFromArray:storeListRspModel.list];
            self.dataSource = tmp;
            [self.tableView successLoadMoreDataWithNoMoreData:!storeListRspModel.hasNextPage];
        }
        
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [self dismissLoading];
        if(1 == page) {
            [self.tableView failGetNewData];
        } else {
            [self.tableView failLoadMoreData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    HDLog(@"size:{%f, %f} offset:{%f, %f}", scrollView.contentSize.width, scrollView.contentSize.height, scrollView.contentOffset.x, scrollView.contentOffset.y);
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableView.class)];
    
    if(indexPath.row >= self.dataSource.count) {
        return cell;
    }
    
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMBaseStoreModel.class]) {
        /// 门店卡片
        WMBaseStoreModel *trueModel = (WMBaseStoreModel *)model;
        trueModel.isFirst = indexPath.row == 0;
        trueModel.indexPath = indexPath;
        if ([self.model.storeLogoShowType isEqualToString: YumNowLandingPageStoreCardStyleBig]) {
            trueModel.numberOfLinesOfNameLabel = 2;
            WMStoreCell *cell = [WMStoreCell cellWithTableView:tableView];
            cell.model = trueModel;
            return cell;
        } else {
            trueModel.numberOfLinesOfNameLabel = 1;
            WMCNStoreTableViewCell *cell = [WMCNStoreTableViewCell cellWithTableView:tableView];
            cell.model = trueModel;
            return cell;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}



#pragma mark - layout
- (void)updateConstraints {
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(85) + kRealWidth(36));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [super updateConstraints];
}

- (SATableView *)tableView {
    if(!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.bounces = NO;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    }
    return _tableView;
}

- (YumNowStoreListFilterHeaderView *)headerView {
    if(!_headerView) {
        _headerView = [[YumNowStoreListFilterHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(85) + kRealWidth(36))];
        @HDWeakify(self);
        _headerView.filterViewWillAppear = ^(UIView * _Nonnull filterView) {
            @HDStrongify(self);
            HDLog(@"要出来啦嫂嫂");
            !self.filterViewWillAppear ?: self.filterViewWillAppear(filterView);
        };

        _headerView.filterViewWillDisAppear = ^(UIView * _Nonnull filterView, WMNearbyFilterModel * _Nonnull option) {
            @HDStrongify(self);
            HDLog(@"你选了:%@", option);
            self.filterOption = option;
            [self getNewData];
            
        };
        
        _headerView.titleDidSelected = ^(NSInteger index, WMNearbyFilterModel * _Nonnull option) {
            @HDStrongify(self);
            !self.filterViewWillAppear ?: self.filterViewWillAppear(nil);
            self.index = index;
            self.filterOption = option;
            [self getNewData];
        };
    }
    return _headerView;
}

@end


@implementation YumNowLandingPageStoreListCollectionViewCellModel



@end
