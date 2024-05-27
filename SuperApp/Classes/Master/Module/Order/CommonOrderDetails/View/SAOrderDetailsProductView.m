//
//  SAOrderDetailsProductView.m
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAOrderDetailsProductView.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"


@interface SAOrderDetailsProductView ()
///< 商品图片
@property (nonatomic, strong) UIImageView *iconImageView;
///< 商品名称
@property (nonatomic, strong) SALabel *nameLabel;
///< 商品sku
@property (nonatomic, strong) SALabel *skuLabel;
///< 商品数量
@property (nonatomic, strong) SALabel *quantityLabel;
///< 销售价
@property (nonatomic, strong) SALabel *salePriceLabel;
///< 原价
@property (nonatomic, strong) SALabel *originalPriceLabel;
@end


@implementation SAOrderDetailsProductView

- (void)hd_setupViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.skuLabel];
    [self addSubview:self.quantityLabel];
    [self addSubview:self.salePriceLabel];
    [self addSubview:self.originalPriceLabel];
}

- (void)updateConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self.mas_top).offset(HDAppTheme.value.padding.left);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    if (!self.skuLabel.isHidden) {
        [self.skuLabel sizeToFit];
        [self.skuLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealHeight(5));
            make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(8));
            make.right.lessThanOrEqualTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        }];
    }

    if (!self.quantityLabel.isHidden) {
        [self.quantityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(8));
            make.right.lessThanOrEqualTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
            make.bottom.equalTo(self.iconImageView.mas_bottom);
        }];
    }

    [self.salePriceLabel sizeToFit];
    [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];

    if (!self.originalPriceLabel.isHidden) {
        [self.salePriceLabel sizeToFit];
        [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.salePriceLabel.mas_left).offset(-kRealWidth(8));
            make.bottom.equalTo(self.iconImageView.mas_bottom);
        }];
    }

    [super updateConstraints];
}

- (void)setModel:(SAGoodsModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithCornerRadius:5 size:CGSizeMake(kRealWidth(80), kRealWidth(80))] imageView:self.iconImageView];
    self.nameLabel.text = model.goodsName.desc;
    if (HDIsStringNotEmpty(model.skuName)) {
        self.skuLabel.text = model.skuName;
        self.skuLabel.hidden = NO;
    } else {
        self.skuLabel.hidden = YES;
    }

    if (model.quantity > 0) {
        self.quantityLabel.text = [NSString stringWithFormat:@"x%zd", model.quantity];
        self.quantityLabel.hidden = NO;
    } else {
        self.quantityLabel.hidden = YES;
    }

    self.salePriceLabel.text = model.goodsSellPrice.thousandSeparatorAmount;
    if (model.goodsOriPrice) {
        NSAttributedString *originalPrice = [[NSAttributedString alloc] initWithString:model.goodsOriPrice.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: HDAppTheme.font.standard3,
            NSForegroundColorAttributeName: HDAppTheme.color.G2,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: HDAppTheme.color.G2
        }];

        self.originalPriceLabel.attributedText = originalPrice;
        self.originalPriceLabel.hidden = NO;
    } else {
        self.originalPriceLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = UIImageView.new;
    }
    return _iconImageView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = SALabel.new;
        _nameLabel.font = HDAppTheme.font.standard3;
        _nameLabel.textColor = HDAppTheme.color.G1;
        _nameLabel.numberOfLines = 3;
    }
    return _nameLabel;
}

- (SALabel *)skuLabel {
    if (!_skuLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 2;
        _skuLabel = label;
    }
    return _skuLabel;
}
- (SALabel *)quantityLabel {
    if (!_quantityLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;

        _quantityLabel = label;
    }
    return _quantityLabel;
}

- (SALabel *)salePriceLabel {
    if (!_salePriceLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2;
        label.textColor = HDAppTheme.color.C1;
        label.numberOfLines = 1;

        _salePriceLabel = label;
    }
    return _salePriceLabel;
}

- (SALabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 1;
        _originalPriceLabel = label;
    }
    return _originalPriceLabel;
}

@end
