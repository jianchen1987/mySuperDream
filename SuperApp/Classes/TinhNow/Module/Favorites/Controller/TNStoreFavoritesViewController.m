//
//  TNStoreFavoritesViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreFavoritesViewController.h"
#import "SATableView.h"
#import "TNFavoritesCell+Skeleton.h"
#import "TNFavoritesCell.h"
#import "TNFavoritesDTO.h"
#import "TNStoreFavoritesModel.h"
#import "TNStoreFavoritesRspModel.h"


@interface TNStoreFavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (strong, nonatomic) SATableView *tableView;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// dto
@property (strong, nonatomic) TNFavoritesDTO *favoriteDto;
/// 数据源
@property (strong, nonatomic) NSMutableArray<TNStoreFavoritesModel *> *dataArray;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
@end


@implementation TNStoreFavoritesViewController
- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView getNewData];
    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        self.currentPage = 1;
        [self getStoreFavoriteListData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        self.currentPage += 1;
        [self getStoreFavoriteListData];
    };
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            self.tableView.dataSource = self.provider;
            self.tableView.delegate = self.provider;
            [self.tableView successGetNewDataWithNoMoreData:true];
        }
    };
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - 获取店铺收藏列表数据
- (void)getStoreFavoriteListData {
    @HDWeakify(self);
    [self.favoriteDto queryStoreFavoritesListWithPageNum:self.currentPage pageSize:20 success:^(TNStoreFavoritesRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.currentPage = rspModel.pageNum;
        if (rspModel.pageNum == 1) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:rspModel.list];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self.dataArray addObjectsFromArray:rspModel.list];
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    }];
}
#pragma mark - 删除收藏店铺
- (void)removeStoreFavorite:(NSString *)favariteId storeType:(NSInteger)storeType supplierId:(NSString *)supplierId {
    [self.view showloading];
    @HDWeakify(self);
    [self.favoriteDto removeStoreFavoriteByID:favariteId storeType:storeType supplierId:supplierId success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        [HDTips showWithText:TNLocalizedString(@"8N0AYQDY", @"删除成功") inView:self.view hideAfterDelay:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger i = 0;
            for (TNStoreFavoritesModel *model in self.dataArray) {
                if ([model.storeFavoriteId isEqualToString:favariteId]) {
                    [self.dataArray removeObjectAtIndex:i];
                    break;
                }
                i += 1;
            }
            [self.tableView successLoadMoreDataWithNoMoreData:NO];
        });
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark - tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNStoreFavoritesModel *model = self.dataArray[indexPath.section];
    TNFavoritesCell *cell = [TNFavoritesCell cellWithTableView:tableView];
    cell.storeModel = model;
    @HDWeakify(self);
    cell.storeDeleteCallBack = ^(TNStoreFavoritesModel *_Nonnull model) {
        @HDStrongify(self);
        [NAT showAlertWithMessage:TNLocalizedString(@"zKRyQ77T", @"您确定要删除吗") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismissCompletion:^{
                    [self removeStoreFavorite:model.storeFavoriteId storeType:model.isMicroShop supplierId:model.supplierFavoriteRespDto.supplierId];
                }];
            }
            cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TNStoreFavoritesModel *model = self.dataArray[indexPath.section];
    if (model.isMicroShop) {
        [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"sp": model.supplierFavoriteRespDto.supplierId}];
    } else {
        [[HDMediator sharedInstance] navigaveToTinhNowStoreInfoViewController:@{@"storeNo": model.storeId}];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRealWidth(10);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_footer.hidden = YES;
    }
    return _tableView;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNFavoritesCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNFavoritesCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 8;
    }
    return _provider;
}
/** @lazy favoriteDto */
- (TNFavoritesDTO *)favoriteDto {
    if (!_favoriteDto) {
        _favoriteDto = [[TNFavoritesDTO alloc] init];
    }
    return _favoriteDto;
}
/** @lazy dataArray */
- (NSMutableArray<TNStoreFavoritesModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
@end
