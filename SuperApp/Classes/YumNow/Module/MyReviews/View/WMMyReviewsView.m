//
//  WMMyReviewsView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMyReviewsView.h"
#import "SATableView.h"
#import "WMMyReviewsViewModel.h"
#import "WMStoreProductDetailRspModel.h"
#import "WMStoreProductReviewCell.h"
#import "WMStoreProductReviewModel.h"


@interface WMMyReviewsView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) WMMyReviewsViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<WMStoreProductReviewModel *> *dataSource;
@end


@implementation WMMyReviewsView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel loadMoreData];
    };
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    self.viewModel.successGetNewDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource, BOOL hasNextPage) {
        @HDStrongify(self);
        self.dataSource = dataSource;
        [self.tableView successGetNewDataWithNoMoreData:!hasNextPage];
    };
    self.viewModel.successLoadMoreDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource, BOOL hasNextPage) {
        @HDStrongify(self);
        self.dataSource = dataSource;
        [self.tableView successLoadMoreDataWithNoMoreData:!hasNextPage];
    };
    self.viewModel.failedGetNewDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        [self.tableView failGetNewData];
    };
    self.viewModel.failedLoadMoreDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        [self.tableView failLoadMoreData];
    };
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - event response

#pragma mark - public methods
- (void)getNewData {
    [self.tableView getNewData];
}

#pragma mark - private methods

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreProductReviewModel.class]) {
        WMStoreProductReviewCell *cell = [WMStoreProductReviewCell cellWithTableView:tableView];
        WMStoreProductReviewModel *trueModel = (WMStoreProductReviewModel *)model;
        trueModel.cellType = WMStoreProductReviewCellTypeMyReview;
        cell.model = trueModel;
        @HDWeakify(cell);
        @HDWeakify(self);
        cell.clickedUserReviewContentReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            @HDStrongify(self);
            cell.model.isUserReviewContentExpanded = !cell.model.isUserReviewContentExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };

        cell.clickedMerchantReplyReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            @HDStrongify(self);
            cell.model.isMerchantReplyExpanded = !cell.model.isMerchantReplyExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        
        cell.clickedStoreInfoBlock = ^(NSString * _Nonnull storeNo) {
            [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
                @"storeNo" : storeNo,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖我的评论页"] : @"外卖我的评论页",
                @"associatedId" : self.viewModel.associatedId
            }];
        };

        cell.clickedProductItemBlock = ^(NSString *_Nonnull goodsId, NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [self showloading];
            [self.viewModel getStoreProductDetailInfoWithGoodsId:goodsId success:^(WMStoreProductDetailRspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [self dismissLoading];
                if (rspModel.status == WMGoodsStatusOff) {
                    [NAT showToastWithTitle:nil content:WMLocalizedString(@"product_no_longer_available", @"product is no longer available") type:HDTopToastTypeError];
                } else {
                    [HDMediator.sharedInstance navigaveToStoreProductDetailController:@{
                        @"goodsId": goodsId,
                        @"storeNo": storeNo,
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖我的评论页"] : @"外卖我的评论页",
                        @"associatedId" : self.viewModel.associatedId
                    }];
                }
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self dismissLoading];
            }];
        };

        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreProductReviewModel.class]) {
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}
@end
