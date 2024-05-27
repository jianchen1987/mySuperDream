//
//  GNStorePhotoView.m
//  SuperApp
//
//  Created by wmz on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStorePhotoView.h"
#import "GNCollectionView.h"
#import "GNImageTableViewCell.h"
#import "HDCollectionViewVerticalLayout.h"
#import "WMZPageProtocol.h"
#import "YBImageBrowser.h"


@interface GNStorePhotoView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HDCollectionViewBaseFlowLayoutDelegate>
/// collectionView
@property (nonatomic, strong) GNCollectionView *collectionView;
/// name
@property (nonatomic, strong) HDLabel *nameLb;

@end


@implementation GNStorePhotoView

- (void)hd_setupViews {
    self.backgroundColor = self.collectionView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    [self addSubview:self.collectionView];
    [self addSubview:self.nameLb];
    [self.collectionView registerClass:GNStorePhotoItemCell.class forCellWithReuseIdentifier:@"GNStorePhotoItemCell"];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    self.nameLb.hidden = (dataSource.count == 0);
    self.nameLb.text = [NSString stringWithFormat:@"%@ %@", @(dataSource.count).stringValue, GNLocalizedString(@"gn_photos", @"photos")];
    [self.collectionView reloadNewData:NO];
}

- (void)updateConstraints {
    [self.nameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(12));
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        make.top.equalTo(self.nameLb.mas_bottom).offset(kRealWidth(12));
        make.right.left.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNStorePhotoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GNStorePhotoItemCell" forIndexPath:indexPath];
    [cell setGNModel:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floor((kScreenWidth - kRealWidth(32)) / 2);
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray<YBIBImageData *> *marr = [NSMutableArray new];
    for (NSString *model in self.dataSource) {
        YBIBImageData *data = [YBIBImageData new];
        if ([model isKindOfClass:NSString.class]) {
            NSString *modelStr = (NSString *)model;
            data.imageURL = [NSURL URLWithString:modelStr];
        }
        [marr addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];

    GNImageHandle *handle = GNImageHandle.new;
    handle.sourceView = self;
    browser.toolViewHandlers = @[handle];

    browser.dataSourceArray = marr;
    browser.autoHideProjectiveView = false;
    [browser.defaultToolViewHandler yb_hide:YES];
    browser.currentPage = indexPath.row;
    [browser show];
}

- (HDLabel *)nameLb {
    if (!_nameLb) {
        _nameLb = HDLabel.new;
        _nameLb.font = [HDAppTheme.font gn_ForSize:14];
        _nameLb.textColor = HDAppTheme.color.gn_666Color;
    }
    return _nameLb;
}

- (GNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[GNCollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.needShowNoDataView = YES;
        _collectionView.customPlaceHolder = ^(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError) {
            if (!showError) {
                placeholderViewModel.title = GNLocalizedString(@"gn_no_setting", @"暂无设置");
            }
        };
    }
    return _collectionView;
}
@end


@interface GNStorePhotoItemCell ()
/// image
@property (nonatomic, strong) UIImageView *imageIV;

@end


@implementation GNStorePhotoItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
}

- (void)setGNModel:(NSString *)data {
    if ([data isKindOfClass:NSString.class]) {
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:(NSString *)data]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(172 / 375.0 * kScreenWidth, 172 * kScreenWidth / 375.0)]];
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
