//
//  TNHelpBargainRecommendCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHelpBargainRecommendCell.h"
#import "HDAppTheme+TinhNow.h"
#import "HDCollectionViewVerticalLayout.h"
#import "TNBargainGoodModel.h"
#import "TNBargainGoodsCell.h"
#import "TNBargainMoreReusableView.h"
#import "TNCollectionView.h"
#import "TNGoodsCollectionViewCell.h"
#import "TNHelpBargainRecommendCell.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNNewHomeReusableHeaderView.h"


@interface TNHelpBargainRecommendCell () <HDCollectionViewBaseFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
///
@property (nonatomic, strong) TNCollectionView *collectionView;
///
@end


@implementation TNHelpBargainRecommendCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraints {
    self.contentView.hd_width = kScreenWidth;

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(self.contentView);
        make.height.equalTo(@(self.collectionView.collectionViewLayout.collectionViewContentSize.height)).priorityHigh();
    }];
    [super updateConstraints];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView successGetNewDataWithNoMoreData:NO];
    [self layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodModel *gModel = [TNBargainGoodModel modelWithProductModel:trueModel];
            [[HDMediator sharedInstance] navigaveTinhNowBargainProductDetailViewController:@{@"activityId": gModel.activityId}];
        } else {
            [HDMediator.sharedInstance navigaveTinhNowProductDetailViewController:@{@"productId": trueModel.productId}];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodsCell *cell = [TNBargainGoodsCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNBargainGoodsCell.class)];
            cell.model = [TNBargainGoodModel modelWithProductModel:trueModel];
            return cell;
        } else {
            TNGoodsCollectionViewCell *cell = [TNGoodsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNGoodsCollectionViewCell.class)];
            trueModel.cellType = TNGoodsShowCellTypeOnlyGoods;
            cell.model = trueModel;
            return cell;
        }
    } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
        TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                       identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:TNGoodsModel.class]) {
        TNGoodsModel *trueModel = (TNGoodsModel *)model;
        if (trueModel.productType == TNProductTypeBargain) {
            TNBargainGoodModel *bmodel = [TNBargainGoodModel modelWithProductModel:trueModel];
            bmodel.preferredWidth = self.itemWidth;
            return CGSizeMake(self.itemWidth, bmodel.cellHeight);
        } else {
            trueModel.cellType = TNGoodsShowCellTypeOnlyGoods;
            trueModel.preferredWidth = self.itemWidth;
            return CGSizeMake(self.itemWidth, trueModel.cellHeight);
        }
    } else if ([model isKindOfClass:TNHomeChoicenessSkeletonCellModel.class]) {
        return CGSizeMake(self.itemWidth, ChoicenessSkeletonCellHeight);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TNNewHomeReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:NSStringFromClass(TNNewHomeReusableHeaderView.class)
                                                                                            forIndexPath:indexPath];
        headerView.sectionTitle = TNLocalizedString(@"tn_page_recommended_products", @"推荐商品");
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TNBargainMoreReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                   withReuseIdentifier:NSStringFromClass(TNBargainMoreReusableView.class)
                                                                                          forIndexPath:indexPath];
        return footerView;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth, kRealHeight(60));
    } else {
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kRealWidth(50));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kRealWidth(0), kRealWidth(15), kRealWidth(15), kRealWidth(15));
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

#pragma mark -
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _collectionView.scrollEnabled = NO;
        _collectionView.needRefreshHeader = NO;
        _collectionView.needRefreshFooter = NO;
        _collectionView.mj_footer.hidden = YES;
        [_collectionView registerClass:TNNewHomeReusableHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNNewHomeReusableHeaderView.class)];
        [_collectionView registerClass:TNBargainMoreReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:NSStringFromClass(TNBargainMoreReusableView.class)];
    }
    return _collectionView;
}

@end
