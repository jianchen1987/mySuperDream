//
//  SACMSWaterfallViewController.h
//  SuperApp
//
//  Created by seeu on 2021/12/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSContainerDefine.h"
#import "SACollectionView.h"
#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSCustomCollectionCellModel;
@class SAAddressModel;

@protocol CMSContainerCustomCardViewProtocol <NSObject>

@optional
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInArea:(CMSContainerCustomSection)customArea;

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
                                  inArea:(CMSContainerCustomSection)customArea;

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(nonnull NSIndexPath *)indexPath
                                      inArea:(CMSContainerCustomSection)customArea;

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtRow:(NSUInteger)row
                inArea:(CMSContainerCustomSection)customArea;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
        sizeForItemAtRow:(NSUInteger)row
                  inArea:(CMSContainerCustomSection)customArea;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInArea:(CMSContainerCustomSection)customArea;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
                  insetForArea:(CMSContainerCustomSection)customArea;

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForArea:(CMSContainerCustomSection)customArea;

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForArea:(CMSContainerCustomSection)customArea;

/// 当前位置发生了变化
/// @param address 当前位置, 未授权会返回空值
- (void)locationDidChanged:(SAAddressModel *_Nullable)address;

@end


@class SACMSPageViewConfig;

@interface SACMSWaterfallViewController : SALoginlessViewController <CMSContainerCustomCardViewProtocol>

///< CMS 容器, 默认约束是在NavigationBar下面，如需修改，重写约束
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) HDTableViewSectionModel *waterfallSection; ///< 瀑布流section
@property (nonatomic, strong) HDTableViewSectionModel *noDataSection; ///< noData

@property (nonatomic, strong, readonly) SACollectionView *collectionView;
@property (nonatomic, strong, readonly) SAAddressModel *currentAddress;   ///< 当前位置
@property (nonatomic, strong, readonly) NSArray<HDTableViewSectionModel *> *dataSource; ///< 数据源
@property (nonatomic, copy, readonly) NSString *taskId; ///< 任务中心参数
@property (nonatomic, assign, readonly) BOOL isRedirectionParams;
@property (nonatomic, strong, readonly) SACMSPageViewConfig *pageConfig;


// 请求数据接口，默认调用，非必要不要重写
- (void)getNewData;
// 特殊场景，需要自己传入经纬度使用，非必要不需要主动调起， 使用该接口需要重写- (void)getNewData
- (void)getNewDataWithAddressModel:(SAAddressModel *_Nullable)addressModel;
/// 根据现有数据刷新页面，不会重新请求
- (void)reloadWithNoMoreData:(BOOL)noMore;


- (void)registerClass:(nullable Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;

// 以下方法需要在派生类中调用super
- (void)scrollViewDidScroll:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView NS_REQUIRES_SUPER;


// 触发登录 登出的回调
- (void)loginSuccessHandler NS_REQUIRES_SUPER;
- (void)logoutHandler NS_REQUIRES_SUPER;

- (void)firstLoadSuccessHandler;

@end

NS_ASSUME_NONNULL_END
