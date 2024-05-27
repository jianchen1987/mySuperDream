//
//  WMNewSpecialActivesProductSubView.m
//  SuperApp
//
//  Created by Tia on 2023/7/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewSpecialActivesProductSubView.h"


@interface WMNewSpecialActivesProductSubView ()
/// offset
@property (nonatomic, assign) CGFloat offset;

@end


@implementation WMNewSpecialActivesProductSubView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel categoryNo:(NSString *)categoryNo {
    self.viewModel = viewModel;
    self.categoryNo = categoryNo;
    return [super initWithViewModel:viewModel];
}

- (void)pageViewDidAppear {
    if (!self.dataSource.count) {
        [self requestNewData];
    }
}


- (void)hd_setupViews {
    self.pageNo = 1;
    self.backgroundColor = [UIColor hd_colorWithHexString:@"#F7F7F7"];
    [self addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"productList" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.pageNo = 1;
        self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.productList];
        [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.proModel.products.hasNextPage];
        [self updateMJFoot:!self.viewModel.proModel.products.hasNextPage];
    }];
}

///更新mj底部
- (void)updateMJFoot:(BOOL)isNoMore {
    if (isNoMore && self.dataSource) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        self.collectionView.mj_footer.hidden = NO;
    }
}

#pragma mark - Event
- (void)requestNewData {
    @HDWeakify(self);
    [self.viewModel getSpecialActivesWithPageNo:1 pageSize:10 categoryNo:self.categoryNo success:^(WMSpecialPromotionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.dataSource = [[NSMutableArray alloc] initWithArray:rspModel.products.list];
        self.pageNo = rspModel.products.pageNum;
        [self.collectionView successGetNewDataWithNoMoreData:!rspModel.products.hasNextPage];
        [self updateMJFoot:!rspModel.products.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.collectionView failGetNewData];
    }];
}

- (void)requestMoreData {
    @HDWeakify(self);
    [self.viewModel getSpecialActivesWithPageNo:++self.pageNo pageSize:10 categoryNo:self.categoryNo success:^(WMSpecialPromotionRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.dataSource addObjectsFromArray:rspModel.products.list];
        self.pageNo = rspModel.products.pageNum;
        [self.collectionView successLoadMoreDataWithNoMoreData:!rspModel.products.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.collectionView failLoadMoreData];
    }];
}

- (void)productWillDisplayCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    WMSpecialActivesProductModel *tmpModel = self.dataSource[indexPath.row];
    NSDictionary *param = @{
        @"exposureSort": @(indexPath.row).stringValue,
        @"storeNo": tmpModel.storeNo,
        @"productId": tmpModel.productId,
        @"type": @"customTopicPageProduct",
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
        @"type": @"customTopicPageProduct",
        @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:YES],
        @"plateId": WMManage.shareInstance.plateId
    };
    [LKDataRecord.shared traceEvent:@"takeawayProductClick" name:@"takeawayProductClick" parameters:param SPM:nil];
}

#pragma mark - CollectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMNewSpecialActivesProductCollectionViewCell *cell = [WMNewSpecialActivesProductCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    WMSpecialActivesProductModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMSpecialActivesProductModel *model = self.dataSource[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = model.storeNo;
    params[@"productId"] = model.productId;
    params[@"funnel"] = @"专题商品";
    params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|商品专题"] : @"商品专题";
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self productWillDisplayCollectionView:collectionView indexPath:indexPath];
}

#pragma mark - SACollectionViewWaterFlowLayoutDelegate
- (CGSize)waterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMSpecialActivesProductModel *model = self.dataSource[indexPath.row];
    CGFloat width = floor((kScreenWidth - kRealWidth(40)) / 2.0);
    model.preferredWidth = width;
    return CGSizeMake(width, model.cellNewHeight);
}

- (NSUInteger)columnCountInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout {
    return 2;
}

- (CGFloat)columnMarginInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout {
    return kRealWidth(10);
}

- (CGFloat)rowMarginInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout {
    return kRealWidth(10);
}

- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(8, 12, 12, 12);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.offset = scrollView.contentOffset.y;
}

#pragma mark - lazy load
/** @lazy tableview */
- (SACollectionView *)collectionView {
    if (!_collectionView) {
        SACollectionViewWaterFlowLayout *flowLayout = SACollectionViewWaterFlowLayout.new;
        flowLayout.flowLayoutStyle = SAWaterFlowVerticalEqualWidth;
        flowLayout.delegate = self;
        _collectionView = [[SACollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.needRefreshHeader = NO;
        _collectionView.needRefreshFooter = YES;
        _collectionView.backgroundColor = [UIColor hd_colorWithHexString:@"#F7F7F7"];
        _collectionView.needShowNoDataView = YES;
        @HDWeakify(self);
        //        _collectionView.requestNewDataHandler = ^{
        //            @HDStrongify(self);
        //            [self requestNewData];
        //        };
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self requestMoreData];
        };
    }
    return _collectionView;
}

- (UIScrollView *)getMyScrollView {
    return self.collectionView;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

- (CGFloat)itemWidth {
    return (kScreenWidth - kRealWidth(40)) / 2.0;
}

@end
