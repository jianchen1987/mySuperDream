//
//  TNActivityGoodsView.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityGoodsView.h"
#import "SATalkingData.h"
#import "TNDecimalTool.h"
#import "TNGoodsModel.h"
#import "TNShoppingCar.h"
#import "TNShoppingCartEntryWindow.h"
#import "TNSmallShopCarButton.h"
#import "TNTool.h"
#import "TNSpecialActivityViewController.h"


@interface TNActivityGoodsView ()
/// 商品图片
@property (strong, nonatomic) UIImageView *goodsImageView;
/// 卖光背景图 半透明遮罩
@property (strong, nonatomic) UIView *soldOutView;
/// 卖光图片
@property (nonatomic, strong) UIImageView *soldOutImageView;
/// 热销图片
@property (strong, nonatomic) UIImageView *hotImageView;
/// 商品名
@property (nonatomic, strong) UILabel *goodsNameLabel;
/// 商品售价
@property (nonatomic, strong) UILabel *goodsPriceLabel;
/// 原价文案
@property (nonatomic, strong) UILabel *originalPriceLabel;
/// 小购物车
@property (strong, nonatomic) TNSmallShopCarButton *shopCarBtn;
/// 包邮图片
@property (strong, nonatomic) UIImageView *freeShippingImageView;
/// 促销标签
@property (nonatomic, strong) HDLabel *promotionTag;
/// 批量标签  横向视图才会有
@property (nonatomic, strong) HDLabel *stagePriceTag;

/// tagStackView
@property (strong, nonatomic) UIStackView *tagStackView;
/// 批量标签  普通状态下的  放在图片上
@property (nonatomic, strong) HDLabel *stagePriceNormalTag;
@end


@implementation TNActivityGoodsView
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.goodsImageView];
    [self.goodsImageView addSubview:self.hotImageView];
    [self.goodsImageView addSubview:self.soldOutView];
    [self.soldOutView addSubview:self.soldOutImageView];
    [self addSubview:self.goodsNameLabel];
    [self addSubview:self.goodsPriceLabel];
    [self addSubview:self.originalPriceLabel];
    [self addSubview:self.shopCarBtn];
    [self addSubview:self.tagStackView];
    [self.tagStackView addArrangedSubview:self.freeShippingImageView];
    [self.tagStackView addArrangedSubview:self.promotionTag];
    [self.tagStackView addArrangedSubview:self.stagePriceTag];
    [self.goodsImageView addSubview:self.stagePriceNormalTag];
    UITapGestureRecognizer *recoginer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodClick:)];
    [self addGestureRecognizer:recoginer];
}
- (void)goodClick:(UITapGestureRecognizer *)tap {
    [HDMediator.sharedInstance navigaveTinhNowProductDetailViewController:@{@"productId": self.model.productId}];
}

