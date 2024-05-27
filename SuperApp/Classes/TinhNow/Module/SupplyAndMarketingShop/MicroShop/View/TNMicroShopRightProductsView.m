//
//  TNMicroShopRightProductsView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopRightProductsView.h"
#import "TNCollectionView.h"
#import "TNMarkupPriceSettingAlertView.h"
#import "TNMicroShopProductCell.h"
#import "TNMicroShopProductSkeletonCell.h"
#import "TNMicroShopViewModel.h"


@interface TNMicroShopRightProductsView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) HDUIButton *selectedAllButton;  /// 全选按钮
@property (strong, nonatomic) HDUIButton *batchSettingButton; /// 批量设置按钮
@property (nonatomic, strong) TNCollectionView *collectionView;
@property (nonatomic, assign) BOOL isShowSelected;           ///< 是否展示多选按钮
@property (strong, nonatomic) UIView *batchOprateView;       ///< 全选操作视图
@property (strong, nonatomic) HDUIButton *deleteButton;      ///<删除按钮
@property (strong, nonatomic) HDUIButton *changePriceButton; ///<改价按钮
/// viewModel
@property (strong, nonatomic) TNMicroShopViewModel *viewModel;
@end


@implementation TNMicroShopRightProductsView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.selectedAllButton];
    [self.headerView addSubview:self.batchSettingButton];
    [self addSubview:self.collectionView];
    [self addSubview:self.batchOprateView];
    [self.batchOprateView addSubview:self.deleteButton];
    [self.batchOprateView addSubview:self.changePriceButton];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    self.viewModel.productFailGetNewDataCallback = ^{
        @HDStrongify(self);
        [self.viewModel.productList removeAllObjects];
        [self.collectionView failGetNewData];
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"productsRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.viewModel.currentPage == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        }
    }];
}
#pragma mark -批量删除商品
- (void)batchDeleteProduct:(NSArray<TNSellerProductModel *> *)selectedArr {
    @HDWeakify(self);
    [self.viewModel batchDeleteProductsByProductArr:selectedArr complete:^{
        @HDStrongify(self);
        [self.batchSettingButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.selectedAllButton.selected = NO;
        [self removeProductsFromList:selectedArr];
    }];
}
#pragma mark -批量修改商品价格
- (void)batchChangeProductPrice {
    NSArray *selectedArr = [self getSelectedProductArr];
    if (HDIsArrayEmpty(selectedArr)) {
        return;
    }

    TNMarkupPriceSettingConfig *config = [TNMarkupPriceSettingConfig defaultConfig];
    config.type = TNMarkupPriceSettingTypeBatchProduct;
    config.products = [selectedArr mapObjectsUsingBlock:^id _Nonnull(TNSellerProductModel *_Nonnull obj, NSUInteger idx) {
        return obj.productId;
    }];
    TNMarkupPriceSettingAlertView *alertView = [[TNMarkupPriceSettingAlertView alloc] initAlertViewWithConfig:config];
    @HDWeakify(self);
    alertView.setPricePolicyCompleteCallBack = ^{
        @HDStrongify(self);
        [self.batchSettingButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.selectedAllButton.selected = NO;
        [self.viewModel getProductsNewData:YES];
    };
    [alertView show];
}

//从列表移除商品
- (void)removeProductsFromList:(NSArray<TNSellerProductModel *> *)removes {
    //有下一页就重新刷新页面
    [self.viewModel.productList removeObjectsInArray:removes];
    [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
    if (HDIsArrayEmpty(self.viewModel.productList)) {
        !self.deleteAllProductsCallBack ?: self.deleteAllProductsCallBack();
    }
}

- (NSArray<TNSellerProductModel *> *)getSelectedProductArr {
    NSMutableArray *array = [NSMutableArray array];
    for (TNSellerProductModel *model in self.viewModel.productList) {
        if (model.isSelected) {
            [array addObject:model];
        }
    }
    return array;
}

- (void)updateConstraints {
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(60));
    }];
    [self.selectedAllButton sizeToFit];
    [self.selectedAllButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_centerY);
        make.left.equalTo(self.headerView.mas_left).offset(kRealWidth(10));
    }];
    [self.batchSettingButton sizeToFit];
    [self.batchSettingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_centerY);
        make.right.equalTo(self.headerView.mas_right).offset(-kRealWidth(15));
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.batchOprateView.mas_top);
    }];

    [self.batchOprateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(50));
        make.bottom.equalTo(self.mas_bottom).offset(kRealWidth(50));
    }];
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.batchOprateView.mas_left).offset(kRealWidth(20));
        make.top.equalTo(self.batchOprateView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.batchOprateView.mas_bottom).offset(-kRealWidth(10));
        make.width.equalTo(self.changePriceButton.mas_width);
    }];
    [self.changePriceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteButton.mas_right).offset(kRealWidth(33));
        make.top.equalTo(self.batchOprateView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.batchOprateView.mas_bottom).offset(-kRealWidth(10));
        make.right.equalTo(self.batchOprateView.mas_right).offset(-kRealWidth(20));
    }];

    [super updateConstraints];
}
#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.productList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.productList[indexPath.row];
    if ([model isKindOfClass:TNSellerProductModel.class]) {
        TNMicroShopProductCell *cell = [TNMicroShopProductCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.isShowSelected = self.isShowSelected;
        return cell;
    } else if ([model isKindOfClass:TNMicroShopProductSkeletonCellModel.class]) {
        TNMicroShopProductSkeletonCell *cell = [TNMicroShopProductSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                           identifier:NSStringFromClass(TNMicroShopProductSkeletonCell.class)];
        return cell;
    }
    return UICollectionViewCell.new;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.productList[indexPath.row];
    if ([cell isKindOfClass:TNMicroShopProductCell.class]) {
        TNMicroShopProductCell *productCell = (TNMicroShopProductCell *)cell;
        productCell.model = model;
        @HDWeakify(self);
        productCell.deleteProductCallBack = ^(TNSellerProductModel *_Nonnull curModel) {
            @HDStrongify(self);
            [self removeProductsFromList:@[curModel]];
        };
        productCell.changeProductPriceCallBack = ^{
            @HDStrongify(self);
            [self.viewModel getProductsNewData:YES];
        };
        productCell.setProductHotSalesCallBack = ^(BOOL hotSales) {
            @HDStrongify(self);
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
    } else if ([cell isKindOfClass:TNMicroShopProductSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.productList[indexPath.row];
    if ([model isKindOfClass:TNSellerProductModel.class]) {
        TNSellerProductModel *sModel = model;
        return CGSizeMake(kScreenWidth - kRealWidth(80), sModel.microShopCellHeight);
    } else if ([model isKindOfClass:TNMicroShopProductSkeletonCellModel.class]) {
        TNMicroShopProductSkeletonCellModel *cellModel = (TNMicroShopProductSkeletonCellModel *)model;
        return CGSizeMake(kScreenWidth - kRealWidth(80), cellModel.cellHeight);
    }
    return CGSizeZero;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.viewModel.productList[indexPath.row];
    if ([model isKindOfClass:TNSellerProductModel.class]) {
        TNSellerProductModel *pModel = (TNSellerProductModel *)model;
        if (!self.isShowSelected) {
            [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": pModel.productId, @"isFromProductCenter": @"1"}];
        } else {
            pModel.isSelected = !pModel.isSelected;
            __block BOOL allSelected = YES;
            [self.viewModel.productList enumerateObjectsUsingBlock:^(TNSellerProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.isSelected == NO) {
                    allSelected = NO;
                    *stop = YES;
                }
            }];
            self.selectedAllButton.selected = allSelected;
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        }
    }
}
/** @lazy collectionView */
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kScreenWidth - kRealWidth(80), kRealWidth(191));
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.needRefreshHeader = YES;
        _collectionView.needRefreshFooter = YES;
        _collectionView.needShowNoDataView = YES;
        _collectionView.needShowErrorView = YES;
        _collectionView.mj_footer.hidden = YES;
        @HDWeakify(self);
        _collectionView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel getProductsNewData:NO];
        };
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel loadProductMoreData];
        };
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.title = SALocalizedString(@"no_data", @"暂无数据");
        placeHolder.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolder.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolder.image = @"tn_seller_no_data";
        _collectionView.placeholderViewModel = placeHolder;
    }
    return _collectionView;
}
/** @lazy headerView */
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
/** @lazy batchSettingButton */
- (HDUIButton *)batchSettingButton {
    if (!_batchSettingButton) {
        _batchSettingButton = [[HDUIButton alloc] init];
        _batchSettingButton.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _batchSettingButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_batchSettingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_batchSettingButton setTitleColor:HexColor(0x5D667F) forState:UIControlStateSelected];
        _batchSettingButton.titleEdgeInsets = UIEdgeInsetsMake(4, 20, 4, 20);
        [_batchSettingButton setTitle:TNLocalizedString(@"gzi49m3Y", @"批量设置") forState:UIControlStateNormal];
        [_batchSettingButton setTitle:TNLocalizedString(@"C15r628F", @"取消批量") forState:UIControlStateSelected];
        _batchSettingButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        @HDWeakify(self);
        [_batchSettingButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (!HDIsArrayEmpty(self.viewModel.productList)) {
                id model = self.viewModel.productList.firstObject;
                if ([model isKindOfClass:TNSellerProductModel.class]) {
                    btn.selected = !btn.isSelected;
                    self.isShowSelected = btn.isSelected;
                    self.selectedAllButton.hidden = !btn.isSelected;
                    self.batchOprateView.hidden = !btn.isSelected;

                    self.collectionView.mj_header.hidden = btn.isSelected;
                    if (self.viewModel.hasNextPage) {
                        self.collectionView.mj_footer.hidden = btn.isSelected;
                    }
                    [self.batchOprateView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.mas_bottom).offset(btn.isSelected ? 0 : kRealWidth(50));
                    }];
                    [UIView animateWithDuration:0.25 animations:^{
                        [self.batchOprateView layoutIfNeeded];
                    }];
                    [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
                    if (btn.isSelected) {
                        self.batchSettingButton.backgroundColor = HexColor(0xD6DBE8);
                    } else {
                        self.batchSettingButton.backgroundColor = HDAppTheme.TinhNowColor.C1;
                    }
                }
            }
        }];
    }
    return _batchSettingButton;
}
/** @lazy selectedAllButton */
- (HDUIButton *)selectedAllButton {
    if (!_selectedAllButton) {
        _selectedAllButton = [[HDUIButton alloc] init];
        [_selectedAllButton setTitle:TNLocalizedString(@"c4Iw0foV", @"全选") forState:UIControlStateNormal];
        [_selectedAllButton setImage:[UIImage imageNamed:@"tinhnow-unSelected"] forState:UIControlStateNormal];
        [_selectedAllButton setImage:[UIImage imageNamed:@"tinhnow-selected"] forState:UIControlStateSelected];
        _selectedAllButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_selectedAllButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        _selectedAllButton.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [_selectedAllButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            [self.viewModel.productList enumerateObjectsUsingBlock:^(TNSellerProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.isSelected = btn.isSelected;
            }];
            [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        }];
        _selectedAllButton.hidden = YES;
    }
    return _selectedAllButton;
}
/** @lazy batchOprateView */
- (UIView *)batchOprateView {
    if (!_batchOprateView) {
        _batchOprateView = [[UIView alloc] init];
        _batchOprateView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _batchOprateView.hidden = YES;
    }
    return _batchOprateView;
}
/** @lazy deleteButton */
- (HDUIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[HDUIButton alloc] init];
        _deleteButton.backgroundColor = [UIColor whiteColor];
        _deleteButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_deleteButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_deleteButton setTitle:TNLocalizedString(@"ILIrlMRI", @"移除") forState:UIControlStateNormal];
        _deleteButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:18];
        };
        @HDWeakify(self);
        [_deleteButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            NSArray *selectedArr = [self getSelectedProductArr];
            if (HDIsArrayEmpty(selectedArr)) {
                return;
            }
            [NAT showAlertWithMessage:TNLocalizedString(@"SZwLu50L", @"确定移除所选商品？") confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
                confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [self batchDeleteProduct:selectedArr];
                    [alertView dismiss];
                }
                cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                }];
        }];
    }
    return _deleteButton;
}
/** @lazy changePriceButton */
- (HDUIButton *)changePriceButton {
    if (!_changePriceButton) {
        _changePriceButton = [[HDUIButton alloc] init];
        _changePriceButton.backgroundColor = [UIColor whiteColor];
        _changePriceButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_changePriceButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        [_changePriceButton setTitle:TNLocalizedString(@"ZwILnSab", @"改价") forState:UIControlStateNormal];
        _changePriceButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:18];
        };
        @HDWeakify(self);
        [_changePriceButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self batchChangeProductPrice];
        }];
    }
    return _changePriceButton;
}

@end
