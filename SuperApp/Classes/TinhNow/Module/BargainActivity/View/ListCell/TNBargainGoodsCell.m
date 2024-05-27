//
//  TNBargainGoodsCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainGoodsCell.h"
#import "SAShadowBackgroundView.h"


@interface TNBargainGoodsCell ()
/// 背景
@property (nonatomic, strong) SAShadowBackgroundView *containerView;
/// 商品图片
@property (strong, nonatomic) UIImageView *goodsImageView;
/// 商品名字
@property (strong, nonatomic) UILabel *nameLabel;
/// 价格按钮
@property (strong, nonatomic) UILabel *priceLabel;
/// 底部按钮
@property (strong, nonatomic) HDLabel *bottomLabel;
/// 成交金额
@property (strong, nonatomic) HDUIButton *dealNumBtn;
/// 显示销量  除开砍价列表之外的地方展示
@property (nonatomic, strong) UILabel *soldLabel;
/// 卖光背景图 半透明遮罩
@property (strong, nonatomic) UIView *soldOutView;
///卖光图片
@property (nonatomic, strong) UIImageView *soldOutImageView;
@end


@implementation TNBargainGoodsCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.goodsImageView];
    [self.goodsImageView addSubview:self.soldOutView];
    [self.soldOutView addSubview:self.soldOutImageView];
    [self.containerView addSubview:self.nameLabel];
    [self.containerView addSubview:self.priceLabel];
    [self.containerView addSubview:self.soldLabel];
    [self.containerView addSubview:self.bottomLabel];
    [self.goodsImageView addSubview:self.dealNumBtn];
}
- (void)setIsFromBargainList:(BOOL)isFromBargainList {
    _isFromBargainList = isFromBargainList;
}
- (void)setModel:(TNBargainGoodModel *)model {
    _model = model;
    //设置商品图片
    [HDWebImageManager setImageWithURL:model.images placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(168, 168)] imageView:self.goodsImageView];
    //显示成交数
    if (self.isFromBargainList) {
        [self.dealNumBtn setImage:[UIImage imageNamed:@"tinhnow_fire"] forState:UIControlStateNormal];
        self.dealNumBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        self.dealNumBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.dealNumBtn setTitle:[NSString stringWithFormat:TNLocalizedString(@"tn_had_deals_number", @"已成交%ld件"), model.fixtureNum] forState:UIControlStateNormal];
        self.dealNumBtn.hidden = !(model.fixtureNum > 0);
        //判断库存显示
        if (model.stockNumber > 0) {
            //展示提示
            if (model.isVerifyNewMember) {
                self.bottomLabel.backgroundColor = HDAppTheme.TinhNowColor.C1;
            } else {
                self.bottomLabel.backgroundColor = HDAppTheme.TinhNowColor.R2;
            }
            if (HDIsStringNotEmpty(model.lowestPriceMoney.thousandSeparatorAmount) && HDIsStringNotEmpty(model.registNewTips)) {
                NSString *moneyStr = [NSString stringWithFormat:@"%@ %@", model.lowestPriceMoney.thousandSeparatorAmount, TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
                NSString *tips = [NSString stringWithFormat:@"\n%@", model.registNewTips];
                NSString *text = [moneyStr stringByAppendingString:tips];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
                [attr addAttribute:NSFontAttributeName value:[HDAppTheme.TinhNowFont fontMedium:12] range:[text rangeOfString:tips]];
                NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                paraStyle.lineSpacing = 3;
                [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, text.length)];
                self.bottomLabel.attributedText = attr;
                self.bottomLabel.textAlignment = NSTextAlignmentCenter; //设置行间距后  再设置一下居中
            } else {
                self.bottomLabel.text = [NSString stringWithFormat:@"%@ %@", model.lowestPriceMoney.thousandSeparatorAmount, TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
            }

        } else {
            self.bottomLabel.text = TNLocalizedString(@"tn_bargain_sold_out", @"已抢完");
            self.bottomLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#E1E1E1"];
        }
    } else {
        //不是砍价列表来的  就展示售罄图片
        if (self.model.stockNumber <= 0) {
            self.soldOutView.hidden = false;
            self.soldOutImageView.image = [UIImage imageNamed:model.soldOutImageName];
        } else {
            self.soldOutView.hidden = true;
        }
        self.bottomLabel.text = [NSString stringWithFormat:@"%@ %@", model.lowestPriceMoney.thousandSeparatorAmount, TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
        self.bottomLabel.backgroundColor = HDAppTheme.TinhNowColor.R2;
    }
    //商品名称
    self.nameLabel.text = model.goodsName;
    //商品价值
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_bargain_price_k", @"价值"), model.goodsPriceMoney.thousandSeparatorAmount];
    //商品销量
    if ([model.salesNum integerValue] > 0) {
        NSString *str = TNLocalizedString(@"tn_text_sold_title", @"Sold ");
        self.soldLabel.text = [str stringByAppendingFormat:@"%@", model.salesNum];
        self.soldLabel.hidden = NO;
    } else {
        self.soldLabel.hidden = YES;
    }
    //底部按钮展示
    if (model.isVerifyNewMember) {
        self.bottomLabel.backgroundColor = HDAppTheme.TinhNowColor.C1;
    } else {
        self.bottomLabel.backgroundColor = HDAppTheme.TinhNowColor.R2;
    }
    if (HDIsStringNotEmpty(model.lowestPriceMoney.thousandSeparatorAmount) && HDIsStringNotEmpty(model.registNewTips)) {
        NSString *moneyStr = [NSString stringWithFormat:@"%@ %@", model.lowestPriceMoney.thousandSeparatorAmount, TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
        NSString *tips = [NSString stringWithFormat:@"\n%@", model.registNewTips];
        NSString *text = [moneyStr stringByAppendingString:tips];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr addAttribute:NSFontAttributeName value:[HDAppTheme.TinhNowFont fontMedium:12] range:[text rangeOfString:tips]];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 3;
        [attr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, text.length)];
        self.bottomLabel.attributedText = attr;
        self.bottomLabel.textAlignment = NSTextAlignmentCenter; //设置行间距后  再设置一下居中
    } else {
        self.bottomLabel.text = [NSString stringWithFormat:@"%@ %@", model.lowestPriceMoney.thousandSeparatorAmount, TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
    }
    //设置砍价列表页面的展示
    if (self.isFromBargainList) {
        [self.dealNumBtn setImage:[UIImage imageNamed:@"tinhnow_fire"] forState:UIControlStateNormal];
        self.dealNumBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        self.dealNumBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.dealNumBtn setTitle:[NSString stringWithFormat:TNLocalizedString(@"tn_had_deals_number", @"已成交%ld件"), model.fixtureNum] forState:UIControlStateNormal];
        self.dealNumBtn.hidden = !(model.fixtureNum > 0);
        if (model.stockNumber <= 0) { //砍价页面需要展示已抢完
            self.bottomLabel.text = TNLocalizedString(@"tn_bargain_sold_out", @"已抢完");
            self.bottomLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#E1E1E1"];
        }
    }

    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(1.0);
    }];
    if (!self.soldOutView.isHidden) {
        [self.soldOutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.goodsImageView);
        }];

        [self.soldOutImageView sizeToFit];
        [self.soldOutImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.soldOutView);
            make.size.mas_equalTo(self.soldOutImageView.image.size);
        }];
    }
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
    }];

    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
    }];
    if (!self.soldLabel.isHidden) {
        [self.soldLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
            make.top.equalTo(self.priceLabel.mas_bottom).offset(kRealWidth(3));
            make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(8));
        }];
    }
    [self.bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.soldLabel.isHidden) {
            make.top.equalTo(self.soldLabel.mas_bottom).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(kRealWidth(10));
        }
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(HDIsStringNotEmpty(self.model.registNewTips) ? kRealWidth(45) : kRealWidth(32));
    }];
    [self.dealNumBtn sizeToFit];
    [self.dealNumBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.goodsImageView);
    }];
    [super updateConstraints];
}
// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

