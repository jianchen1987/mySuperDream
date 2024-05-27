//
//  TNNotReviewViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNotReviewViewController.h"
#import "SATableView.h"
#import "TNMyNotReviewListRspModel.h"
#import "TNMyReviewDTO.h"
#import "TNNotReviewFooterView.h"
#import "TNNotReviewGoodCell+Skeleton.h"
#import "TNNotReviewGoodCell.h"
#import "TNNotReviewHeaderView.h"
#import "TNNotificationConst.h"


@interface TNNotReviewViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (strong, nonatomic) SATableView *tableView;
/// dto
@property (strong, nonatomic) TNMyReviewDTO *reviewDTO;
/// 数据源
@property (strong, nonatomic) NSMutableArray<TNMyNotReviewModel *> *dataArray;
/// 当前rspModel
@property (strong, nonatomic) TNMyNotReviewListRspModel *currentRspModel;
/// 提示评价视图视图
@property (strong, nonatomic) HDLabel *tipLabel;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNNotReviewViewController
- (void)hd_setupViews {
    [self.view addSubview:self.tipLabel];
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
    if (!self.tipLabel.isHidden) {
        [self.tipLabel sizeToFit];
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
        }];
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipLabel.isHidden) {
            make.top.equalTo(self.tipLabel.mas_bottom);
        } else {
            make.top.equalTo(self.view);
        }
        make.left.right.bottom.equalTo(self.view);
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
    NSDictionary *dic = noti.userInfo;
    NSString *orderNo = dic[@"orderNo"];
    if (HDIsStringNotEmpty(orderNo)) {
        //删除本地待评论数据
        if (!HDIsArrayEmpty(self.dataArray)) {
            for (TNMyNotReviewModel *model in self.dataArray) {
                if ([model.unifiedOrderNo isEqualToString:orderNo]) {
                    [self.dataArray removeObject:model];
                    [self.tableView successLoadMoreDataWithNoMoreData:!self.currentRspModel.hasNextPage];
                    break;
                }
            }
        }
    }
}
#pragma mark - 获取列表数据
- (void)getReviewListData {
    @HDWeakify(self);
    [self.reviewDTO queryMyNotReviewListWithPageNum:self.currentRspModel.pageNum pageSize:20 success:^(TNMyNotReviewListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.currentRspModel = rspModel;
        if (rspModel.pageNum == 1) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:rspModel.list];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            [self showTipsLabel];
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
#pragma mark - 显示提示文本
- (void)showTipsLabel {
    self.tipLabel.hidden = HDIsArrayEmpty(self.dataArray);
    [self.view setNeedsUpdateConstraints];
}
#pragma mark - tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TNMyNotReviewModel *model = self.dataArray[section];
    return model.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNMyNotReviewModel *model = self.dataArray[indexPath.section];
    TNMyNotReviewGoodInfo *goodInfo = model.items[indexPath.row];
    TNNotReviewGoodCell *cell = [TNNotReviewGoodCell cellWithTableView:tableView];
    cell.info = goodInfo;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TNMyNotReviewModel *model = self.dataArray[section];
    TNNotReviewHeaderView *headerView = [TNNotReviewHeaderView headerWithTableView:tableView];
    headerView.storeInfo = model.storeInfo;
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TNMyNotReviewModel *model = self.dataArray[section];
    TNNotReviewFooterView *footerView = [TNNotReviewFooterView headerWithTableView:tableView];
    footerView.reviewClickCallBack = ^{
        [HDMediator.sharedInstance navigaveToTinhNowPostReviewlViewController:@{@"orderNo": model.unifiedOrderNo}];
    };
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TNMyNotReviewModel *model = self.dataArray[indexPath.section];
    [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": model.unifiedOrderNo}];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealWidth(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRealWidth(60);
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
/** @lazy reviewDTO */
- (TNMyReviewDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = [[TNMyReviewDTO alloc] init];
    }
    return _reviewDTO;
}
- (TNMyNotReviewListRspModel *)currentRspModel {
    if (!_currentRspModel) {
        _currentRspModel = [[TNMyNotReviewListRspModel alloc] init];
    }
    return _currentRspModel;
}
/** @lazy dataArray */
- (NSMutableArray<TNMyNotReviewModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/** @lazy tipLabel */
- (HDLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[HDLabel alloc] init];
        _tipLabel.backgroundColor = HexColor(0xFFF7E8);
        _tipLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _tipLabel.font = HDAppTheme.TinhNowFont.standard12;
        _tipLabel.hd_edgeInsets = UIEdgeInsetsMake(7, 15, 7, 15);
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = TNLocalizedString(@"tn_write_review_timeout_tips_k", @"请在10天内完成评价，10天后系统默认好评");
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNNotReviewGoodCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNNotReviewGoodCell skeletonViewHeight];
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
