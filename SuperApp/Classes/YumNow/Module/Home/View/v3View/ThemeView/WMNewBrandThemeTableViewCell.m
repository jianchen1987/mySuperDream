//
//  WMNewBrandThemeTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewBrandThemeTableViewCell.h"
#import "WMSpecialBrandModel.h"


@implementation WMNewBrandThemeTableViewCell

- (void)cellWillDisplayWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    /// 3.0.19.0 曝光
    if (self.dataSource.count <= indexPath.row)
        return;
    WMBrandThemeModel *itemModel = self.dataSource[indexPath.row];
    if ([itemModel isKindOfClass:WMBrandThemeModel.class] || [itemModel isKindOfClass:WMSpecialBrandModel.class]) {
        NSMutableDictionary *param =
            [NSMutableDictionary dictionaryWithDictionary:@{@"exposureSort": @(indexPath.row).stringValue, @"type": @"brandTopicPage", @"plateId": WMManage.shareInstance.plateId}];
        NSString *value = @"";
        NSString *activityNo = @"";
        if ([itemModel isKindOfClass:WMBrandThemeModel.class]) {
            value = itemModel.name;
            activityNo = itemModel.link;
        } else {
            WMSpecialBrandModel *spec = (WMSpecialBrandModel *)itemModel;
            value = spec.name.desc;
            activityNo = spec.link;
        }
        param[@"activityNo"] = activityNo;
        [collectionView recordStoreExposureCountWithValue:value key:itemModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayBrandExposure"];
    }
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = (kScreenWidth - (kRealWidth(8) + kRealWidth(12) + kRealWidth(12)) * 2) / 3.0;
    CGFloat itemHeight = itemWidth + 4 + 18 + 18;
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        itemHeight = itemWidth + 18 + 4;
    }
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)cardSpace {
    return kRealWidth(12);
}

- (Class)cardClass {
    return WMNewBrandThemeItemCardCell.class;
}

@end


@interface WMNewBrandThemeItemCardCell ()
/// image
@property (nonatomic, strong) UIImageView *imageIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;

@end


@implementation WMNewBrandThemeItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.nameLB];
}

- (void)setGNModel:(WMModel *)data {
    self.model = data;
    if ([data isKindOfClass:WMBrandThemeModel.class]) {
        WMBrandThemeModel *brandModel = (id)data;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.maximumLineHeight = 18;
        paragraphStyle.minimumLineHeight = 18;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:WMFillEmptySpace(brandModel.name) attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
        self.nameLB.attributedText = attStr;
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:brandModel.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(140 / 375.0 * kScreenWidth, 140 / 375.0 * kScreenWidth)]];
    } else if ([data isKindOfClass:WMSpecialBrandModel.class]) {
        WMSpecialBrandModel *brandModel = (id)data;
        self.nameLB.text = WMFillEmptySpace(brandModel.name.desc);
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:brandModel.logo.desc]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(170 / 375.0 * kScreenWidth, 170 / 375.0 * kScreenWidth)]];
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(1);
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
    CGFloat itemWidth = 140 / 375.0 * kScreenWidth;
    CGFloat contentH = kRealHeight(26);
    return itemWidth + contentH;
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat itemWidth = 140 / 375.0 * kScreenWidth;
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(itemWidth);
        make.height.hd_equalTo(itemWidth);
        make.top.hd_equalTo(0);
        make.left.hd_equalTo(kRealWidth(10));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(90);
        make.height.hd_equalTo(kRealWidth(18));
        make.top.hd_equalTo(r0.hd_bottom + kRealWidth(8));
        make.left.hd_equalTo(r0.hd_left);
    }];

    return @[r0, r1];
}

@end
