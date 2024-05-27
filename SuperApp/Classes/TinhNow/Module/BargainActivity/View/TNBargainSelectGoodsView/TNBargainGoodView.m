//
//  TNBargainGoodView.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainGoodView.h"
#import "TNSkuImageView.h"


@interface TNBargainGoodView ()
/// 商品图片
@property (strong, nonatomic) TNSkuImageView *goodsImageView;
/// 商品名字
@property (strong, nonatomic) UILabel *nameLabel;
/// 价格文本
@property (strong, nonatomic) UILabel *priceLabel;
/// 实际支付
@property (strong, nonatomic) UILabel *realPayLabel;
/// 文本提示
@property (strong, nonatomic) UILabel *tipsLabel;
@end


@implementation TNBargainGoodView
- (void)hd_setupViews {
    [self addSubview:self.goodsImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.realPayLabel];
    [self addSubview:self.tipsLabel];
    self.tipsLabel.text = TNLocalizedString(@"tn_bargain_pay_after_success", @"成功后仅需支付：");
}
- (void)setGoodName:(NSString *)goodName {
    _goodName = goodName;
    self.nameLabel.text = goodName;
}
- (void)setModel:(TNProductSkuModel *)model {
    _model = model;
    self.goodsImageView.thumbnail = model.thumbnail;
    self.goodsImageView.largeImageUrl = model.skuLargeImg;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_bargain_price_k", @"价值"), model.marketPrice.thousandSeparatorAmount];
    self.realPayLabel.text = model.lowestPrice.thousandSeparatorAmount;
}
- (void)updateConstraints {
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(100), kRealWidth(100)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(15));
        make.leading.equalTo(self.nameLabel);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
    }];
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
    }];
    [self.realPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsLabel.mas_right).offset(kRealWidth(2));
        make.centerY.equalTo(self.tipsLabel.mas_centerY);
    }];
    [super updateConstraints];
}
/** @lazy goodsImageView */
- (TNSkuImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[TNSkuImageView alloc] init];
    }
    return _goodsImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15M;
    }
    return _nameLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _priceLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _priceLabel;
}
/** @lazy priceLabel */
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [UIColor hd_colorWithHexString:@"#F54C5E"];
        _tipsLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _tipsLabel;
}
/** @lazy priceLabel */
- (UILabel *)realPayLabel {
    if (!_realPayLabel) {
        _realPayLabel = [[UILabel alloc] init];
        _realPayLabel.textColor = [UIColor hd_colorWithHexString:@"#F54C5E"];
        _realPayLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        ;
    }
    return _realPayLabel;
}
@end
