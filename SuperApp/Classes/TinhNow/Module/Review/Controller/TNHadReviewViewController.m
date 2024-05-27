//
//  TNHadReviewViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHadReviewViewController.h"
#import "SATableView.h"
#import "TNGoodReviewCell+Skeleton.h"
#import "TNGoodReviewCell.h"
#import "TNMyHadReviewListRspModel.h"
#import "TNMyReviewDTO.h"
#import "TNNotificationConst.h"


@interface TNHadReviewViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (strong, nonatomic) SATableView *tableView;
/// 数据源
@property (strong, nonatomic) NSMutableArray<TNProductReviewModel *> *dataArray;
/// dto
@property (strong, nonatomic) TNMyReviewDTO *reviewDTO;
/// 当前rspModel
@property (strong, nonatomic) TNMyHadReviewListRspModel *currentRspModel;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNHadReviewViewController
- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self addNotification];
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

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 添加评论成功通知
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postReivewSuccess:) name:kTNNotificationNamePostReviewSuccess object:nil];
}
#pragma mark - 发布评论成功处理
- (void)postReivewSuccess:(NSNotification *)noti {
    //重新拉取最新评论数据
    [self.tableView getNewData];
}
- (void)getReviewListData {
    @HDWeakify(self);
    [self.reviewDTO queryMyHadReviewListWithPageNum:self.currentRspModel.pageNum pageSize:20 success:^(TNMyHadReviewListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.currentRspModel = rspModel;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (rspModel.pageNum == 1) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[rspModel getTransformProductReviewList]];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self.dataArray addObjectsFromArray:[rspModel getTransformProductReviewList]];
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
        [UIView performWithoutAnimation:^{                                                        //防止iOS13以下 刷新晃动的问题
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
- (TNMyReviewDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = [[TNMyReviewDTO alloc] init];
    }
    return _reviewDTO;
}
- (TNMyHadReviewListRspModel *)currentRspModel {
    if (!_currentRspModel) {
        _currentRspModel = [[TNMyHadReviewListRspModel alloc] init];
    }
    return _currentRspModel;
}
/** @lazy dataArray */
- (NSMutableArray<TNProductReviewModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
@end
