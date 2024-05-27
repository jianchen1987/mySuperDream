//
//  TNCategoryContainerView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryContainerView.h"
#import "SACollectionReusableView.h"
#import "TNCategoryLeftTableViewCell.h"
#import "TNCategoryRightCollectionViewCell.h"
#import "TNCategoryViewModel.h"
#import "TNCollectionView.h"
#import "TNFirstLevelCategoryModel.h"
#import "TNMicroShopDTO.h"
#import "TNProductCenterDTO.h"
#import "TNSecondLevelCategoryModel.h"
#import "TNStoreViewModel.h"
/**
 时间很急  选品中心也复用这个页面  如果上级页面没有传storeViewModel  就是展示选品中心页面数据
 */
@interface TNCategoryContainerView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
/// 左边一级分类
@property (strong, nonatomic) UITableView *leftTableView;
/// 右边二三级分类
@property (strong, nonatomic) TNCollectionView *rightCollectionView;
/// storeviewmodel
@property (nonatomic, strong) TNStoreViewModel *storeViewModel;
/// 一级分类数据源
@property (nonatomic, strong) NSArray<TNFirstLevelCategoryModel *> *firstLevel;
/// 二级分类数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *secondLevel;
/// 选品中心dto
@property (strong, nonatomic) TNProductCenterDTO *productCenterDTO;
///  微店dto
@property (strong, nonatomic) TNMicroShopDTO *microShopDto;
/// 是否来自选品中心
@property (nonatomic, assign) BOOL isFromProductCenter;
@end


@implementation TNCategoryContainerView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.storeViewModel = viewModel;
    if (HDIsObjectNil(self.storeViewModel)) {
        self.isFromProductCenter = YES;
    }
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightCollectionView];
}
- (void)hd_bindViewModel {
    if (self.isFromProductCenter) {
        [self loadProductCenterData];
    } else {
        if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
            [self loadMicroShopCategoryData];
        } else {
            [self loadStoreCategoryData];
        }
    }
}

#pragma mark -请求店铺分类数据
- (void)loadStoreCategoryData {
    //请求分类数据
    [self showloading];
    @HDWeakify(self);
    [self.storeViewModel requestStoreAllCategoryDataSuccess:^(NSArray<TNFirstLevelCategoryModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self dismissLoading];
        self.firstLevel = list;
        if (!HDIsArrayEmpty(self.firstLevel)) {
            TNFirstLevelCategoryModel *firstModel = self.firstLevel.firstObject;
            firstModel.isSelected = YES;
            [self prepareSecondLevelData:firstModel];
            [self.leftTableView reloadData];
        } else {
            [self showNoDataPlaceHolderNeedRefrenshBtn:NO refrenshCallBack:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self loadStoreCategoryData];
        }];
    }];
}

#pragma mark -请求微店分类数据
- (void)loadMicroShopCategoryData {
    //请求分类数据
    [self showloading];
    @HDWeakify(self);
    [self.microShopDto queryMicroShopCategoryWithSupplierId:self.storeViewModel.sp success:^(NSArray<TNFirstLevelCategoryModel *> *_Nonnull list) {
        [self dismissLoading];
        self.firstLevel = list;
        if (!HDIsArrayEmpty(self.firstLevel)) {
            TNFirstLevelCategoryModel *firstModel = self.firstLevel.firstObject;
            firstModel.isSelected = YES;
            [self prepareSecondLevelData:firstModel];
            [self.leftTableView reloadData];
        } else {
            [self showNoDataPlaceHolderNeedRefrenshBtn:NO refrenshCallBack:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self loadStoreCategoryData];
        }];
    }];
}

#pragma mark -请求选品中心分类数据
- (void)loadProductCenterData {
    [self showloading];
    @HDWeakify(self);
    [self.productCenterDTO querySellerAllCategorySuccess:^(NSArray<TNFirstLevelCategoryModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self dismissLoading];
        self.firstLevel = [list hd_filterWithBlock:^BOOL(TNFirstLevelCategoryModel *_Nonnull item) {
            return !HDIsArrayEmpty(item.children);
        }];
        ;
        if (!HDIsArrayEmpty(self.firstLevel)) {
            TNFirstLevelCategoryModel *firstModel = self.firstLevel.firstObject;
            firstModel.isSelected = YES;
            [self prepareSecondLevelData:firstModel];
            [self.leftTableView reloadData];
        } else {
            [self showNoDataPlaceHolderNeedRefrenshBtn:NO refrenshCallBack:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self loadStoreCategoryData];
        }];
    }];
}

