//
//  CMSParentHalfChildHalfKingKongAreaCardView.m
//  SuperApp
//
//  Created by Tia on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSParentHalfChildHalfKingKongAreaCardView.h"
#import "CMSParentChildKingKongItemConfig.h"
#import "CMSToolsAreaCardNode.h"
#import "CMSParentHalfChildHalfParentItemView.h"
#import "SACollectionView.h"
#import "SACollectionViewCell.h"

/// cell 高
#define kKingKongAreaCellH (kRealWidth(164))
/// 左边大图高度
#define kKingKongAreaLeftBigViewH kRealWidth(200)
/// 左边大图宽度
#define kKingKongAreaLeftBigViewW kRealWidth(100)
//左图占视图的宽比例
#define kLeftViewWidthMultiplied 0.5


@interface CMSParentHalfChildHalfChildKingKongAreaItemCardCell : SACollectionViewCell

/// image
@property (nonatomic, strong) SDAnimatedImageView *logoIV;
/// image
@property (nonatomic, strong) HDLabel *nameLB;

@property (nonatomic, strong) CMSToolsAreaItemConfig *model;

@end


@implementation CMSParentHalfChildHalfChildKingKongAreaItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.logoIV];
    [self.contentView addSubview:self.nameLB];
}

#pragma mark - setter
- (void)setModel:(CMSToolsAreaItemConfig *)model {
    _model = model;

    const CGFloat scale = UIScreen.mainScreen.scale;
    [HDWebImageManager setGIFImageWithURL:model.imageUrl size:CGSizeMake(44 * scale, 44 * scale) placeholderImage:[HDHelper placeholderImageWithCornerRadius:22 size:CGSizeMake(44, 44) logoWidth:22]
                                imageView:self.logoIV];
    self.nameLB.text = model.title;
    self.nameLB.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    self.nameLB.font = [UIFont systemFontOfSize:model.titleFont];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(12.5));
        make.right.mas_equalTo(kRealWidth(-12.5));
        //        make.left.right.equalTo(self);
        make.height.equalTo(self.logoIV.mas_width).multipliedBy(1);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(5));
        //        make.left.mas_equalTo(kRealWidth(6));
        //        make.right.mas_equalTo(kRealWidth(-6));
        make.left.right.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = SDAnimatedImageView.new;
    }
    return _logoIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HDAppTheme.color.G1;
        label.font = [HDAppTheme.font standard4];
        _nameLB = label;
    }
    return _nameLB;
}

@end


@interface CMSParentHalfChildHalfKingKongAreaCardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) CMSParentHalfChildHalfParentItemView *leftBigView;
@property (nonatomic, strong) SACollectionView *collectionView;
//@property (nonatomic, strong) HDGridView *gridView;
@property (nonatomic, strong) NSArray<CMSToolsAreaItemConfig *> *dataSource;

@end


@implementation CMSParentHalfChildHalfKingKongAreaCardView

- (void)hd_bindViewModel {
    [self.collectionView registerClass:CMSParentHalfChildHalfChildKingKongAreaItemCardCell.class forCellWithReuseIdentifier:NSStringFromClass(
                                                                                                                                CMSParentHalfChildHalfChildKingKongAreaItemCardCell.class)];
}

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.leftBigView];
    [self.containerView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.leftBigView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self.containerView).offset(kRealWidth(10));
        make.width.mas_equalTo(self.containerView).multipliedBy(kLeftViewWidthMultiplied);
        make.height.mas_equalTo(kKingKongAreaLeftBigViewH);
        make.bottom.equalTo(self.containerView).offset(-kRealWidth(10));
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBigView.mas_right).offset(kRealWidth(10));
        make.bottom.equalTo(self.containerView);
        make.top.equalTo(self.leftBigView);
        make.right.equalTo(self.containerView);
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    height += kRealHeight(20) + kKingKongAreaLeftBigViewH;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - private methods
- (void)openRouteWithModel:(CMSToolsAreaItemConfig *)model index:(NSUInteger)index {
    SACMSNode *node = self.config.nodes[index];
    NSString *url = model.link;
    !self.clickNode ?: self.clickNode(self, node, url, [NSString stringWithFormat:@"node@%zd", index]);
}

- (void)reloadData {
    self.leftBigView.imageView.image = nil;
    self.leftBigView.titleLB.text = nil;
    if (HDIsArrayEmpty(self.dataSource))
        return;

    self.leftBigView.titleLB.text = [self.dataSource.firstObject title];
    self.leftBigView.subTitleLB.text = [self.dataSource.firstObject title];
    [HDWebImageManager setGIFImageWithURL:self.dataSource.firstObject.imageUrl
                         placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kKingKongAreaLeftBigViewW, kKingKongAreaLeftBigViewH) logoWidth:kKingKongAreaLeftBigViewW * 0.5]
                                imageView:self.leftBigView.imageView];

    [self.collectionView successGetNewDataWithNoMoreData:NO];

    [self setNeedsUpdateConstraints];
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSParentChildKingKongItemConfig.class json:self.config.getAllNodeContents];
    [self reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CMSParentHalfChildHalfChildKingKongAreaItemCardCell *cell =
        [CMSParentHalfChildHalfChildKingKongAreaItemCardCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                         identifier:NSStringFromClass(CMSParentHalfChildHalfChildKingKongAreaItemCardCell.class)];
    cell.model = self.dataSource[indexPath.row + 1];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count ? self.dataSource.count - 1 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CMSToolsAreaItemConfig *model = self.dataSource[indexPath.row + 1];
    [self openRouteWithModel:model index:[self.dataSource indexOfObject:model]];
}

#pragma mark - event response
- (void)clickLeftBigImageHandler {
    [self openRouteWithModel:self.dataSource.firstObject index:0];
}

#pragma mark - lazy load
- (CMSParentHalfChildHalfParentItemView *)leftBigView {
    if (!_leftBigView) {
        _leftBigView = CMSParentHalfChildHalfParentItemView.new;
        @HDWeakify(self);
        _leftBigView.clickView = ^{
            @HDStrongify(self);
            [self openRouteWithModel:self.dataSource.firstObject index:0];
        };
    }
    return _leftBigView;
}

- (SACollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        CGFloat itemWidth = (kScreenWidth - HDAppTheme.value.padding.left * 2 - kScreenWidth * kLeftViewWidthMultiplied - kRealWidth(10)) / 2;

        flowLayout.itemSize = CGSizeMake(itemWidth, kRealWidth(103));
        flowLayout.minimumLineSpacing = kRealWidth(9);
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[SACollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
