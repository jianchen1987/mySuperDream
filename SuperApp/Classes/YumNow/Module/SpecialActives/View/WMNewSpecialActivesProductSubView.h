//
//  WMNewSpecialActivesProductSubView.h
//  SuperApp
//
//  Created by Tia on 2023/7/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SACollectionView.h"
#import "SACollectionViewWaterFlowLayout.h"
#import "SAView.h"
#import "WMSpecialActivesPictureView.h"
#import "WMNewSpecialActivesProductCollectionViewCell.h"
#import "WMSpecialActivesProductModel.h"
#import "WMSpecialActivesProductRspModel.h"
#import "WMSpecialActivesViewModel.h"
#import "WMSpecialPromotionRspModel.h"
#import "UICollectionView+RecordData.h"
#import "WMZPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewSpecialActivesProductSubView : SAView <UICollectionViewDelegate, UICollectionViewDataSource, SACollectionViewWaterFlowLayoutDelegate, WMZPageProtocol>
/// viewModel
@property (nonatomic, strong) WMSpecialActivesViewModel *viewModel;
/// tableview
@property (nonatomic, strong) SACollectionView *collectionView;
/// dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;
/// pageNo
@property (nonatomic, assign) NSUInteger pageNo;
/// 商品品类编码
@property (nonatomic, copy) NSString *categoryNo;

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel categoryNo:(NSString *_Nullable)categoryNo;
///更新mj底部
- (void)updateMJFoot:(BOOL)isNoMore;
- (void)productClickCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (void)productWillDisplayCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
