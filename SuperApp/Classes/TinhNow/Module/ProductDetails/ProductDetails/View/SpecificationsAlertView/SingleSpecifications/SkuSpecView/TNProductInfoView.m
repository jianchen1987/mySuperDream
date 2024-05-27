//
//  TNProductInfoView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductInfoView.h"
#import "TNSkuImageView.h"


@interface TNProductInfoView ()
/// 商品图片
@property (nonatomic, strong) TNSkuImageView *skuImageView;
/// 价格区间
@property (nonatomic, strong) UILabel *priceRangeLabel;
/// 库存
@property (nonatomic, strong) UILabel *stockLabel;
/// 选中规格文本
@property (nonatomic, strong) UILabel *specLabel;
///// 关闭按钮
//@property (nonatomic, strong) HDUIButton *closeBTN;
/// 重量或者体积
@property (strong, nonatomic) UILabel *weightLabel;
@end


@implementation TNProductInfoView

- (void)hd_setupViews {
    [self addSubview:self.skuImageView];
    [self addSubview:self.priceRangeLabel];
    [self addSubview:self.stockLabel];
    [self addSubview:self.specLabel];
    [self addSubview:self.weightLabel];
}
- (void)updateProductInfoByThumbImageUrl:(NSString *)thumbImageUrl
                           largeImageUrl:(NSString *)largeImageUrl
                                   price:(NSString *)price
                                   stock:(nullable NSNumber *)stock
                            selectedSpec:(nullable NSString *)selectedSpec
                                  weight:(nullable NSString *)weight {
    if (HDIsStringNotEmpty(thumbImageUrl)) {
        self.skuImageView.thumbnail = thumbImageUrl;
    }
    if (HDIsStringNotEmpty(largeImageUrl)) {
        self.skuImageView.largeImageUrl = largeImageUrl;
    }
    if (HDIsStringNotEmpty(price)) {
        self.priceRangeLabel.text = price;
    }
    if (HDIsStringNotEmpty(weight)) {
        self.weightLabel.text = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"d3RQIY8O", @"商品重量"), weight];
        self.weightLabel.hidden = NO;
    } else {
        self.weightLabel.text = @"";
        self.weightLabel.hidden = YES;
    }
    if (stock == nil || [stock integerValue] == 0) {
        self.stockLabel.text = @"";
    } else {
        NSString *showStock = @"";
        if ([stock integerValue] > 10) {
            showStock = @">10";
        } else {
            showStock = [NSString stringWithFormat:@"%@", stock];
        }
        self.stockLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"tn_stock_total", @"Inventory Quantity:"), showStock];
    }
    self.specLabel.text = HDIsStringNotEmpty(selectedSpec) ? [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"6v0MnD2N", @"已选"), selectedSpec] : @"";
    [self setNeedsUpdateConstraints];
}
- (void)updateProductInfoByStock:(NSNumber *)stock selectedSpec:(NSString *)selectedSpec {
    [self updateProductInfoByThumbImageUrl:@"" largeImageUrl:@"" price:@"" stock:stock selectedSpec:selectedSpec weight:@""];
}
- (void)updateConstraints {
    CGFloat specHeight = [self.specLabel.text boundingAllRectWithSize:CGSizeMake(kScreenWidth - 15 - 100 - 18 - 15, MAXFLOAT) font:self.specLabel.font lineSpacing:0].height;
    CGFloat maxfloat = [@"1\n2\n3" boundingAllRectWithSize:CGSizeMake(kScreenWidth - 15 - 100 - 18 - 15, MAXFLOAT) font:self.specLabel.font lineSpacing:0].height;

    [self.skuImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        if (specHeight <= maxfloat) {
            make.bottom.equalTo(self.mas_bottom).offset(-20);
        }
    }];

    [self.priceRangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skuImageView.mas_right).offset(18);
        make.top.equalTo(self.mas_top).offset(20);
        make.right.mas_equalTo(-HDAppTheme.value.padding.right);
    }];

    [self.stockLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skuImageView.mas_right).offset(18);
        make.top.equalTo(self.priceRangeLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(15); //固定高度
    }];

    if (!self.weightLabel.isHidden) {
        [self.weightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.skuImageView.mas_right).offset(18);
            make.top.equalTo(self.stockLabel.mas_bottom).offset(10);
            make.right.mas_equalTo(-HDAppTheme.value.padding.right);
        }];
    }

    [self.specLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skuImageView.mas_right).offset(18);
        if (self.weightLabel.isHidden) {
            make.top.equalTo(self.stockLabel.mas_bottom).offset(10);
        } else {
            make.top.equalTo(self.weightLabel.mas_bottom).offset(10);
        }
        make.right.lessThanOrEqualTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        if (specHeight > maxfloat) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }
    }];
    [super updateConstraints];
}

- (void)clickedCloseBTNHandler {
    if (self.closeClickCallBack) {
        self.closeClickCallBack();
    }
}

/** @lazy skuImageView */
- (TNSkuImageView *)skuImageView {
    if (!_skuImageView) {
        _skuImageView = [[TNSkuImageView alloc] init];
    }
    return _skuImageView;
}
/** @lazy priceRangeLabel */
- (UILabel *)priceRangeLabel {
    if (!_priceRangeLabel) {
        _priceRangeLabel = [[UILabel alloc] init];
        _priceRangeLabel.font = HDAppTheme.TinhNowFont.standard20;
        _priceRangeLabel.textColor = HDAppTheme.TinhNowColor.C3;
    }
    return _priceRangeLabel;
}
/** @lazy stockLabel */
- (UILabel *)stockLabel {
    if (!_stockLabel) {
        _stockLabel = [[UILabel alloc] init];
        _stockLabel.font = HDAppTheme.TinhNowFont.standard12;
        _stockLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _stockLabel;
}
/** @lazy specLabel */
- (UILabel *)specLabel {
    if (!_specLabel) {
        _specLabel = [[UILabel alloc] init];
        _specLabel.font = HDAppTheme.TinhNowFont.standard12;
        _specLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _specLabel.numberOfLines = 0;
    }
    return _specLabel;
}
//- (HDUIButton *)closeBTN {
//    if (!_closeBTN) {
//        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
//        button.adjustsButtonWhenHighlighted = false;
//        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//        [button addTarget:self action:@selector(clickedCloseBTNHandler) forControlEvents:UIControlEventTouchUpInside];
//        _closeBTN = button;
//    }
//    return _closeBTN;
//}
/** @lazy weightLabel */
- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] init];
        _weightLabel.font = HDAppTheme.TinhNowFont.standard12;
        _weightLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _weightLabel;
}
@end