#pragma mark 准备二级分类数据
- (void)prepareSecondLevelData:(TNFirstLevelCategoryModel *)model {
    [self.secondLevel removeAllObjects];
    for (TNSecondLevelCategoryModel *secondModel in model.children) {
        HDTableViewSectionModel *section = HDTableViewSectionModel.new;
        section.commonHeaderModel = secondModel;
        SACollectionReusableViewModel *headerModel = [[SACollectionReusableViewModel alloc] init];
        headerModel.title = secondModel.name;
        headerModel.titleColor = HDAppTheme.TinhNowColor.G1;
        headerModel.titleFont = [HDAppTheme.TinhNowFont fontSemibold:15];
        section.headerModel = headerModel;
        section.list = [NSArray arrayWithArray:secondModel.productCategories];
        [self.secondLevel addObject:section];
    }
    [self.rightCollectionView successGetNewDataWithNoMoreData:YES];
}
- (void)updateConstraints {
    [self.leftTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(kRealWidth(80));
    }];
    [self.rightCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    [super updateConstraints];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.firstLevel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryLeftTableViewCell *cell = [TNCategoryLeftTableViewCell cellWithTableView:tableView];
    TNFirstLevelCategoryModel *model = self.firstLevel[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TNFirstLevelCategoryModel *model = self.firstLevel[indexPath.row];
    if (model.isSelected == true) {
        return;
    }
    model.isSelected = !model.isSelected;
    for (TNFirstLevelCategoryModel *fModel in self.firstLevel) {
        if (model != fModel) {
            fModel.isSelected = false;
        }
    }
    [self prepareSecondLevelData:model];
    [self.leftTableView reloadData];
}

#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.secondLevel.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.secondLevel[section].list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryRightCollectionViewCell *cell = [TNCategoryRightCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                             identifier:NSStringFromClass(TNCategoryRightCollectionViewCell.class)];
    TNCategoryModel *model = self.secondLevel[indexPath.section].list[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth - kRealWidth(80) - kRealWidth(15) * 2 - kRealWidth(10) * 2) / 3;
    return CGSizeMake(width, width + 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.secondLevel.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.secondLevel[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title))
        return CGSizeZero;
    return CGSizeMake(collectionView.frame.size.width, 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.secondLevel.count) {
        return nil;
    }
    HDTableViewSectionModel *sectionModel = self.secondLevel[indexPath.section];
    if (HDIsStringEmpty(sectionModel.headerModel.title))
        return nil;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SACollectionReusableView *headerView = [SACollectionReusableView headerWithCollectionView:collectionView forIndexPath:indexPath];
        SACollectionReusableViewModel *model = (SACollectionReusableViewModel *)sectionModel.headerModel;
        headerView.model = model;
        return headerView;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.secondLevel[indexPath.section];
    TNSecondLevelCategoryModel *seconedModel = sectionModel.commonHeaderModel;
    TNCategoryModel *tModel = sectionModel.list[indexPath.row];
    //分类搜索页面还需要将 同级的分类数据全带过去
    for (TNCategoryModel *oModel in sectionModel.list) {
        oModel.isSelected = false; //全部还原
    }
    //         categoryId -> 三级分类id    categoryModelList-> 三级同类兄弟分类id数组   parentSC -> 二级分类id
    if (self.isFromProductCenter) {
        [[HDMediator sharedInstance]
            navigaveToTinhNowSellerSearchViewController:@{@"categoryId": tModel.menuId, @"categoryModelList": sectionModel.list, @"sp": [TNGlobalData shared].seller.supplierId}];
    } else {
        if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
            [[HDMediator sharedInstance]
                navigaveToTinhNowSellerSearchViewController:
                    @{@"categoryId": tModel.menuId, @"categoryModelList": sectionModel.list, @"storeNo": self.storeViewModel.storeNo, @"sp": self.storeViewModel.sp, @"type": @"2"}];
        } else if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeSellerToAdd) {
            [[HDMediator sharedInstance] navigaveToTinhNowSellerSearchViewController:
                                             @{@"categoryId": tModel.menuId, @"categoryModelList": sectionModel.list, @"storeNo": self.storeViewModel.storeNo, @"sp": self.storeViewModel.sp}];
        } else {
            [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage"
                      withParameters:@{@"categoryId": tModel.menuId, @"categoryModelList": sectionModel.list, @"parentSC": seconedModel.categoryId, @"storeNo": self.storeViewModel.storeNo}];
        }
    }
}
/** @lazy leftTableView */
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.allowsSelection = YES;
        _leftTableView.rowHeight = kRealWidth(60);
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.backgroundColor = HexColor(0xF7F7F9);
        if (@available(iOS 15.0, *)) {
            _leftTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _leftTableView;
}
/** @lazy rightCollectionView */
- (TNCollectionView *)rightCollectionView {
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(15);
        flowLayout.minimumInteritemSpacing = kRealWidth(10);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(30), kRealWidth(15));
        _rightCollectionView = [[TNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _rightCollectionView.backgroundColor = UIColor.whiteColor;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.needRefreshFooter = NO;
        _rightCollectionView.needRefreshHeader = NO;
        _rightCollectionView.needShowNoDataView = YES;
        [_rightCollectionView registerClass:SACollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                        withReuseIdentifier:NSStringFromClass(SACollectionReusableView.class)];
    }
    return _rightCollectionView;
}
/** @lazy secondLevel */
- (NSMutableArray<HDTableViewSectionModel *> *)secondLevel {
    if (!_secondLevel) {
        _secondLevel = [NSMutableArray array];
    }
    return _secondLevel;
}
/** @lazy productCenterDTO */
- (TNProductCenterDTO *)productCenterDTO {
    if (!_productCenterDTO) {
        _productCenterDTO = [[TNProductCenterDTO alloc] init];
    }
    return _productCenterDTO;
}
/** @lazy microShopDto */
- (TNMicroShopDTO *)microShopDto {
    if (!_microShopDto) {
        _microShopDto = [[TNMicroShopDTO alloc] init];
    }
    return _microShopDto;
}
@end
