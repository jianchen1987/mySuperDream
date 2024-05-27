//
//  PNBottomFunIndexCell.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNBottomFunIndexCell.h"
#import "PNCollectionView.h"
#import "PNFunctionCell.h"


@interface PNBottomFunIndexCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PNCollectionView *collectionView;

@property (nonatomic, assign) CGFloat sectionTop;
/// 列 【一行多少个】
@property (nonatomic, assign) NSInteger columnCount;

@end


@implementation PNBottomFunIndexCell

- (void)hd_setupViews {
    self.sectionTop = kRealWidth(20);
    self.columnCount = 3;

    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];

    [super updateConstraints];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNFunctionCell *cell = [PNFunctionCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.bgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PNFunctionCellModel *fmodel = self.dataArray[indexPath.item];
    if (fmodel.actionName.length > 0) {
        NSString *actionName = fmodel.actionName;
        NSString *url = [NSString stringWithFormat:@"SuperApp://PayNow/%@", actionName];
        [SAWindowManager openUrl:url withParameters:@{}];
    }
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(self.sectionTop, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        // 计算宽度  目前一行三个
        CGFloat itemWidth = floor((kScreenWidth - kRealWidth(30)) / self.columnCount);
        flowLayout.itemSize = CGSizeMake(itemWidth, kRealWidth(80));

        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _collectionView.needRecognizeSimultaneously = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _collectionView;
}

- (NSInteger)rowCount {
    NSInteger total = self.dataArray.count;
    NSInteger temp = total % self.columnCount;
    NSInteger row;
    if (temp == 0) {
        row = total / self.columnCount;
    } else {
        row = total / self.columnCount + 1;
    }
    return row;
}

- (CGFloat)collectionViewSizeHeight {
    CGFloat height = self.sectionTop + (kRealWidth(80) * [self rowCount]);
    return height;
}

@end
