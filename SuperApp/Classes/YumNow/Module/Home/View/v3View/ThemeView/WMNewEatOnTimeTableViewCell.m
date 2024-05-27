//
//  WMEatOnTimeTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewEatOnTimeTableViewCell.h"
#import "LKDataRecord.h"
#import "SAAppTheme.h"


@interface WMNewEatOnTimeTableViewCell ()
///标题
@property (nonatomic, strong) HDLabel *titleLB;
///更多
@property (nonatomic, strong) HDUIButton *moreBTN;
/// 换一换
@property (nonatomic, strong) HDUIButton *changeBTN;

@end


@implementation WMNewEatOnTimeTableViewCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.moreBTN];
    [self.bgView addSubview:self.changeBTN];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(self.layoutModel.layoutConfig.inSets.top);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(26));
    }];

    [self.moreBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.left.equalTo(self.titleLB.mas_right).offset(kRealWidth(8));
        make.height.mas_equalTo(kRealWidth(20));
    }];
    [self.changeBTN sizeToFit];
    [self.changeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.cardHeight).priorityHigh();
        make.right.mas_equalTo(-self.layoutModel.layoutConfig.inSets.right);
        make.left.mas_equalTo(self.layoutModel.layoutConfig.inSets.left);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(8)).priorityHigh();
        make.bottom.mas_lessThanOrEqualTo(-self.layoutModel.layoutConfig.inSets.bottom);
    }];

    [self.moreBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moreBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setGNModel:(WMThemeModel *)data {
    self.model = data;
    if ([data isKindOfClass:WMThemeModel.class]) {
        if ([data.type.code isEqualToString:WMThemeTypeMerchant]) {
            self.dataSource = [NSMutableArray arrayWithArray:data.brand];
        } else if ([data.type.code isEqualToString:WMThemeTypeProduct]) {
            self.dataSource = [NSMutableArray arrayWithArray:data.product];
        } else if ([data.type.code isEqualToString:WMThemeTypeStore]) {
            self.dataSource = [NSMutableArray arrayWithArray:data.store];
        } else {
            self.dataSource = NSMutableArray.new;
        }
        self.titleLB.text = WMFillEmptySpace(data.title);
    } else if ([data isKindOfClass:WMeatOnTimeThemeModel.class]) {
        WMeatOnTimeThemeModel *eatModel = (WMeatOnTimeThemeModel *)data;
        self.titleLB.text = WMFillEmptySpace(eatModel.title);
        self.dataSource = [NSMutableArray arrayWithArray:eatModel.rel];
    }
    [self.moreBTN setTitle:WMLocalizedString(@"wm_more", @"more") forState:UIControlStateNormal];
    self.moreBTN.hidden = self.changeBTN.hidden = !self.dataSource.count;

    [super setGNModel:data];
}

- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:WMeatOnTimeModel.class]) {
        WMeatOnTimeModel *tmpModel = (WMeatOnTimeModel *)model;
        WMeatOnTimeThemeModel *eatModel = (WMeatOnTimeThemeModel *)self.model;
        if (![eatModel isKindOfClass:WMeatOnTimeThemeModel.class])
            return;
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:
                                       @{@"storeNo": tmpModel.storeNo, @"productId": tmpModel.productId, @"collectType": self.layoutModel.event[@"type"], @"plateId": @(eatModel.id).stringValue}];
        /// 3.0.19.0 点击
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": tmpModel.storeNo,
            @"productId": tmpModel.productId,
            @"type": @"eatOnTimeProduct",
            @"pageSource": WMSourceTypeHome,
            @"plateId": WMManage.shareInstance.plateId
        };
        [LKDataRecord.shared traceEvent:@"takeawayProductClick" name:@"takeawayProductClick" parameters:param SPM:nil];
    }
}

- (void)cellWillDisplayWithCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMeatOnTimeModel.class]) {
        WMeatOnTimeModel *tmpModel = (WMeatOnTimeModel *)model;
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": tmpModel.storeNo,
            @"productId": tmpModel.productId,
            @"type": @"eatOnTimeProduct",
            @"pageSource": WMSourceTypeHome,
            @"plateId": WMManage.shareInstance.plateId
        };
        [collectionView recordStoreExposureCountWithValue:tmpModel.productId key:tmpModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayProductExposure"];
    }
}

- (void)cardMoreClickAction {
    if (!self.model)
        return;

    ///按时吃饭
    if ([self.model isKindOfClass:WMeatOnTimeThemeModel.class]) {
        WMeatOnTimeThemeModel *model = (WMeatOnTimeThemeModel *)self.model;
        NSString *link = [NSString stringWithFormat:@"SuperApp://YumNow/specialActivity?activityNo=%ld&&type=%@", model.id, WMSpecialActiveTypeEat];
        [self openLink:link dic:@{@"collectType": self.layoutModel.event[@"type"], @"plateId": @(model.id).stringValue}];
    }
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = (kScreenWidth - 12 * 2 - 10 * 3) / 4.0;
    CGFloat itemHeight = itemWidth + 18 * 2 + 18 + 4;
    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        itemHeight = itemWidth + 18 + 18 + 4;
    }
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)cardSpace {
    return 10;
}

