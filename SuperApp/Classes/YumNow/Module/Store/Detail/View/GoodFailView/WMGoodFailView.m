//
//  WMGoodFailView.m
//  SuperApp
//
//  Created by wmz on 2023/5/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMGoodFailView.h"


@interface WMGoodFailView ()
/// titleLB
@property (nonatomic, strong) HDLabel *titleLB;
/// confirmBTN
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// stackView
@property (nonatomic, strong) UIStackView *stackView;

@end


@implementation WMGoodFailView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLB];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.stackView];
    [self addSubview:self.confirmBTN];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(0);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.equalTo(self.scrollView);
    }];

    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.scrollViewContainer layoutIfNeeded];
    [self.titleLB layoutIfNeeded];
    CGFloat height = kScreenHeight * 0.8 - kRealWidth(65) - self.titleLB.hd_height - kRealWidth(60) - (kiPhoneXSeriesSafeBottomHeight ?: kRealWidth(16));
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLB.mas_bottom);
        make.height.mas_equalTo(MIN(self.scrollViewContainer.hd_height, height));
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(kRealWidth(16));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
    }];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    self.scrollView.bounces = NO;
    for (WMShoppingCartStoreProduct *model in dataSource) {
        WMGoodFailItemView *itemView = WMGoodFailItemView.new;
        itemView.product = model;
        [self.stackView addArrangedSubview:itemView];
    }
    self.titleLB.text = [NSString stringWithFormat:WMLocalizedString(@"wm_product_retry_after", @"以下%zd个商品已失效，请删除后重试"), dataSource.count];
    [self updateConstraints];
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.confirmBTN.frame) + (kiPhoneXSeriesSafeBottomHeight ? 0 : kRealWidth(16)));
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = UIStackView.new;
        _stackView.axis = UILayoutConstraintAxisVertical;
    }
    return _stackView;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.font = [HDAppTheme.WMFont wm_ForSize:14];
        _titleLB.textColor = HDAppTheme.WMColor.B6;
        _titleLB.numberOfLines = 0;
    }
    return _titleLB;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsButtonWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"yn_store_del"] forState:UIControlStateNormal];
        [btn setTitle:WMLocalizedString(@"wm_product_delete_all", @"全部删除") forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
        btn.layer.cornerRadius = kRealWidth(22);
        btn.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        btn.imagePosition = HDUIButtonImagePositionLeft;
        btn.spacingBetweenImageAndTitle = kRealWidth(4);
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.clickedConfirmBlock) {
                self.clickedConfirmBlock();
            }
        }];
        _confirmBTN = btn;
    }
    return _confirmBTN;
}
@end


@interface WMGoodFailItemView ()
/// nameLB
@property (nonatomic, strong) HDLabel *nameLB;
/// numLB
@property (nonatomic, strong) HDLabel *numLB;
/// detailLB
@property (nonatomic, strong) HDLabel *detailLB;
/// priceLB
@property (nonatomic, strong) HDLabel *priceLB;
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;
/// statusLB
@property (nonatomic, strong) HDLabel *statusLB;
/// linePriceLB
@property (nonatomic, strong) HDLabel *linePriceLB;
@end


@implementation WMGoodFailItemView

- (void)setProduct:(WMShoppingCartStoreProduct *)product {
    _product = product;
    [HDWebImageManager setImageWithURL:product.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(72), kRealWidth(72))] imageView:self.iconIV];

    self.nameLB.text = product.name.desc;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = kRealWidth(4);
    self.nameLB.attributedText = [[NSMutableAttributedString alloc] initWithString:self.nameLB.text attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    self.numLB.text = [NSString stringWithFormat:@"x%zd", product.purchaseQuantity];

    NSArray<NSString *> *propertyNames = [product.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
        return obj.name.desc;
    }];
    self.detailLB.text =
        [product.goodsSkuName.desc stringByAppendingFormat:@"%@%@", HDIsArrayEmpty(propertyNames) ? @"" : @",", HDIsArrayEmpty(propertyNames) ? @"" : [propertyNames componentsJoinedByString:@"、"]];
    NSAttributedString *priceStr = [[NSAttributedString alloc] initWithString:product.linePrice.thousandSeparatorAmount attributes:@{
        NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
        NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
        NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
    }];
    self.linePriceLB.attributedText = priceStr;
    self.linePriceLB.hidden = !product.showOriginal;
    self.priceLB.text = product.showPrice.thousandSeparatorAmount;
    NSString *statusStr = @"";
    if ([product.statusResult isEqualToString:@"2"]) {
        statusStr = WMLocalizedString(@"wm_product_not_on_sell", @"未到开售时间");
    } else if ([product.statusResult isEqualToString:@"3"]) {
        statusStr = WMLocalizedString(@"wm_product_Not_in_activity", @"未到活动时间");
    }
    self.statusLB.text = statusStr;
    [self setNeedsUpdateConstraints];
}

- (void)hd_setupViews {
    [self addSubview:self.nameLB];
    [self addSubview:self.numLB];
    [self addSubview:self.priceLB];
    [self addSubview:self.iconIV];
    [self addSubview:self.statusLB];
    [self addSubview:self.detailLB];
    [self addSubview:self.linePriceLB];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(72), kRealWidth(72)));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_lessThanOrEqualTo(0);
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(87));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.top.equalTo(self.iconIV);
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(5));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [self.statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.equalTo(self.detailLB.mas_bottom).offset(kRealWidth(5));
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    [self.statusLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.numLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.centerY.equalTo(self.detailLB);
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.centerY.equalTo(self.statusLB);
    }];

    [self.linePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.top.equalTo(self.numLB.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        _nameLB = label;
    }
    return _nameLB;
}

- (HDLabel *)numLB {
    if (!_numLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightBold];
        _numLB = label;
    }
    return _numLB;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Bold"];
        _priceLB = label;
    }
    return _priceLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = kRealWidth(8);
    }
    return _iconIV;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B9;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        _detailLB = label;
    }
    return _detailLB;
}

- (HDLabel *)linePriceLB {
    if (!_linePriceLB) {
        _linePriceLB = HDLabel.new;
    }
    return _linePriceLB;
}

- (HDLabel *)statusLB {
    if (!_statusLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        label.layer.backgroundColor = [UIColor hd_colorWithHexString:@"#F3F4FA"].CGColor;
        label.layer.cornerRadius = kRealWidth(4);
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(8), kRealWidth(5), kRealWidth(8));
        label.textColor = HDAppTheme.WMColor.B6;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        _statusLB = label;
    }
    return _statusLB;
}

@end
