//
//  SASearchRankCell1.m
//  SuperApp
//
//  Created by Tia on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchRankCell.h"
#import "SASearchRankItemCell.h"


@interface SASearchRankCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
/// 最大个数
@property (nonatomic, assign) NSInteger maxCount;

@end


@implementation SASearchRankCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraints {
    //    CGFloat margin = kRealWidth(12);

    NSInteger itemCount = self.maxCount > 0 ? MIN(self.maxCount, 8) : 8;
    if (itemCount) {
        CGFloat height = 52 * itemCount + 34 + 12 + 4 + 12;

        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_equalTo(height);
        }];
    }
    [super updateConstraints];
}

- (void)setDataSource:(NSArray<SASearchThematicModel *> *)dataSource {
    _dataSource = dataSource;
    if (dataSource.count) {
        for (SASearchThematicModel *model in dataSource) {
            self.maxCount = MAX(self.maxCount, model.thematicContentList.count);
        }

        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SASearchRankItemCell *cell = [SASearchRankItemCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SASearchRankItemCell.class)];
    cell.layer.cornerRadius = 8;
    cell.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0800].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowOpacity = 1;
    cell.layer.shadowRadius = 8;

    cell.model = self.dataSource[indexPath.row];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemCount = self.maxCount > 0 ? MIN(self.maxCount, 8) : 8;
    CGFloat width = kScreenWidth / 375 * 240.0;
    if(self.dataSource.count == 1){
        width = kScreenWidth - kRealWidth(12) *2;
    }
    CGFloat height = 52 * itemCount + 34 + 12;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    if(self.clickPhotoBlock) self.clickPhotoBlock(indexPath.row);
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.minimumLineSpacing = kRealWidth(10);
        flowLayout.minimumInteritemSpacing = kRealWidth(10);
        flowLayout.sectionInset = UIEdgeInsetsMake(4, kRealWidth(12), kRealWidth(12), kRealWidth(12));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:SASearchRankItemCell.class forCellWithReuseIdentifier:NSStringFromClass(SASearchRankItemCell.class)];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
