//
//  TNGoodsCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGoodsCollectionViewCell.h"
#import "SAShadowBackgroundView.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "TNDecimalTool.h"
#import "TNEventTracking.h"
#import "TNGoodsModel.h"
#import "TNProductBuyTipsView.h"
#import "TNProductChooseSpecificationsView.h"
#import "TNShoppingCar.h"
#import "TNShoppingCartEntryWindow.h"
#import "TNSkuSpecModel.h"
#import "TNSmallShopCarButton.h"
#import "TNStoreInfoRspModel.h"
#import "TNTool.h"
#import "UIView+NAT.h"
#import <HDVendorKit/HDVendorKit.h>
#import <YYText.h>
#import "TNSpecialActivityViewController.h"


@interface TNGoodsCollectionViewCell ()
/// 背景
@property (nonatomic, strong) UIView *containerView;
/// 商品图片
@property (nonatomic, strong) UIImageView *goodsImageView;
/// 商品名
@property (nonatomic, strong) UILabel *goodsNameLabel;
/// 商品售价
@property (nonatomic, strong) UILabel *goodsPriceLabel;
/// 销量
@property (nonatomic, strong) UILabel *soldLabel;
/// 门店名称
@property (nonatomic, strong) UILabel *storeNameLabel;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowImageView;
/// 商品专题相关
/// 折扣
@property (nonatomic, strong) HDUIButton *discountTag;
/// 卖光背景图 半透明遮罩
@property (strong, nonatomic) UIView *soldOutView;
/// 卖光图片
@property (nonatomic, strong) UIImageView *soldOutImageView;
/// 原价文案
@property (nonatomic, strong) UILabel *originalPriceLabel;
/// 促销标签
@property (nonatomic, strong) HDLabel *promotionTag;
/// 小购物车
@property (strong, nonatomic) TNSmallShopCarButton *shopCarBtn;
/// 占位图片
@property (strong, nonatomic) UIImage *placeloldImage;
/// 包邮图片
@property (strong, nonatomic) UIImageView *freeShippingImageView;
/// tagStackView
@property (strong, nonatomic) UIStackView *tagStackView;
/// 热销图片
@property (strong, nonatomic) UIImageView *hotImageView;
/// 阴影view
@property (strong, nonatomic) CAShapeLayer *shadowLayer;
/// 批量标签
@property (nonatomic, strong) HDLabel *stagePriceTag;
/// 卖家热卖图标
@property (strong, nonatomic) UIImageView *sellerHotImageView;
@end


@implementation TNGoodsCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.goodsImageView];
    [self.containerView addSubview:self.goodsNameLabel];
    [self.containerView addSubview:self.goodsPriceLabel];
    [self.containerView addSubview:self.soldLabel];
    [self.containerView addSubview:self.storeNameLabel];
    [self.containerView addSubview:self.arrowImageView];
    [self.containerView addSubview:self.discountTag];
    [self.goodsImageView addSubview:self.soldOutView];
    [self.soldOutView addSubview:self.soldOutImageView];
    [self.containerView addSubview:self.originalPriceLabel];
    [self.containerView addSubview:self.shopCarBtn];
    [self.containerView addSubview:self.tagStackView];
    [self.tagStackView addArrangedSubview:self.freeShippingImageView];
    [self.tagStackView addArrangedSubview:self.promotionTag];
    [self.tagStackView addArrangedSubview:self.stagePriceTag];
    [self.containerView addSubview:self.hotImageView];
    [self.goodsImageView addSubview:self.sellerHotImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnStoreName:)];
    [self.storeNameLabel addGestureRecognizer:tap];
}

- (void)updateConstraints {
    if (self.displayStyle == TNGoodsDisplayStyleHorizontal) {
        [self updateHorizontalStyleConstraints];
    } else {
        [self updateWaterFallsFlowStyleConstraints];
    }
    [super updateConstraints];
}

