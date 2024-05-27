//
//  MuItipleIconDownTextUpMarqueeCardView.m
//  SuperApp
//
//  Created by Tia on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSMuItipleIconDownTextUpMarqueeCardView.h"
#import "CMSMuItipleIconTextMarqueeItemConfig.h"
#import "SACollectionView.h"
#import "SACollectionViewCell.h"


@interface CMSMuItipleIconDownTextUpMarqueeItemCardCell : SACollectionViewCell
/// image
@property (nonatomic, strong) SDAnimatedImageView *logoIV;
/// image
@property (nonatomic, strong) HDLabel *nameLB;
///< container
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) CMSMuItipleIconTextMarqueeItemConfig *model;

@end


@implementation CMSMuItipleIconDownTextUpMarqueeItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.container];
    [self.container addSubview:self.logoIV];
    [self.container addSubview:self.nameLB];
}

- (void)updateConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container);
        make.left.equalTo(self.container.mas_left).offset(3);
        make.right.equalTo(self.container.mas_right).offset(-3);
        make.bottom.equalTo(self.logoIV.mas_top);
    }];

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(52), kRealWidth(52)));
        make.bottom.equalTo(self.container.mas_bottom).offset(-kRealWidth(8));
        make.centerX.equalTo(self.container);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(CMSMuItipleIconTextMarqueeItemConfig *)model {
    _model = model;

    const CGFloat scale = UIScreen.mainScreen.scale;
    [HDWebImageManager setGIFImageWithURL:model.imageUrl size:CGSizeMake(44 * scale, 44 * scale) placeholderImage:[HDHelper placeholderImageWithCornerRadius:22 size:CGSizeMake(44, 44) logoWidth:22]
                                imageView:self.logoIV];
    self.nameLB.text = model.title;
    self.nameLB.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    self.nameLB.font = [UIFont systemFontOfSize:model.titleFont];

    [self setNeedsUpdateConstraints];
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
        label.adjustsFontSizeToFitWidth = YES;
        _nameLB = label;
    }
    return _nameLB;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = UIColor.whiteColor;
        _container.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12.0f];
        };
    }
    return _container;
}

@end

#define kCollectionViewHeight kRealWidth(86)


@interface CMSMuItipleIconDownTextUpMarqueeCardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SACollectionView *collectionView;

@property (nonatomic, strong) NSArray<CMSMuItipleIconTextMarqueeItemConfig *> *dataSource;

@end


@implementation CMSMuItipleIconDownTextUpMarqueeCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.containerView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
        make.height.mas_equalTo(kCollectionViewHeight);
    }];

    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    height += kCollectionViewHeight;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    return height;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CMSMuItipleIconDownTextUpMarqueeItemCardCell *cell = [CMSMuItipleIconDownTextUpMarqueeItemCardCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                                   identifier:NSStringFromClass(CMSMuItipleIconDownTextUpMarqueeItemCardCell.class)];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CMSMuItipleIconTextMarqueeItemConfig *model = self.dataSource[indexPath.row];
    self.clickNode(self, self.config.nodes[indexPath.row], model.link, [NSString stringWithFormat:@"node@%zd", indexPath.row]);
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];
    self.dataSource = [NSArray yy_modelArrayWithClass:CMSMuItipleIconTextMarqueeItemConfig.class json:config.getAllNodeContents];
    [self.collectionView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - lazy
- (SACollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(kRealWidth(75), kCollectionViewHeight);
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, HDAppTheme.value.padding.left, 0, HDAppTheme.value.padding.right);
        _collectionView = [[SACollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:CMSMuItipleIconDownTextUpMarqueeItemCardCell.class forCellWithReuseIdentifier:NSStringFromClass(CMSMuItipleIconDownTextUpMarqueeItemCardCell.class)];
    }
    return _collectionView;
}

@end
