//
//  WMStoreFavoutiteListController.m
//  SuperApp
//
//  Created by Chaos on 2020/12/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFavoutiteListController.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "WMSearchStoreRspModel.h"
#import "WMShoppingCartSelectedAllView.h"
#import "WMStoreFavouriteDTO.h"
#import "WMStoreSearchResultTableViewCell+Skeleton.h"
#import "WMStoreSearchResultTableViewCell.h"
#import "UITableView+RecordData.h"


@interface WMStoreFavoutiteListController () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 底部全选视图
@property (strong, nonatomic) WMShoppingCartSelectedAllView *selectedAllView;
/// iphoneX底部安全区域
@property (nonatomic, strong) UIView *iphoneXBottomView;
/// 编辑按钮
@property (strong, nonatomic) HDUIButton *editBtn;
/// 数据源
@property (nonatomic, strong) NSMutableArray<WMStoreListItemModel *> *dataSource;
/// DTO
@property (nonatomic, strong) WMStoreFavouriteDTO *storeFavouriteDTO;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 是否处于编辑状态
@property (nonatomic, assign) BOOL onEditing;
/// 当前页码
@property (nonatomic, assign) NSUInteger pageNo;
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;
@end


@implementation WMStoreFavoutiteListController

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"my_collection", @"我的收藏");
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 2;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectedAllView];
    [self.view addSubview:self.iphoneXBottomView];

    [self.tableView getNewData];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        if (self.selectedAllView.isHidden) {
            make.bottom.equalTo(self.iphoneXBottomView.mas_top);
        } else {
            make.bottom.equalTo(self.selectedAllView.mas_top);
        }
    }];
    [self.selectedAllView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(60));
        make.bottom.equalTo(self.iphoneXBottomView.mas_top);
    }];
    [self.iphoneXBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kiPhoneXSeriesSafeBottomHeight);
    }];
    [super updateViewConstraints];
}

#pragma mark - event response
// 编辑按钮点击
- (void)editClick:(HDUIButton *)btn {
    btn.selected = !btn.selected;
    self.onEditing = !self.onEditing;
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedAllView.hidden = !btn.isSelected;
        [self.view setNeedsUpdateConstraints];
    }];
    if (!self.onEditing) {
        [self resetOnEditingStatus];
        [btn setTitle:WMLocalizedStringFromTable(@"wm_edit_btn", @"编辑", @"Buttons") forState:UIControlStateNormal];
    } else {
        [btn setTitle:WMLocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
    }
    [btn sizeToFit];
    [self.tableView successGetNewDataWithNoMoreData:self.tableView.mj_footer.hidden];
}
// 重置编辑状态下的数据 将删除的数据清零
- (void)resetOnEditingStatus {
    for (WMStoreListItemModel *item in self.dataSource) {
        item.isEditSelected = NO;
    }
    [self.selectedAllView setDeleteBtnEnabled:false];
}
// 编辑状态下  全选点击
- (void)onEditingAllSelectClick:(BOOL)isSelectAll {
    //所有门店状态 跟随isSelectAll
    for (WMStoreListItemModel *item in self.dataSource) {
        item.isEditSelected = isSelectAll;
    }
    [self.selectedAllView setDeleteBtnEnabled:isSelectAll];
    [self.tableView successGetNewDataWithNoMoreData:self.tableView.mj_footer.hidden];
}
// 全选状态下 批量删除点击
- (void)onEditingBatchDeleteClick {
    NSMutableArray *deleteItems = [NSMutableArray array];
    for (WMStoreListItemModel *item in self.dataSource) {
        if (item.isEditSelected) {
            [deleteItems addObject:item.storeNo];
        }
    }
    if (!HDIsArrayEmpty(deleteItems)) {
        // 弹窗确认
        [NAT showAlertWithMessage:WMLocalizedString(@"n0pQd2sF", @"确认删除门店吗？") confirmButtonTitle:WMLocalizedStringFromTable(@"not_now", @"Not Now", @"Buttons")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }
            cancelButtonTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                [self batchDeleteStoresWithDeleteItems:deleteItems];
            }];
    }
}
// 更新底部编辑视图状态
- (void)updateSelectedAllViewStatus {
    // 是否选中所有刷新出来的门店
    BOOL isAllSelected = YES;
    for (WMStoreListItemModel *model in self.dataSource) {
        if (!model.isEditSelected) {
            isAllSelected = NO;
            break;
        }
    }
    //设置全选按钮
    [self.selectedAllView setSelectedBtnStatus:isAllSelected];

    //设置删除按钮是否可点击
    BOOL hasSelected = NO; //是否有一个商品被选中了
    for (WMStoreListItemModel *model in self.dataSource) {
        if (model.isEditSelected) {
            hasSelected = YES;
            break;
        }
    }
    [self.selectedAllView setDeleteBtnEnabled:hasSelected];
    [self.tableView successGetNewDataWithNoMoreData:self.tableView.mj_footer.hidden];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;

    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreSearchResultTableViewCell *cell = [WMStoreSearchResultTableViewCell cellWithTableView:tableView];
        WMStoreListItemModel *item = (WMStoreListItemModel *)model;
        item.isShowSaleCount = true;
        cell.onEditing = self.onEditing;
        cell.model = item;
        @HDWeakify(tableView);
        cell.BlockOnClickPromotion = ^{
            @HDStrongify(tableView)[tableView reloadData];
        };
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreListItemModel *item = (WMStoreListItemModel *)model;
        if (self.onEditing) {
            item.isEditSelected = !item.isEditSelected;
            [self updateSelectedAllViewStatus];
        } else {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"storeNo"] = item.storeNo;
            params[@"storeName"] = item.storeName.desc;
            params[@"distance"] = [NSNumber numberWithDouble:item.distance];
            params[@"sourceType"] = WMStoreDetailSourceTypeStoreFavourite;
            params[@"notAddBusinessHomePage"] = @1;
            params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖门店收藏页"] : @"外卖门店收藏页";
            params[@"associatedId"] = self.viewModel.associatedId;
            
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];

            /// 3.0.19.0 点击
            NSDictionary *param = @{
                @"storeNo": item.storeNo,
                @"type": @"collectionStore",
                @"pageSource": [WMManage.shareInstance currentCompleteSource:self includeSelf:YES],
                @"plateId": WMManage.shareInstance.plateId
            };
            [LKDataRecord.shared traceEvent:@"takeawayStoreClick" name:@"takeawayStoreClick" parameters:param SPM:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreListItemModel.class]) {
        WMStoreListItemModel *itemModel = model;
        /// 3.0.19.0 曝光
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": itemModel.storeNo,
            @"type": @"collectionStore",
            @"pageSource": [WMManage.shareInstance currentCompleteSource:self includeSelf:YES],
            @"plateId": WMManage.shareInstance.plateId
        };
        [tableView recordStoreExposureCountWithValue:itemModel.storeNo key:itemModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayStoreExposure"];
    }
}

