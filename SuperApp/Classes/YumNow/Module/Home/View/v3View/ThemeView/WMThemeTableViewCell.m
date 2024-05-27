//
//  WMThemeTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMThemeTableViewCell.h"
#import "LKDataRecord.h"


@interface WMThemeTableViewCell ()
///标题
@property (nonatomic, strong) HDLabel *titleLB;
///更多
@property (nonatomic, strong) HDUIButton *moreBTN;

@end


@implementation WMThemeTableViewCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.moreBTN];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(self.layoutModel.layoutConfig.inSets.top);
        make.right.equalTo(self.moreBTN.mas_left).offset(-kRealWidth(5));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(26));
    }];

    [self.moreBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(20));
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
    self.moreBTN.hidden = !self.dataSource.count;
    [super setGNModel:data];
}

- (void)card:(UICollectionView *)card itemClick:(NSIndexPath *)indexPath {
    if (self.dataSource.count <= indexPath.row)
        return;
    id model = self.dataSource[indexPath.row];
    ///品牌主题
    if ([model isKindOfClass:WMBrandThemeModel.class]) {
        WMBrandThemeModel *tmpModel = (WMBrandThemeModel *)model;
        if (![self.model isKindOfClass:WMThemeModel.class])
            return;
        if ([tmpModel.link containsString:@"storeDetail"] || [tmpModel.link containsString:@"specialActivity"]) {
            [self openLink:tmpModel.link dic:@{
                @"collectType": self.layoutModel.event[@"type"],
                @"plateId": self.model.themeNo,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.品牌主题专区@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.品牌主题专区@%zd", indexPath.row],
                @"associatedId" : self.viewModel.associatedId
            }];
        } else {
            [self openLink:tmpModel.link dic:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.品牌主题专区@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.品牌主题专区@%zd", indexPath.row],
                @"associatedId" : self.viewModel.associatedId
            }];
        }
        /// 3.0.19.0 点击
        NSDictionary *param =
            @{@"exposureSort": @(indexPath.row).stringValue, @"activityNo": tmpModel.link, @"type": @"brandTopicPage", @"pageSource": WMSourceTypeHome, @"plateId": WMManage.shareInstance.plateId};
        [LKDataRecord.shared traceEvent:@"takeawayBrandClick" name:@"takeawayBrandClick" parameters:param SPM:nil];
    }
    ///门店
    else if ([model isKindOfClass:WMStoreThemeModel.class]) {
        WMStoreThemeModel *tmpModel = (WMStoreThemeModel *)model;
        if (![self.model isKindOfClass:WMThemeModel.class])
            return;
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
            @"storeNo": tmpModel.storeNo,
            @"collectType": self.layoutModel.event[@"type"],
            @"plateId": self.model.themeNo,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.门店专区@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.门店专区@%zd", indexPath.row],
            @"associatedId" : self.viewModel.associatedId
        }];
        /// 3.0.19.0 点击
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": tmpModel.storeNo,
            @"type": @"customTopicPageStore",
            @"pageSource": WMSourceTypeHome,
            @"plateId": WMManage.shareInstance.plateId
        };
        [LKDataRecord.shared traceEvent:@"takeawayStoreClick" name:@"takeawayStoreClick" parameters:param SPM:nil];
    }
    ///商品
    else if ([model isKindOfClass:WMProductThemeModel.class]) {
        WMProductThemeModel *tmpModel = (WMProductThemeModel *)model;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"storeNo"] = tmpModel.storeNo;
        params[@"productId"] = tmpModel.productId;
        params[@"plateId"] = self.model.themeNo;
        params[@"collectType"] = self.layoutModel.event[@"type"];
        params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.门店专区@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.门店专区@%zd", indexPath.row];
        params[@"associatedId"] = self.viewModel.associatedId;
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
        /// 3.0.19.0 点击
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": tmpModel.storeNo,
            @"productId": tmpModel.productId,
            @"type": @"customTopicPageProduct",
            @"pageSource": WMSourceTypeHome,
            @"plateId": WMManage.shareInstance.plateId
        };
        [LKDataRecord.shared traceEvent:@"takeawayProductClick" name:@"takeawayProductClick" parameters:param SPM:nil];
    }
    ///按时吃饭
    else if ([model isKindOfClass:WMeatOnTimeModel.class]) {
        WMeatOnTimeModel *tmpModel = (WMeatOnTimeModel *)model;
        WMeatOnTimeThemeModel *eatModel = (WMeatOnTimeThemeModel *)self.model;
        if (![eatModel isKindOfClass:WMeatOnTimeThemeModel.class])
            return;
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
            @"storeNo": tmpModel.storeNo,
            @"productId": tmpModel.productId,
            @"collectType": self.layoutModel.event[@"type"],
            @"plateId": @(eatModel.id).stringValue,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖首页.按时吃饭@%zd", indexPath.row] : [NSString stringWithFormat:@"外卖首页.按时吃饭@%zd", indexPath.row],
            @"associatedId" : self.viewModel.associatedId
        }];
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
    ///商品
    if ([model isKindOfClass:WMProductThemeModel.class]) {
        WMProductThemeModel *tmpModel = (WMProductThemeModel *)model;
        NSDictionary *param = @{
            @"exposureSort": @(indexPath.row).stringValue,
            @"storeNo": tmpModel.storeNo,
            @"productId": tmpModel.productId,
            @"type": @"customTopicPageProduct",
            @"pageSource": WMSourceTypeHome,
            @"plateId": WMManage.shareInstance.plateId
        };
        [collectionView recordStoreExposureCountWithValue:tmpModel.productId key:tmpModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayProductExposure"];
    }
    ///按时吃饭
    else if ([model isKindOfClass:WMeatOnTimeModel.class]) {
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
    ///其他主题
    if ([self.model isKindOfClass:WMThemeModel.class]) {
        WMThemeModel *model = (WMThemeModel *)self.model;
        if ([model.link containsString:@"storeDetail"] || [model.link containsString:@"specialActivity"]) {
            [self openLink:model.link dic:@{@"collectType": self.layoutModel.event[@"type"], @"plateId": self.model.themeNo}];
        } else {
            [self openLink:model.link dic:nil];
        }

    }
    ///按时吃饭
    else if ([self.model isKindOfClass:WMeatOnTimeThemeModel.class]) {
        WMeatOnTimeThemeModel *model = (WMeatOnTimeThemeModel *)self.model;
        NSString *link = [NSString stringWithFormat:@"SuperApp://YumNow/specialActivity?activityNo=%ld&&type=%@", model.id, WMSpecialActiveTypeEat];
        [self openLink:link dic:@{@"collectType": self.layoutModel.event[@"type"], @"plateId": @(model.id).stringValue}];
    }
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = 140 / 375.0 * kScreenWidth;
    CGFloat contentH = kRealWidth(50);
    return CGSizeMake(itemWidth, itemWidth + contentH);
}

- (Class)cardClass {
    return WMThemeItemCardCell.class;
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
            @HDStrongify(self) if ([self respondsToSelector:@selector(cardMoreClickAction)])[self cardMoreClickAction];
        }];
    }
    return _moreBTN;
}