- (void)updateConstraints {
    if (self.style == TNActivityGoodsDisplayStyleNormal) {
        [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.width.mas_equalTo(self.goodItemWidth);
            make.height.mas_equalTo(self.goodItemWidth);
        }];

        if (!self.stagePriceNormalTag.isHidden) {
            [self.stagePriceNormalTag mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.goodsImageView.mas_left).offset(kRealWidth(2));
                make.bottom.equalTo(self.goodsImageView.mas_bottom).offset(-kRealWidth(2));
                make.size.mas_equalTo(CGSizeMake(kRealWidth(38), kRealWidth(15)));
            }];
        }

        [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kRealWidth(5));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(5));
            make.top.equalTo(self.goodsImageView.mas_bottom).offset(kRealWidth(10));
            ;
        }];
        // 包邮或者
        if (!self.freeShippingImageView.isHidden || !self.promotionTag.isHidden) {
            [self.freeShippingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kRealWidth(34), kRealWidth(18)));
            }];
            [self.promotionTag sizeToFit];
            [self.promotionTag mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kRealWidth(15));
            }];
            [self.tagStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.goodsNameLabel.mas_leading);
                make.bottom.equalTo(self.goodsPriceLabel.mas_top).offset(-kRealWidth(8));
            }];
        }

        CGFloat originalPriceHeight = [@"1" boundingAllRectWithSize:CGSizeMake(self.goodItemWidth - kRealWidth(10), MAXFLOAT) font:[HDAppTheme.TinhNowFont fontRegular:10] lineSpacing:0].height;
        [self.goodsPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsNameLabel.mas_left);
            make.bottom.equalTo(self.mas_bottom).offset(-(15 + originalPriceHeight));
        }];
        if (!self.originalPriceLabel.isHidden) {
            [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsPriceLabel.mas_bottom).offset(kRealWidth(5));
                make.left.equalTo(self.goodsPriceLabel.mas_left);
            }];
        }
        if (!self.shopCarBtn.isHidden) {
            [self.shopCarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsPriceLabel.mas_top);
                make.right.equalTo(self.mas_right).offset(-kRealWidth(8));
                make.size.mas_equalTo(CGSizeMake(kRealWidth(26), kRealWidth(26)));
            }];
        }

    } else if (self.style == TNActivityGoodsDisplayStyleHorizontal) {
        [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.mas_top).offset(kRealWidth(15));
            make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(15));
            make.width.mas_equalTo(self.goodsImageView.mas_height);
            //            make.height.mas_equalTo(self.goodItemWidth);
        }];
        [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(10));
            make.top.equalTo(self.goodsImageView.mas_top);
            make.right.lessThanOrEqualTo(self.mas_right);
        }];

        // 包邮或者
        if (!self.freeShippingImageView.isHidden || !self.promotionTag.isHidden || !self.stagePriceTag.isHidden) {
            [self.freeShippingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kRealWidth(34), kRealWidth(18)));
            }];
            [self.promotionTag sizeToFit];
            [self.promotionTag mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kRealWidth(15));
            }];
            [self.stagePriceTag sizeToFit];
            [self.stagePriceTag mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kRealWidth(15));
            }];
            [self.tagStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.goodsNameLabel.mas_leading);
                make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(kRealWidth(10));
            }];
        }

        [self.goodsPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsNameLabel.mas_left);
            make.bottom.equalTo(self.goodsImageView.mas_bottom);
        }];
        if (!self.originalPriceLabel.isHidden) {
            [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.goodsPriceLabel.mas_right).offset(kRealWidth(5));
                make.centerY.equalTo(self.goodsPriceLabel.mas_centerY);
            }];
        }
        if (!self.shopCarBtn.isHidden) {
            [self.shopCarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.goodsPriceLabel.mas_bottom);
                make.right.equalTo(self.mas_right);
                make.size.mas_equalTo(CGSizeMake(kRealWidth(26), kRealWidth(26)));
            }];
        }
    }

    [self.hotImageView sizeToFit];
    [self.hotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.goodsImageView);
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

    [super updateConstraints];
}
- (void)setStyle:(TNActivityGoodsDisplayStyle)style {
    _style = style;
    if (style == TNActivityGoodsDisplayStyleHorizontal) {
        self.goodsNameLabel.font = HDAppTheme.TinhNowFont.standard14;
        self.goodsPriceLabel.font = HDAppTheme.TinhNowFont.standard15B;
        self.originalPriceLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightLight];
    }
}
- (void)setGoodItemWidth:(CGFloat)goodItemWidth {
    _goodItemWidth = goodItemWidth;
}
- (void)setGoodItemHeight:(CGFloat)goodItemHeight {
    _goodItemHeight = goodItemHeight;
}
- (void)setHasFreeShippingOrPromotion:(BOOL)hasFreeShippingOrPromotion {
    _hasFreeShippingOrPromotion = hasFreeShippingOrPromotion;
}

