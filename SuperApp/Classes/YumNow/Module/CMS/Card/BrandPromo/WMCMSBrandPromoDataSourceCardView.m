//
//  WMCMSBrandPromoDataSourceCardView.m
//  SuperApp
//
//  Created by Tia on 2023/11/28.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCMSBrandPromoDataSourceCardView.h"
#import "SACollectionView.h"
#import "SACollectionViewCell.h"
#import "WMBrandThemeModel.h"
#import "SAAddressModel.h"
#import "SAAddressCacheAdaptor.h"

#define kCollectionViewHeight (140 / 375.0 * kScreenWidth + kRealWidth(26))


@interface WMCMSBrandPromoDataSourceCardViewCell : SACollectionViewCell
/// image
@property (nonatomic, strong) UIImageView *imageIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;

@property (nonatomic, strong) WMBrandThemeModel *model;

@end


@implementation WMCMSBrandPromoDataSourceCardViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.nameLB];
}


- (void)setModel:(WMBrandThemeModel *)model {
    self.nameLB.text = WMFillEmptySpace(model.name);
    [self.imageIV sd_setImageWithURL:[NSURL URLWithString:model.images]
                    placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(140 / 375.0 * kScreenWidth, 140 / 375.0 * kScreenWidth)]];
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(1);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imageIV);
        make.top.equalTo(self.imageIV.mas_bottom).offset(kRealWidth(8));
    }];

    [super updateConstraints];
}

- (UIImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = UIImageView.new;
        _imageIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(4);
            view.clipsToBounds = YES;
        };
        _imageIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:14];
        _nameLB = label;
    }
    return _nameLB;
}

@end


@interface WMCMSBrandPromoDataSourceCardView () <UICollectionViewDelegate, UICollectionViewDataSource>
///标题
@property (nonatomic, strong) HDLabel *titleLB;
///更多
@property (nonatomic, strong) HDUIButton *moreBTN;

@property (nonatomic, strong) SACollectionView *collectionView;

@property (nonatomic, copy) NSArray<WMBrandThemeModel *> *dataSource; ///< 数据源

@property (nonatomic, copy) NSString *link;

@end


@implementation WMCMSBrandPromoDataSourceCardView

#pragma mark - Overwirite
- (BOOL)shouldRequestDataSourceWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    if (HDIsStringNotEmpty(dataSource)) {
        return YES;
    }
    return NO;
}

- (NSString *)dataSourcePathWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    return dataSource;
}

- (NSDictionary *)setupRequestParamtersWithDataSource:(NSString *)dataSource cardConfig:(nonnull SACMSCardViewConfig *)config {
    NSMutableDictionary *req = NSMutableDictionary.new;
    NSDictionary *superParameters = [super setupRequestParamtersWithDataSource:dataSource cardConfig:config];
    [req addEntriesFromDictionary:superParameters];
    if (config.addressModel) {
        [req addEntriesFromDictionary:@{@"geoPointDTO": @{@"lat": config.addressModel.lat.stringValue, @"lon": config.addressModel.lon.stringValue}}];
    }
    req[@"type"] = WMThemeTypeMerchant;
    req[@"operatorNo"] = SAUser.shared.operatorNo;
    req[@"cardId"] = config.cardNo;
    return req;
}

- (void)parsingDataSourceResponse:(NSDictionary *)responseData withCardConfig:(SACMSCardViewConfig *)config {
    [super parsingDataSourceResponse:responseData withCardConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:WMBrandThemeModel.class json:responseData[@"data"][@"brand"]];
    if(self.dataSource.count) {
        self.link = responseData[@"data"][@"link"];
        self.titleLB.text = WMFillEmptySpace(responseData[@"data"][@"title"]);
        [self.moreBTN setTitle:WMLocalizedString(@"wm_more", @"more") forState:UIControlStateNormal];
        self.moreBTN.hidden = !self.dataSource.count;
    }else{
        self.link = nil;
        self.titleLB.text = nil;
        [self.moreBTN setTitle:nil forState:UIControlStateNormal];
        self.moreBTN.hidden = YES;
    }    // 先更新约束
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
    
    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.moreBTN];
    [self.containerView addSubview:self.collectionView];
}

- (void)updateConstraints {
    
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(0);
        make.right.equalTo(self.moreBTN.mas_left).offset(-kRealWidth(5));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(26));
    }];

    [self.moreBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(20));
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(8));
        make.height.mas_equalTo(kCollectionViewHeight);
    }];

    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    if (self.dataSource.count <= 0)
        return 0;
    CGFloat height = 0;
    height += kRealWidth(26);//标题
    height += kRealHeight(8);
    height += kCollectionViewHeight;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    return height;
}

#pragma mark - action
- (void)cardMoreClickAction {
    if (!self.link.length) return;
    NSString *link = self.link;
    if ([SAWindowManager canOpenURL:link]) {
        [SAWindowManager openUrl:link withParameters:nil];
    }
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];
    self.dataSource = [NSArray yy_modelArrayWithClass:WMBrandThemeModel.class json:config.getAllNodeContents];
    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];

    [self.collectionView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WMCMSBrandPromoDataSourceCardViewCell *cell = [WMCMSBrandPromoDataSourceCardViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                     identifier:NSStringFromClass(WMCMSBrandPromoDataSourceCardViewCell.class)];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMBrandThemeModel *model = self.dataSource[indexPath.row];
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
        flowLayout.itemSize = CGSizeMake(140 / 375.0 * kScreenWidth, kCollectionViewHeight);
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, HDAppTheme.value.padding.left, 0, HDAppTheme.value.padding.right);
        _collectionView = [[SACollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:WMCMSBrandPromoDataSourceCardViewCell.class forCellWithReuseIdentifier:NSStringFromClass(WMCMSBrandPromoDataSourceCardViewCell.class)];
        _collectionView.needShowNoDataView = NO;
    }
    return _collectionView;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:18];
        _titleLB = label;
    }
    return _titleLB;
}

- (HDUIButton *)moreBTN {
    if (!_moreBTN) {
        _moreBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _moreBTN.layer.cornerRadius = kRealHeight(10);
        _moreBTN.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(10), 0, kRealWidth(10));
        [_moreBTN setTitleColor:HDAppTheme.WMColor.B6 forState:UIControlStateNormal];
        _moreBTN.layer.backgroundColor = HDAppTheme.WMColor.F2F2F2.CGColor;
        _moreBTN.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        @HDWeakify(self)[_moreBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if ([self respondsToSelector:@selector(cardMoreClickAction)]) {
                [self cardMoreClickAction];
            }
        }];
    }
    return _moreBTN;
}


@end
