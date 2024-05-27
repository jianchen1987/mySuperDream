//
//  TNHorizontalSpecsView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNHorizontalSpecsView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNCollectionViewCell.h"
#import "TNProductSpecPropertieModel.h"


@interface TNSpecElementCollectionViewCell : TNCollectionViewCell
/// 选购数量
@property (strong, nonatomic) HDLabel *countLabel;
///
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UIView *colorLineView;
///
@property (strong, nonatomic) TNProductSpecPropertieModel *model;
@end


@implementation TNSpecElementCollectionViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.colorLineView];
}
- (void)setModel:(TNProductSpecPropertieModel *)model {
    _model = model;
    self.nameLabel.text = model.propValue;
    self.colorLineView.hidden = !model.isUserSelected;
    if (model.isUserSelected) {
        self.nameLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.nameLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
    } else {
        self.nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
        self.nameLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
    }

    if (model.selectedSkuCount > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"x%ld", model.selectedSkuCount];
        self.countLabel.hidden = NO;
    } else {
        self.countLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    if (self.model.isNeedCountSpace) {
        [self.countLabel sizeToFit];
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_leading);
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(4));
            make.height.mas_equalTo(kRealWidth(15));
        }];
    }
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        if (self.model.isNeedCountSpace) {
            make.top.equalTo(self.countLabel.mas_bottom).offset(kRealWidth(4));
        } else {
            make.centerY.equalTo(self.contentView.mas_centerY);
        }
    }];
    [self.colorLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.centerX.equalTo(self.nameLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), 3));
    }];
    [super updateConstraints];
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.C1;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
/** @lazy colorLineView */
- (UIView *)colorLineView {
    if (!_colorLineView) {
        _colorLineView = [[UIView alloc] init];
        _colorLineView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _colorLineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _colorLineView;
}
/** @lazy countLabel */
- (HDLabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[HDLabel alloc] init];
        _countLabel.backgroundColor = HDAppTheme.TinhNowColor.cFF2323;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _countLabel.hd_edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _countLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:7];
        };
    }
    return _countLabel;
}
@end


@interface TNHorizontalSpecsView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
/// cell高度 取列表最高的
@property (nonatomic, assign) CGFloat cellHeight;
///
@property (strong, nonatomic) UIView *lineView;

@end


@implementation TNHorizontalSpecsView
- (void)hd_setupViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView];
}
- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(self.cellHeight);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}
- (void)setSpecValues:(NSArray<TNProductSpecPropertieModel *> *)specValues {
    _specValues = specValues;
    self.cellHeight = 0;
    __block BOOL hasSkuCount = NO;
    [specValues enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.nameSize.height > self.cellHeight) {
            self.cellHeight = obj.nameSize.height;
        }
        if (obj.selectedSkuCount > 0) {
            hasSkuCount = YES;
        }
    }];

    [specValues enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isNeedCountSpace = hasSkuCount;
    }];
    //如果有选中数量的
    if (hasSkuCount) {
        self.cellHeight += kRealWidth(19);
        //下间距
        self.cellHeight += kRealWidth(15);
    } else {
        //高度+上下间距
        self.cellHeight += kRealWidth(20);
    }

    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.specValues.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNSpecElementCollectionViewCell *cell = [TNSpecElementCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    TNProductSpecPropertieModel *model = self.specValues[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNProductSpecPropertieModel *model = self.specValues[indexPath.row];
    CGFloat width = model.nameSize.width;
    if (model.selectedSkuCount > 0 && model.selectedSkuCountLableWidth > model.nameSize.width) {
        width = model.selectedSkuCountLableWidth;
    }
    return CGSizeMake(width, self.cellHeight);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TNProductSpecPropertieModel *model = self.specValues[indexPath.row];
    if (model.isUserSelected) {
        return;
    }
    [self.specValues enumerateObjectsUsingBlock:^(TNProductSpecPropertieModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isUserSelected = NO;
    }];
    model.isUserSelected = YES;
    [self.collectionView reloadData];
    !self.selectedItemCallBack ?: self.selectedItemCallBack(model);
}
/** @lazy collectionView */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = kRealWidth(30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _collectionView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xD6DBE8);
    }
    return _lineView;
}
@end
