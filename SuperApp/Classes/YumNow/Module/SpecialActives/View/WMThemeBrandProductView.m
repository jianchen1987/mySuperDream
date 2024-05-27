//
//  WMThemeBrandProductView.m
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMThemeBrandProductView.h"
#import "WMBrandThemeTableViewCell.h"
#import "WMSpecialBrandPagingModel.h"


@implementation WMThemeBrandProductView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.collectionView registerClass:WMBrandThemeItemCardCell.class forCellWithReuseIdentifier:@"WMBrandThemeItemCardCell"];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"brandList" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.pageNo = 1;
        self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.brandList];
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.proModel.brands.hasNextPage];
        [self updateMJFoot:!self.viewModel.proModel.brands.hasNextPage];
    }];
}

#pragma mark - Event
- (void)requestNewData {
    @HDWeakify(self);
    [self.viewModel getSpecialActivesWithPageNo:1 pageSize:10 success:^(WMSpecialPromotionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.dataSource = [[NSMutableArray alloc] initWithArray:rspModel.brands.list];
        self.pageNo = rspModel.brands.pageNum;
        [self.collectionView successGetNewDataWithNoMoreData:!rspModel.brands.hasNextPage];
        [self updateMJFoot:!rspModel.brands.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.collectionView failGetNewData];
    }];
}

- (void)requestMoreData {
    @HDWeakify(self);
    [self.viewModel getSpecialActivesWithPageNo:++self.pageNo pageSize:10 success:^(WMSpecialPromotionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.dataSource addObjectsFromArray:rspModel.brands.list];
        self.pageNo = rspModel.brands.pageNum;
        [self.collectionView successLoadMoreDataWithNoMoreData:!rspModel.brands.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.collectionView failLoadMoreData];
    }];
}

- (CGSize)waterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = 170 / 375.0 * kScreenWidth;
    return CGSizeMake(itemWidth, itemWidth + kRealHeight(25));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMBrandThemeItemCardCell *cell = [WMBrandThemeItemCardCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    WMSpecialBrandModel *model = (WMSpecialBrandModel *)self.dataSource[indexPath.row];
    [cell setGNModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMSpecialBrandModel *model = (WMSpecialBrandModel *)self.dataSource[indexPath.row];
    if ([model.link containsString:@"storeDetail"] || [model.link containsString:@"specialActivity"]) {
        if ([SAWindowManager canOpenURL:model.link]) {
            [SAWindowManager openUrl:model.link withParameters:@{
                @"collectType": self.viewModel.collectType,
                @"plateId": self.viewModel.plateId, @"from": @"TOPIC_PAGE",
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|品牌专题"] : @"品牌专题",
                @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : self.viewModel.activeNo
                
            }];
        }
    } else {
        if ([SAWindowManager canOpenURL:model.link])
            [SAWindowManager openUrl:model.link withParameters:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|品牌专题"] : @"品牌专题",
                @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : self.viewModel.activeNo
            }];
    }
    [self productClickCollectionView:collectionView indexPath:indexPath];
}

- (void)productWillDisplayCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    WMSpecialBrandModel *model = (WMSpecialBrandModel *)self.dataSource[indexPath.row];
    /// 3.0.19.0
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"exposureSort": @(indexPath.row).stringValue,
        @"type": @"brandTopicPage",
        @"plateId": WMManage.shareInstance.plateId,
        @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
        @"activityNo": model.link
    }];
    [collectionView recordStoreExposureCountWithValue:model.name.desc key:model.showTime indexPath:indexPath info:param eventName:@"takeawayBrandExposure"];
}

- (void)productClickCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    WMSpecialBrandModel *model = (WMSpecialBrandModel *)self.dataSource[indexPath.row];
    /// 3.0.19.0
    NSDictionary *param = @{
        @"exposureSort": @(indexPath.row).stringValue,
        @"activityNo": model.link,
        @"type": @"brandTopicPage",
        @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
        @"plateId": WMManage.shareInstance.plateId
    };
    [LKDataRecord.shared traceEvent:@"takeawayBrandClick" name:@"takeawayBrandClick" parameters:param SPM:nil];
}

@end
