//
//  WMCMSKingKongAreaDataSourceCard.m
//  SuperApp
//
//  Created by Tia on 2023/11/28.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCMSKingKongAreaDataSourceCardView.h"
#import "SACollectionView.h"
#import "SACollectionViewCell.h"
#import "SAAddressModel.h"
#import "SAAddressCacheAdaptor.h"
#import "WMKingKongAreaModel.h"
#import "WMIndicatorSliderView.h"


@interface WMCMSKingKongAreaDataSourceCardViewCell : SACollectionViewCell
/// image
@property (nonatomic, strong) SDAnimatedImageView *imageIV;
/// image
@property (nonatomic, strong) HDLabel *nameLB;

@property (nonatomic, strong) WMKingKongAreaModel *model;

@end


@implementation WMCMSKingKongAreaDataSourceCardViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.nameLB];
}

- (void)setModel:(WMKingKongAreaModel *)data {
    self.nameLB.text = WMFillEmptySpace(data.name);
    [HDWebImageManager setGIFImageWithURL:data.icon size:CGSizeMake(kRealWidth(54), kRealWidth(54))
                         placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(54), kRealWidth(54))]
                                imageView:self.imageIV];
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(8));
        make.right.mas_equalTo(kRealWidth(-8));
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(1);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageIV.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [super updateConstraints];
}

- (SDAnimatedImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = SDAnimatedImageView.new;
    }
    return _imageIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.numberOfLines = SAMultiLanguageManager.isCurrentLanguageCN ? 1 : 2;
        _nameLB = label;
    }
    return _nameLB;
}

@end


@interface WMCMSKingKongAreaDataSourceCardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SACollectionView *collectionView;

@property (nonatomic, strong) WMIndicatorSliderView *sliderView;

@property (nonatomic, copy) NSArray<WMKingKongAreaModel *> *dataSource; ///< 数据源
///<
@end


@implementation WMCMSKingKongAreaDataSourceCardView

#pragma mark - Overwirite
- (BOOL)shouldRequestDataSourceWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    //    dataSource = @"/takeaway-merchant/app/super-app/get-king-kong-area";
    if (HDIsStringNotEmpty(dataSource)) {
        return YES;
    }
    return NO;
}

- (NSString *)dataSourcePathWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    //    dataSource = @"/takeaway-merchant/app/super-app/get-king-kong-area";
    return dataSource;
}

- (NSDictionary *)setupRequestParamtersWithDataSource:(NSString *)dataSource cardConfig:(nonnull SACMSCardViewConfig *)config {
    NSMutableDictionary *req = NSMutableDictionary.new;
    NSDictionary *superParameters = [super setupRequestParamtersWithDataSource:dataSource cardConfig:config];
    [req addEntriesFromDictionary:superParameters];
    if (config.addressModel) {
        [req addEntriesFromDictionary:@{@"location": @{@"lat": config.addressModel.lat.stringValue, @"lon": config.addressModel.lon.stringValue}}];
    }
    req[@"lang"] = SAMultiLanguageManager.currentLanguage;
    req[@"cardId"] = config.cardNo;
    return req;
}

- (void)parsingDataSourceResponse:(NSDictionary *)responseData withCardConfig:(SACMSCardViewConfig *)config {
    [super parsingDataSourceResponse:responseData withCardConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:WMKingKongAreaModel.class json:responseData[@"data"][@"details"]];

    self.sliderView.hidden = self.dataSource.count < 9;
    self.sliderView.offset = self.sliderView.offset;

    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];
    // 最后刷新collectionView，否则可能会因为高度为0，导致不刷新
    [self.collectionView successGetNewDataWithNoMoreData:NO];
}

- (void)hd_setupViews {
    [super hd_setupViews];
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.sliderView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sliderView.hidden) {
            make.top.left.right.equalTo(self.containerView);
        } else {
            make.edges.equalTo(self.containerView);
        }

        if ([SAMultiLanguageManager isCurrentLanguageCN]) {
            make.height.mas_equalTo(self.cardItemHeight * 2 + 8);
        } else {
            make.height.mas_equalTo(self.cardItemHeight * 2 + 8);
        }
    }];

    if (!self.sliderView.hidden) {
        [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.sliderView.isHidden) {
                make.width.mas_equalTo(kRealWidth(50));
                make.height.mas_offset(kRealWidth(3));
                make.centerX.mas_equalTo(0);
                make.top.equalTo(self.collectionView.mas_bottom);
            }
        }];
        [self.sliderView layoutIfNeeded];
    }

    [super updateConstraints];
}


static const CGFloat kMaxRowCount = 2.f;

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    if (self.dataSource.count <= 0) return 0;
    CGFloat height = 0;

    int count = MIN(kMaxRowCount, MAX(0, self.dataSource.count));
    CGFloat collectionViewHeight = 0;
    if (count == 2) {
        collectionViewHeight = count * self.cardItemHeight + 8;
    } else {
        collectionViewHeight = count * self.cardItemHeight;
    }
    height += collectionViewHeight;
    if (!self.sliderView.hidden) {
        height += kRealWidth(3);
    }
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    return height;
}

- (CGFloat)cardItemHeight {
    if ([SAMultiLanguageManager isCurrentLanguageCN]) {
        return kRealWidth(80);
    }
    return kRealWidth(94);
}
#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];
    self.dataSource = [NSArray yy_modelArrayWithClass:WMKingKongAreaModel.class json:config.getAllNodeContents];


    self.sliderView.hidden = self.dataSource.count < 9;
    self.sliderView.offset = self.sliderView.offset;

    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];


    [self.collectionView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WMCMSKingKongAreaDataSourceCardViewCell *cell = [WMCMSKingKongAreaDataSourceCardViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                         identifier:NSStringFromClass(WMCMSKingKongAreaDataSourceCardViewCell.class)];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
    //    return 50;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMKingKongAreaModel *model = self.dataSource[indexPath.row];
    NSString *link = model.link;
    if ([SAWindowManager canOpenURL:link]) {
        [SAWindowManager openUrl:link withParameters:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.sliderView isHidden] && scrollView.contentSize.width > scrollView.frame.size.width) {
        self.sliderView.offset = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width);
    }
}

#pragma mark - lazy
- (SACollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(kRealWidth(70), self.cardItemHeight);
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.minimumInteritemSpacing = 8.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, HDAppTheme.value.padding.left, 0, HDAppTheme.value.padding.right);
        _collectionView = [[SACollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:WMCMSKingKongAreaDataSourceCardViewCell.class forCellWithReuseIdentifier:NSStringFromClass(WMCMSKingKongAreaDataSourceCardViewCell.class)];
        _collectionView.needShowNoDataView = NO;
    }
    return _collectionView;
}

- (WMIndicatorSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = WMIndicatorSliderView.new;
        _sliderView.layer.backgroundColor = HDAppTheme.WMColor.F1F1F1.CGColor;
        _sliderView.layer.cornerRadius = kRealWidth(3.5);
        _sliderView.hidden = YES;
    }
    return _sliderView;
}

@end