/** @lazy goodsImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
    }
    return _goodsImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _nameLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.R1;
        _priceLabel.font = HDAppTheme.TinhNowFont.standard15B;
        _priceLabel.numberOfLines = 2;
    }
    return _priceLabel;
}
/** @lazy bottomLabel */
- (HDLabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[HDLabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _bottomLabel.textColor = [UIColor whiteColor];
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}
/** @lazy containerView */
- (SAShadowBackgroundView *)containerView {
    if (!_containerView) {
        _containerView = [[SAShadowBackgroundView alloc] init];
        _containerView.shadowRoundRadius = 8.0f;
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _containerView;
}

//-(HDLabel *)tipsLabel{
//    if (!_tipsLabel) {
//        _tipsLabel = [[HDLabel alloc] init];
//        _tipsLabel.backgroundColor = [UIColor colorWithRed:52/255.0 green:59/255.0 blue:77/255.0 alpha:0.50];;
//        _tipsLabel.textColor = [UIColor whiteColor];
//        _tipsLabel.font = HDAppTheme.TinhNowFont.standard12;
//        _tipsLabel.numberOfLines = 0;
//        _tipsLabel.hd_edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//        _tipsLabel.textAlignment = NSTextAlignmentCenter;
//        _tipsLabel.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
//            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
//        };
//    }
//    return _tipsLabel;
//}
- (HDUIButton *)dealNumBtn {
    if (!_dealNumBtn) {
        _dealNumBtn = [[HDUIButton alloc] init];
        _dealNumBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_dealNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dealNumBtn setTitle:TNLocalizedString(@"tn_bargain_specials", @"砍价特惠") forState:UIControlStateNormal];
        _dealNumBtn.userInteractionEnabled = false;
        _dealNumBtn.spacingBetweenImageAndTitle = kRealWidth(2);
        _dealNumBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _dealNumBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FE1F36"] toColor:[UIColor hd_colorWithHexString:@"#FF9657"]];
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:8];
        };
    }
    return _dealNumBtn;
}
/** @lazy soldLabel */
- (UILabel *)soldLabel {
    if (!_soldLabel) {
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = HDAppTheme.TinhNowFont.standard11;
        _soldLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _soldLabel;
}
/** @lazy soldOutImageView */
- (UIImageView *)soldOutImageView {
    if (!_soldOutImageView) {
        _soldOutImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_sold_out_bg_k"]];
    }
    return _soldOutImageView;
}
/** @lazy  soldOutView*/
- (UIView *)soldOutView {
    if (!_soldOutView) {
        _soldOutView = [[UIView alloc] init];
        _soldOutView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.60];
        _soldOutView.hidden = YES;
    }
    return _soldOutView;
}
@end


@implementation TNBargainGoodsCellModel

@end
