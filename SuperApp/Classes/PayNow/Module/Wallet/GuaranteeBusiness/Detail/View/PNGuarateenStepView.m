//
//  PNGuarateenStepView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenStepView.h"
#import "PNCollectionView.h"
#import "PNGuarateenStepCell.h"


@interface PNGuarateenStepView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger flowStep;
@end


@implementation PNGuarateenStepView

- (void)hd_setupViews {
    [self addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark
- (void)refreshView:(NSArray *)dataSource flowStep:(NSInteger)flowStep {
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
    self.flowStep = flowStep;
    [self.collectionView successGetNewDataWithNoMoreData:NO];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count > 0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:flowStep - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    });
}

#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNGuarateenStepCell *cell = [PNGuarateenStepCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    [cell refreshCell:[self.dataSource objectAtIndex:indexPath.row] index:indexPath.item flowstep:self.flowStep];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kRealWidth(94), kRealWidth(100));
}
#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(88, 93);

        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.needRefreshFooter = false;
        _collectionView.needRefreshHeader = false;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
