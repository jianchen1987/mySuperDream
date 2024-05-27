//
//  SACMSWaterfallViewController+waterfall.h
//  SuperApp
//
//  Created by seeu on 2023/11/29.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallViewController.h"
#import "HDCollectionViewBaseFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSPageViewConfig;
@class SACMSWaterfallCategoryCollectionReusableViewModel;
@class SACMSCategoryTitleModel;
@class SACMSWaterfallPageViewConfig;


@interface SACMSWaterfallViewController (waterfall)

///< 当前页
@property (nonatomic, assign) NSUInteger currentPage;
///< 瀑布流配置
@property (nonatomic, strong, nullable) SACMSWaterfallPageViewConfig *waterfallConfig;
///< 分类配置
@property (nonatomic, strong, nullable) SACMSWaterfallCategoryCollectionReusableViewModel *categoryTitleViewConfig;
///< 当前分类
@property (nonatomic, strong, nullable) SACMSCategoryTitleModel *currentCategory;


- (void)generateWaterfallTemplateWithPageConfig:(SACMSPageViewConfig *)pageConfig;

- (void)waterfallTemplateLoadMoreData;


- (UICollectionReusableView *)waterfallTemplateCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (UICollectionViewCell *)waterfallTemplateCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)waterfallTemplateCollectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)waterfallTemplateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (UIEdgeInsets)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

- (NSInteger)waterfallTemplateCollectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
