//
//  PNAccountIndexCell.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNAccountIndexCell.h"
#import "PNAcountCell.h"
#import "PNCollectionView.h"


@interface PNAccountIndexCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) PNCollectionView *collectionView;
@end


@implementation PNAccountIndexCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView successGetNewDataWithNoMoreData:NO];
    [self setNeedsUpdateConstraints];
}

#pragma mark
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNAcountCell *cell = [PNAcountCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(15);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(kScreenWidth - kRealWidth(75), kRealWidth(150));
        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _collectionView.needRecognizeSimultaneously = NO;
    }
    return _collectionView;
}

@end
