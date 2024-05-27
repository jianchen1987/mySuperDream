//
//  SAAggregateSearchResultTableViewViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAggregateSearchResultTableViewViewController.h"
#import "GNStoreCellModel.h"
#import "GNStoreViewCell.h"
#import "SAAggregateSearchViewModel.h"
#import "SATableView.h"
#import "WMStoreListItemModel.h"
#import "WMStoreSearchResultTableViewCell.h"
#import "WMStoreSkeletonCell.h"
#import "SAAddressCacheAdaptor.h"

@interface SAAggregateSearchResultTableViewViewController () <UITableViewDelegate, UITableViewDataSource>
///< tableview
@property (nonatomic, strong) SATableView *tableView;
///< dataSource
@property (nonatomic, strong) NSArray *dataSource;
///< keyword
@property (nonatomic, copy) NSString *keyWord;
///< vuewNidek
@property (nonatomic, strong) SAAggregateSearchViewModel *viewModel;
///< pageNum
@property (nonatomic, assign) NSUInteger currentPage;

@end


@implementation SAAggregateSearchResultTableViewViewController

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.currentPage = 1;
    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getDataWithPageNum:1];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };
    [self initDataSource];

    // 监听位置改变
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
}

- (void)userChangedLocationHandler:(NSNotification *)notification {
    self.currentlyAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    //如果有关键词重新刷新数据
    if (HDIsStringNotEmpty(self.keyWord)) {
        [self getDataWithPageNum:1];
    }
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [super updateViewConstraints];
}


#pragma mark - DATA
- (void)getNewDataWithKeyWord:(NSString *)keyWord {
    if ([keyWord isEqualToString:_keyWord]) {
        return;
    }
    [self initDataSource];

    _keyWord = keyWord;
    [self getDataWithPageNum:1];
}

- (void)initDataSource {
    self.dataSource =
        @[WMStoreSkeletonCellModel.new, WMStoreSkeletonCellModel.new, WMStoreSkeletonCellModel.new, WMStoreSkeletonCellModel.new, WMStoreSkeletonCellModel.new, WMStoreSkeletonCellModel.new];
    [self.tableView successGetNewDataWithNoMoreData:YES];
}

- (void)loadMoreData {
    [self getDataWithPageNum:self.currentPage + 1];
}

- (void)getDataWithPageNum:(NSUInteger)pageNum {
    @HDWeakify(self);
    if(HDIsObjectNil(self.currentlyAddress)) {
        self.currentlyAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    }

    [self.viewModel searchWithKeyWord:self.keyWord businessLine:self.businessLine address:self.currentlyAddress pageNum:pageNum pageSize:10
        success:^(SAAggregateSearchResultRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.currentPage = rspModel.pageNum;
            if (pageNum == 1) {
                self.dataSource = [NSArray arrayWithArray:rspModel.list];
                [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            } else {
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.dataSource];
                [tmp addObjectsFromArray:rspModel.list];
                self.dataSource = [NSArray arrayWithArray:tmp];
                [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            if (pageNum == 1) {
                self.dataSource = @[];
                [self.tableView failGetNewData];
            } else {
                [self.tableView failLoadMoreData];
            }
        }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreSearchResultTableViewCell *cell = [WMStoreSearchResultTableViewCell cellWithTableView:tableView];
        WMStoreListItemModel *item = (WMStoreListItemModel *)model;
        item.isShowSaleCount = true;
        item.keyWord = self.keyWord;
        cell.model = item;
        @HDWeakify(self);
        cell.clickedProductViewBlock = ^(NSString *_Nonnull menuId, NSString *_Nonnull productId) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"storeNo"] = item.storeNo;
            params[@"storeName"] = item.storeName.desc;
            params[@"menuId"] = menuId;
            params[@"productId"] = productId;
            params[@"distance"] = [NSNumber numberWithDouble:item.distance];
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        };
        cell.clickedMoreViewBlock = ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"storeNo"] = item.storeNo;
            params[@"storeNo"] = item.storeNo;
            params[@"storeName"] = item.storeName.desc;
            params[@"distance"] = [NSNumber numberWithDouble:item.distance];
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        };
        cell.BlockOnClickPromotion = ^{
            @HDStrongify(self);
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };

        return cell;
    } else if ([model isKindOfClass:GNStoreCellModel.class]) {
        GNStoreViewCell *cell = [GNStoreViewCell cellWithTableView:tableView];
        GNStoreCellModel *trueModel = (GNStoreCellModel *)model;
        trueModel.source = @"AggregateSearch";
        [cell setGNModel:trueModel];
        return cell;
    } else if ([model isKindOfClass:WMStoreSkeletonCellModel.class]) {
        WMStoreSkeletonCell *cell = [WMStoreSkeletonCell cellWithTableView:tableView];
        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:WMStoreSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreListItemModel *item = (WMStoreListItemModel *)model;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"storeNo"] = item.storeNo;
        params[@"storeNo"] = item.storeNo;
        params[@"storeName"] = item.storeName.desc;
        params[@"distance"] = [NSNumber numberWithDouble:item.distance];
        params[@"source"] = self.viewModel.source;
        params[@"associatedId"] = self.viewModel.associatedId;
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
    }
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = YES;
        _tableView.needRefreshHeader = NO;
        _tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#F2F2F2"];
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.image = @"wn_placeholder_nodata";
        placeHolder.imageSize = CGSizeMake(kRealWidth(200), kRealWidth(200));
        placeHolder.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        placeHolder.titleColor = [UIColor hd_colorWithHexString:@"#8F8F8F"];
        placeHolder.needRefreshBtn = NO;
        placeHolder.title = SALocalizedString(@"no_data", @"暂无数据");
        _tableView.placeholderViewModel = placeHolder;
    }
    return _tableView;
}

- (SAAggregateSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAAggregateSearchViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
