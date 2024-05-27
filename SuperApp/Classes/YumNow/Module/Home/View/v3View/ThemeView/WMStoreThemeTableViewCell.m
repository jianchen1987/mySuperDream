//
//  WMStoreThemeTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMStoreThemeTableViewCell.h"


@implementation WMStoreThemeTableViewCell

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
    CGFloat itemWidth = 200 / 375.0 * kScreenWidth;
    CGFloat itemHeight = itemWidth / 2.0;
    CGFloat contentH = kRealWidth(54);
    return CGSizeMake(itemWidth, itemHeight + contentH);
}

- (Class)cardClass {
    return WMStoreThemeItemCardCell.class;
}

@end


@interface WMStoreThemeItemCardCell ()
/// image
@property (nonatomic, strong) UIImageView *imageIV;
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;
/// floatLayoutLB
@property (nonatomic, strong) YYLabel *floatLayoutLB;
///评分视图
@property (nonatomic, strong) UIView *rateView;

@property (nonatomic, strong) UIImageView *rateIV;

@property (nonatomic, strong) HDLabel *rateLB;

@end


@implementation WMStoreThemeItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.logoIV];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.floatLayoutLB];
    [self.contentView addSubview:self.rateView];
    [self.rateView addSubview:self.rateIV];
    [self.rateView addSubview:self.rateLB];
}

- (void)setGNModel:(WMStoreThemeModel *)data {
    if ([data isKindOfClass:WMStoreThemeModel.class]) {
        self.nameLB.text = WMFillEmptySpace(data.storeName);
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:data.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(200 / 375.0 * kScreenWidth, 100 / 375.0 * kScreenWidth)]];
        [self.logoIV sd_setImageWithURL:[NSURL URLWithString:data.logo] placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(30), kRealWidth(30))]];
        self.rateLB.text = [NSString stringWithFormat:@"%.1f", data.reviewScore];

        self.floatLayoutLB.hidden = HDIsArrayEmpty(data.promotions);
        if (!data.tagString) {
            NSArray *arr = [WMStoreDetailPromotionModel configPromotions:data.promotions productPromotion:nil hasFastService:false];
            data.tagString = NSMutableAttributedString.new;
            [arr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
                                                                                                  alignToFont:obj.titleLabel.font
                                                                                                    alignment:YYTextVerticalAlignmentCenter];
                if (idx != arr.count - 1) {
                    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                                      attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                                                                           alignment:YYTextVerticalAlignmentCenter];
                    [objStr appendAttributedString:spaceText];
                }
                [data.tagString appendAttributedString:objStr];
            }];
        }
        self.floatLayoutLB.attributedText = data.tagString;
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(0.5);
    }];

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kRealWidth(4));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(28), kRealWidth(28)));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imageIV);
        make.top.equalTo(self.imageIV.mas_bottom).offset(kRealWidth(6));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.floatLayoutLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutLB.isHidden) {
            make.top.hd_equalTo(self.nameLB.mas_bottom).offset(kRealWidth(6));
            make.left.right.equalTo(self.nameLB);
            make.height.mas_equalTo(kRealWidth(20));
        }
    }];

    [self.rateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(4));
        make.bottom.equalTo(self.imageIV.mas_bottom).offset(-kRealWidth(4));
    }];

    [self.rateIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.rateIV.image.size);
        make.left.mas_equalTo(kRealWidth(6));
        make.top.mas_equalTo(kRealWidth(4));
        make.bottom.mas_equalTo(kRealWidth(-4));
    }];

    [self.rateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rateIV);
        make.right.mas_equalTo(-kRealWidth(5.5));
        make.left.equalTo(self.rateIV.mas_right).offset(kRealWidth(2));
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

- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = UIImageView.new;
        _logoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.12].CGColor;
            view.layer.shadowOffset = CGSizeMake(0, 0);
            view.layer.shadowOpacity = 1;
            view.layer.cornerRadius = kRealWidth(4);
            view.layer.borderColor = HDAppTheme.WMColor.bg3.CGColor;
            view.layer.borderWidth = 0.8;
            view.layer.shadowRadius = 4;
        };
    }
    return _logoIV;
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

- (UIView *)rateView {
    if (!_rateView) {
        _rateView = UIView.new;
        _rateView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _rateView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.12].CGColor;
            view.layer.shadowOffset = CGSizeMake(0, 0);
            view.layer.shadowOpacity = 1;
            view.layer.shadowRadius = 4;
        };
    }
    return _rateView;
}

- (UIImageView *)rateIV {
    if (!_rateIV) {
        _rateIV = UIImageView.new;
        _rateIV.image = [UIImage imageNamed:@"yn_home_star"];
    }
    return _rateIV;
}

- (HDLabel *)rateLB {
    if (!_rateLB) {
        _rateLB = HDLabel.new;
        _rateLB.font = [HDAppTheme.WMFont wm_boldForSize:13];
        _rateLB.textColor = [UIColor hd_colorWithHexString:@"#3A3838"];
    }
    return _rateLB;
}

- (YYLabel *)floatLayoutLB {
    if (!_floatLayoutLB) {
        _floatLayoutLB = YYLabel.new;
        _floatLayoutLB.numberOfLines = 1;
        _floatLayoutLB.lineBreakMode = NSLineBreakByWordWrapping;
        _floatLayoutLB.userInteractionEnabled = NO;
    }
    return _floatLayoutLB;
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
