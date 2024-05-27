//
//  TNStoreRecommendProductView.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNStoreRecommendProductView.h"


@interface TNStoreRecommendProductView ()
/// 商品图片
@property (strong, nonatomic) UIImageView *goodsImageView;
/// 商品名
@property (nonatomic, strong) UILabel *goodsNameLabel;
/// 商品售价
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (strong, nonatomic) HDLabel *salesLabel; ///<销量
///折扣
@property (nonatomic, strong) HDUIButton *discountTag;
@end


@implementation TNStoreRecommendProductView
- (void)hd_setupViews {
    [self addSubview:self.goodsImageView];
    [self.goodsImageView addSubview:self.salesLabel];
    [self.goodsImageView addSubview:self.discountTag];
    [self addSubview:self.goodsNameLabel];
    [self addSubview:self.goodsPriceLabel];

    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor colorWithRed:203 / 255.0 green:212 / 255.0 blue:217 / 255.0 alpha:0.25].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowRadius = 6;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDetail)];
    [self addGestureRecognizer:tap];
}

- (void)gotoDetail {
    [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": self.model.productId, @"sp": self.sp}];
}
- (void)setModel:(TNGoodsModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(100, 100)] imageView:self.goodsImageView];
    self.goodsNameLabel.text = model.productName;
    self.goodsPriceLabel.text = model.price.thousandSeparatorAmount;
    //显示折扣
    if (HDIsStringNotEmpty(model.showDisCount)) {
        self.discountTag.hidden = false;
        [self.discountTag setTitle:model.showDisCount forState:UIControlStateNormal];
    } else {
        self.discountTag.hidden = true;
    }
    //判断是否显示已售数量 商品销量>0，显示销售件数；如商品销量=0，则不显示销售数量字段
    if (HDIsStringNotEmpty(model.salesLabel)) {
        self.salesLabel.hidden = false;
        NSString *str = TNLocalizedString(@"tn_text_sold_title", @"Sold ");
        self.salesLabel.text = [str stringByAppendingFormat:@"%@", model.salesLabel];
    } else {
        self.salesLabel.hidden = true;
    }
    [self setNeedsUpdateConstraints];
}
- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
}
- (void)setSp:(NSString *)sp {
    _sp = sp;
}
- (void)updateConstraints {
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.itemWidth, self.itemWidth));
    }];
    [self.salesLabel sizeToFit];
    [self.salesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.goodsImageView.mas_right).offset(-kRealWidth(10));
        make.bottom.equalTo(self.goodsImageView.mas_bottom).offset(-kRealWidth(5));
    }];
    if (!self.discountTag.isHidden) {
        [self.discountTag sizeToFit];
        [self.discountTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.goodsImageView);
        }];
    }
    [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(5));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(5));
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(kRealWidth(5));
        make.height.mas_equalTo(kRealWidth(30));
    }];
    [self.goodsPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(5));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(5));
        make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(kRealWidth(5));
    }];

    [super updateConstraints];
}
/** @lazy goodImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
        };
    }
    return _goodsImageView;
}

/** @lazy goodNameLabel */
- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.font = HDAppTheme.TinhNowFont.standard12;
        _goodsNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _goodsNameLabel.numberOfLines = 2;
    }
    return _goodsNameLabel;
}
/** @lazy goodsPriceLabel */
- (UILabel *)goodsPriceLabel {
    if (!_goodsPriceLabel) {
        _goodsPriceLabel = [[UILabel alloc] init];
        _goodsPriceLabel.font = HDAppTheme.TinhNowFont.standard12B;
        _goodsPriceLabel.textColor = HDAppTheme.TinhNowColor.C3;
        _goodsPriceLabel.numberOfLines = 1;
    }
    return _goodsPriceLabel;
}
/** @lazy salesLabel */
- (HDLabel *)salesLabel {
    if (!_salesLabel) {
        _salesLabel = [[HDLabel alloc] init];
        _salesLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.50];
        _salesLabel.textColor = [UIColor whiteColor];
        _salesLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _salesLabel.textAlignment = NSTextAlignmentCenter;
        _salesLabel.hd_edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        _salesLabel.layer.cornerRadius = 4;
        _salesLabel.layer.masksToBounds = YES;
    }
    return _salesLabel;
}
/** @lazy discountTag */
- (HDUIButton *)discountTag {
    if (!_discountTag) {
        _discountTag = [[HDUIButton alloc] init];
        _discountTag.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        [_discountTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_discountTag setBackgroundImage:[UIImage imageNamed:@"tn_discount_tag"] forState:UIControlStateNormal];
        _discountTag.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 3);
        _discountTag.hidden = true;
    }
    return _discountTag;
}
@end