#pragma mark - private methods
- (void)getData {
    @HDWeakify(self);
    [self.storeFavouriteDTO getFavouriteStoreListWithPageNum:self.pageNo pageSize:10 success:^(WMSearchStoreRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSArray<WMStoreListItemModel *> *list = rspModel.list;
        if (self.onEditing && self.selectedAllView.isSelectedAll) {
            [list enumerateObjectsUsingBlock:^(WMStoreListItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.isEditSelected = true;
            }];
        }
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        BOOL isNoData = false;
        if (self.pageNo == 1) {
            [self.dataSource removeAllObjects];
            if (list.count) {
                [self.dataSource addObjectsFromArray:list];
            } else {
                isNoData = true;
            }
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            if (list.count) {
                [self.dataSource addObjectsFromArray:list];
            }
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
        self.tableView.mj_footer.hidden = isNoData || !rspModel.hasNextPage;
        [self updateNavigationItemWithNoData:isNoData];
        [self updateSelectedAllViewStatus];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        self.pageNo == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
        self.pageNo = MAX(1, self.pageNo - 1);
    }];
}

- (void)batchDeleteStoresWithDeleteItems:(NSArray *)deleteItems {
    [self showloading];
    @HDWeakify(self);
    [self.storeFavouriteDTO removeFavouriteWithStoreNos:deleteItems success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [self.tableView setContentOffset:CGPointZero animated:false];
        //退出编辑模式
        [self editClick:self.editBtn];

        // 重新获取数据
        [self.tableView getNewData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)updateNavigationItemWithNoData:(BOOL)noData {
    if (noData) {
        self.hd_navigationItem.rightBarButtonItem = nil;
    } else {
        self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.provider;
        _tableView.dataSource = self.provider;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.image = @"no_data_placeholder";
        model.title = WMLocalizedString(@"Rm4W1b7k", @"暂无收藏门店");
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.pageNo = 1;
            [self getData];
        };
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.pageNo += 1;
            [self getData];
        };
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

- (WMShoppingCartSelectedAllView *)selectedAllView {
    if (!_selectedAllView) {
        _selectedAllView = [[WMShoppingCartSelectedAllView alloc] init];
        @HDWeakify(self);
        _selectedAllView.selectedAllClickCallBack = ^(BOOL isSelecedAll) {
            @HDStrongify(self);
            [self onEditingAllSelectClick:isSelecedAll];
        };
        _selectedAllView.deleteClickCallBack = ^{
            @HDStrongify(self);
            [self onEditingBatchDeleteClick];
        };
        _selectedAllView.hidden = YES;
    }
    return _selectedAllView;
}

- (HDUIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[HDUIButton alloc] init];
        [_editBtn setTitle:WMLocalizedStringFromTable(@"wm_edit_btn", @"编辑", @"Buttons") forState:UIControlStateNormal];
        [_editBtn setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        _editBtn.titleLabel.font = HDAppTheme.font.standard3;
        [_editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        //        _editBtn.hd_eventTimeInterval = 0.01;
        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 7);
        [_editBtn sizeToFit];
    }
    return _editBtn;
}

- (WMStoreFavouriteDTO *)storeFavouriteDTO {
    if (!_storeFavouriteDTO) {
        _storeFavouriteDTO = WMStoreFavouriteDTO.new;
    }
    return _storeFavouriteDTO;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)iphoneXBottomView {
    if (!_iphoneXBottomView) {
        _iphoneXBottomView = UIView.new;
        _iphoneXBottomView.backgroundColor = UIColor.whiteColor;
    }
    return _iphoneXBottomView;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeOther;
}
- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
