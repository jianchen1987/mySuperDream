//
//  WMEatOnTimeActivesProductView.m
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMEatOnTimeActivesProductView.h"


@implementation WMEatOnTimeActivesProductView

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"onTimeModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.pageNo = 1;
        self.headView.buinessTime = self.viewModel.onTimeModel.businessTime;
        self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.onTimeModel.rel.list];
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.onTimeModel.rel.hasNextPage];
        [self.collectionView layoutIfNeeded];
        [self.collectionView sendSubviewToBack:self.headView];
        [self updateMJFoot:!self.viewModel.onTimeModel.rel.hasNextPage];
    }];
}

#pragma mark - Event
- (void)requestNewData {
    @HDWeakify(self);
    [self.viewModel getEatOnTimeWithId:self.viewModel.activeNo pageNo:1 success:^(WMMoreEatOnTimeRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.dataSource = [[NSMutableArray alloc] initWithArray:rspModel.rel.list];
        self.pageNo = rspModel.rel.pageNum;
        [self.collectionView successGetNewDataWithNoMoreData:!rspModel.rel.hasNextPage];
        [self updateMJFoot:!rspModel.rel.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self.collectionView failGetNewData];
    }];
}

- (void)requestMoreData {
    @HDWeakify(self);
    [self.viewModel getEatOnTimeWithId:self.viewModel.activeNo pageNo:++self.pageNo success:^(WMMoreEatOnTimeRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.dataSource addObjectsFromArray:rspModel.rel.list];
        self.pageNo = rspModel.rel.pageNum;
        [self.collectionView successLoadMoreDataWithNoMoreData:!rspModel.rel.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self.collectionView failLoadMoreData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMSpecialActivesProductModel *model = self.dataSource[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = model.storeNo;
    params[@"productId"] = model.productId;
    params[@"funnel"] = @"专题商品";
    params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|按时吃饭专题"] : @"按时吃饭专题";
    params[@"associatedId"] = HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : self.viewModel.activeNo;

    if (self.viewModel.plateId)
        params[@"plateId"] = self.viewModel.plateId;
    if (self.viewModel.topicPageId)
        params[@"topicPageId"] = self.viewModel.topicPageId;
    if (self.viewModel.collectType)
        params[@"collectType"] = self.viewModel.collectType;
    if (self.viewModel.collectContent)
        params[@"collectContent"] = self.viewModel.collectContent;

    [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];

    [self productClickCollectionView:collectionView indexPath:indexPath];
}

- (void)productWillDisplayCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    WMSpecialActivesProductModel *tmpModel = self.dataSource[indexPath.row];
    NSDictionary *param = @{
        @"exposureSort": @(indexPath.row).stringValue,
        @"storeNo": tmpModel.storeNo,
        @"productId": tmpModel.productId,
        @"type": @"eatOnTimeProduct",
        @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
        @"plateId": WMManage.shareInstance.plateId
    };
    [collectionView recordStoreExposureCountWithValue:tmpModel.productId key:tmpModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayProductExposure"];
}

- (void)productClickCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    WMSpecialActivesProductModel *tmpModel = self.dataSource[indexPath.row];
    /// 3.0.19.0 点击
    NSDictionary *param = @{
        @"exposureSort": @(indexPath.row).stringValue,
        @"storeNo": tmpModel.storeNo,
        @"productId": tmpModel.productId,
        @"type": @"eatOnTimeProduct",
        @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
        @"plateId": WMManage.shareInstance.plateId
    };
    [LKDataRecord.shared traceEvent:@"takeawayProductClick" name:@"takeawayProductClick" parameters:param SPM:nil];
}

@end
