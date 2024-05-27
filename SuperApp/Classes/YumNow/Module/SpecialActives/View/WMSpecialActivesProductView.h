//
//  WMSpecialActivesProductView.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionView.h"
#import "SACollectionViewWaterFlowLayout.h"
#import "SAView.h"
#import "WMSpecialActivesPictureView.h"
#import "WMSpecialActivesProductCollectionViewCell.h"
#import "WMSpecialActivesProductModel.h"
#import "WMSpecialActivesProductRspModel.h"
#import "WMSpecialActivesViewModel.h"
#import "WMSpecialPromotionRspModel.h"
#import "UICollectionView+RecordData.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialActivesProductView : SAView <UICollectionViewDelegate, UICollectionViewDataSource, SACollectionViewWaterFlowLayoutDelegate>
/// viewModel
@property (nonatomic, strong) WMSpecialActivesViewModel *viewModel;
/// tableview
@property (nonatomic, strong) SACollectionView *collectionView;
/// tableHeader
@property (nonatomic, strong) WMSpecialActivesPictureView *headView;
/// dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;
/// pageNo
@property (nonatomic, assign) NSUInteger pageNo;
///更新mj底部
- (void)updateMJFoot:(BOOL)isNoMore;
- (void)productClickCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (void)productWillDisplayCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
