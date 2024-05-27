//
//  SASuggestionDetailTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASuggestionDetailTableViewCell.h"
#import "SAGeneralUtil.h"


@implementation SASuggestionDetailTableViewCellModel

@end


@interface SASuggestionDetaiPhotoCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation SASuggestionDetaiPhotoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _imageView;
}

@end


@interface SASuggestionDetailTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *imageUrls;

@end


@implementation SASuggestionDetailTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.topView];
    [self.topView addSubview:self.tipLabel];
    [self.topView addSubview:self.timeLabel];
    [self.topView addSubview:self.topLine];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.collectionView];
}

#pragma mark - layout
- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(50));
        make.left.top.right.equalTo(self.contentView);
    }];

    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.centerY.equalTo(self.topView);
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-margin);
        make.centerY.equalTo(self.topView);
    }];

    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.topView);
        make.left.equalTo(self.tipLabel);
        make.right.equalTo(self.timeLabel);
    }];

    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(kRealWidth(15));
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(15));
    }];

    NSInteger itemCount = self.imageUrls.count;
    if (itemCount) {
        NSInteger row = (NSInteger)((itemCount - 1) / 3) + 1;
        CGFloat rowHeigth = (kScreenWidth - 2 * kRealWidth(12) - 2 * kRealWidth(10)) / 3.0f;
        CGFloat height = row * rowHeigth + (row - 1) * kRealWidth(10);

        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.detailLabel);
            make.top.equalTo(self.detailLabel.mas_bottom).offset(kRealWidth(10));
            make.height.mas_equalTo(height);
            make.bottom.mas_equalTo(-kRealWidth(20));
        }];
    }
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SASuggestionDetailTableViewCellModel *)model {
    _model = model;
    self.tipLabel.text = model.title;
    self.timeLabel.text = [SAGeneralUtil getDateStrWithTimeInterval:model.time / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
    self.detailLabel.text = model.content;
    self.imageUrls = model.imageUrls;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SASuggestionDetaiPhotoCell *cell = [SASuggestionDetaiPhotoCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SASuggestionDetaiPhotoCell.class)];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[indexPath.row]]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth - 2 * kRealWidth(12) - 2 * kRealWidth(10)) / 3.0f;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickPhotoBlock)
        self.clickPhotoBlock(indexPath.row);
}

#pragma mark - lazy load
- (UIView *)topView {
    if (!_topView) {
        _topView = UIView.new;
    }
    return _topView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        UILabel *l = UILabel.new;
        l.font = HDAppTheme.font.sa_standard16B;
        l.textColor = HDAppTheme.color.sa_C333;
        _tipLabel = l;
    }
    return _tipLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *l = UILabel.new;
        l.font = HDAppTheme.font.sa_standard12;
        l.textColor = HDAppTheme.color.sa_C999;
        _timeLabel = l;
    }
    return _timeLabel;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.new;
        _topLine.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _topLine;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *l = UILabel.new;
        l.font = HDAppTheme.font.sa_standard12;
        l.textColor = HDAppTheme.color.sa_C333;
        l.hd_lineSpace = 4;
        l.numberOfLines = 0;
        _detailLabel = l;
    }
    return _detailLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.minimumLineSpacing = kRealWidth(10);
        flowLayout.minimumInteritemSpacing = kRealWidth(10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:SASuggestionDetaiPhotoCell.class forCellWithReuseIdentifier:NSStringFromClass(SASuggestionDetaiPhotoCell.class)];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