#pragma mark - override
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
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

#pragma mark - private methods
- (void)clickOnStoreName:(UITapGestureRecognizer *)tap {
    [KeyWindow endEditing:YES];
    [SAWindowManager openUrl:@"SuperApp://TinhNow/StoreInfo" withParameters:@{@"storeNo": self.model.storeNo}];
    !self.clickStoreTrackEventCallBack ?: self.clickStoreTrackEventCallBack();
}
- (void)setDisplayStyle:(TNGoodsDisplayStyle)displayStyle {
    _displayStyle = displayStyle;
    [self setNeedsUpdateConstraints];
}
- (void)setIsNeedShowHotSale:(BOOL)isNeedShowHotSale {
    _isNeedShowHotSale = isNeedShowHotSale;
}
- (void)setIsNeedShowSellerHotSale:(BOOL)isNeedShowSellerHotSale {
    _isNeedShowSellerHotSale = isNeedShowSellerHotSale;
    self.sellerHotImageView.hidden = isNeedShowSellerHotSale;
}
- (void)setIsFromSpecialVercialStyle:(CGFloat)isFromSpecialVercialStyle {
    _isFromSpecialVercialStyle = isFromSpecialVercialStyle;
}
- (void)setIsFromSpecialActivityController:(BOOL)isFromSpecialActivityController {
    _isFromSpecialActivityController = isFromSpecialActivityController;
}
- (void)setModel:(TNGoodsModel *)model {
    _model = model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:self.placeloldImage];
    if (model.productNameAttr) {
        self.goodsNameLabel.attributedText = model.productNameAttr;
    } else {
        self.goodsNameLabel.text = model.productName;
    }

    self.goodsPriceLabel.text = _model.price.thousandSeparatorAmount;
    self.storeNameLabel.text = model.storeName;

    // 判断市场价格是否隐藏 如商户端设置的默认SKU『市场价 ≤ 销售价』，则用户端商品隐藏市场价（划线价）
    NSComparisonResult result = [[TNDecimalTool toDecimalNumber:model.marketPrice.amount] compare:[TNDecimalTool toDecimalNumber:model.price.amount]];
    if (model.marketPrice.amount.doubleValue > 0 && result == NSOrderedDescending) {
        NSAttributedString *originalPrice = [[NSAttributedString alloc] initWithString:model.marketPrice.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:12.f weight:UIFontWeightLight],
            NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G3,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: HDAppTheme.TinhNowColor.G3
        }];
        self.originalPriceLabel.hidden = false;
        self.originalPriceLabel.attributedText = originalPrice;
    } else {
        self.originalPriceLabel.hidden = true;
    }

    if (self.isNeedShowHotSale) {
        self.hotImageView.hidden = NO;
        self.discountTag.hidden = YES;
    } else {
        self.hotImageView.hidden = YES;
        // 显示折扣
        if (HDIsStringNotEmpty(_model.showDisCount)) {
            self.discountTag.hidden = false;
            [self.discountTag setTitle:_model.showDisCount forState:UIControlStateNormal];
        } else {
            self.discountTag.hidden = true;
        }
    }
    self.sellerHotImageView.hidden = !model.enabledHotSale;

    // 显示促销商品
    self.promotionTag.hidden = !model.isSale;
    self.stagePriceTag.hidden = !model.stagePrice;
    // 包邮图标
    self.freeShippingImageView.hidden = !model.freightSetting;
    // 是否显示卖光图片
    if (model.isOutOfStock) {
        self.soldOutView.hidden = false;
        self.soldOutImageView.image = [UIImage imageNamed:model.soldOutImageName];
    } else {
        self.soldOutView.hidden = true;
    }
    // 判断是否显示已售数量 商品销量>0，显示销售件数；如商品销量=0，则不显示销售数量字段
    if (HDIsStringNotEmpty(model.salesLabel)) {
        self.soldLabel.hidden = false;
        NSString *str = TNLocalizedString(@"tn_text_sold_title", @"Sold ");
        self.soldLabel.text = [str stringByAppendingFormat:@"%@", model.salesLabel];
    } else {
        self.soldLabel.hidden = true;
    }
    // 显示小购物车
    if (_model.isNeedShowSmallShopCar) {
        self.shopCarBtn.hidden = NO;
        self.shopCarBtn.goodModel = _model;
    } else {
        self.shopCarBtn.hidden = YES;
    }
    if (_model.cellType == TNGoodsShowCellTypeGoodsAndStore) {
        self.storeNameLabel.hidden = false;
        self.arrowImageView.hidden = false;
    } else {
        self.storeNameLabel.hidden = true;
        self.arrowImageView.hidden = true;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - 瀑布流布局
- (void)updateWaterFallsFlowStyleConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(1.0);
    }];
    if (!self.sellerHotImageView.isHidden) {
        [self.sellerHotImageView sizeToFit];
        [self.sellerHotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            [self.sellerHotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.goodsImageView);
            }];
        }];
    }

    [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
    }];
    UIView *lastView = self.goodsNameLabel;
    if (!self.freeShippingImageView.isHidden || !self.promotionTag.isHidden || !self.stagePriceTag.isHidden) {
        lastView = self.tagStackView;
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
            make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(kRealWidth(8));
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
        }];
    }

    [self.goodsPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(8));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
    }];

    if (!self.discountTag.isHidden) {
        [self.discountTag sizeToFit];
        [self.discountTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.containerView);
        }];
    }
    if (!self.hotImageView.isHidden) {
        [self.hotImageView sizeToFit];
        [self.hotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.goodsImageView);
        }];
    }

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

    if (self.originalPriceLabel.isHidden == false) {
        [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsPriceLabel.mas_right).offset(kRealWidth(7));
            make.centerY.equalTo(self.goodsPriceLabel);
            if (!self.shopCarBtn.isHidden) {
                make.right.lessThanOrEqualTo(self.shopCarBtn.mas_left).offset(-kRealWidth(8));
            } else {
                make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(8));
            }
        }];
    }
    if (!self.soldLabel.isHidden) {
        [self.soldLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
            make.top.equalTo(self.goodsPriceLabel.mas_bottom).offset(kRealWidth(3));
            make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(8));
        }];
    }
    if (!self.shopCarBtn.isHidden) {
        [self.shopCarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsPriceLabel.mas_top);
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(26), kRealWidth(26)));
        }];
    }

    if (self.model.cellType == TNGoodsShowCellTypeGoodsAndStore) {
        UIView *topView = self.goodsPriceLabel;
        if (!self.soldLabel.isHidden && !self.shopCarBtn.isHidden) {
            topView = self.soldLabel;
        }
        if (self.soldLabel.isHidden && !self.shopCarBtn.isHidden) {
            topView = self.shopCarBtn;
        }
        if (!self.soldLabel.isHidden && self.shopCarBtn.isHidden) {
            topView = self.soldLabel;
        }

        [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(8));
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            make.right.equalTo(self.arrowImageView.mas_left).offset(-kRealWidth(10));
        }];
        [self.arrowImageView sizeToFit];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(8));
            make.centerY.equalTo(self.storeNameLabel.mas_centerY);
            make.size.mas_equalTo(self.arrowImageView.frame.size);
        }];
    }
    [self.goodsPriceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.originalPriceLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.soldLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.shopCarBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}