- (void)setGoodNameLabelText {
    if ([self.model.type isEqualToString:TNGoodsTypeOverseas] || [self.model.typeName isEqualToString:TNGoodsTypeOverseas]) {
        UIImage *globalImage = [UIImage imageNamed:@"tn_global_k_small"];
        NSString *name = [NSString stringWithFormat:@" %@", self.model.productName];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
        imageMent.image = globalImage;
        UIFont *font = self.goodsNameLabel.font;
        CGFloat paddingTop = font.lineHeight - font.pointSize;
        imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width, globalImage.size.height);
        NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
        [text insertAttributedString:attachment atIndex:0];
        [text addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];

        self.goodsNameLabel.attributedText = text;
    } else {
        self.goodsNameLabel.text = self.model.productName;
    }
}

- (void)setModel:(TNGoodsModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(100, 100)] imageView:self.goodsImageView];
    [self setGoodNameLabelText];
    self.goodsPriceLabel.text = _model.price.thousandSeparatorAmount;
    // 判断市场价格是否隐藏 如商户端设置的默认SKU『市场价 ≤ 销售价』，则用户端商品隐藏市场价（划线价）
    NSComparisonResult result = [[TNDecimalTool toDecimalNumber:_model.marketPrice.cent] compare:[TNDecimalTool toDecimalNumber:_model.price.cent]];
    if (_model.marketPrice.cent.doubleValue > 0 && result == NSOrderedDescending) {
        self.originalPriceLabel.hidden = false;
    } else {
        self.originalPriceLabel.hidden = true;
    }
    if (self.originalPriceLabel.isHidden == false) {
        NSAttributedString *originalPrice = [[NSAttributedString alloc] initWithString:_model.marketPrice.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: self.originalPriceLabel.font,
            NSForegroundColorAttributeName: self.originalPriceLabel.textColor,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: self.originalPriceLabel.textColor
        }];
        self.originalPriceLabel.attributedText = originalPrice;
    }
    if (_model.isNeedShowSmallShopCar) {
        self.shopCarBtn.hidden = NO;
        self.shopCarBtn.goodModel = _model;
    } else {
        self.shopCarBtn.hidden = YES;
    }
    // 是否显示卖光图片
    if (_model.isOutOfStock) {
        self.soldOutView.hidden = false;
        self.soldOutImageView.image = [UIImage imageNamed:_model.soldOutImageName];
    } else {
        self.soldOutView.hidden = true;
    }
    // 显示促销商品
    self.promotionTag.hidden = !model.isSale;
    // 包邮图标
    self.freeShippingImageView.hidden = !model.freightSetting;
    if (self.style == TNActivityGoodsDisplayStyleHorizontal) {
        self.stagePriceTag.hidden = !model.stagePrice;
        self.stagePriceNormalTag.hidden = YES;
    } else {
        self.stagePriceNormalTag.hidden = !model.stagePrice;
        self.stagePriceTag.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}
