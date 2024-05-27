//
//  GNSortFilterView.m
//  SuperApp
//
//  Created by wmz on 2022/6/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNSortFilterView.h"
#import "GNSortHeadView.h"


@interface GNSortFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat collectionViewH;
}
/// 全部产品
@property (nonatomic, strong) HDLabel *nameLB;
/// 关闭
@property (nonatomic, strong) HDUIButton *closeBTN;

@end


@implementation GNSortFilterView

- (void)hd_setupViews {
    [self addSubview:self.shadomView];
    [self addSubview:self.dataView];
    [self.dataView addSubview:self.headView];
    [self.headView addSubview:self.nameLB];
    [self.headView addSubview:self.closeBTN];
    [self.dataView addSubview:self.collectionView];
    [self.collectionView registerClass:GNClassCodeItemCell.class forCellWithReuseIdentifier:@"GNClassCodeItemCell"];
}

- (void)updateConstraints {
    [self.shadomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(56));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.centerY.mas_equalTo(0);
    }];

    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.centerY.mas_equalTo(0);
    }];

    [self.dataSource mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(kRealWidth(8));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(collectionViewH);
        make.bottom.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (void)setCateDatasource:(NSArray<GNClassificationModel *> *)cateDatasource {
    _cateDatasource = cateDatasource;
    collectionViewH = kRealWidth(94) * ceil(cateDatasource.count / 5.0);
    self.normalRect = CGRectMake(0, 0, kScreenWidth, MIN(kScreenHeight - kNavigationBarH - kRealWidth(120), collectionViewH + kRealWidth(56)));
    [self.collectionView updateUI];
    [self setNeedsUpdateConstraints];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cateDatasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNClassCodeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNClassCodeItemCell" forIndexPath:indexPath];
    [cell setGNModel:self.cateDatasource[indexPath.row]];
    cell.imageIV.alpha = 1;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(4);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(floor((kScreenWidth - kRealWidth(16)) / 5.0), kRealWidth(94));
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.cateDatasource enumerateObjectsUsingBlock:^(GNClassificationModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.select = (idx == indexPath.row);
    }];
    [self.collectionView updateUI];
    [self dissmiss];

    if (self.viewSelectModel) {
        self.viewSelectModel(self.cateDatasource[indexPath.row], indexPath);
    }
}

- (GNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        _collectionView = [[GNCollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.text = GNLocalizedString(@"gn_all_categories", @"所有分类");
        _nameLB.font = [HDAppTheme.font gn_boldForSize:16];
    }
    return _nameLB;
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        _closeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBTN setImage:[UIImage imageNamed:@"gn_storeinfo_close"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_closeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [GNEvent eventResponder:self target:btn key:@"closeAction"];
        }];
    }
    return _closeBTN;
}

@end