#pragma mark - 横向单个商品布局
- (void)updateHorizontalStyleConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(self.isFromSpecialVercialStyle ? kRealWidth(5) : kRealWidth(15));
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(15));
        make.width.equalTo(self.goodsImageView.mas_height);
    }];
    [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.containerView.mas_right).offset(self.isFromSpecialVercialStyle ? -kRealWidth(10) : -kRealWidth(15));
    }];

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
        make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(kRealWidth(5));
        make.leading.equalTo(self.goodsNameLabel.mas_leading);
        //        make.height.mas_equalTo(kRealWidth(18));
    }];

    [self.goodsPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagStackView.mas_bottom).offset(kRealWidth(8));
        make.leading.equalTo(self.goodsNameLabel.mas_leading);
    }];

    if (!self.discountTag.isHidden) {
        [self.discountTag sizeToFit];
        [self.discountTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.goodsImageView);
        }];
    }
    if (!self.hotImageView.isHidden) {
        [self.hotImageView sizeToFit];
        [self.hotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.goodsImageView);
        }];
    }
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

    if (self.originalPriceLabel.isHidden == false) {
        [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsPriceLabel.mas_right).offset(kRealWidth(7));
            make.centerY.equalTo(self.goodsPriceLabel);
            if (!self.shopCarBtn.isHidden) {
                make.right.lessThanOrEqualTo(self.shopCarBtn.mas_left).offset(-kRealWidth(8));
            } else {
                make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(self.isFromSpecialVercialStyle ? -kRealWidth(10) : -kRealWidth(15));
            }
        }];
    }
    if (!self.shopCarBtn.isHidden) {
        [self.shopCarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsPriceLabel.mas_top);
            make.right.equalTo(self.containerView.mas_right).offset(self.isFromSpecialVercialStyle ? -kRealWidth(10) : -kRealWidth(15));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(26), kRealWidth(26)));
        }];
    }

    if (!self.soldLabel.isHidden) {
        [self.soldLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.goodsNameLabel.mas_leading);
            make.top.equalTo(self.goodsPriceLabel.mas_bottom).offset(kRealWidth(5));
            make.right.lessThanOrEqualTo(self.containerView.mas_right).offset(-kRealWidth(15));
        }];
    }
    if (self.model.cellType == TNGoodsShowCellTypeGoodsAndStore) {
        [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.goodsNameLabel.mas_leading);
            make.bottom.equalTo(self.goodsImageView.mas_bottom);
            make.right.equalTo(self.arrowImageView.mas_left).offset(-kRealWidth(10));
        }];
        [self.arrowImageView sizeToFit];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView.mas_right).offset(self.isFromSpecialVercialStyle ? -kRealWidth(10) : -kRealWidth(15));
            make.centerY.equalTo(self.storeNameLabel.mas_centerY);
            make.size.mas_equalTo(self.arrowImageView.frame.size);
        }];
    }
    [self.goodsPriceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.originalPriceLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.soldLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.shopCarBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}
