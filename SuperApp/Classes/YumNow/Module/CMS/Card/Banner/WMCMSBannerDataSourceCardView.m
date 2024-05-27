//
//  WMCMSBannerDataSourceCard.m
//  SuperApp
//
//  Created by Tia on 2023/11/28.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCMSBannerDataSourceCardView.h"
#import "SACollectionView.h"
#import "SACollectionViewCell.h"
#import "WMAdadvertisingModel.h"
#import "SAAddressModel.h"
#import "SAAddressCacheAdaptor.h"

#define kCollectionViewHeight (170.0 * kScreenWidth / 375.0)


@interface WMCMSBannerDataSourceCardViewCell : SACollectionViewCell
/// image
@property (nonatomic, strong) UIImageView *imageIV;

@property (nonatomic, strong) WMAdadvertisingModel *model;

@end


@implementation WMCMSBannerDataSourceCardViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
}

- (void)setModel:(WMAdadvertisingModel *)model {
    if ([model isKindOfClass:WMAdadvertisingModel.class]) {
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:model.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(150 / 375.0 * kScreenWidth, 170.0 * kScreenWidth / 375.0)]];
    } else if ([model isKindOfClass:NSString.class]) {
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:(NSString *)model]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(152 / 375.0 * kScreenWidth, 112 * kScreenWidth / 375.0)]];
    }
}

- (void)updateConstraints {
    [self.imageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (UIImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = UIImageView.new;
        _imageIV.contentMode = UIViewContentModeScaleAspectFill;
        _imageIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
            view.clipsToBounds = YES;
        };
    }
    return _imageIV;
}

@end


@interface WMCMSBannerDataSourceCardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SACollectionView *collectionView;

@property (nonatomic, copy) NSArray<WMAdadvertisingModel *> *dataSource; ///< 数据源

@end


@implementation WMCMSBannerDataSourceCardView

#pragma mark - Overwirite
- (BOOL)shouldRequestDataSourceWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    //    dataSource = @"/takeaway-merchant/app/super-app/get-advertising";
    if (HDIsStringNotEmpty(dataSource)) {
        return YES;
    }
    return NO;
}

- (NSString *)dataSourcePathWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    //    dataSource = @"/takeaway-merchant/app/super-app/get-advertising";
    return dataSource;
}

- (NSDictionary *)setupRequestParamtersWithDataSource:(NSString *)dataSource cardConfig:(nonnull SACMSCardViewConfig *)config {
    NSMutableDictionary *req = NSMutableDictionary.new;
    NSDictionary *superParameters = [super setupRequestParamtersWithDataSource:dataSource cardConfig:config];
    [req addEntriesFromDictionary:superParameters];
    if (config.addressModel) {
        [req addEntriesFromDictionary:@{@"geo": @{@"lat": config.addressModel.lat.stringValue, @"lon": config.addressModel.lon.stringValue}}];
    }
    req[@"space"] = WMHomeFoucsAdviseType;
    req[@"cardId"] = config.cardNo;
    return req;
}

- (void)parsingDataSourceResponse:(NSDictionary *)responseData withCardConfig:(SACMSCardViewConfig *)config {
    [super parsingDataSourceResponse:responseData withCardConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:WMAdadvertisingModel.class json:responseData[@"data"]];

    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];
    // 最后刷新collectionView，否则可能会因为高度为0，导致不刷新
    //    [self.collectionView reloadData];
    [self.collectionView successGetNewDataWithNoMoreData:NO];
}

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
    if (self.dataSource.count <= 0) return 0;
    CGFloat height = 0;
    height += kCollectionViewHeight;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    return height;
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];
    //
    self.dataSource = [NSArray yy_modelArrayWithClass:WMAdadvertisingModel.class json:self.config.getAllNodeContents];
    //    [self.dataSource enumerateObjectsUsingBlock:^(WMAdadvertisingModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    //        if (HDIsStringNotEmpty(obj.title)) {
    //            self.hasTitle = true;
    //            *stop = true;
    //        }
    //    }];
    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];
    // 最后刷新collectionView，否则可能会因为高度为0，导致不刷新
    [self.collectionView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WMCMSBannerDataSourceCardViewCell *cell = [WMCMSBannerDataSourceCardViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                             identifier:NSStringFromClass(WMCMSBannerDataSourceCardViewCell.class)];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMAdadvertisingModel *model = self.dataSource[indexPath.row];
    NSString *link = model.link;
    if ([SAWindowManager canOpenURL:link]) {
        [SAWindowManager openUrl:link withParameters:nil];
    }
}

#pragma mark - lazy
- (SACollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(150, kCollectionViewHeight);
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, HDAppTheme.value.padding.left, 0, HDAppTheme.value.padding.right);
        _collectionView = [[SACollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:WMCMSBannerDataSourceCardViewCell.class forCellWithReuseIdentifier:NSStringFromClass(WMCMSBannerDataSourceCardViewCell.class)];
        _collectionView.needShowNoDataView = NO;
    }
    return _collectionView;
}

@end
