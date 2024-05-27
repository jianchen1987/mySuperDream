//
//  WMNewStoreThemeTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewStoreThemeTableViewCell.h"


@implementation WMNewStoreThemeTableViewCell

- (void)cellWillDisplayWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    /// 3.0.19.0 曝光
    if (self.dataSource.count <= indexPath.row)
        return;
    WMStoreThemeModel *itemModel = self.dataSource[indexPath.row];
    if ([itemModel isKindOfClass:WMStoreThemeModel.class]) {
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": itemModel.storeNo,
            @"type": @"customTopicPageStore",
            @"pageSource": WMSourceTypeHome,
            @"plateId": WMManage.shareInstance.plateId
        };
        [collectionView recordStoreExposureCountWithValue:itemModel.storeNo key:itemModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayStoreExposure"];
    }
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = (kScreenWidth - (kRealWidth(8) + kRealWidth(12) + kRealWidth(12)) * 2) / 3.0;
    CGFloat itemHeight = itemWidth * (86 / 104.0) + 18 * 2 + 4;
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        itemHeight = itemWidth * (86 / 104.0) + 18 + 4;
    }
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)cardSpace {
    return kRealWidth(12);
}

- (Class)cardClass {
    return WMNewStoreThemeItemCardCell.class;
}

@end


@interface WMNewStoreThemeItemCardCell ()
/// 新标签背景
@property (nonatomic, strong) UIImageView *logoTagBgView;
/// image
@property (nonatomic, strong) UIImageView *imageIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;

@end


@implementation WMNewStoreThemeItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.logoTagBgView];
    [self.contentView addSubview:self.nameLB];
}

- (void)setGNModel:(WMStoreThemeModel *)data {
    if ([data isKindOfClass:WMStoreThemeModel.class]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.maximumLineHeight = 18;
        paragraphStyle.minimumLineHeight = 18;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:WMFillEmptySpace(data.storeName) attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
        self.nameLB.attributedText = attStr;
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:data.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(200 / 375.0 * kScreenWidth, 100 / 375.0 * kScreenWidth)]];

        self.logoTagBgView.hidden = !data.isNew;
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.left.mas_equalTo(2);
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(86 / 104.0);
    }];

    [self.logoTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageIV.mas_top).offset(-2);
        make.left.equalTo(self.imageIV.mas_left).offset(-2);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imageIV);
        make.top.equalTo(self.imageIV.mas_bottom).offset(4);
        make.height.mas_greaterThanOrEqualTo(18);
    }];
    [super updateConstraints];
}

- (UIImageView *)imageIV {
    if (!_imageIV) {
        _imageIV = UIImageView.new;
        _imageIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
            view.clipsToBounds = YES;
        };
        _imageIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageIV;
}

- (UIImageView *)logoTagBgView {
    if (!_logoTagBgView) {
        _logoTagBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_home_new_shop"]];
        _logoTagBgView.hidden = YES;
    }
    return _logoTagBgView;
}


- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.color.sa_C333;
        label.font = HDAppTheme.font.sa_standard12;
        label.numberOfLines = 2;
        if (SAMultiLanguageManager.isCurrentLanguageCN)
            label.numberOfLines = 1;
        _nameLB = label;
    }
    return _nameLB;
}

+ (CGFloat)skeletonViewHeight {
    CGFloat itemWidth = 200 / 375.0 * kScreenWidth;
    return itemWidth / 2.0 + kRealWidth(50);
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat itemWidth = 200 / 375.0 * kScreenWidth;
    CGFloat itemHeight = itemWidth / 2.0;

    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(itemWidth);
        make.height.hd_equalTo(itemHeight);
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(kRealWidth(10));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(50);
        make.height.hd_equalTo(kRealWidth(17));
        make.top.hd_equalTo(r0.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(kRealWidth(20));
        make.top.hd_equalTo(r1.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    return @[r0, r1, r2];
}

@end