@end


@interface WMThemeItemCardCell ()
/// image
@property (nonatomic, strong) UIImageView *imageIV;
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;
/// priceLB
@property (nonatomic, strong) HDLabel *priceLB;
/// originLB
@property (nonatomic, strong) HDLabel *originLB;

@end


@implementation WMThemeItemCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.logoIV];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.priceLB];
    [self.contentView addSubview:self.originLB];
}

- (void)setGNModel:(WMModel *)data {
    if ([data isKindOfClass:WMProductThemeModel.class]) {
        self.nameLB.numberOfLines = 1;
        WMProductThemeModel *productModel = (id)data;
        self.nameLB.text = WMFillEmptySpace(productModel.name);
        self.priceLB.text = WMFillMonEmpty(productModel.price);
        self.originLB.text = WMFillMonEmpty(productModel.originalPrice);
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:productModel.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(140 / 375.0 * kScreenWidth, 140 / 375.0 * kScreenWidth)]];
        [self.logoIV sd_setImageWithURL:[NSURL URLWithString:productModel.logo] placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(30), kRealWidth(30))]];
        NSMutableAttributedString *originalPriceStr = [[NSMutableAttributedString alloc] initWithString:WMFillMonEmpty(productModel.originalPrice)];
        [GNStringUntils attributedString:originalPriceStr color:HDAppTheme.WMColor.CCCCCC colorRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr font:[HDAppTheme.WMFont wm_ForSize:12] fontRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr center:YES colorRange:originalPriceStr.string];
        self.originLB.attributedText = originalPriceStr;
        self.originLB.hidden = (productModel.originalPrice.floatValue == productModel.price.floatValue);
    } else if ([data isKindOfClass:WMeatOnTimeModel.class]) {
        self.nameLB.numberOfLines = 1;
        WMeatOnTimeModel *productModel = (id)data;
        self.nameLB.text = WMFillEmptySpace(productModel.name);
        self.priceLB.text = WMFillMonEmpty(productModel.price);
        self.originLB.text = WMFillMonEmpty(productModel.originalPrice);
        [self.imageIV sd_setImageWithURL:[NSURL URLWithString:productModel.images]
                        placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(140 / 375.0 * kScreenWidth, 140 / 375.0 * kScreenWidth)]];
        [self.logoIV sd_setImageWithURL:[NSURL URLWithString:productModel.logo] placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(30), kRealWidth(30))]];
        NSMutableAttributedString *originalPriceStr = [[NSMutableAttributedString alloc] initWithString:WMFillMonEmpty(productModel.originalPrice)];
        [GNStringUntils attributedString:originalPriceStr color:HDAppTheme.WMColor.CCCCCC colorRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr font:[HDAppTheme.WMFont wm_ForSize:12] fontRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr center:YES colorRange:originalPriceStr.string];
        self.originLB.attributedText = originalPriceStr;
        self.originLB.hidden = (productModel.originalPrice.floatValue == productModel.price.floatValue);
    }
}

- (void)updateConstraints {
    [self.imageIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.imageIV.mas_width).multipliedBy(1);
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

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.priceLB.isHidden) {
            make.left.equalTo(self.imageIV);
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(4));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
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

- (HDLabel *)priceLB {
    if (!_priceLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.font = [HDAppTheme.WMFont wm_boldForSize:14];
        _priceLB = label;
    }
    return _priceLB;
}

- (HDLabel *)originLB {
    if (!_originLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B1B1B1;
        label.font = [HDAppTheme.WMFont wm_boldForSize:12];
        _originLB = label;
    }
    return _originLB;
}

@end