- (Class)cardClass {
    return WMNewEatOnTimeItemCardCell.class;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = HDAppTheme.font.sa_standard16SB;
        _titleLB = label;
    }
    return _titleLB;
}

- (HDUIButton *)moreBTN {
    if (!_moreBTN) {
        _moreBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _moreBTN.layer.cornerRadius = kRealHeight(10);
        _moreBTN.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 2);
        [_moreBTN setTitleColor:HDAppTheme.WMColor.B6 forState:UIControlStateNormal];
        //        _moreBTN.layer.backgroundColor = HDAppTheme.color.sa_C1.CGColor;
        _moreBTN.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _moreBTN.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [_moreBTN setImage:[UIImage imageNamed:@"yn_icon_more_arrow"] forState:UIControlStateNormal];
        _moreBTN.imagePosition = HDUIButtonImagePositionRight;
        @HDWeakify(self);

        [_moreBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if ([self respondsToSelector:@selector(cardMoreClickAction)])[self cardMoreClickAction];
        }];
    }
    return _moreBTN;
}

- (HDUIButton *)changeBTN {
    if (!_changeBTN) {
        _changeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_changeBTN setImage:[UIImage imageNamed:@"yn_icon_change"] forState:UIControlStateNormal];
        _changeBTN.titleLabel.font = HDAppTheme.font.sa_standard12;
        [_changeBTN setTitleColor:[UIColor hd_colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_changeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) !self.changeDataCell ?: self.changeDataCell(self.layoutModel);
        }];
        _changeBTN.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [_changeBTN setTitle:WMLocalizedString(@"wm_home_Refresh", @"换一批") forState:UIControlStateNormal];
    }
    return _changeBTN;
}

@end


@interface WMNewEatOnTimeItemCardCell ()
/// image
@property (nonatomic, strong) UIImageView *imageIV;
/// logo
//@property (nonatomic, strong) UIImageView *logoIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;
/// priceLB
@property (nonatomic, strong) HDLabel *priceLB;
/// originLB
@property (nonatomic, strong) HDLabel *originLB;

@end


@implementation WMNewEatOnTimeItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    //    [self.contentView addSubview:self.logoIV];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.priceLB];
    [self.contentView addSubview:self.originLB];
}

- (void)setGNModel:(WMModel *)data {
    if ([data isKindOfClass:WMeatOnTimeModel.class]) {
        WMeatOnTimeModel *productModel = (id)data;


        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.maximumLineHeight = 18;
        paragraphStyle.minimumLineHeight = 18;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:WMFillEmptySpace(productModel.name) attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
        self.nameLB.attributedText = attStr;
        //        self.nameLB.text = productModel.name;
        self.priceLB.text = WMFillMonEmpty(productModel.price);
        self.originLB.text = WMFillMonEmpty(productModel.originalPrice);
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:productModel.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(140 / 375.0 * kScreenWidth, 140 / 375.0 * kScreenWidth)]];
        NSMutableAttributedString *originalPriceStr = [[NSMutableAttributedString alloc] initWithString:WMFillMonEmpty(productModel.originalPrice)];
        [GNStringUntils attributedString:originalPriceStr color:HDAppTheme.color.sa_searchBarTextColor colorRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr font:HDAppTheme.font.sa_standard11 fontRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr center:YES colorRange:originalPriceStr.string];
        self.originLB.attributedText = originalPriceStr;
        self.originLB.hidden = (productModel.originalPrice.floatValue == productModel.price.floatValue);
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
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


    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.priceLB.isHidden) {
            make.left.equalTo(self.imageIV);
            make.top.equalTo(self.nameLB.mas_bottom);
            make.height.mas_equalTo(18);
        }
    }];


    [self.originLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.originLB.isHidden) {
            make.left.equalTo(self.priceLB.mas_right).offset(kRealWidth(2));
            make.centerY.equalTo(self.priceLB);
        }
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
        label.font = HDAppTheme.font.sa_standard12;
        label.numberOfLines = 2;
        if (SAMultiLanguageManager.isCurrentLanguageCN)
            label.numberOfLines = 1;
        _nameLB = label;
    }
    return _nameLB;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.font = HDAppTheme.font.sa_standard12H;
        _priceLB = label;
    }
    return _priceLB;
}

- (HDLabel *)originLB {
    if (!_originLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.color.sa_searchBarTextColor;
        label.font = HDAppTheme.font.sa_standard11;
        _originLB = label;
    }
    return _originLB;
}

@end
