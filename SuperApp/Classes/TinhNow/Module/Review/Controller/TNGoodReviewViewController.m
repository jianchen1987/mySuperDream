//
//  TNGoodReviewViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNGoodReviewViewController.h"
#import "SATableView.h"
#import "TNGoodReviewCell+Skeleton.h"
#import "TNGoodReviewCell.h"
#import "TNQueryProductReviewListRspModel.h"
#import "TNReviewDTO.h"


@interface TNGoodReviewViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (strong, nonatomic) SATableView *tableView;
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 列表数据DTO
@property (strong, nonatomic) TNReviewDTO *reviewDTO;
/// 当前rsp
@property (strong, nonatomic) TNQueryProductReviewListRspModel *currentRspModel;
/// 数据源
@property (strong, nonatomic) NSMutableArray<TNProductReviewModel *> *dataArray;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNGoodReviewViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        NSString *productId = parameters[@"productId"];
        if (HDIsStringNotEmpty(productId)) {
            self.productId = productId;
        }
    }
    return self;
}
- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView getNewData];
    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        self.currentRspModel.pageNum = 1;
        [self getReviewListData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        self.currentRspModel.pageNum += 1;
        [self getReviewListData];
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
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_product_reviews", @"全部评论");
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
- (void)getReviewListData {
    @HDWeakify(self);
    [self.reviewDTO queryProductReviewListWithProductId:self.productId pageNum:self.currentRspModel.pageNum pageSize:20 success:^(TNQueryProductReviewListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.currentRspModel = rspModel;
        if (rspModel.pageNum == 1) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:rspModel.content];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self.dataArray addObjectsFromArray:rspModel.content];
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    }];
}
#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNProductReviewModel *model = self.dataArray[indexPath.row];
    TNGoodReviewCell *cell = [TNGoodReviewCell cellWithTableView:tableView];
    cell.model = model;
    @HDWeakify(self);
    cell.clickedUserReviewContentReadMoreOrReadLessBlock = ^{
        @HDStrongify(self);
        model.isExtend = !model.isExtend;
        [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                                           //        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView successLoadMoreDataWithNoMoreData:!self.currentRspModel.hasNextPage]; //全量刷新  不然星星控件和富文本会复用闪现
        }];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
/** @lazy reviewDTO */
- (TNReviewDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = [[TNReviewDTO alloc] init];
    }
    return _reviewDTO;
}
/** @lazy dataArray */
- (NSMutableArray<TNProductReviewModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/** @lazy currentRspModel */
- (TNQueryProductReviewListRspModel *)currentRspModel {
    if (!_currentRspModel) {
        _currentRspModel = [[TNQueryProductReviewListRspModel alloc] init];
        _currentRspModel.pageNum = 1;
    }
    return _currentRspModel;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNGoodReviewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNGoodReviewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 8;
    }
    return _provider;
}
@end
