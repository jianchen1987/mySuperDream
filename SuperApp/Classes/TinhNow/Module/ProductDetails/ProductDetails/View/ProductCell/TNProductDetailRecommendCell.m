//
//  TNProductDetailRecommendCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductDetailRecommendCell.h"
#import "HDAppTheme+TinhNow.h"
#import "HDCollectionViewVerticalLayout.h"
#import "TNCollectionView.h"
#import "TNEventTracking.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNGoodsModel.h"
#import "TNQueryGoodsRspModel.h"


@interface TNProductDetailRecommendCell () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
/// collection
@property (nonatomic, strong) TNCollectionView *collectionView;
///
@property (nonatomic, assign) CGFloat collectionViewHeight;
///
@property (strong, nonatomic) TNProductDetailRecommendCellModel *oldModel;
@end


@implementation TNProductDetailRecommendCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.collectionView];
}
- (void)setModel:(TNProductDetailRecommendCellModel *)model {
    _model = model;
    if (HDIsObjectNil(self.oldModel) || ![self.oldModel.goodsArray isEqualToArray:model.goodsArray]) {
        [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.collectionViewHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.collectionViewHeight);
            }];
            !self.reloadSectionCallBack ?: self.reloadSectionCallBack();
        });
        self.oldModel = model;
    }
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(self.collectionViewHeight);
    }];
}
#pragma mark - CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.goodsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(TNGoodsCollectionViewCell.class) forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TNGoodsCollectionViewCell *goodCell = (TNGoodsCollectionViewCell *)cell;
    TNGoodsModel *model = self.model.goodsArray[indexPath.row];
    goodCell.model = model;

    //记录曝光商品位置
    [TNEventTrackingInstance startRecordingExposureIndexWithProductId:model.productId];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TNGoodsModel *model = self.model.goodsArray[indexPath.row];
    [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": model.productId, @"sp": self.model.sp}];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNGoodsModel *model = self.model.goodsArray[indexPath.row];
    model.preferredWidth = self.itemWidth;
    return CGSizeMake(self.itemWidth, model.cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(10), kRealWidth(15));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}
- (CGFloat)itemWidth {
    return (kScreenWidth - kRealWidth(40)) / 2;
}
/** @lazy collectionView */
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.header_suspension = YES;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _collectionView.needRefreshHeader = NO;
        _collectionView.needRefreshFooter = NO;
        [_collectionView registerClass:[TNGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];
    }
    return _collectionView;
}
@end


@implementation TNProductDetailRecommendCellModel

@end
