//
//  TNSkuSpecView.m
//  SuperApp
//
//  Created by 张杰 on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSkuSpecView.h"
#import "TNSKUDataFilter.h"
#import "TNSkuCountReusableView.h"
#import "TNSkuSpecCell.h"
#import "TNSkuSpecModel.h"
#import "TNSkuSpecTitleReusableView.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface TNSkuSpecView () <UICollectionViewDelegate, UICollectionViewDataSource, TNSKUDataFilterDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
/// SKU过滤器
@property (nonatomic, strong) TNSKUDataFilter *filter;
/// 当前选中的SKU
@property (nonatomic, strong) TNProductSkuModel *selectedSkuModel;
/// 增减视图
@property (strong, nonatomic) TNSkuCountReusableView *footerCountView;

@end


@implementation TNSkuSpecView
- (void)dealloc {
    [self removeNoti];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedCount = 1; //默认一件
        [self addNoti];
    }
    return self;
}
#pragma mark -键盘监听
- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    !self.willShowKeyboardModifyCountCallBack ?: self.willShowKeyboardModifyCountCallBack(keyboardRect);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, self.collectionView.height - (HDIsArrayEmpty(self.model.specs) ? kRealWidth(23) : kRealWidth(23)), 0);
}
- (void)keyboardWillHide:(NSNotification *)noti {
    !self.willHiddenKeyboardModifyCountCallBack ?: self.willHiddenKeyboardModifyCountCallBack();
    self.collectionView.contentInset = UIEdgeInsetsZero;
}
- (void)setModel:(TNSkuSpecModel *)model {
    _model = model;
    [self.filter reloadData];
    //没有规格选择的 就直接  默认选中 第一个sku
    if (HDIsArrayEmpty(self.model.specs) && !HDIsArrayEmpty(self.model.skus)) {
        self.selectedSkuModel = self.model.skus.firstObject;
    } else {
        //设置选中默认SKU
        [self.model.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *_Nonnull skuObj, NSUInteger skuIdx, BOOL *_Nonnull stop) {
            if (skuObj.isDefault && !skuObj.isOutOfStock && skuObj.stock.integerValue > 0) {
                [skuObj.specValueKeyArray enumerateObjectsUsingBlock:^(id _Nonnull specValueKeyObj, NSUInteger specValueKeyIdx, BOOL *_Nonnull stop) {
                    [self.model.specs enumerateObjectsUsingBlock:^(TNProductSpecificationModel *_Nonnull specObj, NSUInteger specIdx, BOOL *_Nonnull stop) {
                        [specObj.specValues enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *_Nonnull subObj, NSUInteger subIdx, BOOL *_Nonnull stop) {
                            if ([subObj.propId isEqualToString:specValueKeyObj]) {
                                NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:subIdx inSection:specIdx];
                                [_filter didSelectedPropertyWithIndexPath:defaultIndexPath];
                                *stop = YES;
                            }
                        }];
                    }];
                }];
            }
        }];
        self.selectedSkuModel = self.filter.currentResult;
    }
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];

    if (self.selectedSkuCallBack) {
        self.selectedSkuCallBack(_filter.selectedIndexPaths, self.selectedSkuModel);
    }
    [self setNeedsUpdateConstraints];
}
#pragma mark - 更新加减数据
- (void)updateCountViewData {
    if (HDIsObjectNil(self.selectedSkuModel)) {
        return;
    }
    if (self.footerCountView.countView.count > self.selectedSkuModel.stock.integerValue) {
        [self.footerCountView.countView updateCount:self.selectedSkuModel.stock.integerValue];
        self.selectedCount = self.selectedSkuModel.stock.integerValue;
    }
    if (self.model.goodsLimitBuy) {
        self.footerCountView.countView.maxCount = self.model.maxLimit;
        self.footerCountView.countView.minCount = self.model.minLimit;

    } else {
        self.footerCountView.countView.maxCount = self.selectedSkuModel.stock.integerValue;
        self.footerCountView.countView.minCount = 1;
    }
    if (self.footerCountView.countView.count >= self.footerCountView.countView.maxCount) {
        [self.footerCountView.countView enableOrDisablePlusButton:false];
    } else {
        [self.footerCountView.countView enableOrDisablePlusButton:true];
    }
}
- (void)hd_setupViews {
    [self addSubview:self.collectionView];

    self.filter = [[TNSKUDataFilter alloc] initWithDataSource:self];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat specViewHeight = self.collectionView.contentSize.height;
            if (specViewHeight > 0 && specViewHeight > self.collectionViewHeight) {
                self.collectionViewHeight = specViewHeight;
                if (self.collectionViewHeightCallBack) {
                    self.collectionViewHeightCallBack();
                }
            }
        });
    }];
}
- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (HDIsArrayEmpty(self.model.specs)) {
        return 1;
    }
    return self.model.specs.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (HDIsArrayEmpty(self.model.specs)) {
        return 1;
    }
    TNProductSpecificationModel *spec = [self.model.specs objectAtIndex:section];
    return spec.specValues.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (HDIsArrayEmpty(self.model.specs)) {
        [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    }
    TNSkuSpecCell *cell = [TNSkuSpecCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNSkuSpecCell.class)];
    TNProductSpecificationModel *spec = [self.model.specs objectAtIndex:indexPath.section];
    TNProductSpecPropertieModel *proModel = [spec.specValues objectAtIndex:indexPath.row];
    cell.specNameStr = proModel.propValue;
    cell.isSelected = [_filter.selectedIndexPaths containsObject:indexPath];
    cell.hasStock = [_filter.availableIndexPathsSet containsObject:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (HDIsArrayEmpty(self.model.specs) || indexPath.section == self.model.specs.count - 1) {
            TNSkuCountReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                    withReuseIdentifier:NSStringFromClass(TNSkuCountReusableView.class)
                                                                                           forIndexPath:indexPath];
            self.footerCountView = footerView;
            @HDWeakify(self);
            self.footerCountView.countView.changedCountHandler = ^(TNModifyShoppingCountViewOperationType type, NSUInteger count) {
                @HDStrongify(self);
                self.selectedCount = count;
            };
            self.footerCountView.countView.maxCountLimtedHandler = ^(NSUInteger count) {
                [NAT showToastWithTitle:nil content:@"库存不足" type:HDTopToastTypeWarning];
            };

            [self updateCountViewData];
            return footerView;
        } else {
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)
                                                             forIndexPath:indexPath];
            ;
        }
    }

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TNProductSpecificationModel *spec = [self.model.specs objectAtIndex:indexPath.section];
        TNSkuSpecTitleReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                    withReuseIdentifier:NSStringFromClass(TNSkuSpecTitleReusableView.class)
                                                                                           forIndexPath:indexPath];
        headerView.titleStr = spec.specName;
        return headerView;
    }

    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (HDIsArrayEmpty(self.model.specs)) {
        return CGSizeZero;
    }
    return CGSizeMake(self.collectionView.hd_width, 40.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (HDIsArrayEmpty(self.model.specs)) {
        return CGSizeMake(self.collectionView.hd_width, 55.0f);
    }

    CGFloat height = 10.f;
    if (section == self.model.specs.count - 1) {
        height = 55.0f;
    }
    return CGSizeMake(self.collectionView.hd_width, height);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (HDIsArrayEmpty(self.model.specs)) {
        return CGSizeMake(self.collectionView.hd_width, 15);
    }

    TNProductSpecificationModel *spec = [self.model.specs objectAtIndex:indexPath.section];
    TNProductSpecPropertieModel *proModel = [spec.specValues objectAtIndex:indexPath.row];
    return CGSizeMake(proModel.nameWidth, kRealWidth(28));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (HDIsArrayEmpty(self.model.specs)) {
        return;
    }

    if (![_filter.availableIndexPathsSet containsObject:indexPath]) {
        return;
    }
    [_filter didSelectedPropertyWithIndexPath:indexPath];
    TNProductSkuModel *skuModel = _filter.currentResult;
    self.selectedSkuModel = skuModel;
    //更新加减数据
    [self updateCountViewData];

    if (self.selectedSkuCallBack) {
        self.selectedSkuCallBack(_filter.selectedIndexPaths, self.selectedSkuModel);
    }
    [self.collectionView reloadData];
}
#pragma mark - TNSKUDataSource Delegate
//属性种类个数
- (NSInteger)numberOfSectionsForPropertiesInFilter:(TNSKUDataFilter *)filter {
    return self.model.specs.count;
}

//每个种类所有的的属性值(也就是多少种组合，多少个SKU)
- (NSInteger)numberOfConditionsInFilter:(TNSKUDataFilter *)filter {
    return self.model.skus.count;
}

// 返回单个类 一共有多少属性
- (NSArray *)filter:(TNSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    TNProductSpecificationModel *spec = [self.model.specs objectAtIndex:section];
    NSMutableArray *array = [NSMutableArray array];
    [spec.specValues enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [array addObject:obj.propId];
    }];

    return [array copy];
}

- (NSArray *)filter:(TNSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    TNProductSkuModel *skuModel = self.model.skus[row];
    //没有库存 或者 不能售卖  得过滤掉
    if (skuModel.stock.integerValue <= 0 || skuModel.isOutOfStock) {
        return @[];
    }
    return skuModel.specValueKeyArray;
}

- (id)filter:(TNSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    TNProductSkuModel *skuModel = self.model.skus[row];
    return skuModel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 20.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:TNSkuSpecTitleReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNSkuSpecTitleReusableView.class)];
        [_collectionView registerClass:TNSkuCountReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:NSStringFromClass(TNSkuCountReusableView.class)];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];

        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
@end