/** @lazy goodImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            if (self.style == TNActivityGoodsDisplayStyleHorizontal) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:8];
            } else {
                [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
            }
        };
    }
    return _goodsImageView;
}
/** @lazy  hotImageView*/
- (UIImageView *)hotImageView {
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_hot_good_k"]];
    }
    return _hotImageView;
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
/** @lazy goodsPriceLabel */
- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = [UIFont systemFontOfSize:10.f weight:UIFontWeightLight];
        _originalPriceLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _originalPriceLabel.numberOfLines = 1;
        _originalPriceLabel.hidden = true;
    }
    return _originalPriceLabel;
}
/** @lazy shopCarBtn */
- (TNSmallShopCarButton *)shopCarBtn {
    if (!_shopCarBtn) {
        _shopCarBtn = [[TNSmallShopCarButton alloc] init];
        @HDWeakify(self);
        _shopCarBtn.addShopCartTrackEventCallBack = ^(NSString *_Nonnull productId, TNItemModel *_Nonnull itemModel) {
            @HDStrongify(self);
            [self showloading];
            @HDWeakify(self);
            [[TNShoppingCar share] addItemToShoppingCarWithItem:itemModel success:^(TNAddItemToShoppingCarRspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [self dismissLoading];
                [self layoutIfNeeded];

                CGPoint point = [self convertPoint:self.goodsImageView.frame.origin toView:[UIApplication sharedApplication].keyWindow];
                point.x += self.goodsImageView.frame.size.width / 2;
                point.y += self.goodsImageView.frame.size.height / 2;

                [TNTool startAddProductToCartAnimationWithImage:self.model.thumbnail startPoint:point endPoint:[TNShoppingCar share].activityBottomCartPoint
                                                         inView:[UIApplication sharedApplication].keyWindow completion:^{
                                                             [[TNShoppingCar share] activityCartShake];
                                                             [HDTips showWithText:TNLocalizedString(@"tn_add_cart_success", @"添加购物车成功") inView:KeyWindow hideAfterDelay:3];
                                                         }];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                [self dismissLoading];
                [HDTips showWithText:TNLocalizedString(@"tn_add_cart_fail", @"添加购物车失败") inView:KeyWindow hideAfterDelay:3];
            }];
        };
    }
    return _shopCarBtn;
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
    }
    return _soldOutView;
}
/** @lazy freeShippingImageView */
- (UIImageView *)freeShippingImageView {
    if (!_freeShippingImageView) {
        _freeShippingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_small_freeshipping"]];
        _freeShippingImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        _freeShippingImageView.hidden = YES;
    }
    return _freeShippingImageView;
}
/** @lazy tagStackView */
- (UIStackView *)tagStackView {
    if (!_tagStackView) {
        _tagStackView = [[UIStackView alloc] init];
        _tagStackView.axis = UILayoutConstraintAxisHorizontal;
        _tagStackView.spacing = kRealWidth(5);
        _tagStackView.alignment = UIStackViewAlignmentFill;
    }
    return _tagStackView;
}
/** @lazy promotionTag */
- (HDLabel *)promotionTag {
    if (!_promotionTag) {
        _promotionTag = [[HDLabel alloc] init];
        _promotionTag.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _promotionTag.textColor = HexColor(0xFF2323);
        _promotionTag.backgroundColor = [UIColor whiteColor];
        _promotionTag.textAlignment = NSTextAlignmentCenter;
        _promotionTag.text = @"Promotion";
        _promotionTag.hd_edgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _promotionTag.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            if (HDIsArrayEmpty(view.layer.sublayers)) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:2 borderWidth:0.5 borderColor:HexColor(0xFF2323)];
            }
        };
        _promotionTag.hidden = true;
    }
    return _promotionTag;
}
/** @lazy stagePriceTag */
- (HDLabel *)stagePriceTag {
    if (!_stagePriceTag) {
        _stagePriceTag = [[HDLabel alloc] init];
        _stagePriceTag.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _stagePriceTag.textColor = HexColor(0xFF2323);
        _stagePriceTag.backgroundColor = [UIColor whiteColor];
        _stagePriceTag.textAlignment = NSTextAlignmentCenter;
        _stagePriceTag.text = TNLocalizedString(@"d6Te2ndf", @"批量");
        _stagePriceTag.hd_edgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _stagePriceTag.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            if (HDIsArrayEmpty(view.layer.sublayers)) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:2 borderWidth:0.5 borderColor:HexColor(0xFF2323)];
            }
        };
        //        _promotionTag.hidden = true;
    }
    return _stagePriceTag;
}
/** @lazy stagePriceNormalTag */
- (HDLabel *)stagePriceNormalTag {
    if (!_stagePriceNormalTag) {
        _stagePriceNormalTag = [[HDLabel alloc] init];
        _stagePriceNormalTag.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _stagePriceNormalTag.textColor = [UIColor whiteColor];
        _stagePriceNormalTag.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.50];
        _stagePriceNormalTag.textAlignment = NSTextAlignmentCenter;
        _stagePriceNormalTag.text = TNLocalizedString(@"d6Te2ndf", @"批量");
        //        _stagePriceNormalTag.hd_edgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _stagePriceNormalTag.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
        _stagePriceNormalTag.hidden = true;
    }
    return _stagePriceNormalTag;
}
@end