#pragma mark - lazy load
/** @lazy containerView */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        @HDWeakify(self);
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            if (self.shadowLayer) {
                [self.shadowLayer removeFromSuperlayer];
                self.shadowLayer = nil;
            }
            if (self.displayStyle == TNGoodsDisplayStyleWaterFallsFlow) {
                self.shadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:8 shadowRadius:8 shadowOpacity:1
                                               shadowColor:[UIColor colorWithRed:203 / 255.0 green:212 / 255.0 blue:217 / 255.0 alpha:0.25].CGColor
                                                 fillColor:[UIColor whiteColor].CGColor
                                              shadowOffset:CGSizeMake(0, 4)];
            } else {
                self.shadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:0 shadowOpacity:0 shadowColor:[UIColor whiteColor].CGColor
                                                 fillColor:[UIColor whiteColor].CGColor
                                              shadowOffset:CGSizeZero];
            }
        };
    }
    return _containerView;
}
/** @lazy goodImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8.0];
        };
    }
    return _goodsImageView;
}
/** @lazy goodNameLabel */
- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.font = HDAppTheme.TinhNowFont.standard15;
        _goodsNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _goodsNameLabel.numberOfLines = 2;
        //        _goodsNameLabel.preferredMaxLayoutWidth = self.width - kRealWidth(16);
    }
    return _goodsNameLabel;
}
/** @lazy goodsPriceLabel */
- (UILabel *)goodsPriceLabel {
    if (!_goodsPriceLabel) {
        _goodsPriceLabel = [[UILabel alloc] init];
        _goodsPriceLabel.font = HDAppTheme.TinhNowFont.standard17B;
        _goodsPriceLabel.textColor = HDAppTheme.TinhNowColor.C3;
        _goodsPriceLabel.numberOfLines = 1;
    }
    return _goodsPriceLabel;
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
/** @lazy storeNameLabel */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = HDAppTheme.TinhNowFont.standard12;
        _storeNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _storeNameLabel.userInteractionEnabled = YES;
        _storeNameLabel.numberOfLines = 2;
    }
    return _storeNameLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
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
/** @lazy goodsPriceLabel */
- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightLight];
        _originalPriceLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _originalPriceLabel.numberOfLines = 1;
        _originalPriceLabel.hidden = true;
    }
    return _originalPriceLabel;
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
        //        _promotionTag.hidden = true;
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
    }
    return _stagePriceTag;
}
/** @lazy shopCarBtn */
- (TNSmallShopCarButton *)shopCarBtn {
    if (!_shopCarBtn) {
        _shopCarBtn = [[TNSmallShopCarButton alloc] init];
        @HDWeakify(self);
        _shopCarBtn.addShopCartTrackEventCallBack = ^(NSString *_Nonnull productId, TNItemModel *_Nonnull itemModel) {
            @HDStrongify(self);
            [KeyWindow showloading];
            @HDWeakify(self);
            [[TNShoppingCar share] addItemToShoppingCarWithItem:itemModel success:^(TNAddItemToShoppingCarRspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [KeyWindow dismissLoading];
                [self layoutIfNeeded];

                CGPoint point = [self convertPoint:self.goodsImageView.frame.origin toView:[UIApplication sharedApplication].keyWindow];
                point.x += self.goodsImageView.frame.size.width / 2;
                point.y += self.goodsImageView.frame.size.height / 2;


                [TNTool startAddProductToCartAnimationWithImage:self.model.thumbnail startPoint:point
                                                       endPoint:self.isFromSpecialActivityController ? [TNShoppingCar share].activityBottomCartPoint :
                                                                                                       [[TNShoppingCartEntryWindow sharedInstance] getCartButtonConvertPoint]
                                                         inView:[UIApplication sharedApplication].keyWindow completion:^{
                                                             self.isFromSpecialActivityController ? [[TNShoppingCar share] activityCartShake] : [[TNShoppingCartEntryWindow sharedInstance] shake];
                                                             [HDTips showWithText:TNLocalizedString(@"tn_add_cart_success", @"添加购物车成功") inView:KeyWindow hideAfterDelay:3];
                                                         }];

                !self.addShopCartTrackEventCallBack ?: self.addShopCartTrackEventCallBack(productId);
                [TNEventTrackingInstance trackEvent:@"add_cart" properties:@{@"productId": productId}];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                [self dismissLoading];
                [HDTips showWithText:TNLocalizedString(@"tn_add_cart_fail", @"添加购物车失败") inView:KeyWindow hideAfterDelay:3];
            }];
        };
    }
    return _shopCarBtn;
}
/** @lazy placeloldImage */
- (UIImage *)placeloldImage {
    if (!_placeloldImage) {
        _placeloldImage = [HDHelper placeholderImageWithSize:CGSizeMake(100, 100)];
    }
    return _placeloldImage;
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
/** @lazy  hotImageView*/
- (UIImageView *)hotImageView {
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_hot_good_k"]];
        _hotImageView.hidden = YES;
    }
    return _hotImageView;
}
/** @lazy sellerHotImageView */
- (UIImageView *)sellerHotImageView {
    if (!_sellerHotImageView) {
        _sellerHotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_seller_hot_product"]];
    }
    return _sellerHotImageView;
}
@end
