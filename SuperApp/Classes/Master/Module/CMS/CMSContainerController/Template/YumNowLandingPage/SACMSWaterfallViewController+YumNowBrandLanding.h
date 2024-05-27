//
//  SACMSWaterfallViewController+YumNowBrandLanding.h
//  SuperApp
//
//  Created by seeu on 2023/11/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallViewController.h"
#import "HDCollectionViewBaseFlowLayout.h"
#import "YumNowLandingPageStoreListCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSPageViewConfig;
@class SAYumNowLandingPageCategoryRspModel;
@class SACMSWaterfallPageViewConfig;
@class SAYumNowLandingPageCategoryModel;
@class WMNearbyFilterModel;

@interface SACMSWaterfallViewController (YumNowBrandLanding)

///< 分类标题
@property (nonatomic, strong, nullable) SAYumNowLandingPageCategoryRspModel *categoryTitleConfig;
///< 瀑布流配置
@property (nonatomic, strong, nullable) SACMSWaterfallPageViewConfig *landingPageWaterFallConfig;

///< 当前分类
@property (nonatomic, strong, nullable) SAYumNowLandingPageCategoryModel *currentCategoryModel;
///< 当前的筛选
@property (nonatomic, strong, nullable) WMNearbyFilterModel *filterModel;
///< 当前页
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, weak, nullable) YumNowLandingPageStoreListCollectionReusableView *reusableView;

@property (nonatomic, assign) NSInteger currentReusableViewIndex;


- (void)generateYumNowBrandLandingTemplateWithPageConfig:(SACMSPageViewConfig *)pageConfig;

- (void)yumNowBrandLandingTemplateLoadMoreData;


- (UICollectionReusableView *)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (UICollectionViewCell *)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (UIEdgeInsets)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

- (NSInteger)yumNowBrandLandingTemplateCollectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
