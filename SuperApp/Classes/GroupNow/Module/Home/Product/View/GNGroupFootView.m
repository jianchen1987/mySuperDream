//
//  GNGroupFootView.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNGroupFootView.h"
#import "GNCellModel.h"


@interface GNGroupFootView ()
///总计
@property (nonatomic, strong) HDLabel *totalLB;
///购买
@property (nonatomic, strong) HDUIButton *buyBtn;
///价格
@property (nonatomic, strong) HDLabel *priceLB;
///原价
@property (nonatomic, strong) HDLabel *normalPriceLB;
/// line
@property (nonatomic, strong) UIView *line;

@end


@implementation GNGroupFootView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self addSubview:self.normalPriceLB];
    [self addSubview:self.priceLB];
    [self addSubview:self.buyBtn];
    [self addSubview:self.totalLB];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.totalLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.equalTo(self.totalLB);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.normalPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.normalPriceLB.isHidden) {
            make.top.equalTo(self.priceLB.mas_bottom);
            make.right.equalTo(self.priceLB);
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        }
    }];

    [self.buyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
        if (self.normalPriceLB.isHidden) {
            make.top.equalTo(self.priceLB.mas_bottom).offset(kRealWidth(12));
        } else {
            make.top.equalTo(self.normalPriceLB.mas_bottom).offset(kRealWidth(12));
        }
        make.left.mas_offset(kRealWidth(12));
        make.bottom.mas_offset(-kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
        make.top.left.right.mas_equalTo(0);
    }];

    [self.priceLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.priceLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setProductModel:(GNProductModel *)productModel {
    _productModel = productModel;
    NSMutableAttributedString *originalPriceStr = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(productModel.originalPrice)];
    [GNStringUntils attributedString:originalPriceStr color:HDAppTheme.color.gn_999Color colorRange:originalPriceStr.string font:[HDAppTheme.font gn_ForSize:12] fontRange:originalPriceStr.string];
    [GNStringUntils attributedString:originalPriceStr center:YES colorRange:originalPriceStr.string];
    self.normalPriceLB.attributedText = originalPriceStr;
    self.priceLB.text = GNFillMonEmpty(productModel.price);
    self.normalPriceLB.hidden = (!productModel.originalPrice || [productModel.originalPrice isKindOfClass:NSNull.class] || productModel.originalPrice.doubleValue == productModel.price.doubleValue);
    BOOL enable = [productModel.productStatus.codeId isEqualToString:GNProductStatusUp] && productModel.isTermOfValidity && !productModel.isSoldOut;
    NSString *title = GNLocalizedString(@"gn_panic_buying", @"立即抢购");
    if (productModel.isSoldOut)
        title = GNLocalizedString(@"gn_sold_out", @"已售罄");
    [self.buyBtn setTitle:title forState:UIControlStateNormal];
    self.buyBtn.userInteractionEnabled = enable;
    self.buyBtn.layer.backgroundColor = enable ? HDAppTheme.color.gn_mainColor.CGColor : [HDAppTheme.color.gn_mainColor colorWithAlphaComponent:0.2].CGColor;
}

- (HDUIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:GNLocalizedString(@"gn_panic_buying", @"立即抢购") forState:UIControlStateNormal];
        [_buyBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
        _buyBtn.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
        _buyBtn.layer.cornerRadius = kRealWidth(22);
        _buyBtn.titleLabel.font = [HDAppTheme.font gn_boldForSize:16];
        @HDWeakify(self)[_buyBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"buyAction"];
        }];
    }
    return _buyBtn;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        _priceLB = HDLabel.new;
        _priceLB.font = [HDAppTheme.WMFont wm_ForSize:20 fontName:@"DIN-Bold"];
    }
    return _priceLB;
}

- (HDLabel *)normalPriceLB {
    if (!_normalPriceLB) {
        _normalPriceLB = HDLabel.new;
    }
    return _normalPriceLB;
}

- (HDLabel *)totalLB {
    if (!_totalLB) {
        _totalLB = HDLabel.new;
        _totalLB.text = GNLocalizedString(@"gn_order_allPrice", @"");
        _totalLB.textColor = HDAppTheme.WMColor.B3;
        _totalLB.font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
    }
    return _totalLB;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _line;
}

@end
