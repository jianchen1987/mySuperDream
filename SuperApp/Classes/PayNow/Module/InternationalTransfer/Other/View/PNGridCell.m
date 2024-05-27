//
//  PNGridCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGridCell.h"
#import "PNCollectionView.h"
#import "PNGrideItemModel.h"
#import "PNLimitGridItemCell.h"


@interface PNGridCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, strong) NSMutableArray *dataSoucreArray;
@end


@implementation PNGridCell

- (void)hd_setupViews {
    self.column = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(10));
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-10));
    }];
    [super updateConstraints];
}

- (void)setModel:(PNGrideModel *)model {
    _model = model;
    self.column = model.gridColumn;
    self.titleLabel.text = model.title;
    self.dataSoucreArray = [NSMutableArray arrayWithArray:model.listArray];
    [self.collectionView successGetNewDataWithNoMoreData:NO];

    [self setNeedsUpdateConstraints];
}

#pragma mark

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNLimitGridItemCell *cell = [PNLimitGridItemCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = [self.dataSoucreArray objectAtIndex:indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSoucreArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemSize = floor((kScreenWidth - kRealWidth(24)) / self.column) - 0.5;
    return CGSizeMake(itemSize, kRealWidth(52));
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard20B;
        label.text = PNLocalizedString(@"pn_limit_for_payer", @"转账限额(Transfer Limit for payer)");
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - kRealWidth(24), 100) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _collectionView.needRecognizeSimultaneously = NO;

        _collectionView.layer.cornerRadius = kRealWidth(8);
        _collectionView.layer.borderWidth = 1;
        _collectionView.layer.borderColor = HDAppTheme.PayNowColor.lineColor.CGColor;
        _collectionView.layer.masksToBounds = YES;
    }
    return _collectionView;
}

- (NSMutableArray *)dataSoucreArray {
    if (!_dataSoucreArray) {
        _dataSoucreArray = [NSMutableArray array];
    }
    return _dataSoucreArray;
}

@end
